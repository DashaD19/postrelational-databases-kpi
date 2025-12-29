/// Художник — автор творів мистецтва
Class Gallery.Artist Extends (Gallery.Person, %Persistent)
{

/// Повне ім'я художника (обов'язкове, унікальне)
Property FullName As %String(MAXLEN = 200) [ Required ];

/// Індекс для унікальності FullName
Index FullNameIndex On FullName [ Unique ];

/// Країна походження
Property Country As %String(MAXLEN = 100);

/// Рік народження
Property BirthYear As %Integer;

/// Біографія художника (потік символів)
Property Biography As %Stream.GlobalCharacter;

/// Відношення one-many: художник створює багато творів
Relationship Artworks As Gallery.Artwork [ Cardinality = many, Inverse = Artist ];

/// Отримати інформацію про художника
Method GetInfo() As %String
{
    Quit ..FullName _ " (" _ ..Country _ ", " _ ..BirthYear _ ")"
}

}
