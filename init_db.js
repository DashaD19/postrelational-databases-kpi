// MongoDB init script for Gallery database
// Variant 2: Style A (camelCase, descriptive)

use gallery_db

// Drop existing collections
db.artists.drop()
db.artworks.drop()
db.exhibitions.drop()

// ===== NORMALIZED MODEL: Artists =====
// One-many relationship: Artist -> Artworks (via reference)

db.artists.insertMany([
    {
        _id: "artist_1",
        fullName: "Leonardo da Vinci",
        country: "Italy",
        birthYear: 1452,
        biography: "Italian Renaissance polymath, painter, sculptor, architect, and inventor."
    },
    {
        _id: "artist_2",
        fullName: "Vincent van Gogh",
        country: "Netherlands",
        birthYear: 1853,
        biography: "Dutch Post-Impressionist painter known for bold colors and emotional honesty."
    },
    {
        _id: "artist_3",
        fullName: "Pablo Picasso",
        country: "Spain",
        birthYear: 1881,
        biography: "Spanish painter and sculptor, co-founder of Cubism movement."
    },
    {
        _id: "artist_4",
        fullName: "Claude Monet",
        country: "France",
        birthYear: 1840,
        biography: "French Impressionist painter, founder of the Impressionist movement."
    }
])

// ===== NORMALIZED MODEL: Artworks =====
// References artistId for one-many relationship

db.artworks.insertMany([
    {
        _id: "artwork_1",
        title: "Mona Lisa",
        creationYear: 1503,
        technique: "Oil on panel",
        dimensions: "77x53 cm",
        artistId: "artist_1",
        ratings: { "CriticA": 10, "CriticB": 9, "CriticC": 10 }
    },
    {
        _id: "artwork_2",
        title: "The Last Supper",
        creationYear: 1498,
        technique: "Tempera on gesso",
        dimensions: "460x880 cm",
        artistId: "artist_1",
        ratings: { "CriticA": 9, "CriticB": 10 }
    },
    {
        _id: "artwork_3",
        title: "Starry Night",
        creationYear: 1889,
        technique: "Oil on canvas",
        dimensions: "73.7x92.1 cm",
        artistId: "artist_2",
        ratings: { "CriticA": 10, "CriticB": 10, "CriticC": 9 }
    },
    {
        _id: "artwork_4",
        title: "Guernica",
        creationYear: 1937,
        technique: "Oil on canvas",
        dimensions: "349x776 cm",
        artistId: "artist_3",
        ratings: { "CriticA": 10, "CriticB": 9 }
    },
    {
        _id: "artwork_5",
        title: "Water Lilies",
        creationYear: 1906,
        technique: "Oil on canvas",
        dimensions: "89x93 cm",
        artistId: "artist_4",
        ratings: { "CriticA": 9, "CriticB": 8 }
    }
])

// ===== EMBEDDED MODEL: Exhibitions with Exhibits =====
// Parent-children: Exhibition contains Exhibits array
// Embedded object: Location

db.exhibitions.insertMany([
    {
        _id: "exhibition_1",
        title: "Renaissance Masters",
        startDate: new Date("2024-01-15"),
        endDate: new Date("2024-04-15"),
        location: {
            building: "National Gallery",
            hall: "Hall A",
            floor: 1
        },
        exhibits: [
            { position: 1, artworkId: "artwork_1", description: "Masterpiece of portrait painting" },
            { position: 2, artworkId: "artwork_2", description: "Religious art at its finest" }
        ]
    },
    {
        _id: "exhibition_2",
        title: "Impressionism Journey",
        startDate: new Date("2024-03-01"),
        endDate: new Date("2024-06-30"),
        location: {
            building: "Modern Art Museum",
            hall: "Hall B",
            floor: 2
        },
        exhibits: [
            { position: 1, artworkId: "artwork_3", description: "Iconic night sky painting" },
            { position: 2, artworkId: "artwork_5", description: "Beautiful garden series" }
        ]
    },
    {
        _id: "exhibition_3",
        title: "20th Century Art",
        startDate: new Date("2024-05-01"),
        endDate: new Date("2024-08-31"),
        location: {
            building: "City Art Center",
            hall: "Main Hall",
            floor: 1
        },
        exhibits: [
            { position: 1, artworkId: "artwork_4", description: "Anti-war statement masterpiece" }
        ]
    },
    {
        _id: "exhibition_4",
        title: "Dutch Golden Age",
        startDate: new Date("2024-09-01"),
        endDate: new Date("2024-12-15"),
        location: {
            building: "National Gallery",
            hall: "Hall C",
            floor: 3
        },
        exhibits: [
            { position: 1, artworkId: "artwork_3", description: "Van Gogh retrospective" }
        ]
    }
])

print("Gallery database initialized successfully!")
print("Collections: artists (4), artworks (5), exhibitions (4)")
