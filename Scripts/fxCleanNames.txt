(inputText as text) as text =>
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