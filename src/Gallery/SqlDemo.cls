/// Демонстрація SQL можливостей в IRIS
Class Gallery.SqlDemo Extends %RegisteredObject
{

/// Демонстрація динамічного SQL
ClassMethod DynamicSqlDemo()
{
    Write "=== Динамічний SQL ===", !

    // Створюємо запит
    Set query = "SELECT %ID, Title, CreationYear, Artist->FullName As ArtistName FROM Gallery.Artwork WHERE CreationYear >= ? ORDER BY CreationYear"
    Set statement = ##class(%SQL.Statement).%New()
    Set status = statement.%Prepare(query)

    If $$$ISERR(status) {
        Write "Помилка підготовки запиту", !
        Quit
    }

    // Виконуємо з параметром (твори з 1800 року)
    Set resultSet = statement.%Execute(1800)

    Write "Твори з 1800 року:", !
    While resultSet.%Next() {
        Write "  ", resultSet.%GetData(2), " (", resultSet.%GetData(3), ") - ", resultSet.%GetData(4), !
    }
    Write !
}

/// Демонстрація простого вбудованого SQL
ClassMethod EmbeddedSqlSimpleDemo()
{
    Write "=== Простий вбудований SQL ===", !

    // Отримуємо один запис
    New SQLCODE, artistName, artworkCount

    &sql(SELECT FullName, COUNT(a.%ID)
         INTO :artistName, :artworkCount
         FROM Gallery.Artist ar
         LEFT JOIN Gallery.Artwork a ON a.Artist = ar.%ID
         GROUP BY ar.%ID
         ORDER BY COUNT(a.%ID) DESC)

    If SQLCODE = 0 {
        Write "Художник з найбільшою кількістю творів: ", artistName, " (", artworkCount, " творів)", !
    } ElseIf SQLCODE = 100 {
        Write "Немає даних", !
    } Else {
        Write "Помилка SQL: ", SQLCODE, !
    }
    Write !
}

/// Демонстрація вбудованого SQL з курсором
ClassMethod EmbeddedSqlCursorDemo()
{
    Write "=== Вбудований SQL з курсором ===", !

    New SQLCODE, title, artistName, creationYear

    // Оголошуємо курсор з implicit join
    &sql(DECLARE artworksCursor CURSOR FOR
         SELECT Title, Artist->FullName, CreationYear
         FROM Gallery.Artwork
         ORDER BY CreationYear DESC)

    // Відкриваємо курсор
    &sql(OPEN artworksCursor)

    If SQLCODE '= 0 {
        Write "Помилка відкриття курсору: ", SQLCODE, !
        Quit
    }

    Write "Твори мистецтва (останні 5):", !
    Set count = 0
    For {
        &sql(FETCH artworksCursor INTO :title, :artistName, :creationYear)
        Quit:SQLCODE'=0
        Set count = count + 1
        Quit:count>5
        Write "  ", title, " (", creationYear, ") - ", artistName, !
    }

    // Закриваємо курсор
    &sql(CLOSE artworksCursor)
    Write !
}

/// Демонстрація implicit join (->)
ClassMethod ImplicitJoinDemo()
{
    Write "=== Implicit Join (оператор ->) ===", !

    New SQLCODE, exhibitPosition, exhibitionTitle, artworkTitle

    // Запит з подвійним implicit join
    &sql(DECLARE exhibitsCursor CURSOR FOR
         SELECT Position, Exhibition->Title, Artwork->Title
         FROM Gallery.Exhibit
         WHERE Exhibition->Title IS NOT NULL
         ORDER BY Exhibition->Title)

    &sql(OPEN exhibitsCursor)

    Write "Експонати з виставками та творами:", !
    Set count = 0
    For {
        &sql(FETCH exhibitsCursor INTO :exhibitPosition, :exhibitionTitle, :artworkTitle)
        Quit:SQLCODE'=0
        Set count = count + 1
        Quit:count>5
        Write "  Позиція ", exhibitPosition, ": '", artworkTitle, "' на виставці '", exhibitionTitle, "'", !
    }

    &sql(CLOSE exhibitsCursor)
    Write !
}

/// Демонстрація роботи з методом-запитом класу
ClassMethod ClassQueryDemo()
{
    Write "=== Метод-запит класу (%SQLQuery) ===", !

    // Використовуємо %Library.ResultSet для виконання запиту
    Set resultSet = ##class(%ResultSet).%New("Gallery.Artist:GetAllArtists")
    Set status = resultSet.Execute()

    If $$$ISERR(status) {
        Write "Помилка виконання запиту", !
        Quit
    }

    Write "Всі художники:", !
    Set count = 0
    While resultSet.%Next() {
        Set count = count + 1
        Quit:count>5
        Write "  ", resultSet.%Get("FullName"), " (", resultSet.%Get("Country"), ", ", resultSet.%Get("BirthYear"), ")", !
    }
    Write !
}

/// Демонстрація COS-based запиту (%Query)
ClassMethod CosBasedQueryDemo()
{
    Write "=== COS-based запит (%Query) ===", !

    // Використовуємо запит GetExhibitionsByDateRange
    Set resultSet = ##class(%ResultSet).%New("Gallery.Exhibition:GetExhibitionsByDateRange")

    // Встановлюємо діапазон дат (останні 10 років)
    Set startFrom = $HOROLOG - (365 * 10)
    Set endTo = $HOROLOG + (365 * 2)

    Set status = resultSet.Execute(startFrom, endTo)

    If $$$ISERR(status) {
        Write "Помилка виконання запиту", !
        Quit
    }

    Write "Виставки за датою:", !
    Set count = 0
    While resultSet.%Next() {
        Set count = count + 1
        Quit:count>5
        Write "  ", resultSet.%Get("Title"), !
    }
    Write !
}

/// Демонстрація роботи тригера
ClassMethod TriggerDemo()
{
    Write "=== Демонстрація тригера ===", !

    // Очищаємо лог
    Kill ^GalleryLog

    // Створюємо художника
    Set artist = ##class(Gallery.Artist).%New()
    Set artist.FullName = "Тестовий Художник " _ $Random(1000)
    Set artist.Country = "Україна"
    Set artist.BirthYear = 1990
    Set status = artist.%Save()

    If $$$ISERR(status) {
        Write "Помилка збереження: ", $System.Status.GetErrorText(status), !
        Quit
    }

    Write "Створено художника: ", artist.FullName, !

    // Перевіряємо лог
    Write "Записи в логу ^GalleryLog:", !
    Set key = ""
    For {
        Set key = $Order(^GalleryLog("Artist", key))
        Quit:key=""
        Set key2 = ""
        For {
            Set key2 = $Order(^GalleryLog("Artist", key, key2))
            Quit:key2=""
            Set key3 = ""
            For {
                Set key3 = $Order(^GalleryLog("Artist", key, key2, key3))
                Quit:key3=""
                Write "  ID=", key, ", Операція=", key2, ", Час=", key3, ", Ім'я=", ^GalleryLog("Artist", key, key2, key3), !
            }
        }
    }
    Write !
}

/// Запустити всі демонстрації
ClassMethod RunAllDemos()
{
    Write "=================================================", !
    Write "    ДЕМОНСТРАЦІЯ SQL В IRIS (Галерея)", !
    Write "=================================================", !
    Write !

    Do ..DynamicSqlDemo()
    Do ..EmbeddedSqlSimpleDemo()
    Do ..EmbeddedSqlCursorDemo()
    Do ..ImplicitJoinDemo()
    Do ..ClassQueryDemo()
    Do ..CosBasedQueryDemo()
    Do ..TriggerDemo()

    Write "=================================================", !
    Write "    ДЕМОНСТРАЦІЮ ЗАВЕРШЕНО", !
    Write "=================================================", !
}

}
