Class St.Tools.Task.AbstractEnum [ Abstract ]
{

ClassMethod BuildValueList() As %String
{
   Set valueList = ","_..GetValuesOfParametersString()
   Return valueList
}

ClassMethod BuildDisplayList() As %String
{
   Set displayList = ","_..GetParametersString()
   Return displayList
}

ClassMethod GetValuesOfParameters()
{
   Set parametersList = ..GetParameters()
   Set valueList= $lb("")
   For i=1:1:$LISTLENGTH(parametersList){
      Set value = $PARAMETER($CLASSNAME(),$LIST(parametersList,i))
      Set $LIST(valueList,i) = value
   }
   Return valueList
}

ClassMethod GetParameters() [ CodeMode = objectgenerator ]
{
   Set parametersClass=""
   For i=1:1:%class.Parameters.Count(){
      Set parametersClass=parametersClass_$LISTBUILD(%class.Parameters.GetAt(i).Name)
   }
   Do %code.WriteLine($char(9)_"Return """_parametersClass_"""")
}

ClassMethod GetParametersString() As %String
{
   Return $listtostring(..GetParameters())
}

ClassMethod GetValuesOfParametersString() As %String
{
   Return $listtostring(..GetValuesOfParameters())
}

}
