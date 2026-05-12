// 06-02. 수동으로 지식 그래프 구축
// Source: https://wikidocs.net/319220
// These queries write to Neo4j. They use PracticeChapter06 to keep cleanup scoped.

// 1. Clean only Chapter 6 practice data.
MATCH (n:PracticeChapter06)
DETACH DELETE n;

// 2. Create people.
MERGE (sejong:Person:PracticeChapter06 {name: "세종대왕"})
SET sejong.born = 1397,
    sejong.died = 1450,
    sejong.role = "왕",
    sejong.description = "조선의 제4대 왕, 한글 창제"
MERGE (jang:Person:PracticeChapter06 {name: "장영실"})
SET jang.born = 1390,
    jang.role = "과학자",
    jang.description = "조선 최고의 발명가"
MERGE (sung:Person:PracticeChapter06 {name: "성삼문"})
SET sung.born = 1418,
    sung.died = 1456,
    sung.role = "학자",
    sung.description = "집현전 학자"
MERGE (park:Person:PracticeChapter06 {name: "박팽년"})
SET park.born = 1417,
    park.died = 1456,
    park.role = "학자",
    park.description = "집현전 학자"
RETURN sejong, jang, sung, park;

// 3. Create achievements and inventions.
MERGE (hangul:Achievement:PracticeChapter06 {name: "훈민정음"})
SET hangul.year = 1443,
    hangul.type = "문자",
    hangul.description = "백성을 가르치는 바른 소리"
MERGE (sundial:Achievement:PracticeChapter06 {name: "앙부일구"})
SET sundial.year = 1434,
    sundial.type = "발명",
    sundial.description = "해시계"
MERGE (waterclock:Achievement:PracticeChapter06 {name: "자격루"})
SET waterclock.year = 1434,
    waterclock.type = "발명",
    waterclock.description = "자동 물시계"
MERGE (raingauge:Achievement:PracticeChapter06 {name: "측우기"})
SET raingauge.year = 1441,
    raingauge.type = "발명",
    raingauge.description = "강우량 측정 기구"
RETURN hangul, sundial, waterclock, raingauge;

// 4. Create organization.
MERGE (jiphyeon:Organization:PracticeChapter06 {name: "집현전"})
SET jiphyeon.type = "학술기관",
    jiphyeon.founded = 1420,
    jiphyeon.description = "왕실 학술 연구 기관"
RETURN jiphyeon;

// 5. Create relationships.
MATCH (sejong:Person:PracticeChapter06 {name: "세종대왕"})
MATCH (jang:Person:PracticeChapter06 {name: "장영실"})
MATCH (sung:Person:PracticeChapter06 {name: "성삼문"})
MATCH (park:Person:PracticeChapter06 {name: "박팽년"})
MATCH (hangul:Achievement:PracticeChapter06 {name: "훈민정음"})
MATCH (sundial:Achievement:PracticeChapter06 {name: "앙부일구"})
MATCH (waterclock:Achievement:PracticeChapter06 {name: "자격루"})
MATCH (raingauge:Achievement:PracticeChapter06 {name: "측우기"})
MATCH (jiphyeon:Organization:PracticeChapter06 {name: "집현전"})
MERGE (sejong)-[:CREATED {year: 1443}]->(hangul)
MERGE (sejong)-[:ESTABLISHED]->(jiphyeon)
MERGE (sejong)-[:COLLABORATED_WITH]->(jang)
MERGE (jang)-[:INVENTED]->(sundial)
MERGE (jang)-[:INVENTED]->(waterclock)
MERGE (jang)-[:INVENTED]->(raingauge)
MERGE (sung)-[:WORKED_AT]->(jiphyeon)
MERGE (park)-[:WORKED_AT]->(jiphyeon)
MERGE (sung)-[:PARTICIPATED_IN]->(hangul)
MERGE (park)-[:PARTICIPATED_IN]->(hangul);

// 6. Visualize the complete Chapter 6 practice graph.
MATCH (n:PracticeChapter06)-[r]->(m:PracticeChapter06)
RETURN n, r, m;

// 7. Explore around Sejong up to two hops.
MATCH path = (:Person:PracticeChapter06 {name: "세종대왕"})-[*1..2]-(connected:PracticeChapter06)
RETURN path;

// 8. Answer: What are Sejong's achievements or institutions?
MATCH (:Person:PracticeChapter06 {name: "세종대왕"})-[:CREATED|ESTABLISHED]->(target)
RETURN target.name AS 이름, labels(target)[0] AS 유형
ORDER BY 이름;

// 9. Answer: Who worked at Jiphyeonjeon?
MATCH (scholar:Person:PracticeChapter06)-[:WORKED_AT]->(:Organization:PracticeChapter06 {name: "집현전"})
RETURN scholar.name AS 학자
ORDER BY 학자;

// 10. Answer: What did Jang Yeong-sil invent?
MATCH (:Person:PracticeChapter06 {name: "장영실"})-[:INVENTED]->(invention:Achievement)
RETURN invention.name AS 발명품, invention.year AS 연도
ORDER BY 연도, 발명품;

// 11. Answer: Who participated in Hunminjeongeum creation?
MATCH (person:Person:PracticeChapter06)-[:CREATED|PARTICIPATED_IN]->(:Achievement:PracticeChapter06 {name: "훈민정음"})
RETURN person.name AS 참여자, person.role AS 역할
ORDER BY 참여자;
