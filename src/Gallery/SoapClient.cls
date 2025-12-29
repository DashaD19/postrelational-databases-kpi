/// SOAP клієнт для тестування веб-сервісу художників
Class Gallery.SoapClient Extends %RegisteredObject
{

/// Демонстрація всіх SOAP операцій
ClassMethod RunDemo()
{
    Write "========== SOAP Client Demo (Gallery) ==========", !

    Do ..DemoGetAllArtists()
    Do ..DemoGetArtist()
    Do ..DemoCreateArtist()
    Do ..DemoUpdateArtist()
    Do ..DemoDeleteArtist()

    Write "=================================================", !
}

/// Отримання списку художників
ClassMethod DemoGetAllArtists()
{
    Write !,"--- GetAllArtists ---", !

    Set client = ##class(%SOAP.WebClient).%New()
    Set client.Location = "http://localhost:52773/csp/user/Gallery.SoapService.cls"

    Set request = ##class(%SOAP.RequestMessage).%New()
    Set request.MethodName = "GetAllArtists"

    Set status = client.SendSOAPRequest("", request, .response)

    If $$$ISOK(status) {
        Write "Got response: ", response.Body.Read(), !
    } Else {
        Write "Error: ", $System.Status.GetErrorText(status), !
    }
}

/// Виклик сервісу напряму через ObjectScript
ClassMethod DemoGetArtist()
{
    Write !,"--- GetArtist (direct call) ---", !

    Set artistId = $Order(^Gallery.ArtistD(""))
    If artistId = "" {
        Write "No artists found", !
        Quit
    }

    Set service = ##class(Gallery.SoapService).%New()
    Set result = service.GetArtist(artistId)

    If $IsObject(result) {
        Write "Artist: ", result.FullName, " from ", result.Country, !
    } Else {
        Write "Artist not found", !
    }
}

/// Створення художника
ClassMethod DemoCreateArtist()
{
    Write !,"--- CreateArtist (direct call) ---", !

    Set service = ##class(Gallery.SoapService).%New()
    Set result = service.CreateArtist("SOAP Test Artist "_$Random(9999), "Germany", 1975, "Created via SOAP")

    Write "Result: ", result, !
}

/// Оновлення художника
ClassMethod DemoUpdateArtist()
{
    Write !,"--- UpdateArtist (direct call) ---", !

    Set artistId = ""
    Set key = ""
    For {
        Set key = $Order(^Gallery.ArtistD(key))
        Quit:key=""
        If key["SOAP Test" {
            Set artistId = key
            Quit
        }
    }

    If artistId = "" {
        Write "No SOAP test artist found", !
        Quit
    }

    Set service = ##class(Gallery.SoapService).%New()
    Set result = service.UpdateArtist(artistId, "France", 1980)

    Write "Result: ", result, !
}

/// Видалення художника
ClassMethod DemoDeleteArtist()
{
    Write !,"--- DeleteArtist (direct call) ---", !

    Set artistId = ""
    Set key = ""
    For {
        Set key = $Order(^Gallery.ArtistD(key))
        Quit:key=""
        If key["SOAP Test" {
            Set artistId = key
            Quit
        }
    }

    If artistId = "" {
        Write "No SOAP test artist found to delete", !
        Quit
    }

    Set service = ##class(Gallery.SoapService).%New()
    Set result = service.DeleteArtist(artistId)

    Write "Result: ", result, !
}

}
