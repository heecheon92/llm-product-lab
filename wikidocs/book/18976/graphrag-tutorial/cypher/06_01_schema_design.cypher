// 06-01. 지식 그래프 스키마 설계
// Source: https://wikidocs.net/319219
// Some statements create Neo4j constraints. Review before running in a shared database.

// 1. Visualize the current database schema in Neo4j Browser.
CALL db.schema.visualization();

// 2. Count nodes by label.
CALL db.labels() YIELD label
CALL {
  WITH label
  MATCH (n)
  WHERE label IN labels(n)
  RETURN count(n) AS count
}
RETURN label, count
ORDER BY count DESC, label;

// 3. List relationship types.
CALL db.relationshipTypes() YIELD relationshipType
RETURN relationshipType
ORDER BY relationshipType;

// 4. Create uniqueness constraints for the tutorial schema.
CREATE CONSTRAINT person_name IF NOT EXISTS
FOR (p:Person) REQUIRE p.name IS UNIQUE;

CREATE CONSTRAINT achievement_name IF NOT EXISTS
FOR (a:Achievement) REQUIRE a.name IS UNIQUE;

CREATE CONSTRAINT organization_name IF NOT EXISTS
FOR (o:Organization) REQUIRE o.name IS UNIQUE;

// 5. Create required-property constraints.
CREATE CONSTRAINT person_name_exists IF NOT EXISTS
FOR (p:Person) REQUIRE p.name IS NOT NULL;

CREATE CONSTRAINT achievement_name_exists IF NOT EXISTS
FOR (a:Achievement) REQUIRE a.name IS NOT NULL;

CREATE CONSTRAINT organization_name_exists IF NOT EXISTS
FOR (o:Organization) REQUIRE o.name IS NOT NULL;

// 6. Review constraints.
SHOW CONSTRAINTS;
