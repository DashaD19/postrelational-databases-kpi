/// Вбудований клас для локації в галереї
Class Gallery.Location Extends %SerialObject
{

/// Назва будівлі
Property Building As %String(MAXLEN = 100);

/// Назва залу
Property Hall As %String(MAXLEN = 50);

/// Номер поверху (від 0 до 50)
Property Floor As %Integer(MAXVAL = 50, MINVAL = 0);

}
