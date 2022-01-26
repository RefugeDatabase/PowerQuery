= (DateValue as date, MonthEnding as number) =>
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
