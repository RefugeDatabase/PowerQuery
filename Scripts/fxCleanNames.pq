let func =
    (inputText as text) =>
    let
        toRemove = {""""} & Text.ToList(":{}[]"), // Listing characters to remove
        cleanText = Text.Remove( inputText, toRemove), // Removing unwanted characters
        trimText = Text.Trim( cleanText ), // Trim
        replaceText = Text.Replace(trimText, "â€™", "'"), // Replace set of characters
        splitText = Text.Split(replaceText, "-"), // Double-barrelled surnames split
        properTextList = List.Transform(splitText, each Text.Proper(_)), // Proper each separate name before combining again
        combineText = Text.Combine(properTextList, "-")
    in
        combineText
        
, documentation = [
Documentation.Name =  " fxCleanNames
", Documentation.Description = " Performs regular cleaning functions on first and last names.
" , Documentation.LongDescription = " Performs regular cleaning functions on first and last names.
", Documentation.Category = " Table
", Documentation.Source = " https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxCleanNames.pq
", Documentation.Author = " Dimitris Mandiliotis.
", Documentation.Author = " Dimitris Mandiliotis.
", Documentation.Example = {[Description =  " https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxCleanNames.pq
" , Code = " 
 ", Result = " 
"]}] 
 in 
    Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation)) 
