// 05-01. Neo4j Browser 탐험
// Source: https://wikidocs.net/319213
//
// Browser-only command, not Cypher:
//   :play movies
// Run that command in Neo4j Browser first if the movie sample data is not loaded.

// 1. Count all nodes.
MATCH (n)
RETURN count(n) AS totalNodes;

// 2. Count all relationships.
MATCH ()-[r]->()
RETURN count(r) AS totalRelationships;

// 3. Count nodes by label combination.
MATCH (n)
RETURN labels(n) AS labels, count(*) AS count
ORDER BY count DESC, labels;

// 4. Count relationships by type.
MATCH ()-[r]->()
RETURN type(r) AS relationshipType, count(*) AS count
ORDER BY count DESC, relationshipType;

// 5. Visualize a small actor-to-movie subgraph.
MATCH (person:Person)-[actedIn:ACTED_IN]->(movie:Movie)
RETURN person, actedIn, movie
LIMIT 25;

// 6. Inspect movies connected to Tom Hanks.
MATCH (tom:Person {name: "Tom Hanks"})-[actedIn:ACTED_IN]->(movie:Movie)
RETURN tom, actedIn, movie;

// 7. Inspect cast members of The Matrix as a table.
MATCH (actor:Person)-[:ACTED_IN]->(:Movie {title: "The Matrix"})
RETURN actor.name AS actor
ORDER BY actor;

// 8. Find people who both acted in and directed at least one movie.
MATCH (person:Person)-[:ACTED_IN]->(:Movie)
MATCH (person)-[:DIRECTED]->(:Movie)
RETURN DISTINCT person.name AS person
ORDER BY person
LIMIT 25;
