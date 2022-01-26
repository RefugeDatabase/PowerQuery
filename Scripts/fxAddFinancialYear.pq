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
Documentation.Name =  " fxAddFinancialYear
" , Documentation.LongDescription = " Adds financial year in form of YY/YY to be used for auto-coding campaign income. Source: https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxAddFinancialYear.pq
", Documentation.Source = " https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxAddFinancialYear.pq
"] 
 in 
    Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
in
    Source
