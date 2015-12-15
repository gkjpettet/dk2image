#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  ' The only argument we take is the path of the DICOM.
		  
		  using ShellFormat
		  using DICOMKit
		  
		  dim f as Xojo.IO.FolderItem
		  dim dcm as DICOMKit.ObjectDK
		  dim p as Picture
		  dim t1, ms1, ms2 as Integer
		  dim t2 As Double
		  
		  ' Check at least one argument was passed
		  if args.Ubound < 1 then
		    Print Colourise("Error:", ShellColor.Red) + " no arguments passed."
		    Quit
		  end if
		  
		  ' Grab the file path
		  try
		    f = new Xojo.IO.FolderItem(args(1).ToText)
		  catch
		    Print Colourise("Error:", ShellColor.Red) + " Invalid file path specified."
		    Quit
		  end try
		  
		  ' Is this a DICOM file?
		  if not DICOMKit.IsDICOM(f) then
		    Print Colourise("Error:", ShellColor.Red) + " Not a DICOM file."
		    Quit
		  end if
		  
		  
		  ' Get the image file and save it to the Desktop
		  try
		    ' Start counting
		    t1 = Ticks()
		    dcm = DICOMKit.Open(f)
		    ' How long did it take to parse?
		    t2 = (Ticks() - t1)/60*1000
		    ms1 = t2
		    try
		      ' Start counting
		      t1 = Ticks()
		      p = dcm.ToPicture()
		      ' How long did it take to parse?
		      t2 = (Ticks() - t1)/60*1000
		      ms2 = t2
		      try
		        p.Save(SpecialFolder.Desktop.Child("test.jpg"), Picture.SaveAsJPEG)
		      catch
		        Print Colourise("Error:", ShellColor.Red) + " A problem occurred trying to save the JPEG to disk."
		        Quit
		      end try
		    catch
		      Print Colourise("Error:", ShellColor.Red) + " Unable to extract the image from the DICOM file."
		      Quit
		    end try
		  catch
		    Print Colourise("Error:", ShellColor.Red) + " A problem occurred trying to parse the DICOM file."
		    Quit
		  end try
		  
		  
		  
		  Print Colourise("Success!", ShellColor.Green) + " (" + ms1.ToText + " ms to parse, " + ms2.ToText + " ms to extract image)"
		End Function
	#tag EndEvent


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
		        -h    --help           
		              Prints this help text and then exits
		
		              --version        
		              Prints the version information and then exits
		
		        -q    --quiet          
		              Quiet mode. Prints no warnings and errors
		 
		        -v    --verbose        
		              Prints all processing details
		
		    image processing options
		      frame selection
		        -f     --frame         [n]umber: integer
		               select the specified frame (default: 1)
		               e.g. dk2image someFile -f 4     (would select the 4th frame of someFile)
		
		        -fr    --frame-range   [n]umber [c]ount: integer
		               select [c] frames beginning with frame [n]
		               e.g. dk2image someFile -fr 4 3  (would select frames 4, 5, 6 of someFile)
		
		        -fa    --all-frames    
		               select all frames
		
		      rotation
		        -rl    --rotate-left
		               rotate the image left (-90 degrees, anti-clockwise) 
		
		        -rr    --rotate-right
		               rotate the image right (+90 degrees, clockwise)
		
		      flipping
		        -fh    --flip-horizontally
		               flip the image horizontally
		
		        -fv    --flip-vertically
		               flip the image vertically
		
		      windowing
		        -ww    --set-window   [c]entre [w]idth: float
		               set the image window using centre [c] and width [w]
		
		    output options
		      image format
		        -oj    --write-jpeg
		               Save the image as a JPEG
		        -op    --write-png
		               Save the image as a PNG
		        -ob    --write-bmp
		               Save the image as a Windows BMP
		        -ot    --write-tiff
		               Save the image as a TIFF
	#tag EndNote


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
