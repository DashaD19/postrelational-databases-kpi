/// REST API для роботи з художниками галереї
Class Gallery.RestBroker Extends %CSP.REST
{

Parameter CONTENTTYPE = "application/json";

Parameter CHARSET = "utf-8";

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/artists" Method="GET" Call="GetAllArtists"/>
    <Route Url="/artist/:id" Method="GET" Call="GetArtist"/>
    <Route Url="/artist" Method="POST" Call="CreateArtist"/>
    <Route Url="/artist/:id" Method="PUT" Call="UpdateArtist"/>
    <Route Url="/artist/:id" Method="DELETE" Call="DeleteArtist"/>
</Routes>
}

/// Отримання списку всіх художників
ClassMethod GetAllArtists() As %Status
{
    Set array = []

    Set key = ""
    For {
        Set key = $Order(^Gallery.ArtistD(key))
        Quit:key=""

        Set data = $Get(^Gallery.ArtistD(key))
        Set artistObject = {}
        Set artistObject.id = key
        Set artistObject.fullName = key
        Set artistObject.country = $ListGet(data, 2)
        Set artistObject.birthYear = $ListGet(data, 3)

        Do array.%Push(artistObject)
    }

    Write array.%ToJSON()
    Quit $$$OK
}

/// Отримання художника за ID
ClassMethod GetArtist(artistId As %String) As %Status
{
    Set artist = ##class(Gallery.Artist).%OpenId(artistId)

    If '$IsObject(artist) {
        Set %response.Status = "404 Not Found"
        Write {"error": "Artist not found"}.%ToJSON()
        Quit $$$OK
    }

    Set result = {}
    Set result.id = artistId
    Set result.fullName = artist.FullName
    Set result.country = artist.Country
    Set result.birthYear = artist.BirthYear
    Set result.artworksCount = artist.ArtworksCount

    If artist.Biography.Size > 0 {
        Set result.biography = artist.Biography.Read()
    }

    Write result.%ToJSON()
    Quit $$$OK
}

/// Створення нового художника
ClassMethod CreateArtist() As %Status
{
    Set data = ##class(%DynamicObject).%FromJSON(%request.Content)

    Set artist = ##class(Gallery.Artist).%New()
    Set artist.FullName = data.fullName
    Set artist.Country = data.country
    Set artist.BirthYear = data.birthYear

    If data.biography '= "" {
        Do artist.Biography.Write(data.biography)
    }

    Set status = artist.%Save()

    If $$$ISERR(status) {
        Set %response.Status = "400 Bad Request"
        Set errorMsg = $System.Status.GetErrorText(status)
        Write {"error": (errorMsg)}.%ToJSON()
        Quit $$$OK
    }

    Set %response.Status = "201 Created"
    Set result = {}
    Set result.id = artist.FullName
    Set result.message = "Artist created successfully"
    Write result.%ToJSON()
    Quit $$$OK
}

/// Оновлення художника
ClassMethod UpdateArtist(artistId As %String) As %Status
{
    Set artist = ##class(Gallery.Artist).%OpenId(artistId)

    If '$IsObject(artist) {
        Set %response.Status = "404 Not Found"
        Write {"error": "Artist not found"}.%ToJSON()
        Quit $$$OK
    }

    Set data = ##class(%DynamicObject).%FromJSON(%request.Content)

    If data.country '= "" {
        Set artist.Country = data.country
    }
    If data.birthYear '= "" {
        Set artist.BirthYear = data.birthYear
    }
    If data.biography '= "" {
        Do artist.Biography.Clear()
        Do artist.Biography.Write(data.biography)
    }

    Set status = artist.%Save()

    If $$$ISERR(status) {
        Set %response.Status = "400 Bad Request"
        Set errorMsg = $System.Status.GetErrorText(status)
        Write {"error": (errorMsg)}.%ToJSON()
        Quit $$$OK
    }

    Set result = {}
    Set result.id = artistId
    Set result.message = "Artist updated successfully"
    Write result.%ToJSON()
    Quit $$$OK
}

/// Видалення художника
ClassMethod DeleteArtist(artistId As %String) As %Status
{
    Set status = ##class(Gallery.Artist).%DeleteId(artistId)

    If $$$ISERR(status) {
        Set %response.Status = "400 Bad Request"
        Set errorMsg = $System.Status.GetErrorText(status)
        Write {"error": (errorMsg)}.%ToJSON()
        Quit $$$OK
    }

    Set result = {}
    Set result.message = "Artist deleted successfully"
    Write result.%ToJSON()
    Quit $$$OK
}

}
