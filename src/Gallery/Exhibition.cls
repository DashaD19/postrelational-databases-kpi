/// Виставка в галереї
Class Gallery.Exhibition Extends %Persistent
{

/// Назва виставки (обов'язкова)
Property Title As %String(MAXLEN = 200) [ Required ];

/// Дата початку
Property StartDate As %Date;

/// Дата завершення
Property EndDate As %Date;

/// Локація виставки (вбудований об'єкт)
Property Location As Gallery.Location;

/// Відношення parent-children: виставка містить експонати
Relationship Exhibits As Gallery.Exhibit [ Cardinality = children, Inverse = Exhibition ];

}
