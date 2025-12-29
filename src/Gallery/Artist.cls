/// Художник — автор творів мистецтва
Class Gallery.Artist Extends (Gallery.Person, %Persistent, %Populate)
{

/// Повне ім'я художника (обов'язкове, унікальне, використовується як IDKEY)
Property FullName As %String(MAXLEN = 200, POPSPEC = "Name()") [ Required ];

/// Індекс IDKEY для унікальності FullName
Index FullNameIndex On FullName [ IdKey, Unique ];

/// Країна походження
Property Country As %String(MAXLEN = 100, POPSPEC = "USState()");

/// Рік народження
Property BirthYear As %Integer(POPSPEC = "Integer(1400,2000)");

/// Біографія художника (потік символів)
Property Biography As %Stream.GlobalCharacter;

/// Відношення one-many: художник створює багато творів
Relationship Artworks As Gallery.Artwork [ Cardinality = many, Inverse = Artist ];

/// Кількість творів художника (обчислювана властивість)
Property ArtworksCount As %Integer [ Calculated, SqlComputeCode = {set {ArtworksCount} = ##class(Gallery.Artist).CalcArtworksCount({%%ID})}, SqlComputed ];

/// Розрахунок кількості творів
ClassMethod CalcArtworksCount(artistId As %String) As %Integer
{
    Set count = 0
    &sql(SELECT COUNT(*) INTO :count FROM Gallery.Artwork WHERE Artist = :artistId)
    Quit count
}

/// Метод для отримання кількості творів (getter для Calculated)
Method ArtworksCountGet() As %Integer
{
    Quit ##class(Gallery.Artist).CalcArtworksCount(..%Id())
}

/// Генерація біографії для %Populate
Method BiographyPopulate() As %Status
{
    Do ..Biography.WriteLine(##class(%PopulateUtils).String(50))
    Do ..Biography.WriteLine(##class(%PopulateUtils).String(50))
    Quit $$$OK
}

/// Отримати інформацію про художника
Method GetInfo() As %String
{
    Quit ..FullName _ " (" _ ..Country _ ", " _ ..BirthYear _ ")"
}

/// SQL-запит: отримати всіх художників
Query GetAllArtists() As %SQLQuery(CONTAINID = 1)
{
    SELECT %ID, FullName, Country, BirthYear
    FROM Gallery.Artist
    ORDER BY FullName
}

/// SQL-запит з параметром: художники за країною
Query GetArtistsByCountry(countryName As %String) As %SQLQuery(CONTAINID = 1)
{
    SELECT %ID, FullName, Country, BirthYear
    FROM Gallery.Artist
    WHERE Country = :countryName
    ORDER BY FullName
}

/// Тригер: логування змін художників
Trigger LogArtistChanges [ Event = INSERT/UPDATE, Foreach = row/object, Time = AFTER ]
{
    Set ^GalleryLog("Artist", {%%ID}, {%%OPERATION}, $H) = {FullName}
}

}
