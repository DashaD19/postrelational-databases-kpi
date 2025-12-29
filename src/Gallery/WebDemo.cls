/// Демонстрація веб-функціональності галереї
Class Gallery.WebDemo Extends %RegisteredObject
{

/// Запуск повної демонстрації REST та SOAP
ClassMethod Run()
{
    Write "============================================", !
    Write "    Web Demo - Gallery (PR7)", !
    Write "============================================", !

    Write !, "REST Client Demo:", !
    Do ##class(Gallery.RestClient).RunDemo()

    Write !, "SOAP Client Demo:", !
    Do ##class(Gallery.SoapClient).RunDemo()

    Write !, "============================================", !
    Write "Demo completed!", !
    Write !, "CSP Page available at:", !
    Write "http://localhost:52773/csp/user/Gallery.ArtistPage.cls", !
    Write !, "REST API available at:", !
    Write "http://localhost:52773/gallery/api/artists", !
    Write !, "SOAP WSDL available at:", !
    Write "http://localhost:52773/csp/user/Gallery.SoapService.cls?WSDL", !
    Write "============================================", !
}

/// Показати інструкції з налаштування
ClassMethod ShowSetup()
{
    Write "============================================", !
    Write "    Setup Instructions", !
    Write "============================================", !
    Write !, "1. Configure REST application in System Management Portal:", !
    Write "   - Go to: System Administration > Security > Applications > Web Applications", !
    Write "   - Create new application: /gallery/api", !
    Write "   - Dispatch Class: Gallery.RestBroker", !
    Write "   - Check 'Enable Application'", !
    Write !, "2. CSP pages are automatically available at:", !
    Write "   http://localhost:52773/csp/user/Gallery.ArtistPage.cls", !
    Write !, "3. SOAP service is automatically available after compilation at:", !
    Write "   http://localhost:52773/csp/user/Gallery.SoapService.cls", !
    Write "============================================", !
}

}
