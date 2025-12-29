/// Виставка в галереї
Class Gallery.Exhibition Extends (%Persistent, %Populate)
{

/// Назва виставки (обов'язкова)
Property Title As %String(MAXLEN = 200, POPSPEC = "Mission()") [ Required ];

/// Дата початку
Property StartDate As %Date(POPSPEC = "Date()");

/// Дата завершення
Property EndDate As %Date(POPSPEC = "Date()");

/// Локація виставки (вбудований об'єкт)
Property Location As Gallery.Location;

/// Відношення parent-children: виставка містить експонати
Relationship Exhibits As Gallery.Exhibit [ Cardinality = children, Inverse = Exhibition ];

/// Генерація вбудованого об'єкта Location для %Populate
Method LocationPopulate() As %Status
{
    Set ..Location.Building = ##class(%PopulateUtils).Company()
    Set ..Location.Hall = "Зал " _ ($Random(10) + 1)
    Set ..Location.Floor = $Random(5) + 1
    Quit $$$OK
}

}
