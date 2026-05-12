// 05-02. Cypher 첫걸음 - 읽기
// Source: https://wikidocs.net/319215
// Assumes the Neo4j movie sample data is loaded via Neo4j Browser's :play movies guide.

// 1. See a few nodes, regardless of label.
MATCH (n)
RETURN n
LIMIT 10;

// 2. Read Person nodes as table data.
MATCH (person:Person)
RETURN person.name AS name, person.born AS born
ORDER BY name
LIMIT 10;

// 3. Read Movie nodes released after 2000.
MATCH (movie:Movie)
WHERE movie.released >= 2000
RETURN movie.title AS title, movie.released AS released
ORDER BY released, title
LIMIT 20;

// 4. Search by property value.
MATCH (person:Person {name: "Tom Hanks"})
RETURN person.name AS name, person.born AS born;

// 5. Search by string containment.
MATCH (person:Person)
WHERE person.name CONTAINS "Tom"
RETURN person.name AS name
ORDER BY name;

// 6. Follow a directed relationship from actor to movie.
MATCH (actor:Person)-[:ACTED_IN]->(movie:Movie)
RETURN actor.name AS actor, movie.title AS movie
ORDER BY actor, movie
LIMIT 15;

// 7. Store the relationship in a variable and inspect its type/properties.
MATCH (actor:Person)-[relationship:ACTED_IN]->(movie:Movie)
RETURN actor.name AS actor,
       type(relationship) AS relationshipType,
       relationship.roles AS roles,
       movie.title AS movie
LIMIT 15;

// 8. Find co-actors through a two-hop pattern.
MATCH (:Person {name: "Tom Hanks"})-[:ACTED_IN]->(movie:Movie)<-[:ACTED_IN]-(coActor:Person)
RETURN DISTINCT coActor.name AS coActor
ORDER BY coActor
LIMIT 25;

// 9. Traverse one step further to discover other movies through co-actors.
MATCH (:Person {name: "Tom Hanks"})-[:ACTED_IN]->(sharedMovie:Movie)<-[:ACTED_IN]-(coActor:Person)-[:ACTED_IN]->(otherMovie:Movie)
WHERE sharedMovie <> otherMovie
RETURN DISTINCT coActor.name AS viaCoActor, otherMovie.title AS otherMovie
ORDER BY viaCoActor, otherMovie
LIMIT 25;

// 10. Count movies per actor.
MATCH (actor:Person)-[:ACTED_IN]->(movie:Movie)
RETURN actor.name AS actor, count(movie) AS movieCount
ORDER BY movieCount DESC, actor
LIMIT 10;

// 11. Collect movie titles per actor.
MATCH (actor:Person)-[:ACTED_IN]->(movie:Movie)
WITH actor, collect(movie.title) AS movies, count(movie) AS movieCount
WHERE movieCount >= 3
RETURN actor.name AS actor, movieCount, movies
ORDER BY movieCount DESC, actor
LIMIT 10;

// 12. Practice: common movies for two actors.
MATCH (:Person {name: "Tom Hanks"})-[:ACTED_IN]->(movie:Movie)<-[:ACTED_IN]-(:Person {name: "Meg Ryan"})
RETURN movie.title AS commonMovie
ORDER BY commonMovie;
