#tag Class
Protected Class Argument
	#tag Method, Flags = &h0
		Sub Constructor(argName as Text, ParamArray argOptions as Text)
		  me.name = argName
		  
		  for each option as Text in argOptions
		    options.Append(option)
		  next option
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		#tag Note
			The name of this argument
		#tag EndNote
		name As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			This argument's options (if any)
		#tag EndNote
		options() As Text
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
			Name="name"
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
