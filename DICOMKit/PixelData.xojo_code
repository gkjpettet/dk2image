#tag Module
Protected Module PixelData
	#tag Method, Flags = &h1
		Protected Function DecompressFrame(data as Xojo.Core.MemoryBlock, transferSyntax as Text) As Xojo.Core.MemoryBlock
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function MonochromeDataToPicture(data as Xojo.Core.MemoryBlock, meta as DICOMKit.PixelData.PixelMeta, invert as Boolean = False) As Picture
		  ' Takes the uncompressed pixel data of a MONOCHROME1 or MONOCHROME2 type image and the required 
		  ' pixel metadata and returns it as a Xojo Picture object.
		  
		  #pragma BackgroundTasks False
		  #pragma BoundsChecking False
		  #pragma StackOverflowChecking False
		  
		  using DICOMKit
		  
		  dim offset, row, col, maxRows, maxCols as Integer
		  dim rawValue as Auto
		  dim image as Picture
		  dim surface as RGBSurface
		  dim minThreshold, maxThreshold, preCalc1, preCalc2, transformedValues(-1, -1) as Double
		  
		  maxRows = meta.rows - 1
		  maxCols = meta.columns - 1
		  offset = 0
		  
		  ' Setup a 2D array to store the grid of transformed pixel values
		  ' A transformed pixel value is a pixel value that has been altered either by applying the
		  ' formula involving the rescale slope and rescale intercept values or by using a lookup table (LUT)
		  ' Currently DICOMKit doesn't support a modality LUT
		  redim transformedValues(meta.rows, meta.columns)
		  
		  ' Create our blank image
		  image = new Picture(meta.columns, meta.rows)
		  
		  ' Fill the image with black pixels as this is the most prevalent colour
		  ' This way we can skip assigning black pixels individually later
		  image.graphics.FillRect(0, 0, image.width, image.height)
		  
		  ' Get a reference to the image's RGBSurface
		  surface = image.RGBSurface
		  
		  ' Precalculate the windowing values to pass to the Monochrome2PixelColourAfterWindowing method
		  ' This  provides a modest speed improvement
		  minThreshold = meta.windowCentre - 0.5 - (meta.windowWidth - 1)/2
		  maxThreshold = meta.windowCentre - 0.5 + (meta.windowWidth - 1)/2
		  preCalc1 = (meta.windowCentre - 0.5)
		  preCalc2 = (meta.windowWidth - 1)
		  
		  ' The following three cases are essentially identical except for the type of value
		  ' read from the MemoryBlock (UInt8, UInt16 and INT16). They are handled separately because it's ~25%
		  ' faster than getting rawValue from a separate method call in the loop
		  select case meta.PixelFormat
		  case meta.UNSIGNED_8_BIT
		    for row = 0 to maxRows
		      for col = 0 to maxCols
		        rawValue = data.UInt8Value(offset)
		        ' Apply the rescale slope and intercept transformation to the raw value and store it
		        transformedValues(row, col) = (meta.rescaleSlope * rawValue) + meta.rescaleIntercept
		        ' Apply the windowing levels to this transformed pixel value (if not black)
		        if transformedValues(row, col) > minThreshold then
		          surface.pixel(col, row) = MonochromePixelColourAfterWindowing(transformedValues(row, col), _
		          minThreshold, maxThreshold, preCalc1, preCalc2, invert)
		        end if
		        offset = offset + 1
		      next col
		    next row
		    
		  case meta.UNSIGNED_16_BIT
		    for row = 0 to maxRows
		      for col = 0 to maxCols
		        rawValue = data.UInt16Value(offset)
		        ' Apply the rescale slope and intercept transformation to the raw value and store it
		        transformedValues(row, col) = (meta.rescaleSlope * rawValue) + meta.rescaleIntercept
		        ' Apply the windowing levels to this transformed pixel value (if not black)
		        if transformedValues(row, col) > minThreshold then
		          surface.pixel(col, row) = MonochromePixelColourAfterWindowing(transformedValues(row, col), _
		          minThreshold, maxThreshold, preCalc1, preCalc2, invert)
		        end if
		        offset = offset + 2
		      next col
		    next row
		    
		  case meta.SIGNED_16_BIT
		    for row = 0 to maxRows
		      for col = 0 to maxCols
		        rawValue = data.Int16Value(offset)
		        ' Apply the rescale slope and intercept transformation to the raw value and store it
		        transformedValues(row, col) = (meta.rescaleSlope * rawValue) + meta.rescaleIntercept
		        ' Apply the windowing levels to this transformed pixel value (if not black)
		        if transformedValues(row, col) > minThreshold then
		          surface.pixel(col, row) = MonochromePixelColourAfterWindowing(transformedValues(row, col), _
		          minThreshold, maxThreshold, preCalc1, preCalc2, invert)
		        end if
		        offset = offset + 2
		      next col
		    next row
		  end select
		  
		  return image
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MonochromePixelColourAfterWindowing(inputValue as Double, minThreshold as Double, maxThreshold as Double, preCalc1 as Double, preCalc2 as Double, invert as Boolean = False) As Color
		  ' Returns the colour required for a particular pixel in a monochrome (either MONOCHROME1 or
		  ' MONOCHROME2) image
		  ' Rather than take a window centre and width, this method takes precalculated values
		  ' for the minimum and maximum threshold for windows as well as two other precalculated
		  ' values (a & b) to speed things up since this method will be called repeatedly from 
		  ' within a tight loop.
		  ' If the optional invert parameter is True then this is a MONOCHROME1 image, otherwise it's
		  ' MONOCHROME2.
		  
		  ' The precalculations are as follows:
		  ' minThreshold = windowCentre - 0.5 - (windowWidth - 1)/2
		  ' maxThreshold = windowCentre - 0.5 + (windowWidth - 1)/2
		  ' preCalc1 = windowCentre - 0.5
		  ' preCalc2 = (windowWidth - 1) + 0.5
		  
		  ' Based on pseudocode from DICOM section C.11.2.1.2:
		  ' https://www.dabsoft.ch/dicom/3/C.11.2.1.2/
		  
		  #pragma BackgroundTasks False
		  #pragma BoundsChecking False
		  #pragma StackOverflowChecking False
		  
		  ' Is the value greater than the windowing threshold?
		  if (inputValue > maxThreshold) then return if (invert, &c000000, &cFFFFFF)
		  
		  ' Less than it?
		  if (inputValue <= minThreshold) then return if (invert, &cFFFFFF, &c000000)
		  
		  ' Must be within the window bounds
		  return HSV(0,0, if(invert, 1-((inputValue - preCalc1) / preCalc2 + 0.5), (inputValue - preCalc1) / preCalc2 + 0.5))
		End Function
	#tag EndMethod


	#tag Note, Name = RescaleIntercept
		Rescale intercept (0028,1052) and rescale slope (0028,1053) are tags that specify the linear 
		transformation from pixels in their stored on disk representation to their in memory representation.
		Essentially, it allows transformation from the manufacturer specific values in the PixelData stream
		to other units (specified in tag 0028,1054) such as Hounsfield Units or optical density.
		
		The formula to convert a pixel value to one of these other units is as follows:
		
		U = m * SV + b
		
		where:
		U = output unit
		m = rescale slope
		SV = stored value on disk
		b = rescale intercept
		
	#tag EndNote


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
