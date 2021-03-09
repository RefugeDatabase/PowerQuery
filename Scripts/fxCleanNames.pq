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
Documentation.Name =  " Table.BlendDataTableau
", Documentation.Description = " Blends table data like in Tableau.
" , Documentation.LongDescription = " Blends table data like in Tableau. See: http://www.thebiccountant.com/2017/02/23/blending-data-in-powerbi-like-in-tableau/
", Documentation.Category = " Table
", Documentation.Source = " http://www.thebiccountant.com/2017/02/23/blending-data-in-powerbi-like-in-tableau/
", Documentation.Author = " Imke Feldmann: www.TheBIccountant.com .
", Documentation.Examples = {[Description =  " http://www.thebiccountant.com/2017/02/23/blending-data-in-powerbi-like-in-tableau/
" , Code = " 
 ", Result = " 
"]}] 
 in 
    Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation)) 
