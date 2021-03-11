let
    Source = let func =
    (inputText as text) as text =>
    let
        CheckSymbols =
            if inputText = "" or inputText = null then inputText else //leave blank as is
                if List.Count(Text.Split(inputText, "@")) = 2 then //if email address contains just one @ symbol
                    if Text.Contains(List.Last(Text.Split(inputText, "@")),".") then //check that there is a "." after the @ symbol
                        inputText else "Invalid"
                    else "Invalid",
        RemoveCommas =
            if Text.Contains(CheckSymbols,",") then "Invalid" else CheckSymbols // Invalidate if it contains commas
    in
        RemoveCommas
        
, documentation = [
Documentation.Name =  " fxVerifyEmail
" , Documentation.LongDescription = " Verifies email address. If invalid, replaces with the value ""Invalid"" Source: https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxCleanNames.pq
", Documentation.Source = " https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxCleanNames.pq
"] 
 in 
    Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
in
    Source
