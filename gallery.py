"""
Практикум 1: Демонстрація концепцій ООП
Предметна область: Галерея/Музей
"""

from abc import ABC, abstractmethod
from typing import List


class Artist:
    """Клас, що представляє художника."""

    def __init__(self, fullName: str, birthYear: int, country: str):
        self.fullName = fullName
        self.birthYear = birthYear
        self.country = country

    def getBio(self) -> str:
        return f"{self.fullName} ({self.birthYear}), {self.country}"


class ArtObject(ABC):
    """Абстрактний клас художнього об'єкта."""

    def __init__(self, title: str, creationYear: int, artist: Artist):
        self.title = title
        self.creationYear = creationYear
        self.artist = artist  # посилання на об'єкт Artist
        self._estimatedPrice: float = 0.0  # приватна властивість

    @abstractmethod
    def getDescription(self) -> str:
        """Абстрактний метод для отримання опису."""
        pass

    def setEstimatedPrice(self, price: float) -> None:
        """Публічний метод для встановлення ціни через приватну властивість."""
        if self._validatePrice(price):
            self._estimatedPrice = price

    def getEstimatedPrice(self) -> float:
        return self._estimatedPrice

    def _validatePrice(self, price: float) -> bool:
        """Приватний метод валідації ціни."""
        return price >= 0

    def getInfo(self) -> str:
        """Базова реалізація методу отримання інформації."""
        return f"{self.title} ({self.creationYear}) - {self.artist.fullName}"


class Painting(ArtObject):
    """Клас картини, успадкований від ArtObject."""

    def __init__(self, title: str, creationYear: int, artist: Artist,
                 technique: str, dimensions: List[int]):
        super().__init__(title, creationYear, artist)
        self.technique = technique  # олія, акварель тощо
        self.dimensions = dimensions  # масив [ширина, висота] в см

    def getDescription(self) -> str:
        """Перевантажений абстрактний метод."""
        width, height = self.dimensions
        return (f"Картина '{self.title}' ({self.technique}), "
                f"{width}x{height} см, {self.creationYear} р.")

    def getInfo(self) -> str:
        """Перевантаження методу базового класу."""
        baseInfo = super().getInfo()
        return f"{baseInfo}, техніка: {self.technique}"


class Sculpture(ArtObject):
    """Клас скульптури, успадкований від ArtObject."""

    def __init__(self, title: str, creationYear: int, artist: Artist,
                 material: str, weightKg: float):
        super().__init__(title, creationYear, artist)
        self.material = material
        self.weightKg = weightKg

    def getDescription(self) -> str:
        """Перевантажений абстрактний метод."""
        return (f"Скульптура '{self.title}' ({self.material}), "
                f"{self.weightKg} кг, {self.creationYear} р.")

    def getInfo(self) -> str:
        """Перевантаження методу базового класу."""
        baseInfo = super().getInfo()
        return f"{baseInfo}, матеріал: {self.material}"


class Exhibition:
    """Клас виставки, що містить колекцію експонатів."""

    def __init__(self, exhibitionName: str, startDate: str):
        self.exhibitionName = exhibitionName
        self.startDate = startDate
        self._exhibits: List[ArtObject] = []  # приватний масив експонатів
        self.visitorComments: List[str] = []  # публічний масив коментарів

    def addExhibit(self, exhibit: ArtObject) -> None:
        self._exhibits.append(exhibit)

    def getExhibits(self) -> List[ArtObject]:
        return self._exhibits.copy()

    def getExhibitCount(self) -> int:
        return len(self._exhibits)

    def addComment(self, comment: str) -> None:
        self.visitorComments.append(comment)

    def getTotalEstimatedValue(self) -> float:
        """Обчислює загальну оціночну вартість виставки."""
        return sum(exhibit.getEstimatedPrice() for exhibit in self._exhibits)


if __name__ == "__main__":
    # Створення художників
    picasso = Artist("Пабло Пікассо", 1881, "Іспанія")
    rodin = Artist("Огюст Роден", 1840, "Франція")
    shevchenko = Artist("Тарас Шевченко", 1814, "Україна")

    print("=== Художники ===")
    print(picasso.getBio())
    print(rodin.getBio())
    print(shevchenko.getBio())

    # Створення картин
    guernica = Painting(
        title="Герніка",
        creationYear=1937,
        artist=picasso,
        technique="олія на полотні",
        dimensions=[776, 349]
    )
    guernica.setEstimatedPrice(200_000_000)

    kateryna = Painting(
        title="Катерина",
        creationYear=1842,
        artist=shevchenko,
        technique="олія на полотні",
        dimensions=[93, 72]
    )
    kateryna.setEstimatedPrice(50_000_000)

    print("\n=== Картини ===")
    print(guernica.getDescription())
    print(f"  Інформація: {guernica.getInfo()}")
    print(f"  Оціночна вартість: ${guernica.getEstimatedPrice():,.0f}")

    print(kateryna.getDescription())
    print(f"  Інформація: {kateryna.getInfo()}")
    print(f"  Оціночна вартість: ${kateryna.getEstimatedPrice():,.0f}")

    # Створення скульптур
    thinker = Sculpture(
        title="Мислитель",
        creationYear=1904,
        artist=rodin,
        material="бронза",
        weightKg=680.0
    )
    thinker.setEstimatedPrice(15_000_000)

    kiss = Sculpture(
        title="Поцілунок",
        creationYear=1889,
        artist=rodin,
        material="мармур",
        weightKg=1200.0
    )
    kiss.setEstimatedPrice(25_000_000)

    print("\n=== Скульптури ===")
    print(thinker.getDescription())
    print(f"  Інформація: {thinker.getInfo()}")
    print(f"  Оціночна вартість: ${thinker.getEstimatedPrice():,.0f}")

    print(kiss.getDescription())
    print(f"  Інформація: {kiss.getInfo()}")
    print(f"  Оціночна вартість: ${kiss.getEstimatedPrice():,.0f}")

    # Створення виставки
    mainExhibition = Exhibition(
        exhibitionName="Шедеври світового мистецтва",
        startDate="2024-01-15"
    )

    # Додавання експонатів до виставки
    mainExhibition.addExhibit(guernica)
    mainExhibition.addExhibit(kateryna)
    mainExhibition.addExhibit(thinker)
    mainExhibition.addExhibit(kiss)

    # Додавання коментарів відвідувачів
    mainExhibition.addComment("Чудова виставка!")
    mainExhibition.addComment("Вражаюча колекція")

    print("\n=== Виставка ===")
    print(f"Назва: {mainExhibition.exhibitionName}")
    print(f"Дата відкриття: {mainExhibition.startDate}")
    print(f"Кількість експонатів: {mainExhibition.getExhibitCount()}")
    print(f"Загальна оціночна вартість: ${mainExhibition.getTotalEstimatedValue():,.0f}")

    print("\nЕкспонати:")
    for exhibit in mainExhibition.getExhibits():
        print(f"  - {exhibit.getDescription()}")

    print("\nКоментарі відвідувачів:")
    for comment in mainExhibition.visitorComments:
        print(f"  - {comment}")

    # Демонстрація поліморфізму
    print("\n=== Демонстрація поліморфізму ===")
    allArtObjects: List[ArtObject] = [guernica, kateryna, thinker, kiss]
    for artObject in allArtObjects:
        print(artObject.getDescription())
