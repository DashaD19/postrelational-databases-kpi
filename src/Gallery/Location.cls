/// Вбудований клас для локації в галереї
Class Gallery.Location Extends %SerialObject
{

/// Назва будівлі
Property Building As %String(MAXLEN = 100, POPSPEC = "Company()");

/// Назва залу
Property Hall As %String(MAXLEN = 50, POPSPEC = "String(3)");

/// Номер поверху
Property Floor As %Integer(POPSPEC = "Integer(1,5)");

}
