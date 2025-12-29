/// Налаштування та генерація тестових даних
Class Gallery.Setup Extends %RegisteredObject
{

/// Очистити всі дані та згенерувати нові
ClassMethod Reset(count As %Integer = 3)
{
    Write "Очищення даних...", !

    // Видалення в правильному порядку (children перед parent)
    Do ##class(Gallery.Exhibit).%KillExtent()
    Do ##class(Gallery.Exhibition).%KillExtent()
    Do ##class(Gallery.Artwork).%KillExtent()
    Do ##class(Gallery.Artist).%KillExtent()

    // Очищення логів
    Kill ^GalleryLog

    Write "Генерація даних...", !

    // Генерація художників
    Do ##class(Gallery.Artist).Populate(count)

    // Генерація творів
    Do ##class(Gallery.Artwork).Populate(count * 2)

    // Генерація виставок
    Do ##class(Gallery.Exhibition).Populate(count)

    // Генерація експонатів (вручну, бо children)
    Do ..PopulateExhibits(count * 3)

    Write "Готово!", !
    Do ..ShowStats()
}

/// Генерація експонатів
ClassMethod PopulateExhibits(count As %Integer)
{
    Set exhibCount = 0
    &sql(SELECT COUNT(*) INTO :exhibCount FROM Gallery.Exhibition)
    If exhibCount = 0 Quit

    Set artCount = 0
    &sql(SELECT COUNT(*) INTO :artCount FROM Gallery.Artwork)

    For i = 1:1:count {
        Set exhibId = $Random(exhibCount) + 1
        Set exhibition = ##class(Gallery.Exhibition).%OpenId(exhibId)
        If '$IsObject(exhibition) Continue

        Set exhibit = ##class(Gallery.Exhibit).%New()
        Set exhibit.Position = i
        Set exhibit.DisplayNotes = ##class(%PopulateUtils).String(5)
        Do exhibit.TagsPopulate()

        If artCount > 0 {
            Set artworkId = $Random(artCount) + 1
            Do exhibit.ArtworkSetObjectId(artworkId)
        }

        Set exhibit.Exhibition = exhibition
        Do exhibit.%Save()
    }
}

/// Показати статистику
ClassMethod ShowStats()
{
    Write !
    Write "Статистика:", !

    Set cnt = 0
    &sql(SELECT COUNT(*) INTO :cnt FROM Gallery.Artist)
    Write "  Художників: ", cnt, !

    &sql(SELECT COUNT(*) INTO :cnt FROM Gallery.Artwork)
    Write "  Творів: ", cnt, !

    &sql(SELECT COUNT(*) INTO :cnt FROM Gallery.Exhibition)
    Write "  Виставок: ", cnt, !

    &sql(SELECT COUNT(*) INTO :cnt FROM Gallery.Exhibit)
    Write "  Експонатів: ", cnt, !
}

/// Показати глобали (для демонстрації IDKEY)
ClassMethod ShowGlobals()
{
    Write "=== Глобали Gallery ===", !

    Write "^Gallery.ArtistD:", !
    ZWrite ^Gallery.ArtistD

    Write !
    Write "^Gallery.ArtistI:", !
    ZWrite ^Gallery.ArtistI
}

}
