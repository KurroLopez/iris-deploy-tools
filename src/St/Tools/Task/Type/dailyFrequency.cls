Class St.Tools.Task.Type.DailyFrequency Extends %Integer [ ClassType = datatype, DependsOn = St.Tools.Task.Item.DailyFrequency ]
{

Parameter DISPLAYLIST = {##class(St.Tools.Task.Item.DailyFrequency).BuildDisplayList()};

Parameter VALUELIST = {##class(St.Tools.Task.Item.DailyFrequency).BuildValueList()};

}
