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

/// SQL-запит: отримати всі виставки
Query GetAllExhibitions() As %SQLQuery(CONTAINID = 1)
{
    SELECT %ID, Title, StartDate, EndDate, Location_Building
    FROM Gallery.Exhibition
    ORDER BY StartDate DESC
}

/// SQL-запит з параметром: виставки за будівлею
Query GetExhibitionsByBuilding(buildingName As %String) As %SQLQuery(CONTAINID = 1)
{
    SELECT %ID, Title, StartDate, EndDate, Location_Hall
    FROM Gallery.Exhibition
    WHERE Location_Building = :buildingName
    ORDER BY StartDate
}

/// COS-based запит: виставки за датою (реалізація на ObjectScript)
Query GetExhibitionsByDateRange(startFrom As %Date, endTo As %Date) As %Query(ROWSPEC = "ID:%Integer,Title:%String,StartDate:%Date,EndDate:%Date")
{
}

/// Метод Execute для COS-based запиту
ClassMethod GetExhibitionsByDateRangeExecute(ByRef qHandle As %Binary, startFrom As %Date, endTo As %Date) As %Status
{
    Set sql = "SELECT %ID, Title, StartDate, EndDate FROM Gallery.Exhibition WHERE StartDate >= ? AND EndDate <= ? ORDER BY StartDate"
    Set statement = ##class(%SQL.Statement).%New()
    Set status = statement.%Prepare(sql)
    If $$$ISERR(status) Quit status
    Set rset = statement.%Execute(startFrom, endTo)
    Set qHandle("rset") = rset
    Quit $$$OK
}

/// Метод Fetch для COS-based запиту
ClassMethod GetExhibitionsByDateRangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExhibitionsByDateRangeExecute ]
{
    Set rset = qHandle("rset")
    If rset.%Next() {
        Set Row = $ListBuild(rset.%GetData(1), rset.%GetData(2), rset.%GetData(3), rset.%GetData(4))
    } Else {
        Set Row = ""
        Set AtEnd = 1
    }
    Quit $$$OK
}

/// Метод Close для COS-based запиту
ClassMethod GetExhibitionsByDateRangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExhibitionsByDateRangeExecute ]
{
    Kill qHandle
    Quit $$$OK
}

}
