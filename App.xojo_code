#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  ' The only argument we take is the path of the DICOM.
		  
		  using ShellFormat
		  using DICOMKit
		  
		  ' Check at least one argument was passed
		  if args.Ubound < 1 then
		    Print Colourise("Error: ", ShellColor.Red) + "No input file specified."
		    Quit()
		  end if
		  
		  ' Process the arguments
		  try
		    ProcessArguments(args)
		  catch err as AppException
		    Print Colourise("Error: ", ShellColor.Red) + err.Message
		    Quit()
		  end try
		  
		  ' Has a valid DICOM file been passed?
		  try
		    if not DICOMKit.IsDICOM(dcmFile) then
		      if not quietMode then
		        Print Colourise("Error: ", ShellColor.Red) + dcmFile.Name + " is not a DICOM file."
		      end if
		      Quit()
		    end if
		  catch err as ExceptionDK
		    if not quietMode then Print Colourise("Error: ", ShellColor.Red) + err.Message
		    Quit()
		  end try
		  
		  ' Parse the DICOM file
		  try
		    dcm = DICOMKit.Open(dcmFile)
		  catch err as ExceptionDK
		    if not quietMode then Print Colourise("Error: ", ShellColor.Red) + err.Message
		    Quit()
		  end try
		  
		  ' Create the picture
		  
		  ' We're done
		  if not quietMode then Print "Done."
		  return ERROR_NONE
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function ArgumentDefined(argName as Text) As Boolean
		  ' Takes an argument name and returns True if its been previously passed, False if not.
		  ' Required as some arguments have both short (e.g. 'v') and long (e.g. 'verbose') forms.
		  
		  dim arg as Text
		  
		  if arguments.HasKey(argName) then return True
		  
		  if argName.Length = 1 then
		    ' Get the long form of this argument
		    try
		      arg = ArgumentLongName(argName)
		      return arguments.HasKey(arg)
		    catch
		      ' There is no long form version of this argument
		      return False
		    end try
		  else
		    ' Get the short form of this argument
		    try
		      arg = ArgumentShortName(argName)
		      return arguments.HasKey(arg)
		    catch
		      ' There is no short form version of this argument
		      return False
		    end try
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ArgumentLongName(shortName as Text) As Text
		  ' Takes the short form of an argument name and returns the long form version.
		  ' Raises an exception if the argument passed is not recognised.
		  
		  select case shortName
		  case "h"
		    return "help"
		  case "q"
		    return "quiet"
		  case "f"
		    return "frame"
		  case "fr"
		    return "frame-range"
		  case "fa"
		    return "all-frames"
		  case "rl"
		    return "rotate-left"
		  case "rr"
		    return "rotate-right"
		  case "fh"
		    return "flip-horizontally"
		  case "fv"
		    return "flip-vertically"
		  case "ww"
		    return "set-window"
		  case "oj"
		    return "write-jpeg"
		  case "op"
		    return "write-png"
		  case "ob"
		    return "write-bmp"
		  case "ot"
		    return "write-tiff"
		  case else
		    dim err as new AppException(ARGUMENT_HAS_NO_LONGNAME, "Argument '" + _
		    shortName + "' has no long form")
		    raise err
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ArgumentShortName(longName as Text) As Text
		  ' Takes the long form of an argument name and returns the short form version.
		  ' Raises an exception if the argument passed is not recognised.
		  
		  select case longName
		  case "help"
		    return "h"
		  case "quiet"
		    return "q"
		  case "frame"
		    return "f"
		  case "frame-range"
		    return "fr"
		  case "all-frames"
		    return "fa"
		  case "rotate-left"
		    return "rl"
		  case "rotate-right"
		    return "rr"
		  case "flip-horizontally"
		    return "fh"
		  case "flip-vertically"
		    return "fv"
		  case "set-window"
		    return "ww"
		  case "write-jpeg"
		    return "oj"
		  case "write-png"
		    return "op"
		  case "write-bmp"
		    return "ob"
		  case "write-tiff"
		    return "ot"
		  case else
		    dim err as new AppException(ARGUMENT_HAS_NO_SHORTNAME, "Argument '" + _
		    longName + "' has no short form")
		    raise err
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function OptionsExpected(argumentName as Text) As Integer
		  ' Takes the name of an argument and returns how many options (if any) are expected.
		  
		  select case argumentName
		  case "h", "help", "version", "q", "quiet", "fa", "all-frames", "rl", "rotate-left", _
		    "rr", "rotate-right", "fh", "flip-horizontally", "fv", "flip-vertically", "oj", _
		    "write-jpeg", "op", "write-png", "ob", "write-bmp", "ot", "write-tiff"
		    return 0
		  case "f", "frame"
		    return 1
		  case "fr", "frame-range", "ww", "set-window"
		    return 2
		  else ' unknown argument
		    return 0
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessArguments(args() as String)
		  dim a, optionsLeft as Integer
		  dim argName, lastArgName as Text
		  dim arg as Argument
		  dim isArg as Boolean
		  
		  arguments = new Xojo.Core.Dictionary
		  
		  for a = 0 to args.Ubound
		    argName = args(a).ToText
		    if a = 0 then
		      continue ' the 1st argument is always the app path
		    elseif a = 1 then ' should be the input file
		      try
		        dcmFile = new Xojo.IO.FolderItem(argName)
		      catch
		        dim err as new AppException(ERROR_INVALID_INPUT_FILE, "Unable to open '" + _
		        argName + "'")
		        raise err
		      end try
		    elseif a = 2 and argName.Length > 3 and argName.Left(2) <> "--" then
		      ' Could be the desired outputFile
		      try
		        outputFile = new Xojo.IO.FolderItem(argName)
		      catch
		        dim err as new AppException(ERROR_INVALID_OUTPUT_FILE, "Unable to create '" + _
		        argName + "'")
		        raise err
		      end try
		    else
		      if argName.Length >= 1 and argName.Left(1) = "+" then
		        isArg = True
		        argName = argName.Replace("+", "")
		      elseif argName.Length >= 2 and argName.Left(2) = "--" then
		        isArg = True
		        argName = argName.Replace("--", "")
		      else
		        isArg = False
		      end if
		      if isArg then
		        if optionsLeft > 0 then
		          ' Insufficent options passed for the preceding argument
		          dim err as new AppException(ERROR_ARGUMENT_OPTION, "An insufficent number of options " + _
		          "was passed for the " + lastArgName + " argument (" + OptionsExpected(lastArgName).ToText + _
		          " required)")
		          raise err
		        end if
		        ' A new argument
		        ' if arguments.HasKey(argName) then
		        if argumentDefined(argName) then
		          ' This argument already exists
		          dim err as new AppException(ERROR_DUPLICATE_ARGUMENT, "The argument '" + _
		          argName + "' has already been specified")
		          raise err
		        else
		          if not ValidArgument(argName) then
		            dim err as new AppException(ERROR_INVALID_ARGUMENT, "The argument '" + _
		            argName + "' is not recognised")
		            raise err
		          end if
		          arguments.Value(argName) = new Argument(argName)
		          ' How many options does this argument expect (if any)?
		          optionsLeft = OptionsExpected(argName)
		          ' Remember this argument's name
		          lastArgName = argName
		        end if
		      else
		        ' This is an option for the last argument
		        if optionsLeft = 0 then
		          dim err as new AppException(ERROR_ARGUMENT_OPTION, "Too many options passed for the " + _
		          lastArgName + " argument (" + OptionsExpected(lastArgName).ToText + _
		          " required)")
		          raise err
		        end if
		        try
		          Argument(arguments.Value(lastArgName)).options.Append(argName)
		          optionsLeft = optionsLeft - 1
		        catch
		          dim err as new AppException(ERROR_ARGUMENT_OPTION, "No argument for the passed" + _
		          " option was specified")
		          raise err
		        end try
		      end if
		    end if
		  next a
		  
		  ' Set various modes (if required)
		  quietMode = if(ArgumentDefined("quiet"), True, False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ValidArgument(argumentName as Text) As Boolean
		  ' Takes the name of an argument and returns how many options (if any) are expected.
		  
		  select case argumentName
		  case "h", "help", "version", "q", "quiet", "f", "frame", "fr", "frame-range", "fa", "all-frames", _
		    "rl", "rotate-left", "rr", "rotate-right", "fh", "flip-horizontally", "fv", "flip-vertically", _
		    "ww", "set-window", "oj", "write-jpeg", "op", "write-png", "ob", "write-bmp", "ot", "write-tiff"
		    return True
		  else ' unknown argument
		    return False
		  end select
		End Function
	#tag EndMethod


	#tag Note, Name = Arguments
		Standard usage of dk2image is as follows:
		
		[] denotes optional
		
		dk2image inputFile [outputFile] [params]
		
		If [outputFile] is not specified then dk2image will save the image file to the same location as
		inputFile with the same name suffixed with "-image"
		
		[params] is an optional list of parameters. All parameters have both a short code and a long code.
		For instance, the shortcode for the help file is "h" and the long code is "help". Short codes are
		prefixed with "-" and long codes are prefixed with "--".
		
	#tag EndNote

	#tag Note, Name = MAN Page
		
		    dk2image - Extract DICOM images to JPEG, PNG, TIFF or BMP files
		
		SYNOPSIS
		    dk2image dicomFile [outputFile] [options]
		
		DESCRIPTION
		    The dk2image tool reads a DICOM file, converts the pixel data according to the selected image
		    processing options and writes back an image in the JPEG, PNG, TIFF or Windows BMP format. This
		    tool currently only supports uncompressed DICOM pixel data.
		
		PARAMETERS
		    dicomFile     The DICOM file to be converted
		    
		    outputFile    The output file to be written to (default: parent folder of dicomFile)
		
		OPTIONS
		    general options
		        +h    --help           
		              Prints this help text and then exits
		
		              --version        
		              Prints the version information and then exits
		
		        +q    --quiet          
		              Quiet mode. Prints no warnings and errors
		
		    image processing options
		      frame selection
		        +f     --frame         [n]umber: integer
		               select the specified frame (default: 1)
		               e.g. dk2image someFile -f 4     (would select the 4th frame of someFile)
		
		        +fr    --frame-range   [n]umber [c]ount: integer
		               select [c] frames beginning with frame [n]
		               e.g. dk2image someFile -fr 4 3  (would select frames 4, 5, 6 of someFile)
		
		        +fa    --all-frames    
		               select all frames
		
		      rotation
		        +rl    --rotate-left
		               rotate the image left (-90 degrees, anti-clockwise) 
		
		        +rr    --rotate-right
		               rotate the image right (+90 degrees, clockwise)
		
		      flipping
		        +fh    --flip-horizontally
		               flip the image horizontally
		
		        +fv    --flip-vertically
		               flip the image vertically
		
		      windowing
		        +ww    --set-window   [c]entre [w]idth: float
		               set the image window using centre [c] and width [w]
		
		    output options
		      image format
		        +oj    --write-jpeg
		               Save the image as a JPEG
		        +op    --write-png
		               Save the image as a PNG
		        +ob    --write-bmp
		               Save the image as a Windows BMP
		        +ot    --write-tiff
		               Save the image as a TIFF
	#tag EndNote


	#tag Property, Flags = &h21
		#tag Note
			The arguments passed to the app
			Key is the argument name (e.g. "rotate-left") and Value (if set) is a the argument as an Argument class.
		#tag EndNote
		Private arguments As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private dcm As DICOMKit.ObjectDK
	#tag EndProperty

	#tag Property, Flags = &h21
		Private dcmFile As Xojo.IO.FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private outputFile As Xojo.IO.FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Mutes all message output.
		#tag EndNote
		quietMode As Boolean = False
	#tag EndProperty


	#tag Constant, Name = ARGUMENT_HAS_NO_LONGNAME, Type = Double, Dynamic = False, Default = \"6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ARGUMENT_HAS_NO_SHORTNAME, Type = Double, Dynamic = False, Default = \"7", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ERROR_ARGUMENT_OPTION, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ERROR_DUPLICATE_ARGUMENT, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ERROR_INVALID_ARGUMENT, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ERROR_INVALID_INPUT_FILE, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ERROR_INVALID_OUTPUT_FILE, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ERROR_NONE, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="quietMode"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
