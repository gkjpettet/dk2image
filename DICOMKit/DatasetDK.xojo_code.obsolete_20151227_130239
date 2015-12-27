#tag Class
Protected Class DatasetDK
	#tag Method, Flags = &h0
		Sub AddElement(element As DICOMKit.ElementDK, replace as Boolean = False)
		  ' Add the passed element to this dataset, if it does not exist already.
		  ' By default, we won't overwrite an existing element with this tag. If replace = True then we will
		  
		  If elements.HasKey(element.tag) and replace = False then
		    exit
		  else
		    elements.Value(element.tag) = element
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AllElements() As DICOMKit.ElementDK()
		  ' Returns all elements in this dataset as an array of ElementDKs.
		  
		  using Xojo.Core
		  
		  dim elementsAsArray() as ElementDK
		  
		  for each entry as DictionaryEntry in elements
		    
		    elementsAsArray.Append(entry.Value)
		    
		  next
		  
		  return elementsAsArray
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  elements = new Xojo.Core.Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ContainsElement(tag as Text, includeChildren as Boolean = False) As Boolean
		  ' Returns True if an element with the specified tag is found in this dataset.
		  ' Defaults to only searching the direct descendants of the dataset. If the optional
		  ' includeChildren Parameter = True then we search the entire dataset.
		  
		  #pragma BackgroundTasks False
		  
		  using Xojo.Core
		  
		  dim element as ElementDK
		  
		  if not includeChildren then return elements.HasKey(tag) ' just direct descendants
		  
		  ' Search the entire dataset
		  if elements.HasKey(tag) then
		    return True ' found as a direct descendant
		  else
		    ' Search recursively
		    for each entry as DictionaryEntry in elements
		      
		      element = elementDK(entry.Value)
		      
		      if element.items.Ubound >= 0 then
		        
		        for each item as ObjectDK in element.items
		          
		          if item.dataset.ContainsElement(tag, includeChildren) = True then return True
		          
		        next item
		        
		      end if
		      
		    next entry
		  end if
		  
		  return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count(includeChildren as Boolean = False) As Integer
		  ' Returns the number of elements in the dataset.
		  ' By default, we only count the number of direct descendants of this DICOM dataset. If the optional
		  ' includeChildren = True then we count all elements (including nested children).
		  
		  using Xojo.Core
		  
		  dim element as ElementDK
		  dim total as Integer = 0
		  
		  if not includeChildren then return elements.Count
		  
		  ' Count nested children
		  for each entry as DictionaryEntry in elements
		    
		    total = total + 1
		    
		    element = ElementDK(entry.Value)
		    
		    if element.items.Ubound >= 0 then
		      
		      for each item as ObjectDK in element.items
		        
		        total = total + item.dataset.Count(includeChildren)
		        
		      next item
		      
		    end if
		    
		  next entry
		  
		  return total
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ElementWithTag(tag as Text, directDescendantOnly as Boolean = False) As DICOMKit.ElementDK
		  ' Returns the first element with the specified tag encountered.
		  ' If the optional directDescendantOnly is True then we'll only look at top-level elements for a match.
		  ' If not found then we raise an DICOMKit exception.
		  
		  #pragma BackgroundTasks False
		  
		  using Xojo.Core
		  
		  dim element as ElementDK
		  
		  if elements.HasKey(tag) then return elements.Value(tag)
		  
		  ' Not a direct descendant of this dataset. Shall we search deeper?
		  if not directDescendantOnly then
		    
		    for each entry as DictionaryEntry in Elements
		      
		      element = entry.Value
		      
		      if element.items.Ubound >= 0 then
		        
		        ' Search this element's children
		        for each item as ObjectDK in element.items
		          
		          try
		            return item.dataset.ElementWithTag(tag)
		          catch
		            ' Not found in this item. Move along...
		          end try
		          
		        next item
		        
		      end if
		      
		    next entry
		    
		  end if
		  
		  ' If we've reached this point then we haven't found the element requested. Raise an exception
		  raise new ExceptionDK(ExceptionDK.ELEMENT_NOT_FOUND, _
		  "No element with tag (" + tag + ") found in the dataset.")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveElement(tag as Text)
		  ' Remove the element with the specified tag from this dataset.
		  
		  if elements.HasKey(tag) then elements.Remove(tag)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private elements As Xojo.Core.Dictionary
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
