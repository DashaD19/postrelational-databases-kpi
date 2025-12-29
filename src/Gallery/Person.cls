/// Абстрактний базовий клас для людей
Class Gallery.Person Extends %RegisteredObject [ Abstract ]
{

/// Ім'я
Property FirstName As %String(MAXLEN = 100, POPSPEC = "FirstName()");

/// Прізвище
Property LastName As %String(MAXLEN = 100, POPSPEC = "LastName()");

/// Дата народження
Property BirthDate As %Date(POPSPEC = "Date()");

/// Отримати повне ім'я
Method GetFullName() As %String
{
    Quit ..FirstName _ " " _ ..LastName
}

}
