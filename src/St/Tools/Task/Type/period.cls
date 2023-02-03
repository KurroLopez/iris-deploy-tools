Class St.Tools.Task.Type.Period Extends %Integer [ ClassType = datatype, DependsOn = St.Tools.Task.Item.Period ]
{

Parameter DISPLAYLIST = {##class(St.Tools.Task.Item.Period).BuildDisplayList()};

Parameter VALUELIST = {##class(St.Tools.Task.Item.Period).BuildValueList()};

}
