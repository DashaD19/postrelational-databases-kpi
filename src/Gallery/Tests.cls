/// Unit-тести для класів Gallery
Class Gallery.Tests Extends %UnitTest.TestCase
{

/// Очистка даних після всіх тестів
Method OnAfterAllTests() As %Status
{
    Do ##class(Gallery.Exhibition).%KillExtent()
    Do ##class(Gallery.Artwork).%KillExtent()
    Do ##class(Gallery.Artist).%KillExtent()
    Quit $$$OK
}

/// Тест створення об'єктів Artist
Method TestCreateArtist()
{
    Set artist = ##class(Gallery.Artist).%New()
    Do $$$AssertTrue($IsObject(artist), "Створення нового Artist")

    Set artist.FullName = "Тестовий Художник"
    Set artist.Country = "Україна"
    Set artist.BirthYear = 1980

    Set status = artist.%Save()
    Do $$$AssertStatusOK(status, "Artist збережено успішно")
    Do $$$AssertNotEquals(artist.%Id(), "", "Artist має ID після збереження")
}

/// Тест обов'язкової властивості (Required) для Artist
Method TestArtistRequiredProperty()
{
    Set artist = ##class(Gallery.Artist).%New()
    Set artist.Country = "Україна"

    Set status = artist.%Save()
    Do $$$AssertStatusNotOK(status, "Artist без FullName не зберігається (Required)")
}

/// Тест унікальної властивості (Unique) для Artist
Method TestArtistUniqueProperty()
{
    // Створюємо першого художника
    Set artist1 = ##class(Gallery.Artist).%New()
    Set artist1.FullName = "Унікальний Художник"
    Set status1 = artist1.%Save()
    Do $$$AssertStatusOK(status1, "Перший Artist збережено")

    // Спробуємо створити другого з таким самим FullName
    Set artist2 = ##class(Gallery.Artist).%New()
    Set artist2.FullName = "Унікальний Художник"
    Set status2 = artist2.%Save()
    Do $$$AssertStatusNotOK(status2, "Другий Artist з тим самим FullName не зберігається (Unique)")
}

/// Тест обмежень (Constraints) для Artwork.CreationYear
Method TestArtworkConstraints()
{
    // Спочатку створимо Artist для зв'язку
    Set artist = ##class(Gallery.Artist).%New()
    Set artist.FullName = "Художник для тесту"
    Do artist.%Save()

    // Тест: рік менше мінімального
    Set artwork1 = ##class(Gallery.Artwork).%New()
    Set artwork1.Title = "Твір 1"
    Set artwork1.CreationYear = 500
    Do artwork1.ArtistSetObjectId(artist.%Id())
    Set status1 = artwork1.%Save()
    Do $$$AssertStatusNotOK(status1, "Artwork з CreationYear < 1000 не зберігається")

    // Тест: рік більше максимального
    Set artwork2 = ##class(Gallery.Artwork).%New()
    Set artwork2.Title = "Твір 2"
    Set artwork2.CreationYear = 2500
    Do artwork2.ArtistSetObjectId(artist.%Id())
    Set status2 = artwork2.%Save()
    Do $$$AssertStatusNotOK(status2, "Artwork з CreationYear > 2100 не зберігається")

    // Тест: коректний рік
    Set artwork3 = ##class(Gallery.Artwork).%New()
    Set artwork3.Title = "Твір 3"
    Set artwork3.CreationYear = 1900
    Do artwork3.ArtistSetObjectId(artist.%Id())
    Set status3 = artwork3.%Save()
    Do $$$AssertStatusOK(status3, "Artwork з коректним CreationYear зберігається")
}

/// Тест відношення one-many (Artist-Artworks)
Method TestOneManyRelationship()
{
    // Створюємо Artist
    Set artist = ##class(Gallery.Artist).%New()
    Set artist.FullName = "Художник з творами"
    Do artist.%Save()

    // Створюємо кілька Artwork для цього Artist
    Set artwork1 = ##class(Gallery.Artwork).%New()
    Set artwork1.Title = "Твір А"
    Set artwork1.CreationYear = 1900
    Do artwork1.ArtistSetObjectId(artist.%Id())
    Do artwork1.%Save()

    Set artwork2 = ##class(Gallery.Artwork).%New()
    Set artwork2.Title = "Твір Б"
    Set artwork2.CreationYear = 1950
    Do artwork2.ArtistSetObjectId(artist.%Id())
    Do artwork2.%Save()

    // Перевіряємо кількість творів через relationship
    Set artistReloaded = ##class(Gallery.Artist).%OpenId(artist.%Id())
    Do $$$AssertEquals(artistReloaded.Artworks.Count(), 2, "Artist має 2 твори через relationship")

    // Перевіряємо computed властивість ArtworksCount
    Do $$$AssertEquals(artistReloaded.ArtworksCount, 2, "ArtworksCount повертає 2")
}

/// Тест відношення parent-children (Exhibition-Exhibits)
Method TestParentChildrenRelationship()
{
    // Створюємо Exhibition
    Set exhibition = ##class(Gallery.Exhibition).%New()
    Set exhibition.Title = "Тестова виставка"
    Set exhibition.StartDate = +$Horolog
    Do exhibition.%Save()

    // Створюємо Exhibit для цієї Exhibition
    Set exhibit1 = ##class(Gallery.Exhibit).%New()
    Set exhibit1.Position = 1
    Set exhibit1.DisplayNotes = "Примітка 1"
    Set exhibit1.Exhibition = exhibition
    Do exhibit1.%Save()

    Set exhibit2 = ##class(Gallery.Exhibit).%New()
    Set exhibit2.Position = 2
    Set exhibit2.DisplayNotes = "Примітка 2"
    Set exhibit2.Exhibition = exhibition
    Do exhibit2.%Save()

    // Перевіряємо кількість експонатів
    Set exhibitionReloaded = ##class(Gallery.Exhibition).%OpenId(exhibition.%Id())
    Do $$$AssertEquals(exhibitionReloaded.Exhibits.Count(), 2, "Exhibition має 2 експонати")
}

/// Тест видалення parent з children (каскадне видалення)
Method TestDeleteParentWithChildren()
{
    // Створюємо Exhibition з Exhibits
    Set exhibition = ##class(Gallery.Exhibition).%New()
    Set exhibition.Title = "Виставка для видалення"
    Do exhibition.%Save()
    Set exhibitionId = exhibition.%Id()

    Set exhibit = ##class(Gallery.Exhibit).%New()
    Set exhibit.Position = 1
    Set exhibit.Exhibition = exhibition
    Do exhibit.%Save()
    Set exhibitId = exhibit.%Id()

    // Видаляємо Exhibition
    Set status = ##class(Gallery.Exhibition).%DeleteId(exhibitionId)
    Do $$$AssertStatusOK(status, "Exhibition видалено успішно")

    // Перевіряємо, що Exhibit теж видалено (каскадне видалення)
    Set exhibitAfter = ##class(Gallery.Exhibit).%OpenId(exhibitId)
    Do $$$AssertTrue('$IsObject(exhibitAfter), "Exhibit видалено каскадно разом з Exhibition")
}

/// Тест видалення Artist з існуючими Artworks (one-many)
Method TestDeleteArtistWithArtworks()
{
    // Створюємо Artist з Artwork
    Set artist = ##class(Gallery.Artist).%New()
    Set artist.FullName = "Художник для видалення"
    Do artist.%Save()
    Set artistId = artist.%Id()

    Set artwork = ##class(Gallery.Artwork).%New()
    Set artwork.Title = "Твір художника"
    Set artwork.CreationYear = 1900
    Do artwork.ArtistSetObjectId(artistId)
    Do artwork.%Save()

    // Спробуємо видалити Artist (має бути помилка — one-many)
    Set status = ##class(Gallery.Artist).%DeleteId(artistId)
    Do $$$AssertStatusNotOK(status, "Artist з Artworks не видаляється (one-many constraint)")
}

/// Тест автоматичної генерації даних (%Populate)
Method TestPopulateArtist()
{
    Set count = ##class(Gallery.Artist).Populate(3, 0)
    Do $$$AssertEquals(count, 3, "Згенеровано 3 Artist через %Populate")
}

}
