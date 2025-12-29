/// Експонат виставки (залежний від Exhibition)
Class Gallery.Exhibit Extends %Persistent
{

/// Позиція експоната на виставці
Property Position As %Integer;

/// Примітки для показу
Property DisplayNotes As %String(MAXLEN = 500);

/// Колекція-список тегів
Property Tags As list Of %String;

/// Посилання на твір мистецтва
Property Artwork As Gallery.Artwork;

/// Відношення parent-children: експонат належить виставці
Relationship Exhibition As Gallery.Exhibition [ Cardinality = parent, Inverse = Exhibits ];

}
