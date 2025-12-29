/// Твір мистецтва
Class Gallery.Artwork Extends (%Persistent, %Populate)
{

/// Назва твору (обов'язкова)
Property Title As %String(MAXLEN = 200, POPSPEC = "Mission()") [ Required ];

/// Рік створення (обмеження: від 1000 до 2100)
Property CreationYear As %Integer(MAXVAL = 2100, MINVAL = 1000, POPSPEC = "Integer(1000,2100)");

/// Техніка виконання
Property Technique As %String(MAXLEN = 100, POPSPEC = "String(2)");

/// Розміри твору
Property Dimensions As %String(MAXLEN = 50, POPSPEC = "String(2)");

/// Колекція-масив оцінок (ключ — ім'я критика, значення — оцінка)
Property Ratings As array Of %Integer;

/// Відношення one-many: твір належить художнику
Relationship Artist As Gallery.Artist [ Cardinality = one, Inverse = Artworks ];

/// Індекс для відношення з Artist
Index ArtistIndex On Artist;

/// Генерація масиву оцінок для %Populate
Method RatingsPopulate() As %Status
{
    Set critics = $ListBuild("Критик1", "Критик2", "Критик3")
    For i = 1:1:$ListLength(critics) {
        Do ..Ratings.SetAt($Random(10) + 1, $List(critics, i))
    }
    Quit $$$OK
}

/// Генерація посилання на Artist для %Populate
Method ArtistPopulate() As %Status
{
    Set count = 0
    &sql(SELECT COUNT(*) INTO :count FROM Gallery.Artist)
    If count > 0 {
        &sql(SELECT TOP 1 %ID INTO :artistId FROM Gallery.Artist ORDER BY NEWID())
        Do ..ArtistSetObjectId(artistId)
    }
    Quit $$$OK
}

/// SQL-запит: отримати всі твори
Query GetAllArtworks() As %SQLQuery(CONTAINID = 1)
{
    SELECT %ID, Title, CreationYear, Technique
    FROM Gallery.Artwork
    ORDER BY CreationYear DESC
}

/// SQL-запит з параметром: твори за роком
Query GetArtworksByYear(minYear As %Integer) As %SQLQuery(CONTAINID = 1)
{
    SELECT %ID, Title, CreationYear, Artist
    FROM Gallery.Artwork
    WHERE CreationYear >= :minYear
    ORDER BY CreationYear
}

/// SQL-запит з implicit join: твори з ім'ям художника
Query GetArtworksWithArtistName() As %SQLQuery(CONTAINID = 1)
{
    SELECT %ID, Title, CreationYear, Artist->FullName As ArtistName
    FROM Gallery.Artwork
    ORDER BY Artist->FullName
}

}
