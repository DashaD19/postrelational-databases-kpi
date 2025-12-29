/// Допоміжний клас для запуску тестів
Class Gallery.RunTests
{

/// Запустити всі тести Gallery
ClassMethod Run()
{
    Write "=== Підготовка до тестування ===", !

    // Очистити дані перед тестами
    Do ##class(Gallery.Exhibition).%KillExtent()
    Do ##class(Gallery.Artwork).%KillExtent()
    Do ##class(Gallery.Artist).%KillExtent()

    Write "Дані очищено", !
    Write !, "=== Запуск Unit-тестів ===", !

    // Налаштування шляху для тестів
    Set ^UnitTestRoot = "/tmp/unittests"

    // Створюємо директорію якщо не існує
    Set dir = "/tmp/unittests/Gallery"

    // Експорт класу тестів
    Set status = $System.OBJ.Export("Gallery.Tests.CLS", dir _ "/Gallery.Tests.xml")
    If '$$$ISOK(status) {
        Write "Помилка експорту: ", $System.Status.GetErrorText(status), !
        Quit
    }

    // Запуск тестів
    Set test = "Gallery:Gallery.Tests"
    Set quals = "/noload/norecursive/nodelete"

    Do ##class(%UnitTest.Manager).RunTest(test, quals)

    Write !, "=== Тестування завершено ===", !
}

/// Швидкий запуск тестів без експорту (для розробки)
ClassMethod QuickTest()
{
    Write "=== Швидкий запуск тестів ===", !

    // Очистити дані перед тестами
    Do ##class(Gallery.Exhibition).%KillExtent()
    Do ##class(Gallery.Artwork).%KillExtent()
    Do ##class(Gallery.Artist).%KillExtent()

    Set tests = ##class(Gallery.Tests).%New()

    Write !, "1. TestCreateArtist:", !
    Do tests.TestCreateArtist()

    Write !, "2. TestArtistRequiredProperty:", !
    Do tests.TestArtistRequiredProperty()

    Write !, "3. TestArtistUniqueProperty:", !
    Do tests.TestArtistUniqueProperty()

    Write !, "4. TestArtworkConstraints:", !
    Do tests.TestArtworkConstraints()

    Write !, "5. TestOneManyRelationship:", !
    Do tests.TestOneManyRelationship()

    Write !, "6. TestParentChildrenRelationship:", !
    Do tests.TestParentChildrenRelationship()

    Write !, "7. TestDeleteParentWithChildren:", !
    Do tests.TestDeleteParentWithChildren()

    Write !, "8. TestDeleteArtistWithArtworks:", !
    Do tests.TestDeleteArtistWithArtworks()

    Write !, "9. TestPopulateArtist:", !
    Do tests.TestPopulateArtist()

    // Очистка
    Do tests.OnAfterAllTests()

    Write !, "=== Всі тести виконано ===", !
}

}
