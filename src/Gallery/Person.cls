/// Абстрактний базовий клас для людей
Class Gallery.Person Extends %RegisteredObject [ Abstract ]
{

/// Ім'я (обов'язкове)
Property FirstName As %String(MAXLEN = 100, POPSPEC = "FirstName()") [ Required ];

/// Прізвище (обов'язкове)
Property LastName As %String(MAXLEN = 100, POPSPEC = "LastName()") [ Required ];

/// Дата народження
Property BirthDate As %Date(POPSPEC = "Date()");

/// Вік (обчислювана властивість)
Property Age As %Integer [ Calculated ];

/// Геттер для обчислення віку на основі дати народження
Method AgeGet() As %Integer
{
    If ..BirthDate = "" Quit ""
    Set todayDays = +$Horolog
    Set ageDays = todayDays - ..BirthDate
    Set ageYears = ageDays \ 365.25
    Quit ageYears
}

/// Отримати повне ім'я
Method GetFullName() As %String
{
    Quit ..FirstName _ " " _ ..LastName
}

}
