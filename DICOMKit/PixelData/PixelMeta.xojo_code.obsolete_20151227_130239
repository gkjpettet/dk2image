#tag Class
Protected Class PixelMeta
	#tag Method, Flags = &h0
		Function PixelFormat() As Integer
		  ' The number of bytes used to represent each pixel in the PixelData stream is determined by the
		  ' PixelRepresentation (element 0028,0103). This method returns a constant describing what data
		  ' type we need to read from the stream to get a pixel.
		  
		  ' Code based on the getPixelFormat() method from the Cornerstone WADOImageLoader:
		  '  https://github.com/chafey/cornerstoneWADOImageLoader/blob/master/src/getPixelFormat.js
		  
		  ' See also information on the PixelRepresentation element:
		  ' http://dicomlookup.com/lookup.asp?sw=Tnumber&q=(0028,0103)
		  
		  if (pixelRepresentation = 0 and bitsAllocated = 8) then
		    return UNSIGNED_8_BIT
		  elseif (pixelRepresentation = 0 and bitsAllocated = 16) then
		    return UNSIGNED_16_BIT
		  elseif (pixelRepresentation = 1 and bitsAllocated = 16) then
		    return SIGNED_16_BIT
		  end if
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		bitsAllocated As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		bitsStored As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		columns As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True then this image should be rendered using the specified window values
		#tag EndNote
		hasWindowValues As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		highBit As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		pixelRepresentation As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		planarConfig As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		rescaleIntercept As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		rescaleSlope As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		rows As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		samplesPerPixel As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		windowCentre As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		windowWidth As Integer = 0
	#tag EndProperty


	#tag Constant, Name = SIGNED_16_BIT, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = UNSIGNED_16_BIT, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = UNSIGNED_8_BIT, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="bitsAllocated"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="bitsStored"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="columns"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="hasWindowValues"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="highBit"
			Group="Behavior"
			Type="Integer"
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
			Name="pixelRepresentation"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="planarConfig"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="rescaleIntercept"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="rescaleSlope"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="rows"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="samplesPerPixel"
			Group="Behavior"
			Type="Integer"
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
			Name="windowCentre"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="windowWidth"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
