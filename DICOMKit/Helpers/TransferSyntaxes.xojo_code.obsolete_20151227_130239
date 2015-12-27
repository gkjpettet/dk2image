#tag Class
Protected Class TransferSyntaxes
	#tag Method, Flags = &h0
		 Shared Function NameFromUID(uid as Text) As Text
		  select case uid
		  case BIG_ENDIAN_EXPLICIT
		    return "Explicit VR big endian"
		  case DEFLATED_EXPLICIT_BIG_ENDIAN
		    return "Explicit VR big endian (deflate)"
		  case JPEG_2000
		    return "JPEG 2000 (lossy)"
		  case JPEG_2000_LOSSLESS
		    return "JPEG 2000 (lossless)"
		  case JPEG_2000_PART2
		    return "JPEG 2000 Part 2"
		  case JPEG_2000_PART2_LOSSLESS
		    return "JPEG 2000 Part 2 (lossless)"
		  case JPEG_EXTENDED
		    return "JPEG extended (lossy 12 bit)"
		  case JPEG_BASELINE
		    return "JPEG baseline (lossy 8 bit)"
		  case JPEG_LOSSLESS
		    return "JPEG lossless"
		  case JPEG_LOSSLESS_FIRST_ORDER
		    return "JPEG lossless first order"
		  case JPEG_LS_LOSSLESS
		    return "JPEG-LS (lossless)"
		  case JPEG_LS_LOSSY
		    return "JPEG-LS (lossy)"
		  case LITTLE_ENDIAN_EXPLICIT
		    return "Explicit VR little endian"
		  case LITTLE_ENDIAN_IMPLICIT
		    return "Implicit VR little endian"
		  case else
		    return uid
		  end select
		End Function
	#tag EndMethod


	#tag Note, Name = About
		The transfer syntax UID specifies how the data in the DICOM file is encoded. Essentially it tells us
		three things:
		
		(1) Explicit / implicit VR:
		If VR's are explicit. That is, if the data type code of every element should be serialized or it will 
		be implicitly deduced from the element tag
		
		(2) Endianness
		
		(3) If pixel data is compressed or uncompressed:
		If pixel data is compressed then the file is always EXPLICIT VR, LITTLE ENDIAN
		
		###################################################################################################
		Uncompressed pixel data
		###################################################################################################
		Implicit VR Little-endian
		-------------------------
		1.2.840.10008.1.2
		This is the only mandatory DICOM transfer syntax, but as the VR is implicit (requiring all 
		applications to have an up to date dictionary to make sense of the data) it is also the worst, and 
		others should be used wherever possible.
		
		Explicit VR Little-endian
		-------------------------
		1.2.840.10008.1.2.1
		Explicit Value Representation must be included for each single DICOM tag. This transfer syntax is 
		more often used since each data element has it's own explicit value type declaration.
		
		Explicit VR Big-endian
		----------------------
		1.2.840.10008.1.2.2
		This is identical to Explicit VR little endian, apart from the fact that big-endian byte ordering 
		is used. It is very little used nowadays.
		
		###################################################################################################
		Compressed pixel data
		NOTE: All the syntaxes below use explicit VR little endian.
		###################################################################################################
		---------------------------------------------------------------------------------------------------
		Lossless compressed
		---------------------------------------------------------------------------------------------------
		JPEG Lossless
		-------------
		1.2.840.10008.1.2.4.57
		This is actually a very simple Pulse Code Modulation scheme, where each pixel is "Predicted" based 
		on previous pixels, and then the much smaller "difference" is stored, after being compressed 
		using Huffman coding.
		
		JPEG Lossless First Order
		-------------------------
		1.2.840.10008.1.2.4.70
		Identical to the main JPEG lossless above, but with a constrained value for the predictor, giving 
		a slightly simplified algorithm, with slightly greater speed, but slightly less compression on 
		most images (2-5% typically)
		
		RLE Lossless
		------------
		1.2.840.10008.1.2.5
		The simplest form of compression technique which is widely supported by most bitmap file formats 
		such as TIFF, BMP, and PCX. The content of the information greatly affects its efficiency in 
		compressing the information, and whilst it is useful for images with large areas of zeros, it is 
		almost useless for images such as radiographs where adjacent pixels rarely have exactly the 
		same value.
		
		JPEG 2000 (Lossless)
		--------------------
		1.2.840.10008.1.2.4.90
		Like JPEG lossless, the use of the name JPEG is confusing, as it bears no resemblance to other 
		"JPEG" compression methods. JPEG 2000 (J2K) is a wavelet based algorithm with the advantage over all 
		the multitude of proprietary wavelets of being standardised and interoperable. In lossless mode 
		(as required for this transfer syntax) the degree of compression is course determined by the image 
		itself, but it typically performs about 10% better than JPEG lossless. It is however a much more 
		complicated algorithm, giving significantly slower performance, and unless space or bandwidth are 
		very constrained (e.g. as they may be for teleradiology), the speed penalty is unlikely to make this 
		a popular choice.
		
		JPEG-LS (Lossless)
		------------------
		1.2.840.10008.1.2.4.80
		Like JPEG lossless and 2000, the use of the name JPEG is confusing, as it bears little resemblance 
		to other "JPEG" compression methods. JPEG-LS is totally different compression mechanism again!  It 
		is a much more "modern" algorithm, combing the best features of others, but it is supposedly much 
		more efficient than JPEG 2000.  Despite being included in the DICOM standard for over a decade, 
		its actual real world use is almost non-existent in PACS.
		
		---------------------------------------------------------------------------------------------------
		Lossy Compressed
		---------------------------------------------------------------------------------------------------
		JPEG Baseline
		-------------
		1.2.840.10008.1.2.4.50
		This provides a DICOM wrapper around "standard" JPEG content, which is equivalent to external JPEG 
		files (though of course still as full DICOM content, rather than than industry standard JFIF 
		header). Note that it is always lossy, irrespective of the quality factor used - so even an image 
		compressed with "100% quality" is still not identical to the original. It is limited to to 8 bits 
		per sample.
		
		JPEG Extended
		-------------
		1.2.840.10008.1.2.4.51
		This is equivalent to JPEG baseline as above, but with extension to allow up to 12 bits per sample, 
		allowing use with modalities which require "re-windowing" such as CT. Unlike baseline, this format 
		is not used much (if at all) outside DICOM.
		
		JPEG 2000 (lossy)
		-----------------
		1.2.840.10008.1.2.4.91
		This is a variation on the JPEG 2000 lossless listed above, but permitting the image to be lossy 
		(infact, it is legal for it also to be lossless using this transfer syntax). In general, the same 
		issues apply to this as to the lossless variation, but it does have a place in teleradiology for 
		two reasons:
		(1). It can (with suitable software) be used incrementally, so that a rough image is shown initially, 
		improving as more data is received
		(2). For a given amount of data, the image is said to be better than using the best alternative 
		lossy method (standard JPEG), but some people do have concerns about artifacts looking more 
		"believable" (and therefore dangerous) than with JPEG, where they are easily noticeable as 
		"blockiness".
		
		JPEG-LS (Lossy)
		---------------
		1.2.840.10008.1.2.4.81
		This is the same basic scheme as JPEG-LS as above, and has the same benefits and drawbacks 
		(including very limited support in the real world), but it achieves greater compression by allowing 
		a small (but defined) discrepancy between the original value and the value obtained after 
		decompression.
		
		---------------------------------------------------------------------------------------------------
		MPEG Transfer Syntaxes
		---------------------------------------------------------------------------------------------------
		Unlike the other transfer syntaxes, the MPEG transfer syntaxes treat the video "as a whole" rather 
		than as a series of individually compressed frames.  Due to the DICOM fragment rules, they are 
		limited to 4 GBytes in total, as only 1 single fragment is permitted.
		
		MPEG-2
		------
		1.2.840.10008.1.2.4.100 & 1.2.840.10008.1.2.4.101
		The .100 syntax etc.uses the basic "Main Profile @ Main Level" (MP@ML) specification, but the .101 
		syntax allows the higher quality "Main Profile @ High Level" (MP@HL) MPEG rules - as defined in the 
		MPEG 2 specification.
		
		MPEG-4
		------
		1.2.840.10008.1.2.4.102 & 1.2.840.10008.1.2.4.103
		These use the "MPEG-4 AVC/H.264 High Profile / Level 4.1" specification - the difference between 
		them being that the .103 syntax explicitly requires blueray (BD) compatibility.
		
		---------------------------------------------------------------------------------------------------
		Special Transfer Syntaxes
		---------------------------------------------------------------------------------------------------
		Deflate
		-------
		1.2.840.10008.1.2.1.99
		Unlike all other DICOM transfer syntaxes, the deflate transfer syntaxes compress the whole of the 
		DICOM data (tags, lengths, VR etc.) rather than just the pixel data - this is done using the 
		standard "deflate" mechanism as used in gzip etc.) It is therefore most suitable for non-pixel 
		objects such as structured reports, presentation states etc.
		
		JPIP
		----
		1.2.840.10008.1.2.4.94
		This uses the "progressive" features of JPEG 2000, by leaving the pixel data out of the main object 
		completely, replacing instead by a URL (in element 0028,7FE0) which points to a site from which the 
		pixel data may be obtained using the JPIP protocol - this allows only the scaling and quality 
		required to be fetched.  It is only really suitable for PACS to workstation use and should never be 
		used for writing images to removable media such as CDs!
		
		JPIP-Deflate
		------------
		1.2.840.10008.1.2.4.95
		This combines the features of JPIP (removing the pixel data) and then deflate - compressing the 
		resulting reduced data.  We have never seen it used in the real world!
	#tag EndNote


	#tag Constant, Name = BIG_ENDIAN_EXPLICIT, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = DEFLATED_EXPLICIT_BIG_ENDIAN, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.1.99", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JPEG_2000, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.4.91", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JPEG_2000_LOSSLESS, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.4.90", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JPEG_2000_PART2, Type = String, Dynamic = False, Default = \"1.2.840.10008.1.2.4.93", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JPEG_2000_PART2_LOSSLESS, Type = String, Dynamic = False, Default = \"1.2.840.10008.1.2.4.92", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JPEG_BASELINE, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.4.50", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JPEG_EXTENDED, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.4.51", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JPEG_LOSSLESS, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.4.57", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JPEG_LOSSLESS_FIRST_ORDER, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.4.70", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JPEG_LS_LOSSLESS, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.4.80", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JPEG_LS_LOSSY, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.4.81", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JPEG_REFERENCED_DEFLATE, Type = String, Dynamic = False, Default = \"1.2.840.10008.1.2.4.95", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JPIP_REFERENCED, Type = String, Dynamic = False, Default = \"1.2.840.10008.1.2.4.94", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LITTLE_ENDIAN_EXPLICIT, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LITTLE_ENDIAN_IMPLICIT, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MPEG2, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.4.100", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MPEG4, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.4.102", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MPEG4_BD_COMPATIBLE, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.4.103", Scope = Public
	#tag EndConstant

	#tag Constant, Name = RFC2557, Type = String, Dynamic = False, Default = \"1.2.840.10008.1.2.6.1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = RLE_LOSSLESS, Type = Text, Dynamic = False, Default = \"1.2.840.10008.1.2.5", Scope = Public
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
