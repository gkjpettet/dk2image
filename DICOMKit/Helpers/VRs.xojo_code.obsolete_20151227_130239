#tag Class
Protected Class VRs
	#tag Method, Flags = &h0
		 Shared Function FromTag(tag as Text) As Text
		  ' Takes a DICOM element tag (as a Text object in the format: group number,element number) and returns
		  ' it's VR. Used for implicitly encoded DICOM files.
		  
		  ' Has our helper VR dictionary been initialised?
		  if VRDictionary = Nil then InitialiseVRDictionary()
		  
		  ' Return the VR for this tag
		  return VRDictionary.Lookup(tag, VRs.UNKNOWN)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub InitialiseVRDictionary()
		  ' Initialise our VR dictionary. This is a private dictionary containing tags (group number,element number)
		  ' as the key and the VR as the corresponding value.
		  ' The dictionary is only accessible via shared getter methods from this class.
		  
		  VRDictionary = new Xojo.Core.Dictionary
		  
		  VRDictionary.Value("0002,0000") = VRs.UNSIGNED_LONG ' FileMetaInformationGroupLength
		  VRDictionary.Value("0002,0001") = VRs.OTHER_BYTE_STRING ' FileMetaInformationVersion
		  VRDictionary.Value("0002,0010") = VRs.UNIQUE_IDENTIFIER ' TransferSyntaxUID
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		#tag Note
			A private dictionary containing tags (group number,element number) as the key and
			the VR as the corresponding value.
		#tag EndNote
		Private Shared VRDictionary As Xojo.Core.Dictionary
	#tag EndProperty


	#tag Constant, Name = AGE_STRING, Type = Text, Dynamic = False, Default = \"AS", Scope = Public
	#tag EndConstant

	#tag Constant, Name = APPLICATION_ENTITY, Type = Text, Dynamic = False, Default = \"AE", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ATTRIBUTE_TAG, Type = Text, Dynamic = False, Default = \"AT", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CODE_STRING, Type = Text, Dynamic = False, Default = \"CS", Scope = Public
	#tag EndConstant

	#tag Constant, Name = DATE, Type = Text, Dynamic = False, Default = \"DA", Scope = Public
	#tag EndConstant

	#tag Constant, Name = DATE_TIME, Type = Text, Dynamic = False, Default = \"DT", Scope = Public
	#tag EndConstant

	#tag Constant, Name = DECIMAL_STRING, Type = Text, Dynamic = False, Default = \"DS", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FLOATING_POINT_DOUBLE, Type = Text, Dynamic = False, Default = \"FD", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FLOATING_POINT_SINGLE, Type = Text, Dynamic = False, Default = \"FL", Scope = Public
	#tag EndConstant

	#tag Constant, Name = INTEGER_STRING, Type = Text, Dynamic = False, Default = \"IS", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LONG_STRING, Type = Text, Dynamic = False, Default = \"LO", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LONG_TEXT, Type = Text, Dynamic = False, Default = \"LT", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OTHER_BYTE_STRING, Type = Text, Dynamic = False, Default = \"OB", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OTHER_FLOAT_STRING, Type = Text, Dynamic = False, Default = \"OF", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OTHER_WORD_STRING, Type = Text, Dynamic = False, Default = \"OW", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PERSON_NAME, Type = Text, Dynamic = False, Default = \"PN", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SEQUENCE_OF_ITEMS, Type = Text, Dynamic = False, Default = \"SQ", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SHORT_STRING, Type = Text, Dynamic = False, Default = \"SH", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SHORT_TEXT, Type = Text, Dynamic = False, Default = \"ST", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SIGNED_LONG, Type = Text, Dynamic = False, Default = \"SL", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SIGNED_SHORT, Type = Text, Dynamic = False, Default = \"SS", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TIME, Type = Text, Dynamic = False, Default = \"TM", Scope = Public
	#tag EndConstant

	#tag Constant, Name = UNIQUE_IDENTIFIER, Type = Text, Dynamic = False, Default = \"UI", Scope = Public
	#tag EndConstant

	#tag Constant, Name = UNKNOWN, Type = Text, Dynamic = False, Default = \"UN", Scope = Public
	#tag EndConstant

	#tag Constant, Name = UNLIMITED_TEXT, Type = Text, Dynamic = False, Default = \"UT", Scope = Public
	#tag EndConstant

	#tag Constant, Name = UNSIGNED_LONG, Type = Text, Dynamic = False, Default = \"UL", Scope = Public
	#tag EndConstant

	#tag Constant, Name = UNSIGNED_SHORT, Type = Text, Dynamic = False, Default = \"US", Scope = Public
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
End Class
#tag EndClass
