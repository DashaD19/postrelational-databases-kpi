/// Твір мистецтва
Class Gallery.Artwork Extends %Persistent
{

/// Інвентарний номер (обов'язковий, унікальний)
Property InventoryNumber As %String(MAXLEN = 50) [ Required ];

/// Індекс для унікальності інвентарного номера
Index InventoryNumberIndex On InventoryNumber [ Unique ];

/// Назва твору (обов'язкова)
Property Title As %String(MAXLEN = 200) [ Required ];

/// Рік створення (обмеження: від 1000 до 2100)
Property CreationYear As %Integer(MAXVAL = 2100, MINVAL = 1000);

/// Техніка виконання
Property Technique As %String(MAXLEN = 100);

/// Розміри твору
Property Dimensions As %String(MAXLEN = 50);

/// Колекція-масив оцінок (ключ — ім'я критика, значення — оцінка)
Property Ratings As array Of %Integer;

/// Відношення one-many: твір належить художнику
Relationship Artist As Gallery.Artist [ Cardinality = one, Inverse = Artworks ];

/// Індекс для відношення з Artist
Index ArtistIndex On Artist;

}
