#tag Module
Protected Module Helpers
	#tag Method, Flags = &h1
		Protected Function Hex16(value as UInt16) As Text
		  ' This method takes a UInt16 and returns its Hex representation as a Text object. 
		  ' It'll always be 4 characters in length. We'll pad with 00's as needed.
		  
		  dim t as Text
		  
		  t = "0000" + value.ToHex
		  
		  return t.Right(4) ' always return 4 characters
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ReadTagFromStream(ByRef stream as Xojo.IO.BinaryStream) As Text
		  ' Reads a tag (group number, element number) and returns it as a Text object.
		  ' Will advance the BinaryStream by 4 bytes.
		  
		  #pragma BackgroundTasks False
		  
		  return Hex16(stream.ReadUInt16) + "," + Hex16(stream.ReadUInt16)
		End Function
	#tag EndMethod


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
