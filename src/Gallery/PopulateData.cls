/// Клас для заповнення галереї тестовими даними
Class Gallery.PopulateData
{

/// Головний метод запуску
ClassMethod Run()
{
    Write "=== Заповнення бази даних галереї ===", !

    // Перевірка та очистка існуючих даних
    Do ..ValidateAndCleanup()

    Write !, "--- Етап 1: Художники ---", !
    Do ..CreateArtists()

    Write !, "--- Етап 2: Твори мистецтва ---", !
    Do ..CreateArtworks()

    Write !, "--- Етап 3: Виставки з експонатами ---", !
    Do ..CreateExhibitionsWithExhibits()

    Write !, "=== Заповнення завершено ===", !
}

/// Перевіряє існуючі дані та очищає при потребі
ClassMethod ValidateAndCleanup()
{
    Write "Перевірка існуючих даних...", !

    // Очистка у правильному порядку (спочатку залежні)
    Do ##class(Gallery.Exhibit).%KillExtent()
    Do ##class(Gallery.Exhibition).%KillExtent()
    Do ##class(Gallery.Artwork).%KillExtent()
    Do ##class(Gallery.Artist).%KillExtent()

    Write "База очищена, готова до заповнення.", !
}

/// Створити художників (5 шт.)
ClassMethod CreateArtists()
{
    // Леонардо да Вінчі
    Try {
        Set artist = ##class(Gallery.Artist).%New()
        Set artist.FirstName = "Леонардо"
        Set artist.LastName = "да Вінчі"
        Set artist.BirthDate = $ZDateH("1452-04-15", 3)
        Set artist.FullName = "Леонардо да Вінчі"
        Set artist.Country = "Італія"
        Set artist.BirthYear = 1452
        Do artist.Biography.WriteLine("Леонардо ді сер П'єро да Вінчі — італійський художник,")
        Do artist.Biography.WriteLine("скульптор, архітектор, музикант, вчений, інженер епохи Відродження.")
        Do artist.Biography.WriteLine("Автор Мони Лізи та Таємної вечері.")
        $$$ThrowOnError(artist.%Save())
        Write "  [+] ", artist.FullName, " (ID:", artist.%Id(), ")", !
    } Catch ex {
        Write "  [!] Помилка: ", ex.DisplayString(), !
    }

    // Вінсент ван Гог
    Try {
        Set artist = ##class(Gallery.Artist).%New()
        Set artist.FirstName = "Вінсент"
        Set artist.LastName = "ван Гог"
        Set artist.BirthDate = $ZDateH("1853-03-30", 3)
        Set artist.FullName = "Вінсент ван Гог"
        Set artist.Country = "Нідерланди"
        Set artist.BirthYear = 1853
        Do artist.Biography.WriteLine("Вінсент Віллем ван Гог — нідерландський художник-постімпресіоніст.")
        Do artist.Biography.WriteLine("Створив близько 2100 творів мистецтва за своє життя.")
        $$$ThrowOnError(artist.%Save())
        Write "  [+] ", artist.FullName, " (ID:", artist.%Id(), ")", !
    } Catch ex {
        Write "  [!] Помилка: ", ex.DisplayString(), !
    }

    // Клод Моне
    Try {
        Set artist = ##class(Gallery.Artist).%New()
        Set artist.FirstName = "Клод"
        Set artist.LastName = "Моне"
        Set artist.BirthDate = $ZDateH("1840-11-14", 3)
        Set artist.FullName = "Клод Моне"
        Set artist.Country = "Франція"
        Set artist.BirthYear = 1840
        Do artist.Biography.WriteLine("Оскар Клод Моне — французький художник,")
        Do artist.Biography.WriteLine("один із засновників імпресіонізму.")
        $$$ThrowOnError(artist.%Save())
        Write "  [+] ", artist.FullName, " (ID:", artist.%Id(), ")", !
    } Catch ex {
        Write "  [!] Помилка: ", ex.DisplayString(), !
    }

    // Пабло Пікассо
    Try {
        Set artist = ##class(Gallery.Artist).%New()
        Set artist.FirstName = "Пабло"
        Set artist.LastName = "Пікассо"
        Set artist.BirthDate = $ZDateH("1881-10-25", 3)
        Set artist.FullName = "Пабло Пікассо"
        Set artist.Country = "Іспанія"
        Set artist.BirthYear = 1881
        Do artist.Biography.WriteLine("Пабло Руїс Пікассо — іспанський художник, скульптор,")
        Do artist.Biography.WriteLine("графік, театральний художник, кераміст та дизайнер.")
        Do artist.Biography.WriteLine("Засновник кубізму, один з найвпливовіших художників XX століття.")
        $$$ThrowOnError(artist.%Save())
        Write "  [+] ", artist.FullName, " (ID:", artist.%Id(), ")", !
    } Catch ex {
        Write "  [!] Помилка: ", ex.DisplayString(), !
    }

    // Рембрандт ван Рейн (5-й художник)
    Try {
        Set artist = ##class(Gallery.Artist).%New()
        Set artist.FirstName = "Рембрандт"
        Set artist.LastName = "ван Рейн"
        Set artist.BirthDate = $ZDateH("1606-07-15", 3)
        Set artist.FullName = "Рембрандт ван Рейн"
        Set artist.Country = "Нідерланди"
        Set artist.BirthYear = 1606
        Do artist.Biography.WriteLine("Рембрандт Гарменс ван Рейн — нідерландський художник,")
        Do artist.Biography.WriteLine("гравер та рисувальник, великий майстер світлотіні.")
        Do artist.Biography.WriteLine("Один з найвидатніших представників Золотого віку голландського мистецтва.")
        $$$ThrowOnError(artist.%Save())
        Write "  [+] ", artist.FullName, " (ID:", artist.%Id(), ")", !
    } Catch ex {
        Write "  [!] Помилка: ", ex.DisplayString(), !
    }
}

/// Створити твори мистецтва
ClassMethod CreateArtworks()
{
    // Отримуємо ID художників через SQL (не hardcoded!)
    Set daVinciId = ..GetArtistIdByName("Леонардо да Вінчі")
    Set vanGoghId = ..GetArtistIdByName("Вінсент ван Гог")
    Set monetId = ..GetArtistIdByName("Клод Моне")
    Set picassoId = ..GetArtistIdByName("Пабло Пікассо")
    Set rembrandtId = ..GetArtistIdByName("Рембрандт ван Рейн")

    // Твори да Вінчі
    Do ..CreateSingleArtwork("INV-001", "Мона Ліза", 1503, "Олія на тополевій дошці", "77 × 53 см", daVinciId)
    Do ..CreateSingleArtwork("INV-002", "Таємна вечеря", 1498, "Темпера на гіпсі", "460 × 880 см", daVinciId)

    // Твори ван Гога
    Do ..CreateSingleArtwork("INV-003", "Зоряна ніч", 1889, "Олія на полотні", "73.7 × 92.1 см", vanGoghId)
    Do ..CreateSingleArtwork("INV-004", "Соняшники", 1888, "Олія на полотні", "92 × 73 см", vanGoghId)

    // Твори Моне
    Do ..CreateSingleArtwork("INV-005", "Враження. Схід сонця", 1872, "Олія на полотні", "48 × 63 см", monetId)
    Do ..CreateSingleArtwork("INV-006", "Водяні лілії", 1906, "Олія на полотні", "89.9 × 94.1 см", monetId)

    // Твори Пікассо
    Do ..CreateSingleArtwork("INV-007", "Герніка", 1937, "Олія на полотні", "349 × 776 см", picassoId)
    Do ..CreateSingleArtwork("INV-008", "Авіньйонські панянки", 1907, "Олія на полотні", "243.9 × 233.7 см", picassoId)

    // Твори Рембрандта
    Do ..CreateSingleArtwork("INV-009", "Нічна варта", 1642, "Олія на полотні", "363 × 437 см", rembrandtId)
    Do ..CreateSingleArtwork("INV-010", "Повернення блудного сина", 1669, "Олія на полотні", "262 × 205 см", rembrandtId)
}

/// Допоміжний метод: отримати ID художника за ім'ям
ClassMethod GetArtistIdByName(fullName As %String) As %Integer
{
    Set sql = "SELECT ID FROM Gallery.Artist WHERE FullName = ?"
    Set stmt = ##class(%SQL.Statement).%New()
    Do stmt.%Prepare(sql)
    Set rs = stmt.%Execute(fullName)
    If rs.%Next() {
        Quit rs.%GetData(1)
    }
    Quit ""
}

/// Допоміжний метод: створити один твір мистецтва
ClassMethod CreateSingleArtwork(inventoryNumber As %String, title As %String, year As %Integer, technique As %String, dimensions As %String, artistId As %Integer)
{
    Try {
        Set artwork = ##class(Gallery.Artwork).%New()
        Set artwork.InventoryNumber = inventoryNumber
        Set artwork.Title = title
        Set artwork.CreationYear = year
        Set artwork.Technique = technique
        Set artwork.Dimensions = dimensions
        // Додаємо оцінки критиків
        Do artwork.Ratings.SetAt($Random(3)+8, "АртКритик")  // 8-10
        Do artwork.Ratings.SetAt($Random(3)+8, "МузейнийЕксперт")
        Do artwork.ArtistSetObjectId(artistId)
        $$$ThrowOnError(artwork.%Save())
        Write "  [+] ", title, " (", year, ")", !
    } Catch ex {
        Write "  [!] ", title, ": ", ex.DisplayString(), !
    }
}

/// Створити виставки разом з експонатами
ClassMethod CreateExhibitionsWithExhibits()
{
    // Виставка 1: Майстри Відродження
    Set exhibRenaissance = ..CreateExhibition("Майстри Відродження", "2024-01-15", "2024-06-30", "Головний корпус", "Зала Італійського мистецтва", 2)
    If exhibRenaissance '= "" {
        Do ..AddExhibitToExhibition(exhibRenaissance, "Мона Ліза", 1, "Центральний експонат. Захисне скло.", $LB("шедевр","портрет","Відродження"))
        Do ..AddExhibitToExhibition(exhibRenaissance, "Таємна вечеря", 2, "Високоякісна репродукція фрески.", $LB("фреска","релігійне мистецтво"))
    }

    // Виставка 2: Імпресіонізм і постімпресіонізм
    Set exhibImpressionism = ..CreateExhibition("Імпресіонізм і постімпресіонізм", "2024-03-01", "2024-09-15", "Західне крило", "Зала французького живопису", 1)
    If exhibImpressionism '= "" {
        Do ..AddExhibitToExhibition(exhibImpressionism, "Враження. Схід сонця", 1, "Картина, що дала назву напрямку.", $LB("імпресіонізм","пейзаж","знаковий твір"))
        Do ..AddExhibitToExhibition(exhibImpressionism, "Зоряна ніч", 2, "Один з найвідоміших творів ван Гога.", $LB("постімпресіонізм","нічний пейзаж"))
        Do ..AddExhibitToExhibition(exhibImpressionism, "Соняшники", 3, "Серія натюрмортів ван Гога.", $LB("постімпресіонізм","натюрморт"))
        Do ..AddExhibitToExhibition(exhibImpressionism, "Водяні лілії", 4, "З відомої серії картин Моне.", $LB("імпресіонізм","пейзаж","сад"))
    }

    // Виставка 3: Модернізм XX століття
    Set exhibModern = ..CreateExhibition("Модернізм XX століття", "2024-05-01", "2024-12-31", "Східне крило", "Зала сучасного мистецтва", 3)
    If exhibModern '= "" {
        Do ..AddExhibitToExhibition(exhibModern, "Герніка", 1, "Антивоєнний шедевр Пікассо.", $LB("кубізм","антивоєнне","монументальне"))
        Do ..AddExhibitToExhibition(exhibModern, "Авіньйонські панянки", 2, "Революційна робота, початок кубізму.", $LB("кубізм","протокубізм","експериментальне"))
    }
}

/// Допоміжний метод: створити виставку
ClassMethod CreateExhibition(title As %String, startDate As %String, endDate As %String, building As %String, hall As %String, floor As %Integer) As Gallery.Exhibition
{
    Try {
        Set exhibition = ##class(Gallery.Exhibition).%New()
        Set exhibition.Title = title
        Set exhibition.StartDate = $ZDateH(startDate, 3)
        Set exhibition.EndDate = $ZDateH(endDate, 3)
        Set exhibition.Location.Building = building
        Set exhibition.Location.Hall = hall
        Set exhibition.Location.Floor = floor
        $$$ThrowOnError(exhibition.%Save())
        Write "  [Виставка] ", title, " (ID:", exhibition.%Id(), ")", !
        Quit exhibition
    } Catch ex {
        Write "  [!] Виставка '", title, "': ", ex.DisplayString(), !
        Quit ""
    }
}

/// Допоміжний метод: додати експонат до виставки
ClassMethod AddExhibitToExhibition(exhibition As Gallery.Exhibition, artworkTitle As %String, position As %Integer, notes As %String, tags As %List)
{
    Set artworkId = ..GetArtworkIdByTitle(artworkTitle)
    If artworkId = "" {
        Write "    [!] Твір '", artworkTitle, "' не знайдено", !
        Quit
    }

    Try {
        Set exhibit = ##class(Gallery.Exhibit).%New()
        Set exhibit.Position = position
        Set exhibit.DisplayNotes = notes
        // Заповнюємо теги зі списку
        For i=1:1:$ListLength(tags) {
            Do exhibit.Tags.Insert($ListGet(tags, i))
        }
        Set exhibit.Artwork = ##class(Gallery.Artwork).%OpenId(artworkId)
        Set exhibit.Exhibition = exhibition
        $$$ThrowOnError(exhibit.%Save())
        Write "    [Експонат #", position, "] ", artworkTitle, !
    } Catch ex {
        Write "    [!] Експонат '", artworkTitle, "': ", ex.DisplayString(), !
    }
}

/// Допоміжний метод: отримати ID твору за назвою
ClassMethod GetArtworkIdByTitle(title As %String) As %Integer
{
    Set sql = "SELECT ID FROM Gallery.Artwork WHERE Title = ?"
    Set stmt = ##class(%SQL.Statement).%New()
    Do stmt.%Prepare(sql)
    Set rs = stmt.%Execute(title)
    If rs.%Next() {
        Quit rs.%GetData(1)
    }
    Quit ""
}

}
