let func =
    (inputText as text) as text =>
    let
        ToRemove = {""""} & Text.ToList("/\|~,.()-_=!£#$%^&*';?:<>¬`—{}[]â€™ÃOGB"), // Listing characters to remove
        CleanText = Text.Remove( inputText, ToRemove), // Removing unwanted characters
        RemovedSpaces = Text.Combine(Splitter.SplitTextByWhitespace()(CleanText)), // Removing spaces
        RemovedCountryCode = // Removing UK country code
            if Text.Length(RemovedSpaces) > 10
            then (
                if Text.Start(RemovedSpaces,2) = "44" then Text.RemoveRange(RemovedSpaces, 0, 2)
                else if Text.Start(RemovedSpaces,3) = "+44" then Text.RemoveRange(RemovedSpaces, 0, 3)
                else if Text.Start(RemovedSpaces,4) = "044" then Text.RemoveRange(RemovedSpaces, 0, 3)
                else if Text.Start(RemovedSpaces,4) = "0044" then Text.RemoveRange(RemovedSpaces, 0, 4)
                else RemovedSpaces
                )
            else RemovedSpaces,
        AddedLeadingZero = //Adding leading zero for UK numbers (starting with 1, 2, 7 and 11 digits long in total)
            if Text.Length(RemovedCountryCode) = 10 and (Text.StartsWith(RemovedCountryCode, "1") or Text.StartsWith(RemovedCountryCode, "2") or Text.StartsWith(RemovedCountryCode, "7"))
            then Text.PadStart(RemovedCountryCode, 11, "0")
            else RemovedCountryCode,
        BlankNonValid = //Removing short phone numbers and email addresses
            if Text.Length(AddedLeadingZero) <= 6 or Text.Contains(AddedLeadingZero, "@") then "" else AddedLeadingZero,
        BlankOnlyText = //Removing values that don't contain any numbers
            if Text.Select(BlankNonValid, Text.ToList("1234567890")) = "" then "" else BlankNonValid
    in
        BlankOnlyText
        
, documentation = [
Documentation.Name =  " fxCleanPhonesUK
" , Documentation.LongDescription = " Performs regular cleaning functions on UK phone numbers to transform to format 0_XXXXXXXXX, where _ = 1, 2 or 7. Source: https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxCleanPhonesUK.pq
", Documentation.Source = " https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxCleanPhonesUK.pq
",
Documentation.Examples = {[
    Description = "Removes UK country code, removes special characters, removes spaces, adds leading zero",
    Code = "fxCleanPhonesUK(""+44. 71 (1111) 1111"")",
    Result = "07111111111"
],[
    Description = "Keeps foreign country code, removes special characters, removes spaces, adds leading zero",
    Code = "fxCleanPhonesUK(""+33. 71 (1111) 1111"")",
    Result = "+337111111111"
],[
    Description = "Disregards values with no numberic values",
    Code = "fxCleanPhonesUK(""Refuge"")",
    Result = """"""    
]}
] 
 in 
    Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
