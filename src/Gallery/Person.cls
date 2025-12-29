/// Абстрактний базовий клас для людей
Class Gallery.Person Extends %RegisteredObject [ Abstract ]
{

Property FirstName As %String(MAXLEN = 100) [ Required ];  // ім'я людини

Property LastName As %String(MAXLEN = 100) [ Required ];  // прізвище

Property BirthDate As %Date;  // дата народження у форматі $HOROLOG

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

/// Повертає повне ім'я (ім'я + прізвище)
Method GetFullName() As %String
{
    Quit ..FirstName _ " " _ ..LastName
}

}
