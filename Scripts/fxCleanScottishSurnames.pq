let
    Source = let func =
    (inputText as text) as text =>
    let
    ReplaceScottish = 
        if Text.Length(inputText) >= 5
        then // Check if text starts with Mc or Mac
            if Text.Start(inputText,2) = "Mc" then Text.Combine(List.Union(
            // Splits text to lists and re-combines: first 2 characters, capitalises 3rd character, remaining characters
            {
                List.RemoveLastN(Text.ToList(inputText), Text.Length(inputText)-2), 
                Text.ToList(Text.Upper(Text.At(inputText,2))), 
                List.RemoveFirstN(Text.ToList(inputText), 3)
            }
            ))
            else if Text.Start(inputText,3) = "Mac" then Text.Combine(List.Union(
            // Splits text to lists and re-combines: first 2 characters, capitalises 3rd character, remaining characters
            {
                List.RemoveLastN(Text.ToList(inputText), Text.Length(inputText)-3), 
                Text.ToList(Text.Upper(Text.At(inputText,3))), 
                List.RemoveFirstN(Text.ToList(inputText), 4)
            }
            ))
            else inputText
        else inputText
    in
        ReplaceScottish
        
, documentation = [
Documentation.Name =  " fxCleanScottishSurnames
" , Documentation.LongDescription = " Performs cleaning of surnames beginning with ""Mc"" or ""Mac"" capitalising the next letter. The function should always follow normal proper casing functions in order to maintain the capitalisation. Source: https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxCleanNames.pq
", Documentation.Source = " https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxCleanScottishSurnames.pq
",
Documentation.Examples = {[
    Description = "Capitalises third character after Mc",
    Code = "fxCleanScottishSurnames(Mcevoy)",
    Result = "McEvoy"
],[
    Description = "Capitalises fourth character after Mac",
    Code = "fxCleanScottishSurnames(Macmillan)",
    Result = "MacMillan"
],[
    Description = "Disregards values that don't start with Mc, Mac or are shorter than 5 characters",
    Code = "fxCleanScottishSurnames(Dimitris)",
    Result = "Dimitris"    
]}
] 
 in 
    Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
in
    Source
