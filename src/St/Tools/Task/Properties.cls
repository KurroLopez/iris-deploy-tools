Class St.Tools.Task.Properties Extends %SerialObject
{

/// Task Name
Property Name As %String(MAXLEN = 100) [ Required ];

/// Task Description
Property Description As %String(MAXLEN = "");

/// NameSpace name
Property NameSpace As %String(MAXLEN = 100);

/// Task class name
Property TaskClass As %String(MAXLEN = "") [ Required ];

/// Type of period
Property Period As St.Tools.Task.Type.Period [ Required ];

/// Daily Frequency
Property DailyFrequency As St.Tools.Task.Type.DailyFrequency;

/// Daily Frequency time
Property DailyFrequencyTime As St.Tools.Task.Type.DailyFrequencyTime;

/// Incremento según definido como DailyFrequencyTime (en minutos o en horas)
Property DailyIncrement As %Integer;

/// Init datetime to start task
Property DailyStartTime As %TimeStamp;

/// End datetime to stop task
Property DailyEndTime As %TimeStamp;

/// Frequency of run task according to Period
/// <li>DAILY: Run each x days, 1-7</li>
/// <li>WEEKLY: Run each x weeks, 1-5</li>
/// <li>MONTHLY: Run each x months, 1-12</li>
/// <li>MONTHLYSPECIAL: Run each x months, 1-12</li>
/// <li>RUNAFTER: Not used </li>
/// <li>ONDEMAND: Not used</li>
Property TimePeriodEvery As %String;

/// Day of run task according to Period
/// <li>DAILY: No used</li>
/// <li>WEEKLY: Day of run task (1: Sunday, 7: Saturday, 234: Monday, Tuesday and Wednesday)</li>
/// <li>MONTHLY: pTimePeriodEvery: Ejecución cada x meses, 1-12 / TimePeriodDay = días de ejecución, 1-31</li>
/// <li>MONTHLYSPECIAL: pTimePeriodEvery: Ejecución cada x meses, 1-12 / TimePeriodDay = semana^dia (semana 1-5 / dia: 1-7 domingo: 1)</li>
/// <li>RUNAFTER: (Se ejecutará después de ejecutarse otra tarea) pTimePeriodEvery: (no usado) / TimePeriodDay: 0 / Guid: Identificador de la tarea a observar </li>
/// <li>ONDEMAND: pTimePeriodEvery: Ignorado / TimePeriodDay = Ignorado</li>
Property TimePeriodDay As %String;

/// Guid to identify task to run after
Property Guid As %String(MAXLEN = "");

/// Settings of task
Property Settings As %String(MAXLEN = "");

Storage Default
{
<Data name="PropertiesState">
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>NameSpace</Value>
</Value>
<Value name="4">
<Value>TaskClass</Value>
</Value>
<Value name="5">
<Value>Period</Value>
</Value>
<Value name="6">
<Value>DailyFrequency</Value>
</Value>
<Value name="7">
<Value>DailyFrequencyTime</Value>
</Value>
<Value name="8">
<Value>DailyIncrement</Value>
</Value>
<Value name="9">
<Value>DailyStartTime</Value>
</Value>
<Value name="10">
<Value>DailyEndTime</Value>
</Value>
<Value name="11">
<Value>TimePeriodEvery</Value>
</Value>
<Value name="12">
<Value>TimePeriodDay</Value>
</Value>
<Value name="13">
<Value>Guid</Value>
</Value>
<Value name="14">
<Value>Settings</Value>
</Value>
</Data>
<State>PropertiesState</State>
<StreamLocation>^St.Tools.Task.PropertiesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
