/*
    Function calling Loqate API to return clean addresses. API documentation: https://www.loqate.com/resources/support/cleanse-api/international-batch-cleanse/
    Loqate API has a limity of 1000 addresses per call. This function has two core parts:
        An internal function (funcLoqate) that performs the API call. Function expects a Key and an Address table formatted based on Loqate's requirements.
        A loop part, where addresses are split in a list of address tables up to 1000 long, which in turn calls the API.
    The function returns clean PAF-verified and cleaned addresses.
    Since the API does not allow for a unique id to bind rows of the pre-clean to after-clean table, a unique combination of data needs to be used to bind the clean data.
    The ID selected is a combination of address line 1, address line 2 and postcode.
    At this iterration, up to three lines of address are returned.
*/

let func = (Key as table, Addresses as table) as table =>
    let
        funcLoqate = (Key as table, Addresses as table) as table =>
        let 
            AddAddressData = Table.AddColumn(Key, "Addresses", each Addresses),
            // Creating Json File
            InitialJson = Json.FromValue(AddAddressData),
            // Converting Json to Text in order to fix Json formatting. Loqate expects addresses and arguements in JSON objects, while PQ transforms tables to array of objects.
            InitialJsonText = Text.FromBinary(InitialJson),
            FinalJsonText = Text.Insert(Text.Middle(InitialJsonText,1,Text.Length(InitialJsonText)-2),Text.Length(InitialJsonText)-3,","&
                Character.FromNumber(34)&"Options"&Character.FromNumber(34)&": {"&Character.FromNumber(34)&"Process"&Character.FromNumber(34)&": "&Character.FromNumber(34)&"Verify"&Character.FromNumber(34)&","&Character.FromNumber(34)&"Certify"&Character.FromNumber(34)&":false,"&Character.FromNumber(34)&"ServerOptions"&Character.FromNumber(34)&": {"&Character.FromNumber(34)&"OutputAddressFormat"&Character.FromNumber(34)&": "&Character.FromNumber(34)&"Yes"&Character.FromNumber(34)&","&Character.FromNumber(34)&"AddressLineSeparator"&Character.FromNumber(34)&":"&Character.FromNumber(34)&"/n"&Character.FromNumber(34)&"}}"),
            // Call API. 
            FinalJson = Json.Document(Web.Contents("https://api.addressy.com/Cleansing/International/Batch/v1.00/json4.ws", [Headers=[#"Content-Type"="application/json"], Content=Text.ToBinary(FinalJsonText)])),
            OutputList = FinalJson,
            // Convert Json to Table
            #"Converted to Table" = Table.FromList(OutputList, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
            #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"Input", "Matches"}, {"Column1.Input", "Column1.Matches"}),
            #"Expanded Column1.Matches" = Table.ExpandListColumn(#"Expanded Column1", "Column1.Matches"),
            #"Expanded Column1.Matches1" = Table.ExpandRecordColumn(#"Expanded Column1.Matches", "Column1.Matches", {"AQI", "AVC", "Address", "Address1", "Address2", "Address3", "Administrative Area", "AdministrativeArea", "CountryName", "DeliveryAddress", "DeliveryAddress1", "HyphenClass", "ISO3166-2", "Country", "ISO3166-3", "ISO3166-N", "Locality", "MatchRuleLabel", "PostalCode", "PostalCodePrimary", "Premise", "PremiseNumber", "Thoroughfare", "ThoroughfareName", "ThoroughfareTrailingType", "ThoroughfareType", "Address4", "DeliveryAddress2", "DependentLocality", "Unmatched", "Building", "SubBuilding", "SubBuildingNumber", "Address5", "DeliveryAddress3"}, {"AQI", "AVC", "Address", "Address1", "Address2", "Address3", "Administrative Area", "AdministrativeArea", "CountryName", "DeliveryAddress", "DeliveryAddress1", "HyphenClass", "ISO3166-2", "Country", "ISO3166-3", "ISO3166-N", "Locality", "MatchRuleLabel", "PostalCode", "PostalCodePrimary", "Premise", "PremiseNumber", "Thoroughfare", "ThoroughfareName", "ThoroughfareTrailingType", "ThoroughfareType", "Address4", "DeliveryAddress2", "DependentLocality", "Unmatched", "Building", "SubBuilding", "SubBuildingNumber", "Address5", "DeliveryAddress3"}),
            #"Expanded Column1.Input" = Table.ExpandRecordColumn(#"Expanded Column1.Matches1", "Column1.Input", {"Address", "Address1", "Address2", "Address3", "Address4", "Address5", "Address6", "Address7", "Address8", "Country", "SuperAdministrativeArea", "Administrative Area", "SubAdministrativeArea", "Locality", "DependentLocality", "DoubleDependentLocality", "Thoroughfare", "DependentThoroughfare", "Building", "Premise", "SubBuilding", "PostalCode", "Organization", "PostBox"}, {"Column1.Input.Address", "Column1.Input.Address1", "Column1.Input.Address2", "Column1.Input.Address3", "Column1.Input.Address4", "Column1.Input.Address5", "Column1.Input.Address6", "Column1.Input.Address7", "Column1.Input.Address8", "Column1.Input.Country", "Column1.Input.SuperAdministrativeArea", "Column1.Input.Administrative Area", "Column1.Input.SubAdministrativeArea", "Column1.Input.Locality", "Column1.Input.DependentLocality", "Column1.Input.DoubleDependentLocality", "Column1.Input.Thoroughfare", "Column1.Input.DependentThoroughfare", "Column1.Input.Building", "Column1.Input.Premise", "Column1.Input.SubBuilding", "Column1.Input.PostalCode", "Column1.Input.Organization", "Column1.Input.PostBox"}),
            // Creates ID with combination of initial address line 1 & address line 2 & postcode
            #"Added ID" = Table.AddColumn(#"Expanded Column1.Input", "ID", each [Column1.Input.Address1]&[Column1.Input.Address2]&[Column1.Input.PostalCode]),
            // Removes not used columns
            #"Removed Columns1" = Table.RemoveColumns(#"Added ID",{"Column1.Input.Address", "Column1.Input.Address1", "Column1.Input.Address2", "Column1.Input.Address3", "Column1.Input.Address4", "Column1.Input.Address5", "Column1.Input.Address6", "Column1.Input.Address7", "Column1.Input.Address8", "Column1.Input.Country", "Column1.Input.SuperAdministrativeArea", "Column1.Input.Administrative Area", "Column1.Input.SubAdministrativeArea", "Column1.Input.Locality", "Column1.Input.DependentLocality", "Column1.Input.DoubleDependentLocality", "Column1.Input.Thoroughfare", "Column1.Input.DependentThoroughfare", "Column1.Input.Building", "Column1.Input.Premise", "Column1.Input.SubBuilding", "Column1.Input.PostalCode", "Column1.Input.Organization", "Column1.Input.PostBox"}),
            #"Reordered Columns1" = Table.ReorderColumns(#"Removed Columns1",{"ID", "AQI", "AVC", "DeliveryAddress1", "DeliveryAddress2", "DeliveryAddress3", "Locality", "PostalCode", "CountryName", "Address", "Address1", "Address2", "Address3", "Administrative Area", "AdministrativeArea", "DeliveryAddress", "HyphenClass", "ISO3166-2", "Country", "ISO3166-3", "ISO3166-N", "MatchRuleLabel", "PostalCodePrimary", "Premise", "PremiseNumber", "Thoroughfare", "ThoroughfareName", "ThoroughfareTrailingType", "ThoroughfareType", "Address4", "DependentLocality", "Unmatched", "Building", "SubBuilding", "SubBuildingNumber", "Address5"}),
            // Final return table
            #"Removed Other Columns" = Table.SelectColumns(#"Reordered Columns1",{"ID", "AQI", "AVC", "DeliveryAddress1", "DeliveryAddress2", "DeliveryAddress3", "Locality", "PostalCode", "CountryName"})
        in
            #"Removed Other Columns",
        // Number on Table.Split function determines how many address records should be passed on to Loqate per each API call.
        AddressesSplit = Table.Split(Addresses,10),
        ListGen = List.Generate(
            ()=>[Counter = 0],
            each [Counter]<List.Count(AddressesSplit),
            each [Counter=[Counter]+1],
            each funcLoqate(Key, AddressesSplit{[Counter]})
        ),
        AddressesFinal = Table.Combine(ListGen)
    in
        AddressesFinal
, documentation = [
Documentation.Name =  " fxCleanAddressesLoqate
" , Documentation.LongDescription = " Performs address cleaning by calling Loqate API. Cost 1.2p per address cleaned. The function receives a table as an arguement with format:
[Key: API key, Geocode: False by default, LoqatePrepare: Table]
LoqatePrepare must have the following headers:
[Address	Address1	Address2	Address3	Address4	Address5	Address6	Address7	Address8	Country	SuperAdministrativeArea	AdministrativeArea	SubAdministrativeArea	Locality	DependentLocality	DoubleDependentLocality	Thoroughfare	DependentThoroughfare	Building	Premise	SubBuilding	PostalCode	Organization	PostBox]
Source code: https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxCleanAddressesLoqate.pq
", Documentation.Source = " https://raw.githubusercontent.com/RefugeDatabase/PowerQuery/main/Scripts/fxCleanAddressesLoqate.pq
"] 
 in
    Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
