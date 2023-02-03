/// Utils for deploy your production.<br>
Class St.Tools.Deploy
{

/// Name of the production by default
Parameter PRODUCTION;

/// Namespace name
Parameter NAMESPACE;

/// Add an item in a production
/// <ul>
/// <li><var>pProduction</var> Name of production.</li>
/// <li><var>pName</var> Name of item. Mandatory.</li>
/// <li><var>pClassName</var> Classname of the item. Mandatory.</li>
/// <li><var>pCategory</var> Category of the item in the production.</li>
/// <li><var>pEnable</var> Set enable item.</li>
/// <li><var>pLogTraceEvents</var> Set enable trace events.</li>
/// <li><var>pPoolSize</var> Pool size.</li>
/// <li><var>pComment</var> Comment.</li>
/// </ul>
/// <example>Do myClass.AddItem("Item1","myPath.MyClass","Internal")</example>
ClassMethod AddItem(pProduction As %String = "", pName As %String, pClassName As %String, pCategory As %String = "", pEnabled As %Boolean = 1, pLogTraceEvents As %Boolean = 1, pPoolSize As %Integer = 1, pComment As %String = "") As %Status
{
    Set ret = $$$OK
    if pProduction = "" set pProduction = ..#PRODUCTION
    Try {
        // Check mandatory values
        If ((pName '="") && (pClassName '=""))
        {
            If '##class(Ens.Config.Item).NameExists(pProduction,pName,.idItem)
            {
                Set production = ##class(Ens.Config.Production).%OpenId(pProduction)
                Write !,"Installing "_pName
                Set objItem = ##class(Ens.Config.Item).%New()
                Set objItem.Name = pName
                Set objItem.ClassName = pClassName
                Set objItem.Enabled = pEnabled
                Set objItem.LogTraceEvents = pLogTraceEvents
                Set objItem.Category = pCategory
                Set objItem.PoolSize = pPoolSize
                Set objItem.Comment = pComment

                Do production.Items.Insert(objItem)
                Set st = production.%Save()
                Kill objItem
                Do ##class(Ens.Director).RestartProduction(0,1)
                Write !,"Item "_pName_" installed."
            }
            Else 
            {
                Write !,"Item "_pName_" already exists."
            }

        }
        Else 
        {
            If (pName = "") set attrib = "pName"
            If (pClassName ="") set attrib = "pClassName" 

            $$$ThrowOnError($System.Status.Error(406,attrib))
        }
    }
    Catch ex {
        Set ret = ex.AsStatus()
        Write !,"Error #",$System.Status.GetErrorCodes(ret),!
        Write !,$System.Status.GetOneStatusText(ret,1),!
    }

    Quit ret
}

/// Remove an item in the production.
/// <ul>
/// <li><var>pProduction</var> Name of production.</li>
/// <li><var>pName</var> Name of the item to remove. Mandatory.</li>
/// </ul>
/// <example>Do myClass.RemoveItem("Item1")</example>
ClassMethod RemoveItem(pProduction AS %String = "", pName As %String) As %Status
{
    Set ret = $$$OK
    if pProduction = "" set pProduction = ..#PRODUCTION
    Try {

        // Check mandatory values
        If (pName '="")
        {
            If ##class(Ens.Config.Item).NameExists(pProduction,pName,.idItem)
            {
                Set production = ##class(Ens.Config.Production).%OpenId(pProduction)
                Write !,"Removing "_pName
                Set objItem = production.FindItemByConfigName(pName)
                Do production.RemoveItem(objItem)
                Set st = production.%Save()
                Kill objItem
                Do ##class(Ens.Director).RestartProduction(0,1)
                Write !,"Item "_pName_" removed"
            } 
            Else 
            {
                Write !,"Item "_pName_" not found."
            }
        }
        Else 
        {
            If (pName = "") set attrib = "pName"

            $$$ThrowOnError($System.Status.Error(406,attrib))
        }
    }
    Catch ex {
        Set ret = ex.AsStatus()
        Write !,"Error #",$System.Status.GetErrorCodes(ret),!
        Write !,$System.Status.GetOneStatusText(ret,1),!
    }

    Quit ret
}

/// Insert or update a default value
/// <ul>
/// <li><var>pProduction</var> Name of production.</li>
/// <li><var>pItemName</var> Name of the item.</li>
/// <li><var>pHostClass</var> Name of class.</li>
/// <li><var>pSettingName</var> Setting name.</li>
/// <li><var>pSettingValue</var> Setting value.</li>
/// <li><var>pAllProduction</var> Set if apply this default value for all productions o just for the defined production. Default value: all productions (*).</li>
/// </ul>
/// <example>
/// /// Add new default setting for the current production
/// Do myClass.AddDefaultSetting("Host.RS.Rest",,"Port","21")
/// // Will be: CurrentProduction||Host.RS.Rest||*||Port --> 21
/// /// Add new default setting for all productions.
/// Do myClass.AddDefaultSetting("Host.RS.Rest",,"Port","21",1)
/// // Will be: *||Host.RS.Rest||*||Port --> 21
/// </example>
ClassMethod AddDefaultSetting(pProduction AS %String = "", pItemName As %String = "*", pHostClass As %String = "*", pSettingName As %String, pSettingValue As %String, pAllProduction As %Boolean = 0) As %Status
{
    Set ret = $$$OK
    if pProduction = "" set pProduction = ..#PRODUCTION
    Try {

        // Check mandatory values
        If (pSettingName '="")
        {
            Set template = "%1||%2||%3||%4"
            if pAllProduction
            {
                set production = "*"
            }
            else
            {
                set production = pProduction
            }
            Set configId = ##class(%Library.MessageDictionary).FormatText(template,production, pItemName, pHostClass, pSettingName)
            If '##class(Ens.Config.DefaultSettings).%ExistsId(configId)
			{
                Set conf = ##class(Ens.Config.DefaultSettings).%New()
                Write !,"Create new config "_configId
            }
            Else
			{
                Set conf = ##class(Ens.Config.DefaultSettings).%OpenId(configId)
                Write !,"Update config "_configId
            }

            Set conf.ProductionName = production
            Set conf.ItemName = pItemName
            Set conf.HostClassName = pHostClass
            Set conf.SettingName = pSettingName
            Set conf.SettingValue = pSettingValue
            Set conf.Deployable = 1

            Do conf.%Save()
            Kill conf
        }
        Else 
        {
            If (pSettingName = "") set attrib = "pSettingName"
            $$$ThrowOnError($System.Status.Error(406,attrib))
        }
    }
    Catch ex {
        Set ret = ex.AsStatus()
        Write !,"Error #",$System.Status.GetErrorCodes(ret),!
        Write !,$System.Status.GetOneStatusText(ret,1),!
    }

    Quit ret
}

/// Remove a default value
/// <ul>
/// <li><var>pProduction</var> Name of production.</li>
/// <li><var>pItemName</var> Item name to remove.</li>
/// <li><var>pHostClass</var> Host classname to remove.</li>
/// <li><var>pSettingName</var> Setting name to remove.</li>
/// <li><var>pAllProduction</var> Set if apply this default value for all productions o just for the defined production. Default value: all productions (*).</li>
/// </ul>
/// <example>Do myClass.RemoveDefaultSetting("Host.RS.Rest",,"Port")</example>
ClassMethod RemoveDefaultSetting(pProduction AS %String = "", pItemName As %String = "*", pHostClass As %String = "*", pSettingName As %String, pAllProduction As %Boolean = 0) As %Status
{
    Set ret = $$$OK
    if pProduction = "" set pProduction = ..#PRODUCTION
    Try {

        // Check mandatory values
        If (pSettingName '="")
        {
            Set template = "%1||%2||%3||%4"
            if pAllProduction
            {
                set production = "*"
            }
            else
            {
                set production = pProduction
            }
            Set configId = ##class(%Library.MessageDictionary).FormatText(template,production, pItemName, pHostClass, pSettingName)

            If ##class(Ens.Config.DefaultSettings).%ExistsId(configId)
			{
                Do ##class(Ens.Config.DefaultSettings).%DeleteId(configId)
            }
            Else
			{
                Write !,"Configure parameter not found ["_configId_"]"
            }
        }
        Else 
        {
            If (pSettingName = "") set attrib = "pSettingName"

            $$$ThrowOnError($System.Status.Error(406,attrib))
        }
    }
    Catch ex {
        Set ret = ex.AsStatus()
        Write !,"Error #",$System.Status.GetErrorCodes(ret),!
        Write !,$System.Status.GetOneStatusText(ret,1),!
    }

    Quit ret
}

/// Register a web application. Configurate a service that doesn't need a special configuration.
/// <ul>
/// <li><var>pNameSpace</var> Name of namespace to run the web application. Mandatory.</li>
/// <li><var>pName</var> Name of web application to create/update. Mandatory.</li>
/// <li><var>pClassName</var> Name of class to run the web application. Mandatory.</li>
/// <li><var>pDescription</var> Description of the web application.</li>
/// <li><var>pRoles</var> Roles used in web application. Default %All</li>
/// </ul>
/// <example>
/// // Add web api
/// Do myClass.RegisterWebApplication("SAMPLES","/myApp/api","Host.RS.Rest","This is my api rest")</example>
ClassMethod RegisterWebApplication(pNameSpace As %String, pName As %String, pClassName As %String, pDescription As %String = "", pRoles As %String = "%All") As %Status
{
    New $Namespace
    Set $Namespace = "%SYS"
    Set ret = $$$OK
    Set spec("AutheEnabled") = $$$AutheUnauthenticated
    Set spec("NameSpace") = pNameSpace
    Set spec("Description") = pDescription
    Set spec("IsNameSpaceDefault") = $$$NO
    Set spec("DispatchClass") = pClassName
    Set spec("MatchRoles")=":"_pRoles

    If ('##class(Security.Applications).Exists(pName)) {
        Write !,"Creating Web application """_pName_"""..."
        Set ret = ##class(Security.Applications).Create(pName, .spec)
        Write !, "Web application """_pName_""" is created."
    }
    Else { // ensure configuration matches in case of updating from old terminal versions
        Write !, "Updating web application """_pName_"""..."
        Set ret = ##class(Security.Applications).Modify(pName, .spec)
        Write !, "Web application """_pName_""" is updated."
    }
    Return ret
}

/// Remove a web application.
/// <ul>
/// <li><var>pName</var> Name of web application to remove. Mandatory.</li>
/// <li><var>pClassName</var> Name of classname of web application. Mandatory.</li>
/// </ul>
/// <example>
/// // Remove web api
/// Do myClass.RemoveWebApplication("/myApp/api","Host.RS.Rest")</example>
ClassMethod RemoveWebApplication(pName As %String, pClassName As %String)
{
    New $Namespace
    Set $Namespace = "%SYS"
    Set ret = $$$OK
    If (##class(Security.Applications).Exists(pName)) {
        Do ##class(Security.Applications).Get(pName, .props)
        If (props("DispatchClass") '= pClassName) {
            Write !, "Web application doesn't refer to DispatchClass "_pClassName
        }
        Else {
            Write !, "Deleting Web application """_pName_"""..."
            Set ret = ##class(Security.Applications).Delete(pName)
            Write !, "Web application """_pName_""" was successfully deleted."
        }
    }
    Return ret
}

/// Add a value into a lookup table. If it exists, replace the value. If doesn't exist the table name, it'll be created in this moment.
/// <ul>
/// <li><var>pList</var> List of values to include. Each item should be a <b>$Listbuild</b> that include:</li>
/// <ul>
/// <li>Table</li>
/// <li>Field</li>
/// <li>Value</li>
/// </ul>
/// </ul>
/// <example>
/// set pList(1)=$Listbuild("MyTable","Campo1","Valor1")
/// set pList(2)=$Listbuild("MyTable","Campo2","Valor2")
/// set pList(3)=$Listbuild("MyTable","Campo3","Valor3")
/// set pList(4)=$Listbuild("MyOtherTable","Campo","Valor")
/// set pList = 4
/// do myClass.AddLookupTable(pList)
/// </example>
ClassMethod AddLookupTable(pList, pReplace As %Boolean = 1) As %Status
{
    Set ret = $$$OK
    Set template = "%1.%2"
    Try {
        For i=1:1:pList
		{
            Set item = ##class(%Library.MessageDictionary).FormatText(template, $List(pList(i),1),$List( pList(i),2))
            If (pReplace)
        {
                Do ##class(Ens.Util.LookupTable).%UpdateValue($List( pList(i),1),$List( pList(i),2),$List( pList(i),3),1)
                Write !,"Created lookup "_item
            }
            Else {
                Set columnaTabla = ##class(Ens.Util.FunctionSet).Lookup($List( pList(i),1),$ZConvert($List( pList(i),2), "U"),"", 0)
                If columnaTabla=""
                {
                    Do ##class(Ens.Util.LookupTable).%UpdateValue($List( pList(i),1),$List( pList(i),2),$List( pList(i),3),1)
                    Write !,"Created lookup "_item
                }
                Else{
                    Write !,"LookUp "_item_" already exists"
                }
                Kill columnaTabla
            }
        }
    }
    Catch ex {
        Set ret = ex.AsStatus()
        Write !,"Error #",$System.Status.GetErrorCodes(ret),!
        Write !,$System.Status.GetOneStatusText(ret,1),!
    }
    Quit ret
}

/// Remove a value of a lookup table.
/// <ul>
/// <li><var>pList</var> List of values to remove. Each item should be a <b>$Listbuild</b> that include:</li>
/// <ul>
/// <li>Table</li>
/// <li>Field</li>
/// </ul>
/// </ul>
/// <example>
/// set pList(1)=$Listbuild("MyTable","Campo1")
/// set pList(2)=$Listbuild("MyTable","Campo2")
/// set pList(3)=$Listbuild("MyTable","Campo3")
/// set pList(4)=$Listbuild("MyOtherTable","Campo")
/// set pList = 4
/// do myClass.RemoveLookupTable(pList)
/// </example>
ClassMethod RemoveLookupTable(pList) As %Status
{
    Set ret = $$$OK
    Try {
        For i=1:1:pList
		{
            Do ##class(Ens.Util.LookupTable).%RemoveValue($List( pList(i),1),$List( pList(i),2))
            Write !,"Removed Lookup "_$List( pList(i),1)_"."_$List( pList(i),2)
        }
    }
    Catch ex {
        Set ret = ex.AsStatus()
        Write !,"Error #",$System.Status.GetErrorCodes(ret),!
        Write !,$System.Status.GetOneStatusText(ret,1),!
    }
    Quit ret
}

/// Add a schedule task
ClassMethod AddTask(pProperties As St.Tools.Task.Properties) As %Status
{
    Set ret = $$$OK
    Try {
        set existe = 0
        if pProperties.NameSpace = "" set pProperties.NameSpace = $NAMESPACE
        &sql(SELECT COUNT(1) INTO :existe FROM %SYS.Task WHERE TaskClass=:pProperties.TaskClass AND Name = :pProperties.Name AND NameSpace = :pProperties.NameSpace)
        if existe = 0
        {
            // Add the task
            set task = ##class(%SYS.Task).%New()
            set task.Name = pProperties.Name
            set task.Description = pProperties.Description
            set task.NameSpace = pProperties.NameSpace
            set task.TimePeriod = pProperties.Period
            set task.TimePeriodEvery = pProperties.TimePeriodEvery
            set task.TimePeriodDay = pProperties.TimePeriodDay

            set task.DailyFrequency = pProperties.DailyFrequency
            set task.DailyFrequencyTime = pProperties.DailyFrequencyTime
            set task.DailyIncrement = pProperties.DailyIncrement
            set task.DailyStartTime = pProperties.DailyStartTime
            set task.DailyEndTime = pProperties.DailyEndTime

            set task.RunAfterGUID = pProperties.Guid

            set taskDef = $CLASSMETHOD(pProperties.TaskClass,"%New")
            do task.AssignSettings(taskDef)
            set task.TaskClass = pProperties.TaskClass
            
            set task.Settings = pProperties.Settings
            $$$ThrowOnError(task.%Save())
        }
    }
    Catch ex {
        Set ret = ex.AsStatus()
        Write !,"Error #",$System.Status.GetErrorCodes(ret),!
        Write !,$System.Status.GetOneStatusText(ret,1),!
    }
    Quit ret
}

}
