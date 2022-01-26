let
    Source = let func =
    (DateValue as date, MonthEnding as number) as text =>
    let
        CY = Text.End ( Text.From ( Date.Year ( DateValue ) ) , 2 ),
        NY = Text.End ( Text.From ( Date.Year ( DateValue ) + 1 ) , 2 ),
        PY = Text.End ( Text.From ( Date.Year ( DateValue ) - 1 ) , 2 ),
        MonthCheck = Date.Month ( DateValue ) > MonthEnding,
        FiscalYear = 
            if
                MonthCheck
            then 
                CY & "/" & NY  
            else
                PY & "/" & CY 
    in
        FiscalYear
        
, documentation = [
Documentation.Name =  " fxVerifyEmail
" , Documentation.LongDescription = " Verifies email address. If invalid, replaces with the value ""Invalid"" Source: https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxCleanNames.pq
", Documentation.Source = " https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxCleanNames.pq
"] 
 in 
    Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
in
    Source
