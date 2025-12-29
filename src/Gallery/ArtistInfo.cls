/// Клас для передачі інформації про художника через SOAP
Class Gallery.ArtistInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Property ArtistId As %String;

Property FullName As %String;

Property Country As %String;

Property BirthYear As %Integer;

Property Biography As %String(MAXLEN = 2000);

}
