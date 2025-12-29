import com.mongodb.client.*;
import com.mongodb.client.model.*;
import org.bson.Document;
import org.bson.conversions.Bson;

import java.util.Arrays;
import java.util.List;

/**
 * MongoDB application for Gallery database.
 * Demonstrates: document retrieval, key-value queries, and aggregation pipeline.
 * Variant 2: Style A (camelCase, descriptive names)
 */
public class GalleryMongoApp {

    private static final String CONNECTION_STRING = "mongodb://localhost:27017";
    private static final String DATABASE_NAME = "gallery_db";

    private MongoClient mongoClient;
    private MongoDatabase database;

    public static void main(String[] args) {
        GalleryMongoApp application = new GalleryMongoApp();
        application.run();
    }

    /**
     * Main execution method
     */
    public void run() {
        System.out.println("========================================");
        System.out.println("  Gallery MongoDB Application (PR8)");
        System.out.println("========================================\n");

        try {
            connectToDatabase();

            displayAllDocuments();
            executeKeyValueQuery();
            executeAggregationPipeline();

        } catch (Exception exception) {
            System.err.println("Error: " + exception.getMessage());
            exception.printStackTrace();
        } finally {
            closeConnection();
        }

        System.out.println("\n========================================");
        System.out.println("  Application completed successfully");
        System.out.println("========================================");
    }

    /**
     * Establishes connection to MongoDB
     */
    private void connectToDatabase() {
        System.out.println("Connecting to MongoDB...");
        mongoClient = MongoClients.create(CONNECTION_STRING);
        database = mongoClient.getDatabase(DATABASE_NAME);
        System.out.println("Connected to database: " + DATABASE_NAME + "\n");
    }

    /**
     * Closes the database connection
     */
    private void closeConnection() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("\nConnection closed.");
        }
    }

    /**
     * Displays all documents from all collections
     */
    private void displayAllDocuments() {
        System.out.println("--- ALL DOCUMENTS ---\n");

        displayCollection("artists");
        displayCollection("artworks");
        displayCollection("exhibitions");
    }

    /**
     * Helper method to display all documents in a collection
     */
    private void displayCollection(String collectionName) {
        System.out.println("Collection: " + collectionName);
        System.out.println("-".repeat(40));

        MongoCollection<Document> collection = database.getCollection(collectionName);

        try (MongoCursor<Document> cursor = collection.find().iterator()) {
            int documentCount = 0;
            while (cursor.hasNext()) {
                Document document = cursor.next();
                System.out.println(document.toJson());
                documentCount++;
            }
            System.out.println("Total documents: " + documentCount + "\n");
        }
    }

    /**
     * Executes key-value query with multiple conditions
     * Query: Find artworks created after 1850 with technique 'Oil on canvas'
     */
    private void executeKeyValueQuery() {
        System.out.println("--- KEY-VALUE QUERY ---");
        System.out.println("Query: Artworks created after 1850 with technique 'Oil on canvas'\n");

        MongoCollection<Document> artworksCollection = database.getCollection("artworks");

        // Query with 2 conditions: creationYear > 1850 AND technique = "Oil on canvas"
        Bson queryFilter = Filters.and(
            Filters.gt("creationYear", 1850),
            Filters.eq("technique", "Oil on canvas")
        );

        System.out.println("Results:");
        System.out.println("-".repeat(40));

        try (MongoCursor<Document> cursor = artworksCollection.find(queryFilter).iterator()) {
            int resultCount = 0;
            while (cursor.hasNext()) {
                Document artwork = cursor.next();
                System.out.println("Title: " + artwork.getString("title"));
                System.out.println("Year: " + artwork.getInteger("creationYear"));
                System.out.println("Technique: " + artwork.getString("technique"));
                System.out.println("Dimensions: " + artwork.getString("dimensions"));
                System.out.println();
                resultCount++;
            }
            System.out.println("Found " + resultCount + " artworks matching criteria.\n");
        }
    }

    /**
     * Executes aggregation pipeline with 4+ stages including $lookup and $group
     * Pipeline: Join artworks with artists, group by country, calculate average year
     */
    private void executeAggregationPipeline() {
        System.out.println("--- AGGREGATION PIPELINE ---");
        System.out.println("Pipeline: Join artworks with artists, group by country,");
        System.out.println("          count artworks and calculate average creation year\n");

        MongoCollection<Document> artworksCollection = database.getCollection("artworks");

        List<Bson> aggregationPipeline = Arrays.asList(
            // Stage 1: $lookup - Join with artists collection
            Aggregates.lookup(
                "artists",          // from collection
                "artistId",         // local field
                "_id",              // foreign field
                "artistInfo"        // output array field
            ),

            // Stage 2: $unwind - Flatten the artistInfo array
            Aggregates.unwind("$artistInfo"),

            // Stage 3: $group - Group by artist's country
            Aggregates.group(
                "$artistInfo.country",
                Accumulators.sum("artworkCount", 1),
                Accumulators.avg("averageCreationYear", "$creationYear"),
                Accumulators.push("artworkTitles", "$title")
            ),

            // Stage 4: $sort - Sort by artwork count descending
            Aggregates.sort(Sorts.descending("artworkCount")),

            // Stage 5: $project - Format output
            Aggregates.project(
                Projections.fields(
                    Projections.computed("country", "$_id"),
                    Projections.include("artworkCount", "averageCreationYear", "artworkTitles"),
                    Projections.excludeId()
                )
            )
        );

        System.out.println("Pipeline stages: $lookup -> $unwind -> $group -> $sort -> $project");
        System.out.println("\nResults:");
        System.out.println("-".repeat(40));

        try (MongoCursor<Document> cursor = artworksCollection.aggregate(aggregationPipeline).iterator()) {
            while (cursor.hasNext()) {
                Document result = cursor.next();
                System.out.println("Country: " + result.getString("country"));
                System.out.println("Artwork Count: " + result.getInteger("artworkCount"));
                System.out.println("Average Creation Year: " +
                    String.format("%.0f", result.getDouble("averageCreationYear")));
                System.out.println("Artworks: " + result.getList("artworkTitles", String.class));
                System.out.println();
            }
        }
    }
}
