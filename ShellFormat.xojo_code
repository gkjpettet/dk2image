#tag Module
Protected Module ShellFormat
	#tag Method, Flags = &h1
		Protected Function Colourise(phrase as String, foreColor as ShellColor, backColor as ShellColor = ShellColor.Default) As String
		  return ShellFormat.Formatted(phrase, False, False, foreColor, backColor)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Formatted(phrase as String, bold as Boolean, underline as Boolean, foreColor as ShellColor, backColor as ShellColor) As String
		  ' chrb(27) is ESC
		  
		  dim fc, bc, b, u as String
		  
		  select case foreColor
		  case ShellColor.Black
		    fc = FG_BLACK
		  case ShellColor.Blue
		    fc = FG_BLUE
		  case ShellColor.Cyan
		    fc = FG_CYAN
		  case ShellColor.Green
		    fc = FG_GREEN
		  case ShellColor.Magenta
		    fc = FG_MAGENTA
		  case ShellColor.Red
		    fc = FG_RED
		  case ShellColor.White
		    fc = FG_WHITE
		  case ShellColor.Yellow
		    fc = FG_YELLOW
		  case else
		    fc = FG_DEFAULT
		  end select
		  
		  select case backColor
		  case ShellColor.Black
		    bc = BG_BLACK
		  case ShellColor.Blue
		    bc = BG_BLUE
		  case ShellColor.Cyan
		    bc = BG_CYAN
		  case ShellColor.Green
		    bc = BG_GREEN
		  case ShellColor.Magenta
		    bc = BG_MAGENTA
		  case ShellColor.Red
		    bc = BG_RED
		  case ShellColor.White
		    bc = BG_WHITE
		  case ShellColor.Yellow
		    bc = BG_YELLOW
		  case else
		    bc = BG_DEFAULT
		  end select
		  
		  b = if(bold, BOLD_ON, BOLD_OFF)
		  
		  u = if(underline, UNDERLINE_ON, UNDERLINE_OFF)
		  
		  return chrb(27) + "[" + fc + ";" + bc + ";" + b + ";" + u + "m"  + phrase + chrb(27) + "[0m"
		End Function
	#tag EndMethod


	#tag Note, Name = About
		This is a simple module for formatting the appearance of strings output to the console.
		
		Essentially a wrapper for the ANSI escape code sequences:
		https://en.wikipedia.org/wiki/ANSI_escape_code#graphics
		
		Thanks to this StackOverflow QA:
		http://stackoverflow.com/questions/2616906/how-do-i-output-coloured-text-to-a-linux-terminal
		
		Xojo thread credit:
		https://forum.xojo.com/28644-coloured-text-in-the-terminal-from-a-console-app
		
	#tag EndNote


	#tag Constant, Name = BG_BLACK, Type = String, Dynamic = False, Default = \"40", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BG_BLUE, Type = String, Dynamic = False, Default = \"44", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BG_CYAN, Type = String, Dynamic = False, Default = \"46", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BG_DEFAULT, Type = String, Dynamic = False, Default = \"49", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BG_GREEN, Type = String, Dynamic = False, Default = \"42", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BG_MAGENTA, Type = String, Dynamic = False, Default = \"45", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BG_RED, Type = String, Dynamic = False, Default = \"41", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BG_WHITE, Type = String, Dynamic = False, Default = \"47", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BG_YELLOW, Type = String, Dynamic = False, Default = \"43", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BOLD_OFF, Type = String, Dynamic = False, Default = \"22", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BOLD_ON, Type = String, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = FG_BLACK, Type = String, Dynamic = False, Default = \"30", Scope = Private
	#tag EndConstant

	#tag Constant, Name = FG_BLUE, Type = String, Dynamic = False, Default = \"34", Scope = Private
	#tag EndConstant

	#tag Constant, Name = FG_CYAN, Type = String, Dynamic = False, Default = \"36", Scope = Private
	#tag EndConstant

	#tag Constant, Name = FG_DEFAULT, Type = String, Dynamic = False, Default = \"39", Scope = Private
	#tag EndConstant

	#tag Constant, Name = FG_GREEN, Type = String, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = FG_MAGENTA, Type = String, Dynamic = False, Default = \"35", Scope = Private
	#tag EndConstant

	#tag Constant, Name = FG_RED, Type = String, Dynamic = False, Default = \"31", Scope = Private
	#tag EndConstant

	#tag Constant, Name = FG_WHITE, Type = String, Dynamic = False, Default = \"37", Scope = Private
	#tag EndConstant

	#tag Constant, Name = FG_YELLOW, Type = String, Dynamic = False, Default = \"33", Scope = Private
	#tag EndConstant

	#tag Constant, Name = UNDERLINE_OFF, Type = String, Dynamic = False, Default = \"24", Scope = Private
	#tag EndConstant

	#tag Constant, Name = UNDERLINE_ON, Type = String, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant


	#tag Enum, Name = ShellColor, Type = Integer, Flags = &h0
		Black
		  Blue
		  Cyan
		  Green
		  Magenta
		  Red
		  White
		  Yellow
		Default
	#tag EndEnum


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
