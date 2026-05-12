// 05-03. Cypher로 데이터 만들기
// Source: https://wikidocs.net/319216
// These queries change the database. Run on a practice database.

// 0. Optional cleanup before re-running this file.
// This targets only the practice graph used in this file.
MATCH (n:PracticeChapter05)
DETACH DELETE n;


// 1. CREATE always creates new data.
CREATE (hong:Person:PracticeChapter05 {name: "홍길동", born: 1990})
RETURN hong;

// 2. Create multiple nodes in one query.
CREATE (kim:Person:PracticeChapter05 {name: "김철수", born: 1985})
CREATE (lee:Person:PracticeChapter05 {name: "이영희", born: 1988})
CREATE (park:Person:PracticeChapter05 {name: "박민수", born: 1992})
RETURN kim, lee, park;

// 3. Create a movie and connect an existing person to it.
CREATE (movie:Movie:PracticeChapter05 {
  title: "나의 첫 영화",
  released: 2024,
  tagline: "그래프로 배우는 첫 Cypher"
})
WITH movie
MATCH (hong:Person:PracticeChapter05 {name: "홍길동"})
CREATE (hong)-[:ACTED_IN {roles: ["주인공"]}]->(movie)
RETURN hong, movie;

// 4. MERGE avoids duplicate nodes when the pattern already exists.
MERGE (trainee:Person:PracticeChapter05 {name: "연습 사용자"})
ON CREATE SET trainee.createdAt = datetime()
ON MATCH SET trainee.lastSeen = datetime()
RETURN trainee;

// 5. MERGE a relationship between matched nodes.
MATCH (hong:Person:PracticeChapter05 {name: "홍길동"})
MATCH (movie:Movie:PracticeChapter05 {title: "나의 첫 영화"})
MERGE (hong)-[review:REVIEWED]->(movie)
ON CREATE SET review.rating = 5, review.summary = "연습용 리뷰"
ON MATCH SET review.updatedAt = datetime()
RETURN hong, review, movie;

// 6. SET properties and add an extra label.
MATCH (hong:Person:PracticeChapter05 {name: "홍길동"})
SET hong.email = "hong@example.com",
    hong.country = "Korea",
    hong:Actor
RETURN hong.name AS name, labels(hong) AS labels, hong.email AS email, hong.country AS country;

// 7. Build a small Korean history practice graph.
MERGE (sejong:Person:King:PracticeChapter05 {name: "세종대왕"})
  ON CREATE SET sejong.born = 1397, sejong.died = 1450
MERGE (jang:Person:Scientist:PracticeChapter05 {name: "장영실"})
  ON CREATE SET jang.born = 1390
MERGE (shin:Person:Scholar:PracticeChapter05 {name: "신숙주"})
  ON CREATE SET shin.born = 1417
MERGE (hangul:Achievement:PracticeChapter05 {name: "훈민정음"})
  ON CREATE SET hangul.year = 1443
MERGE (rainGauge:Achievement:PracticeChapter05 {name: "측우기"})
  ON CREATE SET rainGauge.year = 1441
MERGE (jiphyeonjeon:Organization:PracticeChapter05 {name: "집현전"})
MERGE (sejong)-[:CREATED]->(hangul)
MERGE (sejong)-[:ESTABLISHED]->(jiphyeonjeon)
MERGE (jang)-[:INVENTED]->(rainGauge)
MERGE (sejong)-[:COLLABORATED_WITH]->(jang)
MERGE (shin)-[:WORKED_AT]->(jiphyeonjeon)
RETURN sejong, jang, shin, hangul, rainGauge, jiphyeonjeon;

// 8. Inspect only the practice graph.
MATCH (n:PracticeChapter05)
OPTIONAL MATCH (n)-[r]->(m:PracticeChapter05)
RETURN n, r, m;

// 9. Delete only a relationship.
MATCH (:Person:PracticeChapter05 {name: "홍길동"})-[review:REVIEWED]->(:Movie:PracticeChapter05 {title: "나의 첫 영화"})
DELETE review;

// 10. Delete a disconnected practice node.
MATCH (p:Person:PracticeChapter05 {name: "김철수"})
DETACH DELETE p;

// 11. Final cleanup for all practice data from this file.
// Uncomment and run when you want to reset.
// MATCH (n:PracticeChapter05)
// DETACH DELETE n;
