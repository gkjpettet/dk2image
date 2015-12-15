#tag Module
Protected Module DICOMKit
	#tag Method, Flags = &h1
		Protected Function IsDICOM(file as Xojo.IO.FolderItem) As Boolean
		  ' Takes a FolderItem and determines if it's a DICOM file.
		  ' Performs only a rudimentary check. A DICOM file starts with a 128 byte preamble followed by the
		  ' characters DICM
		  
		  Using Xojo.IO
		  
		  dim stream as BinaryStream
		  
		  stream = BinaryStream.Open(file, BinaryStream.LockModes.Read)
		  
		  ' Must be a minimum of 132 bytes long
		  if stream.Length < 131 then return False
		  
		  ' Check bytes 128 - 131 for DICM
		  stream.Position = 128
		  if stream.ReadInt8 <> &h44 then return False ' D
		  if stream.ReadInt8 <> &h49 then return False ' I
		  if stream.ReadInt8 <> &h43 then return False ' C
		  if stream.ReadInt8 <> &h4D then return False ' M
		  
		  ' Close the file
		  stream.Close()
		  
		  ' Looks like a valid DICOM file
		  return True
		  
		  exception err as NilObjectException
		    return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Open(file as Xojo.IO.FolderItem) As DICOMKit.ObjectDK
		  ' Takes a reference to a FolderItem file, checks it's a DICOM file, parses the entire contents into a
		  ' new ObjectDK, which is then returned.
		  
		  Using Xojo.IO
		  
		  dim dicom as ObjectDK
		  dim stream as BinaryStream
		  
		  ' Have we been passed a real DICOM file?
		  if not IsDICOM(file) then 
		    raise new ExceptionDK(ExceptionDK.INVALID_FILE, _
		    "Unable to open the passed file reference as it is not a valid DICOM file")
		  end if
		  
		  ' Create a new DICOMObject instance from this file
		  dicom = New ObjectDK(file)
		  
		  ' Return this new DICOM object
		  return dicom
		  
		End Function
	#tag EndMethod


	#tag Note, Name = File Meta Information
		The File Meta Information section of a DICOM file contains up to 10 elements (6 required, 4 optional).
		These are as follows:
		
		Tag         Name                              VR   Optional?   Description
		0002,0000   Group length                      UL   No          No of bytes following this element up to and including the last group 0002 element
		0002,0001   File Meta Information Version     OB   No          2 byte field where each bit identifies a version of this File Meta Information header. In the current version, the first byte is &h00 and second byte is &h01
		0002,0002   Media Storage SOP Class UID       UI   No          Essentially contains the C-Store SOP for the image modality
		0002,0003   Media Storage SOP Instance UID    UI   No          Identifies the the SOP instance associated with this file's DICOM data object
		0002,0010   Transfer Syntax UID               UI   No          The transfer syntax used to encode the following data object
		0002,0012   Implementation Class UID          UI   No          Identifies the implementation that wrote the DICOM file
		0002,0013   Implementation Version Name       SH   Yes         Identifies a version for 0002,0012
		0002,0016   Source AET                        AE   Yes         The DICOM AET of the AE that wrote this file's content
		0002,0100   Private Information Creator UID   UI   Yes         The UID of the creator of 0002,0102
		0002,0102   Private Information               OB   Yes         Contains private (often proprietary) information
	#tag EndNote

	#tag Note, Name = To Do
		######################################################################################################
		Image creation
		######################################################################################################
		Need to support lookup tables (LUTs) for DICOMs that do not provide rescale slope/intercept values
		
	#tag EndNote


	#tag Constant, Name = VERSION, Type = Text, Dynamic = False, Default = \"0.1", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
