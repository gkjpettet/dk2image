#tag Class
Protected Class ElementDK
	#tag Method, Flags = &h0
		Sub Constructor()
		  ' Start with null data value
		  me.data = new ElementDataDK(DICOMKit.Helpers.VRs.UNKNOWN)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToText(characterSet as Xojo.Core.TextEncoding = Nil) As Text
		  ' Returns (if possible) a text representation of this element's data.
		  ' Needs to know the character set of the enclosing DICOM object.
		  
		  ' If no characterSet is specified, default to ASCII
		  if characterSet = Nil then characterSet = Xojo.Core.TextEncoding.ASCII
		  
		  return me.data.ToText(-1, characterSet)
		  
		  exception
		    ' Unable to convert the data to Text. Just return nothing
		    return ""
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		data As DICOMKit.ElementDataDK
	#tag EndProperty

	#tag Property, Flags = &h0
		elementNumber As UInt16
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Only relevant for PixelData elements.
		#tag EndNote
		frames() As Xojo.Core.MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h0
		groupNumber As UInt16
	#tag EndProperty

	#tag Property, Flags = &h0
		Items() As DICOMKit.ObjectDK
	#tag EndProperty

	#tag Property, Flags = &h0
		length As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		multiplicity As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			This element's tag. In the format: group,element (no space between comma)
			E.g: 0002,0001
		#tag EndNote
		tag As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		valueStartPosition As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VR As Text
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="elementNumber"
			Group="Behavior"
			Type="UInt16"
		#tag EndViewProperty
		#tag ViewProperty
			Name="groupNumber"
			Group="Behavior"
			Type="UInt16"
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
			Name="length"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="multiplicity"
			Group="Behavior"
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
			Name="tag"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="valueStartPosition"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="VR"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
