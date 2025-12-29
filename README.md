# Лабораторна 7: Web-інтерфейси

Предметна область: Галерея/Музей

Три підходи до створення веб-інтерфейсів в IRIS: CSP-сторінки для серверного рендерингу, REST API для сучасних клієнтів, SOAP веб-сервіс для інтеграції з корпоративними системами.

## CSP (Caché Server Pages)

`ArtistPage.cls` реалізує повний CRUD для художників. Сторінка генерується на сервері, HTML формується в методі `OnPage()`.

**Прямий доступ до глобалу** — список художників читається через `$Order` по `^Gallery.ArtistD`, минаючи об'єктний шар. Це швидше для простого відображення списків, хоча менш безпечно.

```objectscript
Set id = ""
For {
    Set id = $Order(^Gallery.ArtistD(id))
    Quit:id=""
    Set data = ^Gallery.ArtistD(id)
    // render row
}
```

**Форма редагування** — при отриманні параметра `?id=N` завантажує об'єкт через `##class(Gallery.Artist).%OpenId(id)` та заповнює поля форми. Збереження через `%Save()`.

![Список художників](img/1.png)

![Форма редагування](img/2.png)

## REST API

`RestBroker.cls` extends `%CSP.REST` з маршрутизацією через UrlMap:

| Метод | Endpoint | Опис |
|-------|----------|------|
| GET | /artists | Список всіх художників (JSON) |
| GET | /artist/:id | Художник за ID |
| POST | /artist | Створення нового художника |
| PUT | /artist/:id | Оновлення існуючого |
| DELETE | /artist/:id | Видалення |

Відповіді у форматі JSON через `%JSONExport()` для об'єктів. `RestClient.cls` демонструє виклики через `%Net.HttpRequest`.

## SOAP веб-сервіс

`SoapService.cls` extends `%SOAP.WebService` з методами:

- `GetAllArtists()` — повертає масив `ArtistInfo`
- `GetArtist(id)` — один художник
- `CreateArtist(info)` — створення
- `UpdateArtist(id, info)` — оновлення
- `DeleteArtist(id)` — видалення

`ArtistInfo.cls` — DTO-клас для серіалізації даних художника у SOAP-повідомлення. WSDL генерується автоматично за адресою `/csp/user/Gallery.SoapService.cls?WSDL`.

`SoapClient.cls` викликає сервіс через згенерований проксі-клас.

![REST та SOAP клієнти](img/3.png)
