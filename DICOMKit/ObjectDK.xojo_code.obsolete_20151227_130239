#tag Class
Protected Class ObjectDK
	#tag Method, Flags = &h21
		Private Function CalculateElementVM(vr as Text, length as Double) As Integer
		  ' Returns the number of values (i.e. the value multiplicity) encoded within this element's value field.
		  ' Determines this based on the passed VR and the value length.
		  
		  ' See page 30 of this PDF: http://medical.nema.org/dicom/2003/03_05PU.PDF
		  
		  using DICOMKit.Helpers
		  
		  ' Data elements with a VR of LT, SQ, ST, OF, OW, OB and UN always have a VM of 1
		  select case vr
		  case VRs.LONG_TEXT, VRs.SEQUENCE_OF_ITEMS, VRs.SHORT_TEXT, VRs.OTHER_FLOAT_STRING, _
		    VRs.OTHER_WORD_STRING, VRs.OTHER_BYTE_STRING, VRs.UNKNOWN, VRs.UNLIMITED_TEXT
		    return 1
		  case VRs.SIGNED_SHORT, VRs.UNSIGNED_SHORT ' fixed 2 byte value
		    return Floor(length/2)
		  case VRs.AGE_STRING, VRs.ATTRIBUTE_TAG, VRs.FLOATING_POINT_SINGLE, VRs.SIGNED_LONG, _
		    VRs.UNSIGNED_LONG ' fixed 4 byte values
		    return Floor(length/4)
		  case VRs.DATE, VRs.FLOATING_POINT_DOUBLE ' fixed 8 byte values
		    return Floor(length/8)
		  case VRs.APPLICATION_ENTITY, VRs.CODE_STRING, VRs.DATE, VRs.DATE_TIME, VRs.DECIMAL_STRING, _
		    VRs.INTEGER_STRING, VRs.LONG_STRING, VRs.PERSON_NAME, VRs.SHORT_STRING, VRs.SHORT_TEXT, _
		    VRs.TIME, VRs.UNIQUE_IDENTIFIER
		    ' The backslash (\) character is the delimiter
		    ' The actual VM is calculated when we read the element's value. Just return 1 for now...
		    return 1
		  else ' An unspecified VRs. Default to a VM of 1
		    return 1
		  end select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  dataset = new DatasetDK
		  
		  SetEncoding()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(file as Xojo.IO.FolderItem)
		  ' Creates a new DICOM object from the passed DICOM file on disk.
		  
		  Using DICOMKit
		  Using Xojo.IO
		  
		  dataset = new DatasetDK
		  me.file = file
		  
		  ' Get the file meta information from the file
		  ParseFileMetaInformation()
		  
		  'Parse the remaining elements
		  ParseElements(stream, meta.TransferSyntaxUID)
		  
		  ' Determine this object's text encoding
		  SetEncoding()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function CreateAsSequenceItem(stream as Xojo.IO.BinaryStream, transferSyntaxUID as Text) As DICOMKit.ObjectDK
		  ' Returns as a new DICOM object (ObjectDK instance) the dataset contained within the next item of
		  ' the sequence found at the start of the passed BinaryStream.
		  
		  using DICOMKit.Helpers
		  
		  ' Create a new DICOM object
		  dim dcm as new ObjectDK
		  
		  ' #################################################################################################
		  ' Set properties related to the transfer syntax
		  ' #################################################################################################
		  select case transferSyntaxUID
		  case TransferSyntaxes.BIG_ENDIAN_EXPLICIT
		    dcm.littleEndian = False
		    dcm.explicitVR = True
		    dcm.mCompressedPixelData = False
		  case TransferSyntaxes.LITTLE_ENDIAN_EXPLICIT
		    dcm.littleEndian = True
		    dcm.explicitVR = True
		    dcm.mCompressedPixelData = False
		  case TransferSyntaxes.LITTLE_ENDIAN_IMPLICIT
		    dcm.littleEndian = True
		    dcm.explicitVR = False
		    dcm.mCompressedPixelData = False
		  else
		    ' All the remaining transfer syntaxes contain compressed pixel data and are therefore
		    ' explicit VR and little endian
		    dcm.littleEndian = True
		    dcm.explicitVR = True
		    dcm.mCompressedPixelData = True
		  end select
		  ' #################################################################################################
		  
		  ' Parse the elements in this sequence item
		  dcm.ParseElementsInSequenceItem(stream, transferSyntaxUID)
		  
		  ' Return this new DICOM object
		  return dcm
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ElementAtCurrentStreamPosition(ByRef stream as Xojo.IO.BinaryStream, transferSyntaxUID as Text) As DICOMKit.ElementDK
		  ' Reads the next element from the passed BinaryStream and returns it.
		  ' The method also needs to know the transfer syntax as this will tell us if the file is little or 
		  ' big endian and whether to use explicit or implicit VRs.
		  ' Raises an exception if an error occurs.
		  
		  using DICOMKit.Helpers
		  
		  dim originalLittleEndianValue, littleEndian, explicitVR as Boolean
		  dim groupNum, elementNum as UInt16
		  dim elementTag, elementVR as Text
		  dim elementValueLength as Double
		  dim element as DICOMKit.ElementDK
		  
		  ' #################################################################################################
		  ' Transfer Syntax UID properties
		  ' #################################################################################################
		  select case transferSyntaxUID
		  case TransferSyntaxes.BIG_ENDIAN_EXPLICIT
		    littleEndian = False
		    explicitVR = True
		  case TransferSyntaxes.LITTLE_ENDIAN_EXPLICIT
		    littleEndian = True
		    explicitVR = True
		  case TransferSyntaxes.LITTLE_ENDIAN_IMPLICIT
		    littleEndian = True
		    explicitVR = False
		  else
		    ' All the remaining transfer syntaxes contain compressed pixel data and are therefore explicit VR
		    ' and little endian
		    explicitVR = True
		    littleEndian = True
		  end select
		  ' #################################################################################################
		  
		  ' Remember whether or not the BinaryStream is little or big endian before we change it
		  originalLittleEndianValue = stream.littleEndian
		  
		  ' Set the endianness
		  stream.littleEndian = littleEndian
		  
		  ' Get this element's tag
		  groupNum = stream.ReadUInt16()
		  elementNum = stream.ReadUInt16()
		  elementTag = Hex16(groupNum) + "," + Hex16(elementNum)
		  
		  if explicitVR then
		    ' ---------------------
		    ' Explicit VR element
		    ' ---------------------
		    ' VR
		    elementVR = stream.ReadText(2, Xojo.Core.TextEncoding.UTF8)
		    select case elementVR
		    case VRs.OTHER_BYTE_STRING, VRs.OTHER_WORD_STRING, VRs.OTHER_FLOAT_STRING, _
		      VRs.SEQUENCE_OF_ITEMS, VRs.UNLIMITED_TEXT, VRs.UNKNOWN
		      ' The next two bytes are reserved/blank (so we'll skip them)
		      stream.position = stream.position + 2
		      ' Value length for these VRs is 4 bytes
		      elementValueLength = stream.ReadUInt32()
		    else
		      ' Value length for the other VRs is 2 bytes
		      elementValueLength = stream.ReadUInt16()
		    end select
		  else
		    ' ---------------------
		    ' Implicit VR element
		    ' ---------------------
		    ' Need to look up this element's VR from our VR dictionary
		    elementVR = VRs.FromTag(elementTag)
		    ' Value length
		    elementValueLength = stream.ReadUInt32()
		  end if
		  
		  ' Create our blank element
		  element = new ElementDK
		  
		  ' Set the element's tag, VR and value length
		  element.groupNumber = groupNum
		  element.elementNumber = elementNum
		  element.tag = elementTag
		  element.vr = elementVR
		  element.length = elementValueLength
		  
		  ' Multiple values? (i.e. value multiplicity)
		  element.multiplicity = CalculateElementVM(element.vr, element.length)
		  
		  ' Save the position in the stream of the start of this element's value
		  element.valueStartPosition = stream.position
		  
		  ' Read this element's value
		  ReadElementValueFromStream(element, stream, transferSyntaxUID)
		  
		  ' Return the endianness of the stream to its original value
		  stream.littleEndian = originalLittleEndianValue
		  
		  ' Return this element
		  return element
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParseElements(stream as Xojo.IO.BinaryStream, transferSyntaxUID as Text)
		  ' This method takes an open BinaryStream and parses all elements into this DICOM object.
		  ' It expects to be called AFTER ParseFileMetaInformation in order to have the required information to
		  ' correctly make sense of the stream. Also, ParseFileMetaInformation will tell us whether to use
		  ' little or big endian and whether this DICOM file is explicit or implicit VRs.
		  
		  using DICOMKit
		  using DICOMKit.Helpers
		  
		  dim element as ElementDK
		  
		  do until stream.EOF
		    
		    element = ElementAtCurrentStreamPosition(stream, transferSyntaxUID)
		    
		    ' Add this element to our dataset
		    dataset.AddElement(element)
		    
		  loop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParseElementsInSequenceItem(ByRef stream as Xojo.IO.BinaryStream, transferSyntaxUID as Text)
		  ' Takes an open BinaryStream at the start of a sequence item and parses it's elements.
		  
		  using DICOMKit
		  using DICOMKit.Helpers
		  
		  dim element as ElementDK
		  dim nextTag as Text
		  dim itemLength, itemEndPos as Double
		  
		  ' Check for the item tag at the beginning of the stream
		  nextTag = ReadTagFromStream(stream)
		  if nextTag <> Tags.ITEM then
		    ' Rewind the stream 4 bytes
		    stream.position = stream.position - 4
		    raise new ExceptionDK(ExceptionDK.MISSING_ITEM_TAG, _
		    "Missing item tag (FFFE,E000) at the beginning of this sequence item in " + _
		    "the ParseElementsInSequenceItem method of the ObjectDK class. Tag read was " + _
		    nextTag + " at position: " + stream.position.ToText)
		  end if
		  
		  ' Get the length of this sequence item
		  itemLength = stream.ReadUInt32()
		  
		  if itemLength = &hFFFFFFFF then
		    ' Undefined sequence item length
		    do
		      element = ElementAtCurrentStreamPosition(stream, transferSyntaxUID)
		      ' Add this element to our dictionary of elements
		      me.dataset.AddElement(element)
		      
		      ' Have we reached the end of this item?
		      if ReadTagFromStream(stream) = Tags.ITEM_DELIMINATION_ITEM then
		        ' Yes we have. Advance the stream 4 bytes (as they will be empty)
		        stream.position = stream.position + 4
		        exit
		      else
		        ' Not the last element in the sequence item yet. Rewind the stream by 4 bytes
		        stream.position = stream.position - 4
		      end if
		      
		    loop until stream.EOF
		  else
		    
		    ' Explicit sequence item length
		    itemEndPos = stream.position + itemLength
		    Do
		      element = ElementAtCurrentStreamPosition(stream, transferSyntaxUID)
		      
		      me.dataset.AddElement(element)
		      
		    loop until stream.position >= itemEndPos
		    
		  end if
		  
		  ' Determine this object's text encoding
		  SetEncoding()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParseFileMetaInformation()
		  ' To make sense of the contents of a DICOM file, we need some key information which is stored at the
		  ' beginning of the DICOM file, after the DICM prefix, called the DICOM File Meta Information.
		  ' This information is encoded as a set of DICOM elements with explicit VRs. All elements in
		  ' File Meta Information belong to DICOM group 0002.
		  ' See the note entitled File Meta Information for more details.
		  
		  Using Xojo.IO
		  Using DICOMKit.Helpers
		  
		  dim element as ElementDK
		  
		  ' Open our file as a BinaryStream
		  try
		    stream = BinaryStream.Open(file, Xojo.IO.BinaryStream.LockModes.Read)
		  catch noe as NilObjectException
		    raise new ExceptionDK(ExceptionDK.INVALID_FILE, _
		    "This ObjectDK's DICOM file does not exist (method: ObjectDK.ParseFileMetaInformation)")
		  catch ioe as IOException
		    raise new ExceptionDK(ExceptionDK.INVALID_STREAM, _
		    "Unable to open the DICOM file as a BinaryStream (method: ObjectDK.ParseFileMetaInformation)")
		  end try
		  
		  ' Move to the start of the file meta information header (after the preamble and DICM characters)
		  stream.position = 132
		  
		  ' The file meta header is ALWAYS encoded in little endian format
		  stream.littleEndian = True
		  
		  me.meta = new FileMetaInformationDK
		  
		  Do
		    ' Read only the group 0002 elements. Therefore, is the next element a group 0002 one?
		    if Hex16(stream.ReadUInt16) = "0002" then
		      
		      stream.position = stream.position - 2 ' rewind two bytes (as we just peeked ahead)
		      
		      element = ElementAtCurrentStreamPosition(stream, TransferSyntaxes.LITTLE_ENDIAN_EXPLICIT)
		      
		      select case element.tag
		      case Tags.FILE_META_INFORMATION_VERSION
		        'me.meta.version = element.ValueData.DataAtIndex(0)
		      case Tags.MEDIA_STORAGE_SOP_CLASS_UID
		        me.meta.MediaStorageSOPClassUID = element.ToText(myEncoding)
		      case Tags.MEDIA_STORAGE_SOP_INSTANCE_UID
		        me.meta.MediaStorageSOPInstanceUID = element.ToText(myEncoding)
		      case Tags.TRANSFER_SYNTAX_UID
		        me.meta.TransferSyntaxUID = element.ToText(myEncoding)
		        select case me.meta.TransferSyntaxUID
		        case TransferSyntaxes.BIG_ENDIAN_EXPLICIT
		          littleEndian = False
		          explicitVR = True
		          mCompressedPixelData = False
		        case TransferSyntaxes.LITTLE_ENDIAN_EXPLICIT
		          littleEndian = True
		          explicitVR = True
		          mCompressedPixelData = False
		        case TransferSyntaxes.LITTLE_ENDIAN_IMPLICIT
		          littleEndian = True
		          explicitVR = False
		          mCompressedPixelData = False
		        else
		          ' All the remaining transfer syntaxes contain compressed pixel data and are therefore
		          ' explicit VR and little endian
		          littleEndian = True
		          explicitVR = True
		          mCompressedPixelData = True
		        end select
		      case Tags.IMPLEMENTATION_CLASS_UID
		        me.meta.ImplementationClassUID = element.ToText(myEncoding)
		      case Tags.IMPLEMENTATION_VERSION_NAME
		        me.meta.ImplementationVersionName = element.ToText(myEncoding)
		      case Tags.SOURCE_APPLICATION_ENTITY_TITLE
		        me.meta.SourceAET = element.ToText(myEncoding)
		      case Tags.PRIVATE_INFORMATION_CREATOR_UID
		        me.meta.PrivateInformationCreatorUID = element.ToText(myEncoding)
		      case Tags.PRIVATE_INFORMATION
		        me.meta.PrivateInformation = element.ToText(myEncoding)
		      end select
		      
		    else
		      ' The next element is NOT a group 0002 one. Rewind the stream 2 bytes (as we've read two erroneously)
		      stream.position = stream.position - 2
		      exit
		    end if
		  loop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ReadElementValueFromStream(Byref element as DICOMKit.ElementDK, ByRef stream as Xojo.IO.BinaryStream, transferSyntaxUID as Text)
		  ' Takes an open BinaryStream which is positioned at the start of an element value.
		  ' Reads the value and sets the passed element's data to it.
		  
		  ' ########## TO DO ##########
		  ' Need to handle encapsulated pixel data:
		  ' http://dicom.nema.org/dicom/2013/output/chtml/part05/sect_A.4.html
		  
		  Using DICOMKit
		  Using DICOMKit.Helpers
		  
		  dim a as Integer
		  dim mb, memoryBlocks() as Xojo.Core.MemoryBlock
		  dim mutableMB as Xojo.Core.MutableMemoryBlock
		  dim rawTextValue, rawTextValues(), nullByte as Text
		  dim bitsAllocated as ElementDK
		  
		  nullByte = Text.FromUnicodeCodepoint(&h00)
		  
		  ' Set the position of the stream to the start of this element's value
		  stream.position = element.valueStartPosition
		  
		  if element = Nil then break
		  
		  ' Check for null values
		  if element.length = 0 then
		    element.data = new ElementDataDK(element.vr)
		    exit
		  end if
		  
		  if element.tag = Tags.PIXEL_DATA then
		    ' Is the data native (i.e. fixed value length) or encapsulated (i.e. unspecified length)
		    if element.length = &hFFFFFFFF then
		      ' Encapsulated pixel data. Always has a VR of OB
		      element.vr = VRs.OTHER_BYTE_STRING
		      ReadEncapsulatedPixelData(element, stream, transferSyntaxUID)
		    else
		      ' where BitsAllocated (0028,0100) has a value greater than 8 shall have a VR of OW
		      try
		        bitsAllocated = me.dataset.ElementWithTag("0028,0100", True)
		        if Integer.FromText(bitsAllocated.ToText) > 8 then
		          element.vr = VRs.OTHER_WORD_STRING
		        end if
		      catch
		        ' Either we weren't passed a reference to the owning DICOM object or
		        ' BitsAllocated doesn't exist. Do nothing
		      end try
		      ' Read the data
		      mb = stream.Read(element.length)
		      element.frames.Append(mb)
		    end if
		    exit ' we've finished handling this element
		  end if
		  
		  select case element.vr
		  case VRs.AGE_STRING, VRs.APPLICATION_ENTITY, VRs.CODE_STRING, VRs.DATE, VRs.DATE_TIME, VRs.DECIMAL_STRING, _
		    VRs.INTEGER_STRING, VRs.LONG_STRING, VRs.PERSON_NAME, VRs.SHORT_STRING, VRs.SHORT_TEXT, VRs.TIME, _
		    VRs.UNIQUE_IDENTIFIER
		    ' These VRs use the backslash (\) as a delimiter. Check to see if there is any value multiplicity
		    rawTextValue = stream.ReadText(element.length, Xojo.Core.TextEncoding.UTF8).Trim
		    ' Remove null bytes at the end of the Text value
		    if rawTextValue.Right(1) = nullByte then rawTextValue = rawTextValue.Left(rawTextValue.Length-1)
		    rawTextValues = rawTextValue.Split("\")
		    ' Convert this array of Text objects to an array of MemoryBlocks
		    for each t as Text in rawTextValues
		      memoryBlocks.Append(Xojo.Core.TextEncoding.UTF8.ConvertTextToData(t))
		    next t
		    element.data = new ElementDataDK(memoryBlocks, element.vr)
		  case VRs.LONG_TEXT, VRs.OTHER_BYTE_STRING, VRs.SHORT_TEXT, VRs.UNLIMITED_TEXT
		    ' Always have a VM of 1. Just read their value into a memoryBlock
		    rawTextValue = stream.ReadText(element.length, Xojo.Core.TextEncoding.UTF8).Trim
		    ' Remove null bytes at the end of the Text value
		    if rawTextValue.Right(1) = nullByte then rawTextValue = rawTextValue.Left(rawTextValue.Length-1)
		    element.data = new ElementDataDK(Xojo.Core.TextEncoding.UTF8.ConvertTextToData(rawTextValue), element.vr)
		  case VRs.ATTRIBUTE_TAG
		    mb = stream.Read(element.length)
		    element.data = new ElementDataDK(mb, element.vr)
		  case VRs.FLOATING_POINT_SINGLE
		    for a = 1 to element.multiplicity
		      mutableMB = new Xojo.Core.MutableMemoryBlock(4)
		      mutableMB.SingleValue(0) = stream.ReadSingle()
		      memoryBlocks.Append(mutableMB)
		    next a
		    element.data = new ElementDataDK(memoryBlocks, element.vr)
		  case VRs.FLOATING_POINT_DOUBLE
		    For a = 1 to element.multiplicity
		      mutableMB = new Xojo.Core.MutableMemoryBlock(8)
		      mutableMB.DoubleValue(0) = stream.ReadDouble()
		      memoryBlocks.Append(mutableMB)
		    next a
		    element.data = new ElementDataDK(memoryBlocks, element.vr)
		  case VRs.OTHER_FLOAT_STRING
		    mb = stream.Read(element.length)
		    element.data = new ElementDataDK(mb, element.vr)
		  case VRs.OTHER_WORD_STRING
		    mb = stream.Read(element.length)
		    element.data = new ElementDataDK(mb, element.vr)
		  case VRs.SEQUENCE_OF_ITEMS
		    ' Do we know the length of this sequence?
		    if element.length = &hFFFFFFFF then ' undefined sequence length
		      element.length = -1
		      ReadUndefinedSequence(element, stream, transferSyntaxUID)
		    else ' explicit length
		      ReadExplicitLengthSequence(element, stream, transferSyntaxUID,element.length)
		    end if
		  case VRs.SIGNED_LONG
		    for a = 1 to element.multiplicity
		      mutableMB = new Xojo.Core.MutableMemoryBlock(4)
		      mutableMB.Int32Value(0) = stream.ReadInt32()
		      memoryBlocks.Append(mutableMB)
		    next a
		    element.data = new ElementDataDK(memoryBlocks, element.vr)
		  case VRs.SIGNED_SHORT
		    for a = 1 to element.multiplicity
		      mutableMB = new xojo.Core.MutableMemoryBlock(2)
		      mutableMB.Int16Value(0) = stream.ReadInt16()
		      memoryBlocks.Append(mutableMB)
		    next a
		    element.data = new ElementDataDK(memoryBlocks, element.vr)
		  case VRs.UNSIGNED_LONG
		    for a = 1 to element.multiplicity
		      mutableMB = new Xojo.Core.MutableMemoryBlock(4)
		      mutableMB.UInt32Value(0) = stream.ReadUInt32()
		      memoryBlocks.Append(mutableMB)
		    next a
		    element.data = new ElementDataDK(memoryBlocks, element.vr)
		  case VRs.UNKNOWN
		    mb = stream.Read(element.length)
		    element.data = new ElementDataDK(mb,element.vr)
		  case VRs.UNSIGNED_SHORT
		    for a = 1 to element.multiplicity
		      mutableMB = new Xojo.Core.MutableMemoryBlock(2)
		      mutableMB.UInt16Value(0) = stream.ReadUInt16()
		      memoryBlocks.Append(mutableMB)
		    next a
		    element.data = new ElementDataDK(memoryBlocks, element.vr)
		  end select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ReadEncapsulatedPixelData(ByRef element as DICOMKit.ElementDK, ByRef stream as Xojo.IO.BinaryStream, transferSyntaxUID as Text)
		  ' Pixel data can either be native (i.e. raw data of explicit explicit length) or encapsulated
		  ' (i.e. compressed and of unknown length). This method takes a BinaryStream at the start of the 
		  ' passed element's value and reads the encapsulated data.
		  ' http://dicom.nema.org/dicom/2013/output/chtml/part05/sect_A.4.html
		  
		  ' The value is a sequence of bytes resulting from one of the encoding processes.
		  
		  ' The encoded pixel data is split into one or more fragments. Most commonly, a single fragment
		  ' represents a single frame although this is not always the case.
		  ' How the fragments are recombined depends upon the transfer syntax. I think most JPEG compressed
		  ' images require each fragment to represent a single frame when the PixelData elements contains
		  ' multiple frames. If the PixelData contains a single frame, sometimes multiple fragments make up
		  ' the data for that single frame.
		  ' We store the data (as a MemoryBlock) for each frame in this element's frames() array.
		  
		  ' The first item in the sequence of Items before the encoded pixel data stream shall be a Basic
		  ' Offset Table Item (BOTI). The BOTI is not required to be present:
		  ' (1). When BOTI is not present, the Item length shall be zero (&h00000000)
		  ' (2). When BOTI is present, the BOTI value contains concatenated 32-bit unsigned integer values
		  '      that are byte offsets to the first byte of the Item Tag of the first fragment for each 
		  '      frame in the sequence of Items. These offsets are measured from the first byte of the 
		  '      first byte of the first Item Tag following the BOTI
		  ' http://dicom.nema.org/dicom/2013/output/chtml/part05/sect_A.4.html#table_A.4-1
		  ' For a multi-frame image containing just one frame or a single frame image, the BOTI value may
		  ' be present or not. If present it will contain a single value (&h00000000)
		  ' Need to make sure we can accept both an empty BOTI (zero length) and a BOTI filled with
		  ' 32-bit offset values.
		  
		  #pragma BackgroundTasks False
		  
		  using DICOMKit
		  using DICOMKit.Helpers
		  
		  dim nextTag as Text
		  dim BOTILength, nextOffset, offset, offsets(), offsetAnchor as Double
		  dim a, b, d, numFrames, numOffsets as Integer
		  dim fragment, fragments() as ImageFragmentDK
		  dim numFramesElement as ElementDK
		  dim mutableMB as Xojo.Core.MutableMemoryBlock
		  
		  ' Check for the item tag at the beginning of the stream (will be the BOTI)
		  nextTag = ReadTagFromStream(stream)
		  if nextTag <> Tags.ITEM then
		    ' Rewind the stream 4 bytes
		    stream.position = stream.position - 4
		    raise new ExceptionDK(ExceptionDK.MISSING_ITEM_TAG, _
		    "Missing BOTI tag (FFFE,E000) at the beginning of the pixel data in " + _
		    "the ReadEncapsulatedPixelData method of the ObjectDK class. Tag read was " + _
		    nextTag + " at position: " + stream.position.ToText)
		  end if
		  
		  ' How many frames are there in this element?
		  try
		    numFramesElement = me.dataset.ElementWithTag(Tags.NUMBER_OF_FRAMES)
		    numFrames = Integer.FromText(numFramesElement.ToText)
		  catch
		    ' Not defined. Default to a single frame
		    numFrames = 1
		  end try
		  
		  ' Get the length of the BOTI
		  BOTILength = stream.ReadUInt32()
		  
		  ' Have any offsets been specified?
		  if BOTILength <> &h00000000 then
		    ' Get the offsets (this will help us concatenate the fragments into their respective frames later)
		    ' How many offsets are specified?
		    numOffsets = Floor(BOTILength/4)
		    ' Build an array where each entry is the offset from this position in the stream to the
		    ' start of each frame
		    for a = 1 to numOffsets
		      offsets.Append(stream.ReadUInt32())
		    next a
		  end if
		  
		  ' In order to figure out a fragment's offset origin, we need to have a fixed anchor in the stream
		  ' to work with. This will be the first byte of the first Item Tag
		  offsetAnchor = stream.position
		  
		  ' Get each fragment
		  do
		    
		    if ReadTagFromStream(stream) <> Tags.ITEM then
		      ' We're expecting the start of a fragment but we haven't found one. Raise an exception
		      dim err as new ExceptionDK(ExceptionDK.MISSING_ITEM_TAG, _
		      "Missing item tag (FFFE,E000) at the start of a fragment in " + _
		      "ObjectDK.ReadEncapsulatedPixelData at position " + stream.position.ToText)
		      raise err
		    end if
		    
		    fragment = new ImageFragmentDK
		    
		    ' Store the start position of this fragment
		    fragment.startPosition = stream.position
		    
		    ' Store the relative offset
		    fragment.offset = fragment.startPosition - offsetAnchor
		    
		    ' Get the length of the fragment
		    fragment.length = stream.ReadUInt32() 
		    
		    ' Read the fragment data
		    fragment.data = stream.Read(fragment.length)
		    
		    ' Save this fragment. We'll place the proximal fragments at the end of the array so they
		    ' can be popped off
		    if fragments.Ubound < 0 then
		      fragments.Append(fragment)
		    else
		      fragments.Insert(0, fragment)
		    end if
		    
		    ' Have we reached the end of the pixel data?
		    if ReadTagFromStream(stream) = Tags.SEQUENCE_DELIMINATION_ITEM then
		      ' Yes we have. Advance the stream 4 bytes (as they will be empty)
		      stream.position = stream.position + 4
		      exit
		    else
		      ' Not the last element in the sequence item yet. Rewind the stream by 4 bytes and loop again
		      stream.position = stream.position - 4
		    end if
		    
		  loop until stream.EOF
		  
		  ' Now we have all of our fragments, we need to concatenate them into frames
		  if numFrames = 1 then
		    ' Concatenate all fragments into a single frame
		    mutableMB = new Xojo.Core.MutableMemoryBlock(0)
		    while fragments.Ubound >= 0
		      mutableMB.Append(fragments.Pop.data)
		    wend
		    element.frames.Append(mutableMB.Clone)
		  else
		    ' A multiframe image
		    if offsets.Ubound >= 0 then
		      b = offsets.Ubound
		      for a = 0 to b
		        ' Get the offset for the beginning of the current frame
		        offset = offsets(a)
		        ' Create an empty memory block to hold the data for this frame
		        mutableMB = new Xojo.Core.MutableMemoryBlock(0)
		        if a = b then
		          ' This is the final frame, concatenate all remaining fragments
		          while fragments.Ubound >= 0
		            mutableMB.Append(fragments.Pop.data)
		          wend
		          ' Add the data for this frame to this element
		          element.frames.Append(mutableMB.Clone)
		          ' Move to the next frame
		          exit
		        else
		          ' We need to know the offset of the next frame so we know when to stop concatenating
		          nextOffset = offsets(a+1)
		          while fragments.Ubound >= 0
		            fragment = fragments.Pop
		            if fragment.offset >= nextOffset then
		              fragments.Append(fragment) ' didn't mean to pop this off the stack. Put it back
		              ' Add the data for this frame to this element
		              element.frames.Append(mutableMB.Clone)
		              ' Move to the next frame
		              exit
		            else
		              mutableMB.Append(fragment.data) ' add this fragment to the current frame and loop again
		            end if
		          wend
		        end if
		      next a
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ReadExplicitLengthSequence(element as DICOMKit.ElementDK, stream as Xojo.IO.BinaryStream, transferSyntaxUID as Text, sequenceLength as Double)
		  ' The passed element's value is a sequence of items (ObjectDKs).
		  ' We know the length of this sequence (sequenceLength).
		  
		  dim sequenceEndPos as Double
		  
		  ' Some sequences have zero length
		  if sequenceLength = 0 then return
		  
		  sequenceEndPos = element.valueStartPosition + sequenceLength
		  
		  do
		    
		    ' Get this item
		    element.items.Append(ObjectDK.CreateAsSequenceItem(stream, transferSyntaxUID))
		    
		  loop until (stream.position >= sequenceEndPos) or stream.EOF
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ReadUndefinedSequence(ByRef element as DICOMKit.ElementDK, ByRef stream as Xojo.IO.BinaryStream, transferSyntaxUID as Text)
		  ' The passed element's value is a sequence of items (DICOMObjects). The entire sequence is of an
		  ' undefined length.
		  
		  Using DICOMKit.Helpers
		  
		  do
		    
		    ' Get this item
		    element.items.Append(ObjectDK.CreateAsSequenceItem(stream, transferSyntaxUID))
		    
		    ' Was this the last item in this sequence?
		    if ReadTagFromStream(stream) = Tags.SEQUENCE_DELIMINATION_ITEM then
		      ' Yes it it. Skip the next 4 bytes (as they should be blank)
		      stream.position = stream.position + 4
		      ' We're done
		      exit
		    else
		      ' Not the last item in the sequence yet. Rewind the stream by 4 bytes
		      stream.position = stream.position - 4
		    end if
		    
		  loop until stream.EOF ' ensure we always break out of the loop by the end of the stream
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetEncoding()
		  ' Sets the encoding that this object uses for its elements.
		  ' The default encoding for the DICOM standard is the 'default repertoire' aka ISO-IR-6 or ISO 646
		  ' A DICOM object may have its textual elements encoded in a different encoding. If this is the case
		  ' then the encoding will be specified in element 0008,0005.
		  
		  ' The encoding name specified in tag 0008,0005 is often an alias of the preferred IANA character
		  ' set name (e.g. DICOM specifies ISO-IR-6 but the IANA name for this is US-ASCII). Xojo creates
		  ' TextEncoding objects from the IANA name:
		  ' http://www.iana.org/assignments/character-sets/character-sets.xhtml
		  ' More info about the DICOM implementation of the specific character set element here:
		  ' https://www.dabsoft.ch/dicom/3/C.12.1.1.2/
		  
		  ' ########## TO DO ##########
		  ' Element 0008,0005 can have multiple values permitting something called 'Code Extensions'. This
		  ' is not yet supported by DICOMKit - we just use the first value in the element
		  
		  using DICOMKit
		  using DICOMKit.Helpers
		  
		  dim charElement as ElementDK
		  dim characterSet as Text
		  dim defaultEncoding as Xojo.Core.TextEncoding = Xojo.Core.TextEncoding.ASCII
		  
		  ' Get the character set element
		  try
		    charElement = me.dataset.ElementWithTag(Tags.SPECIFIC_CHARACTER_SET)
		  catch err as ExceptionDK
		    ' Use the default repertoire
		    if err.errorNumber = ExceptionDK.ELEMENT_NOT_FOUND then
		      myEncoding = defaultEncoding
		      return
		    end if
		  end try
		  
		  ' Get the first value of this element
		  try
		    characterSet = Xojo.Core.TextEncoding.ASCII.ConvertDataToText(charElement.data.DataAtIndex(0))
		  catch
		    ' Unable to get the character set from the element. Just use the default repertoire
		    myEncoding = defaultEncoding
		    return
		  end try
		  
		  ' Try to convert this to a Xojo TextEncoding object
		  select case characterSet
		  case "ISO_IR 100" ' Latin alphabet 1
		    myEncoding = Xojo.Core.TextEncoding.FromIANAName("ISO-8859-1")
		  case "ISO_IR 101" ' Latin alphabet 2
		    myEncoding = Xojo.Core.TextEncoding.FromIANAName("ISO-8859-2")
		  case "ISO_IR 109" ' Latin alphabet 3
		    myEncoding = Xojo.Core.TextEncoding.FromIANAName("ISO-8859-3")
		  case "ISO_IR 110" ' Latin alphabet 4
		    myEncoding = Xojo.Core.TextEncoding.FromIANAName("ISO-8859-4")
		  case "ISO_IR 144" ' Cyrillic
		    myEncoding = Xojo.Core.TextEncoding.FromIANAName("ISO-8859-5")
		  case "ISO_IR 127" ' Arabic
		    myEncoding = Xojo.Core.TextEncoding.FromIANAName("ISO-8859-6")
		  case "ISO_IR 126" ' Greek
		    myEncoding = Xojo.Core.TextEncoding.FromIANAName("ISO-8859-7")
		  case "ISO_IR 138" ' Hebrew
		    myEncoding = Xojo.Core.TextEncoding.FromIANAName("ISO-8859-8")
		  case "ISO_IR 148" ' Latin alphabet 5
		    myEncoding = Xojo.Core.TextEncoding.FromIANAName("ISO-8859-9")
		  case "ISO_IR 13" ' Japanese
		    myEncoding = Xojo.Core.TextEncoding.FromIANAName("JIS_C6220-1969-jp") ' might be wrong...
		  else
		    myEncoding = defaultEncoding
		  end select
		  
		  exception
		    ' Something bad happened - just return the default repertoire
		    myEncoding = defaultEncoding
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToPicture(frame as Integer = 0) As Picture
		  ' Returns (as a Xojo Picture object) this DICOM's image.
		  ' The optional frame parameter specifies which frame of a multiframe image to return. Defaults to
		  ' the first frame.
		  ' If we encounter an error, we'll return a Nil object
		  
		  ' Essentially a convenience wrapper for ToPicture(frame, centre, width)
		  
		  return ToPicture(frame, 0, 0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToPicture(frame as Integer, windowCentre as Integer, windowWidth as Integer) As Picture
		  ' Returns (as a Xojo Picture object) this DICOM's image.
		  ' The optional frame parameter specifies which frame of a multiframe image to return. Defaults to
		  ' the first frame.
		  ' If specified, we will (attempt to) apply the required window width and centre to the image.
		  ' If window levels not specified (both values = 0) then we use this DICOM's intrinsic window values.
		  ' If we encounter an error, we'll return a Nil object
		  
		  using DICOMKit.Helpers
		  using DICOMKit.PixelData
		  
		  dim data as Xojo.Core.MemoryBlock
		  dim pi as Text
		  dim pixMeta as new PixelMeta
		  
		  ' Get the raw pixel data as a MemoryBlock
		  try
		    data = me.dataset.ElementWithTag(Tags.PIXEL_DATA).frames(0)
		  catch err as RuntimeException
		    ' Couldn't get the PixelData element
		    return Nil
		  end try
		  
		  ' Need to decompress the pixel data. Decoding depends on the transfer syntax
		  if mCompressedPixelData then data = PixelData.DecompressFrame(data, transferSyntax)
		  
		  ' We now have decompressed pixel data. Get the required information about how it's stored
		  try
		    pi = dataset.ElementWithTag(Tags.PHOTOMETRIC_INTERPRETATION).ToText
		  catch err as RuntimeException
		    return Nil ' we need the photometric interpretation value to proceed
		  end try
		  
		  try
		    pixMeta.columns = Integer.FromText(dataset.ElementWithTag(Tags.COLUMNS).ToText)
		    if pixMeta.columns <= 0 then return Nil ' invalid number of columns
		  catch err as RuntimeException
		    return Nil ' we need to know the number of columns in the image to proceed
		  end try
		  
		  try
		    pixMeta.rows = Integer.FromText(dataset.ElementWithTag(Tags.ROWS).ToText)
		    if pixMeta.rows <= 0 then return Nil ' invalid number of rows
		  catch err as RuntimeException
		    return Nil ' we need to know the number of rows in the image to proceed
		  end try
		  
		  try
		    pixMeta.samplesPerPixel = Integer.FromText(dataset.ElementWithTag(Tags.SAMPLES_PER_PIXEL).ToText)
		  catch err as RuntimeException
		    return Nil ' we need to know the number of samples per pixel in the image to proceed
		  end try
		  
		  if pixMeta.samplesPerPixel > 1 then ' colour image
		    try
		      pixMeta.planarConfig = Integer.FromText(dataset.ElementWithTag(Tags.PLANAR_CONFIG).ToText)
		    catch err as RuntimeException
		      return Nil ' we need to know the planar configuration for colour images
		    end try
		  end if
		  
		  try
		    pixMeta.rescaleIntercept = Double.FromText(dataset.ElementWithTag(Tags.RESCALE_INTERCEPT).ToText)
		  catch err as RuntimeException
		    pixMeta.rescaleIntercept = 0
		  end try
		  
		  try
		    pixMeta.rescaleSlope = Double.FromText(dataset.ElementWithTag(Tags.RESCALE_SLOPE).ToText)
		  catch err as RuntimeException
		    pixMeta.rescaleSlope = 1
		  end try
		  
		  try
		    pixMeta.bitsAllocated = Integer.FromText(dataset.ElementWithTag(Tags.BITS_ALLOCATED).ToText)
		  catch err as RuntimeException
		    return Nil ' we need to know the bits allocated to proceed
		  end try
		  
		  try
		    pixMeta.bitsStored = Integer.FromText(dataset.ElementWithTag(Tags.BITS_STORED).ToText)
		  catch err as RuntimeException
		    return Nil ' we need to know the bits stored to proceed
		  end try
		  
		  try
		    pixMeta.highBit = Integer.FromText(dataset.ElementWithTag(Tags.HIGH_BIT).ToText)
		  catch err as RuntimeException
		    return Nil ' we need to know the high bit
		  end try
		  
		  try
		    pixMeta.pixelRepresentation = Integer.FromText(dataset.ElementWithTag(Tags.PIXEL_REPRESENTATION).ToText)
		  catch err as RuntimeException
		    return Nil ' we need to know the pixel representation
		  end try
		  
		  if windowCentre = 0 and windowWidth = 0 then
		    ' Use the DICOM's specified windowing levels
		    try
		      pixMeta.windowCentre = Integer.FromText(dataset.ElementWithTag(Tags.WINDOW_CENTRE).ToText)
		      try
		        pixMeta.windowWidth = Integer.FromText(dataset.ElementWithTag(Tags.WINDOW_WIDTH).ToText)
		        pixMeta.hasWindowValues = True
		      catch err as RuntimeException
		        pixMeta.hasWindowValues = False
		      end try
		    catch err as RuntimeException
		      pixMeta.hasWindowValues = False
		    end try
		  else
		    ' Use the specified windowing levels
		    pixMeta.hasWindowValues = True
		    pixMeta.windowCentre = windowCentre
		    pixMeta.windowWidth = windowWidth
		  end if
		  
		  select case pi
		  case "MONOCHROME1"
		    return PixelData.MonochromeDataToPicture(data, pixMeta, True)
		  case "MONOCHROME2"
		    return PixelData.MonochromeDataToPicture(data, pixMeta)
		  case else
		    ' This type of photometric interpretation is not yet supported by DICOMKit
		    return Nil
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToPictureWithWindow(windowCentre as Integer, windowWidth as Integer, frame as Integer = 0) As Picture
		  ' Returns (as a Xojo Picture object) this DICOM's image.
		  ' The optional frame parameter specifies which frame of a multiframe image to return. Defaults to
		  ' the first frame.
		  ' Attempts apply the required window width and centre to the image.
		  ' If we encounter an error, we'll return a Nil object
		  
		  ' Essentially a wrapper around the ToPicture(frame, centre, width) method.
		  
		  return ToPicture(frame, windowCentre, windowWidth)
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mCompressedPixelData
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  ' Read only.
			End Set
		#tag EndSetter
		compressedPixelData As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		dataset As DICOMKit.DatasetDK
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return myEncoding
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  ' Read-only.
			End Set
		#tag EndSetter
		encoding As Xojo.Core.TextEncoding
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected explicitVR As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			The file on disk that this DICOM object represents.
		#tag EndNote
		Protected file As Xojo.IO.FolderItem
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			Default to True as there are only two transfer syntax UIDs that are big endian:
			
			- TransferSyntaxes.BigEndianExplicit
			- TransferSyntaxes.DeflatedExplicitBigEndian
			
			the rest are little endian.
		#tag EndNote
		Protected littleEndian As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCompressedPixelData As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected meta As DICOMKit.FileMetaInformationDK
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The encoding to use for text elements stored in the object
		#tag EndNote
		Private myEncoding As Xojo.Core.TextEncoding
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected stream As Xojo.IO.BinaryStream
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return me.meta.TransferSyntaxUID
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  ' Read only.
			End Set
		#tag EndSetter
		transferSyntax As Text
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="compressedPixelData"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
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
		#tag ViewProperty
			Name="transferSyntax"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
