/// Експонат виставки (залежний від Exhibition)
Class Gallery.Exhibit Extends (%Persistent, %Populate)
{

/// Позиція експоната на виставці
Property Position As %Integer(POPSPEC = "Integer(1,100)");

/// Примітки для показу
Property DisplayNotes As %String(MAXLEN = 500, POPSPEC = "String(10)");

/// Колекція-список тегів
Property Tags As list Of %String;

/// Посилання на твір мистецтва
Property Artwork As Gallery.Artwork;

/// Відношення parent-children: експонат належить виставці
Relationship Exhibition As Gallery.Exhibition [ Cardinality = parent, Inverse = Exhibits ];

/// Генерація списку тегів для %Populate
Method TagsPopulate() As %Status
{
    Set tagList = $ListBuild("модерн", "класика", "авангард", "імпресіонізм", "реалізм")
    Set numTags = $Random(3) + 1
    For i = 1:1:numTags {
        Set tagIndex = $Random($ListLength(tagList)) + 1
        Do ..Tags.Insert($List(tagList, tagIndex))
    }
    Quit $$$OK
}

/// Генерація посилання на Artwork для %Populate
Method ArtworkPopulate() As %Status
{
    Set count = 0
    &sql(SELECT COUNT(*) INTO :count FROM Gallery.Artwork)
    If count > 0 {
        Set artworkId = $Random(count) + 1
        Do ..ArtworkSetObjectId(artworkId)
    }
    Quit $$$OK
}

}
