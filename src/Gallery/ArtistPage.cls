/// CSP сторінка для роботи з художниками (CRUD)
Class Gallery.ArtistPage Extends %CSP.Page
{

Parameter CONTENTTYPE = "text/html";

ClassMethod OnPage() As %Status
{
    Set action = %request.Get("action")
    Set artistId = %request.Get("id")

    &html<<!DOCTYPE html>
<html>
<head>
    <title>Галерея - Художники</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #fff8f0; }
        h1, h2 { color: #d35400; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #e67e22; padding: 10px; text-align: left; }
        th { background: #f39c12; color: white; }
        tr:hover { background: #fdebd0; }
        .btn { padding: 8px 16px; margin: 5px; cursor: pointer; border: none; border-radius: 4px; }
        .btn-primary { background: #e67e22; color: white; }
        .btn-danger { background: #c0392b; color: white; }
        .btn-secondary { background: #7f8c8d; color: white; }
        input, select { padding: 8px; margin: 5px 0; width: 300px; }
        .form-group { margin: 15px 0; }
        label { display: block; margin-bottom: 5px; color: #d35400; }
        .message { padding: 10px; margin: 10px 0; border-radius: 4px; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        a { color: #e67e22; }
    </style>
</head>
<body>>

    If action = "edit" {
        Do ..ShowEditForm(artistId)
    } ElseIf action = "new" {
        Do ..ShowNewForm()
    } ElseIf action = "save" {
        Do ..SaveArtist()
    } ElseIf action = "delete" {
        Do ..DeleteArtist(artistId)
    } ElseIf action = "view" {
        Do ..ShowArtistDetails(artistId)
    } Else {
        Do ..ShowArtistList()
    }

    &html<</body>
</html>>

    Quit $$$OK
}

/// Відображення списку всіх художників
ClassMethod ShowArtistList()
{
    &html<<h1>Художники галереї</h1>
    <a href="?action=new"><button class="btn btn-primary">Додати художника</button></a>
    <table>
        <tr>
            <th>ID</th>
            <th>Повне ім'я</th>
            <th>Країна</th>
            <th>Рік народження</th>
            <th>Дії</th>
        </tr>>

    Set key = ""
    For {
        Set key = $Order(^Gallery.ArtistD(key))
        Quit:key=""

        Set data = $Get(^Gallery.ArtistD(key))
        Set fullName = key
        Set country = $ListGet(data, 2)
        Set birthYear = $ListGet(data, 3)

        &html<<tr>
            <td>#(key)#</td>
            <td>#($ZConvert(fullName,"O","HTML"))#</td>
            <td>#($ZConvert(country,"O","HTML"))#</td>
            <td>#(birthYear)#</td>
            <td>
                <a href="?action=view&id=#($ZConvert(key,"O","URL"))#"><button class="btn btn-secondary">Переглянути</button></a>
                <a href="?action=edit&id=#($ZConvert(key,"O","URL"))#"><button class="btn btn-primary">Редагувати</button></a>
                <a href="?action=delete&id=#($ZConvert(key,"O","URL"))#" onclick="return confirm('Видалити цього художника?')"><button class="btn btn-danger">Видалити</button></a>
            </td>
        </tr>>
    }

    &html<</table>>
}

/// Відображення деталей художника
ClassMethod ShowArtistDetails(artistId As %String)
{
    &html<<h1>Деталі художника</h1>
    <a href="?"><button class="btn btn-secondary">Назад до списку</button></a>>

    Set artist = ##class(Gallery.Artist).%OpenId(artistId)
    If '$IsObject(artist) {
        &html<<div class="message error">Художника не знайдено</div>>
        Quit
    }

    &html<<div class="form-group">
        <label>ID:</label>
        <span>#($ZConvert(artistId,"O","HTML"))#</span>
    </div>
    <div class="form-group">
        <label>Повне ім'я:</label>
        <span>#($ZConvert(artist.FullName,"O","HTML"))#</span>
    </div>
    <div class="form-group">
        <label>Країна:</label>
        <span>#($ZConvert(artist.Country,"O","HTML"))#</span>
    </div>
    <div class="form-group">
        <label>Рік народження:</label>
        <span>#(artist.BirthYear)#</span>
    </div>
    <div class="form-group">
        <label>Кількість творів:</label>
        <span>#(artist.ArtworksCount)#</span>
    </div>>

    If artist.Biography.Size > 0 {
        &html<<div class="form-group">
            <label>Біографія:</label>
            <p>#($ZConvert(artist.Biography.Read(),"O","HTML"))#</p>
        </div>>
    }
}

/// Форма створення нового художника
ClassMethod ShowNewForm()
{
    &html<<h1>Новий художник</h1>
    <a href="?"><button class="btn btn-secondary">Назад до списку</button></a>
    <form method="post" action="?action=save">
        <div class="form-group">
            <label>Повне ім'я (обов'язково):</label>
            <input type="text" name="fullName" required>
        </div>
        <div class="form-group">
            <label>Країна:</label>
            <input type="text" name="country">
        </div>
        <div class="form-group">
            <label>Рік народження:</label>
            <input type="number" name="birthYear" min="1400" max="2024">
        </div>
        <div class="form-group">
            <label>Біографія:</label>
            <textarea name="biography" rows="4" style="width:300px;"></textarea>
        </div>
        <button type="submit" class="btn btn-primary">Зберегти</button>
    </form>>
}

/// Форма редагування художника
ClassMethod ShowEditForm(artistId As %String)
{
    Set artist = ##class(Gallery.Artist).%OpenId(artistId)
    If '$IsObject(artist) {
        &html<<div class="message error">Художника не знайдено</div>>
        Quit
    }

    Set bio = ""
    If artist.Biography.Size > 0 {
        Set bio = artist.Biography.Read()
    }

    &html<<h1>Редагування художника</h1>
    <a href="?"><button class="btn btn-secondary">Назад до списку</button></a>
    <form method="post" action="?action=save">
        <input type="hidden" name="originalId" value="#($ZConvert(artistId,"O","HTML"))#">
        <div class="form-group">
            <label>Повне ім'я (обов'язково):</label>
            <input type="text" name="fullName" value="#($ZConvert(artist.FullName,"O","HTML"))#" required>
        </div>
        <div class="form-group">
            <label>Країна:</label>
            <input type="text" name="country" value="#($ZConvert(artist.Country,"O","HTML"))#">
        </div>
        <div class="form-group">
            <label>Рік народження:</label>
            <input type="number" name="birthYear" value="#(artist.BirthYear)#" min="1400" max="2024">
        </div>
        <div class="form-group">
            <label>Біографія:</label>
            <textarea name="biography" rows="4" style="width:300px;">#($ZConvert(bio,"O","HTML"))#</textarea>
        </div>
        <button type="submit" class="btn btn-primary">Зберегти</button>
    </form>>
}

/// Збереження художника (створення або оновлення)
ClassMethod SaveArtist()
{
    Set fullName = %request.Get("fullName")
    Set country = %request.Get("country")
    Set birthYear = %request.Get("birthYear")
    Set biography = %request.Get("biography")
    Set originalId = %request.Get("originalId")

    If originalId '= "" {
        Set artist = ##class(Gallery.Artist).%OpenId(originalId)
        If '$IsObject(artist) {
            &html<<div class="message error">Художника не знайдено</div>>
            Quit
        }
    } Else {
        Set artist = ##class(Gallery.Artist).%New()
    }

    Set artist.FullName = fullName
    Set artist.Country = country
    Set artist.BirthYear = birthYear

    Do artist.Biography.Clear()
    If biography '= "" {
        Do artist.Biography.Write(biography)
    }

    Set status = artist.%Save()

    If $$$ISOK(status) {
        &html<<div class="message success">Художника збережено успішно!</div>>
    } Else {
        Set errorMsg = $System.Status.GetErrorText(status)
        &html<<div class="message error">Помилка: #($ZConvert(errorMsg,"O","HTML"))#</div>>
    }

    Do ..ShowArtistList()
}

/// Видалення художника
ClassMethod DeleteArtist(artistId As %String)
{
    Set status = ##class(Gallery.Artist).%DeleteId(artistId)

    If $$$ISOK(status) {
        &html<<div class="message success">Художника видалено!</div>>
    } Else {
        Set errorMsg = $System.Status.GetErrorText(status)
        &html<<div class="message error">Помилка: #($ZConvert(errorMsg,"O","HTML"))#</div>>
    }

    Do ..ShowArtistList()
}

}
