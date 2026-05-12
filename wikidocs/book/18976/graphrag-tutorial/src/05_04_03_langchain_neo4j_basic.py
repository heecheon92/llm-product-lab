from langchain_neo4j import Neo4jGraph

from util import get_neo4j_config

config = get_neo4j_config()

# Neo4j 연결 (환경 변수 또는 직접 지정)
graph = Neo4jGraph(
    url=config.uri,
    username=config.username,
    password=config.password,
    database=config.database,
)

# 스키마 확인
print("데이터베이스 스키마:")
print(graph.schema)

# 읽기 쿼리
result = graph.query("""
    MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
    RETURN p.name AS actor, m.title AS movie
    LIMIT 5
""")

print("배우와 영화:")
for row in result:
    print(f"  {row['actor']} → {row['movie']}")

# 매개변수가 있는 쿼리
result = graph.query(
    """
    MATCH (p:Person {name: $name})-[:ACTED_IN]->(m:Movie)
    RETURN m.title AS movie
    """,
    params={"name": "Tom Hanks"}
)

print("톰 행크스 출연작:")
for row in result:
    print(f"  - {row['movie']}")