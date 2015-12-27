#tag Class
Protected Class ElementDataDK
	#tag Method, Flags = &h0
		Sub Constructor(vr as Text)
		  ' Construct an instance with a null value.
		  
		  redim memoryBlocks(-1)
		  me.multiplicity = 1
		  me.vr = vr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(values() as Xojo.Core.MemoryBlock, vr as Text)
		  ' Construct an instance with multiple values.
		  
		  dim mb as Xojo.Core.MemoryBlock
		  
		  ' Store the data
		  for each mb in values
		    memoryBlocks.Append(mb)
		  next mb
		  
		  ' Set the multiplicity
		  me.multiplicity = memoryBlocks.Ubound + 1
		  
		  me.vr = vr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(value as Xojo.Core.MemoryBlock, vr as Text)
		  ' Construct an instance with a single multiplicity and a single value.
		  
		  ' Store the solitary value
		  memoryBlocks.Append(value)
		  
		  ' Set the multiplicity to 1
		  me.multiplicity = 1
		  
		  me.vr = vr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DataAtIndex(index as Integer) As Xojo.Core.MemoryBlock
		  ' Returns the raw value of the data at the specified index (zero-based).
		  
		  Using DICOMKit
		  
		  if memoryBlocks.Ubound < 0 then
		    return Nil
		  else
		    return memoryBlocks(index)
		  end if
		  
		  exception err as OutOfBoundsException
		    raise new ExceptionDK(ExceptionDK.OUT_OF_BOUNDS, _
		    "Out of bounds exception raised in the DataAtIndex setter method of " + _
		    "the ElementData class")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DataAtIndex(index as Integer, Assigns mb As Xojo.Core.MemoryBlock)
		  ' Assigns the passed MemoryBlock at the specified index.
		  
		  Using DICOMKit
		  
		  memoryBlocks(index) = mb
		  
		  exception err as OutOfBoundsException
		    raise new ExceptionDK(ExceptionDK.OUT_OF_BOUNDS, _
		    "Out of bounds exception raised in the DataAtIndex setter method of " + _
		    "the ElementData class")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToText(index as Integer = - 1, theEncoding as xojo.Core.TextEncoding = Nil) As Text
		  ' Returns this element's value(s) as a Text object.
		  ' If index = -1 then we'll concatenate all values with the backslash (\) character.
		  ' If an index is specified, then that's the value we'll convert to Text and return.
		  ' Defaults to using ASCII encoding.
		  
		  using DICOMKit.Helpers
		  
		  dim mb as Xojo.Core.MemoryBlock
		  dim t as Text
		  
		  if (memoryBlocks.Ubound < 0) or (index < -1) or (index > memoryBlocks.Ubound) then return ""
		  
		  if theEncoding = Nil then theEncoding = Xojo.Core.TextEncoding.ASCII
		  
		  if index = -1 then
		    for each mb in MemoryBlocks
		      
		      select case me.vr
		      case VRs.ATTRIBUTE_TAG
		        t = t + mb.UInt16Value(0).ToText + "," + mb.UInt16Value(2).ToText + "\"
		      case VRs.FLOATING_POINT_SINGLE
		        t = t + mb.SingleValue(0).ToText + "\"
		      case VRs.FLOATING_POINT_DOUBLE
		        t = t + mb.DoubleValue(0).ToText + "\"
		      case VRs.OTHER_BYTE_STRING, VRs.OTHER_FLOAT_STRING, VRs.OTHER_WORD_STRING
		        t = ""
		      case VRs.SIGNED_LONG
		        t = t + mb.Int32Value(0).ToText + "\"
		      case VRs.SIGNED_SHORT
		        t = t + mb.Int16Value(0).ToText + "\"
		      case VRs.UNSIGNED_LONG
		        t = t + mb.UInt32Value(0).ToText + "\"
		      case VRs.UNSIGNED_SHORT
		        t = t + mb.UInt16Value(0).ToText + "\"
		      else
		        ' Just convert to Text
		        t = t + theEncoding.ConvertDataToText(mb) + "\"
		      end select
		      
		    next mb
		    
		    ' Trim a trailing backslash (if present)
		    if t.Right(1) = "\" then t = t.Left(t.Length-1)
		    
		  else
		    ' index specified
		    mb = DataAtIndex(index)
		    
		    select case me.vr
		    case VRs.ATTRIBUTE_TAG
		      t = mb.UInt16Value(0).ToText + "," + mb.UInt16Value(2).ToText
		    case VRs.FLOATING_POINT_SINGLE
		      t = mb.SingleValue(0).ToText
		    case VRs.FLOATING_POINT_DOUBLE
		      t = mb.DoubleValue(0).ToText
		    case VRs.OTHER_BYTE_STRING, VRs.OTHER_FLOAT_STRING, VRs.OTHER_WORD_STRING
		      t = ""
		    case VRs.SIGNED_LONG
		      t = mb.Int32Value(0).ToText
		    case VRs.SIGNED_SHORT
		      t = mb.Int16Value(0).ToText
		    case VRs.UNSIGNED_LONG
		      t = mb.UInt32Value(0).ToText
		    case VRs.UNSIGNED_SHORT
		      t = mb.UInt16Value(0).ToText
		    else
		      ' Just convert to Text
		      t = theEncoding.ConvertDataToText(mb)
		    end select
		    
		  end if
		  
		  return t
		  
		  exception
		    ' This usually happens when TextEncoding can't convert to ASCII. Just return an empty Text object
		    return ""
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		#tag Note
			An array of MemoryBlocks where each item is an individual value. For example, element's with a VM of 1 will have
			a single item. It is possible for an element to have a null value. In this scenario, MemoryBlocks() will be empty.
		#tag EndNote
		Private memoryBlocks() As Xojo.Core.MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			How many values are stored in this data object (i.e. its parent element's value multiplicity or VM).
		#tag EndNote
		multiplicity As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The VR of this data's owning element.
		#tag EndNote
		Private vr As Text
	#tag EndProperty


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
			Name="multiplicity"
			Group="Behavior"
			InitialValue="1"
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
End Class
#tag EndClass
