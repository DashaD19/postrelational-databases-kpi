/// REST клієнт для тестування API художників
Class Gallery.RestClient Extends %RegisteredObject
{

Parameter BASEURL = "http://localhost:52773/gallery/api";

/// Демонстрація всіх REST операцій
ClassMethod RunDemo()
{
    Write "========== REST Client Demo (Gallery) ==========", !

    Do ..DemoGetAllArtists()
    Do ..DemoGetArtist()
    Do ..DemoCreateArtist()
    Do ..DemoUpdateArtist()
    Do ..DemoDeleteArtist()

    Write "================================================", !
}

/// Отримання списку художників
ClassMethod DemoGetAllArtists()
{
    Write !,"--- GET /artists ---", !

    Set request = ##class(%Net.HttpRequest).%New()
    Set request.Server = "localhost"
    Set request.Port = 52773

    Set status = request.Get("/gallery/api/artists")

    If $$$ISOK(status) && (request.HttpResponse.StatusCode = 200) {
        Set response = request.HttpResponse.Data.Read()
        Write "Response: ", response, !
    } Else {
        Write "Error: ", request.HttpResponse.StatusCode, !
    }
}

/// Отримання конкретного художника
ClassMethod DemoGetArtist()
{
    Write !,"--- GET /artist/:id ---", !

    Set artistId = ""
    Set key = $Order(^Gallery.ArtistD(""))
    If key '= "" {
        Set artistId = key
    }

    If artistId = "" {
        Write "No artists found", !
        Quit
    }

    Set request = ##class(%Net.HttpRequest).%New()
    Set request.Server = "localhost"
    Set request.Port = 52773

    Set url = "/gallery/api/artist/" _ $ZConvert(artistId, "O", "URL")
    Set status = request.Get(url)

    If $$$ISOK(status) && (request.HttpResponse.StatusCode = 200) {
        Set response = request.HttpResponse.Data.Read()
        Write "Artist: ", response, !
    } Else {
        Write "Error: ", request.HttpResponse.StatusCode, !
    }
}

/// Створення художника
ClassMethod DemoCreateArtist()
{
    Write !,"--- POST /artist ---", !

    Set request = ##class(%Net.HttpRequest).%New()
    Set request.Server = "localhost"
    Set request.Port = 52773
    Set request.ContentType = "application/json"

    Set body = {}
    Set body.fullName = "Test Artist " _ $Random(9999)
    Set body.country = "Ukraine"
    Set body.birthYear = 1990
    Set body.biography = "Test biography"

    Do request.EntityBody.Write(body.%ToJSON())

    Set status = request.Post("/gallery/api/artist")

    If $$$ISOK(status) {
        Set response = request.HttpResponse.Data.Read()
        Write "Response: ", response, !
    } Else {
        Write "Error creating artist", !
    }
}

/// Оновлення художника
ClassMethod DemoUpdateArtist()
{
    Write !,"--- PUT /artist/:id ---", !

    Set artistId = ""
    Set key = $Order(^Gallery.ArtistD(""))
    If key '= "" {
        Set artistId = key
    }

    If artistId = "" {
        Write "No artists found", !
        Quit
    }

    Set request = ##class(%Net.HttpRequest).%New()
    Set request.Server = "localhost"
    Set request.Port = 52773
    Set request.ContentType = "application/json"

    Set body = {}
    Set body.country = "Poland"
    Set body.birthYear = 1985

    Do request.EntityBody.Write(body.%ToJSON())

    Set url = "/gallery/api/artist/" _ $ZConvert(artistId, "O", "URL")
    Set status = request.Put(url)

    If $$$ISOK(status) {
        Set response = request.HttpResponse.Data.Read()
        Write "Response: ", response, !
    } Else {
        Write "Error updating artist", !
    }
}

/// Видалення художника
ClassMethod DemoDeleteArtist()
{
    Write !,"--- DELETE /artist/:id ---", !

    Set testId = ""
    Set key = ""
    For {
        Set key = $Order(^Gallery.ArtistD(key))
        Quit:key=""
        If key["Test Artist" {
            Set testId = key
            Quit
        }
    }

    If testId = "" {
        Write "No test artist found to delete", !
        Quit
    }

    Set request = ##class(%Net.HttpRequest).%New()
    Set request.Server = "localhost"
    Set request.Port = 52773

    Set url = "/gallery/api/artist/" _ $ZConvert(testId, "O", "URL")
    Set status = request.Delete(url)

    If $$$ISOK(status) {
        Set response = request.HttpResponse.Data.Read()
        Write "Response: ", response, !
    } Else {
        Write "Error deleting artist", !
    }
}

}
