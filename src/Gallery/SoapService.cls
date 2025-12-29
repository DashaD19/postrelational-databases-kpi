/// SOAP веб-сервіс для роботи з художниками галереї
Class Gallery.SoapService Extends %SOAP.WebService
{

Parameter SERVICENAME = "GalleryArtistService";

Parameter NAMESPACE = "http://gallery.kpi.ua/soap";

Parameter USECLASSNAMESPACES = 1;

/// Отримання списку всіх художників
Method GetAllArtists() As %ListOfObjects(ELEMENTTYPE="Gallery.ArtistInfo") [ WebMethod ]
{
    Set resultList = ##class(%ListOfObjects).%New()

    Set key = ""
    For {
        Set key = $Order(^Gallery.ArtistD(key))
        Quit:key=""

        Set data = $Get(^Gallery.ArtistD(key))

        Set info = ##class(Gallery.ArtistInfo).%New()
        Set info.ArtistId = key
        Set info.FullName = key
        Set info.Country = $ListGet(data, 2)
        Set info.BirthYear = $ListGet(data, 3)

        Do resultList.Insert(info)
    }

    Quit resultList
}

/// Отримання художника за ID
Method GetArtist(ArtistId As %String) As Gallery.ArtistInfo [ WebMethod ]
{
    Set artist = ##class(Gallery.Artist).%OpenId(ArtistId)

    If '$IsObject(artist) {
        Quit ""
    }

    Set info = ##class(Gallery.ArtistInfo).%New()
    Set info.ArtistId = ArtistId
    Set info.FullName = artist.FullName
    Set info.Country = artist.Country
    Set info.BirthYear = artist.BirthYear

    If artist.Biography.Size > 0 {
        Set info.Biography = artist.Biography.Read()
    }

    Quit info
}

/// Створення нового художника
Method CreateArtist(FullName As %String, Country As %String, BirthYear As %Integer, Biography As %String) As %String [ WebMethod ]
{
    Set artist = ##class(Gallery.Artist).%New()
    Set artist.FullName = FullName
    Set artist.Country = Country
    Set artist.BirthYear = BirthYear

    If Biography '= "" {
        Do artist.Biography.Write(Biography)
    }

    Set status = artist.%Save()

    If $$$ISOK(status) {
        Quit "Created: " _ FullName
    } Else {
        Quit "Error: " _ $System.Status.GetErrorText(status)
    }
}

/// Оновлення художника
Method UpdateArtist(ArtistId As %String, Country As %String, BirthYear As %Integer) As %String [ WebMethod ]
{
    Set artist = ##class(Gallery.Artist).%OpenId(ArtistId)

    If '$IsObject(artist) {
        Quit "Error: Artist not found"
    }

    If Country '= "" {
        Set artist.Country = Country
    }
    If BirthYear > 0 {
        Set artist.BirthYear = BirthYear
    }

    Set status = artist.%Save()

    If $$$ISOK(status) {
        Quit "Updated: " _ ArtistId
    } Else {
        Quit "Error: " _ $System.Status.GetErrorText(status)
    }
}

/// Видалення художника
Method DeleteArtist(ArtistId As %String) As %String [ WebMethod ]
{
    Set status = ##class(Gallery.Artist).%DeleteId(ArtistId)

    If $$$ISOK(status) {
        Quit "Deleted: " _ ArtistId
    } Else {
        Quit "Error: " _ $System.Status.GetErrorText(status)
    }
}

}
