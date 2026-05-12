# Source: https://wikidocs.net/319220
from langchain_neo4j import Neo4jGraph

from util import get_neo4j_config

config = get_neo4j_config()

graph = Neo4jGraph(
    url=config.uri,
    username=config.username,
    password=config.password,
    database=config.database,
)

# Chapter 6 practice graph. This script writes to Neo4j.
graph.query("""
MATCH (n:PracticeChapter06)
DETACH DELETE n
""")

graph.query("""
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

MERGE (jiphyeon:Organization:PracticeChapter06 {name: "집현전"})
SET jiphyeon.type = "학술기관",
    jiphyeon.founded = 1420,
    jiphyeon.description = "왕실 학술 연구 기관"

MERGE (sejong)-[:CREATED {year: 1443}]->(hangul)
MERGE (sejong)-[:ESTABLISHED]->(jiphyeon)
MERGE (sejong)-[:COLLABORATED_WITH]->(jang)
MERGE (jang)-[:INVENTED]->(sundial)
MERGE (jang)-[:INVENTED]->(waterclock)
MERGE (jang)-[:INVENTED]->(raingauge)
MERGE (sung)-[:WORKED_AT]->(jiphyeon)
MERGE (park)-[:WORKED_AT]->(jiphyeon)
MERGE (sung)-[:PARTICIPATED_IN]->(hangul)
MERGE (park)-[:PARTICIPATED_IN]->(hangul)
""")

print("Chapter 6 지식 그래프 구축 완료!")

result = graph.query("""
MATCH (:PracticeChapter06)-[r]->(:PracticeChapter06)
RETURN count(r) AS totalRelationships
""")

print(f"생성된 관계: {result[0]['totalRelationships']}개")
