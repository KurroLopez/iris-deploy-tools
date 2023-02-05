/// an example of Installer class just to create a new clear namespace and database IRISAPP
Class demo.Installer Extends St.Tools.Deploy
{

Parameter PRODUCTION = "MySolution.Production";

ClassMethod setupInit() As %Status
{
  // Now we going to deploy some items into the new namespace
  do ..AddItem(,"SalesMetrics","MySolution.SalesMetrics")
  
  // Create a duplicate item disabled
  do ..AddItem(,"SalesMetricsDuplicate","MySolution.SalesMetrics",,0)

  // Add some values into Default properties
  // Default values for SalesMetricsDuplicate
  Do ..AddDefaultSetting(,"SalesMetricsDuplicate",,"AlertOnError","1")
  // Default values for all items with MySolution.SalesMetrics class
  Do ..AddDefaultSetting(,,"MySolution.SalesMetrics","AlertGroups","SalesErrorGroup")

  // Add a lookup table with values
  set itemCount = 0
  set pList($Increment(itemCount))=$Listbuild("RgbColors","Red","255,0,0")
  set pList($Increment(itemCount))=$Listbuild("RgbColors","Blue","0,0,255")
  set pList($Increment(itemCount))=$Listbuild("RgbColors","Green","0,255,0")
  set pList($Increment(itemCount))=$Listbuild("RgbColors","Black","0,1,0")  // With a mistake
  set pList($Increment(itemCount))=$Listbuild("RgbColor","White","255,255,255")  // Table name wrong
  set pList = itemCount
  do ..AddLookupTable(.pList)

  quit $$$OK
}

ClassMethod setupFix() As %Status
{
  // Remove duplicate itedisabled
  do ..RemoveItem(,"SalesMetricsDuplicate")

  // Remove default setting 
  Do ..RemoveDefaultSetting(,"SalesMetricsDuplicate",,"AlertOnError")
  
  // Fix lookup table mistake
  set itemCount = 0
  set pList($Increment(itemCount))=$Listbuild("RgbColors","Black","0,0,0")
  set pList($Increment(itemCount))=$Listbuild("RgbColors","White","255,255,255")
  set pList = itemCount
  do ..AddLookupTable(.pList)
  kill pList, itemCount
  set itemCount = 0
  set pList($Increment(itemCount))=$Listbuild("RgbColor","White")
  set pList = itemCount
  do ..RemoveLookupTable(.pList)

  quit $$$OK
}

}
