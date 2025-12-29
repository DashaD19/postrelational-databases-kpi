# Лабораторна 5: Методи та Unit-тести

Предметна область: Галерея/Музей

Розширення класів з ПР4 обчислюваними властивостями, автогенерацією тестових даних через %Populate та модульними тестами для перевірки бізнес-логіки.

## Обчислювана властивість

`Artist.ArtworksCount` — динамічна властивість, яка підраховує твори художника через SQL-підзапит. Getter-метод `ArtworksCountGet()` виконує `SELECT COUNT(*)` щоразу при читанні, тому результат завжди актуальний без потреби в синхронізації.

```objectscript
Property ArtworksCount As %Integer [ Calculated, SqlComputed ];

Method ArtworksCountGet() As %Integer
{
    Quit ##class(Gallery.Artist).CalcArtworksCount(..%Id())
}

ClassMethod CalcArtworksCount(artistId As %String) As %Integer
{
    Set count = 0
    &sql(SELECT COUNT(*) INTO :count FROM Gallery.Artwork WHERE Artist = :artistId)
    Quit count
}
```

![Демонстрація ArtworksCount](img/1.png)

## Автогенерація даних

Класи розширені суперкласом `%Populate` та POPSPEC параметрами для генерації реалістичних тестових даних.

| Клас | POPSPEC | Методи *Populate() |
|------|---------|-------------------|
| Artist | FullName=Name(), Country=USState() | BiographyPopulate() для потоку |
| Artwork | Title, CreationYear=Integer(1400,2024) | RatingsPopulate(), ArtistPopulate() |
| Exhibition | Title, StartDate, EndDate | LocationPopulate() для embedded |
| Exhibit | Position, DisplayNotes | TagsPopulate(), ArtworkPopulate() |

Кастомні методи *Populate() потрібні для властивостей, які %Populate не вміє генерувати автоматично: потоки, колекції, відношення.

```objectscript
Do ##class(Gallery.Artist).Populate(5)
```

![Результат генерації](img/2.png)

## Unit-тести

Клас `Gallery.Tests` extends `%UnitTest.TestCase` містить 9 тестів:

**Створення об'єктів** — перевірка що Artist, Artwork, Exhibition створюються та зберігаються без помилок.

**Унікальність** — спроба створити другого Artist з тим же FullName або Artwork з тим же InventoryNumber має повертати помилку.

**Обов'язкові властивості** — збереження без Required властивостей має провалюватись.

**Відношення** — перевірка що Artwork.Artist посилається на реального Artist, Exhibit.Exhibition на реальну Exhibition.

**Каскадне видалення** — при видаленні Exhibition всі Exhibit видаляються автоматично.

**Заборона видалення parent** — неможливо видалити Exhibition поки є Exhibit (перевіряється через налаштування відношення).

```objectscript
Do ##class(Gallery.RunTests).QuickTest()
```

![Результати тестів](img/3.png)
