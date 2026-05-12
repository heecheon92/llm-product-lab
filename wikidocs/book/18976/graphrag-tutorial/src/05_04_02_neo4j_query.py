from neo4j import GraphDatabase

from util import get_neo4j_config

config = get_neo4j_config()
driver = GraphDatabase.driver(config.uri, auth=config.auth)

# 읽기 쿼리 실행
def get_movies(tx, limit=5):
    query = """
    MATCH (m:Movie)
    RETURN m.title AS title, m.released AS year
    LIMIT $limit
    """
    result = tx.run(query, limit=limit)
    return [
        {"title": record["title"], "year": record["year"]}
        for record in result
    ]

# 세션으로 실행
with driver.session(database=config.database) as session:
    # execute_read: 읽기 전용 쿼리 (더 빠름, 복제본 사용 가능)
    movies = session.execute_read(get_movies, limit=5)

    print("영화 목록:")
    for movie in movies:
        print(f"  - {movie['title']} ({movie['year']})")


def create_person(tx, name, born):
    query = """
    MERGE (p:Person {name: $name})
    ON CREATE SET p.born = $born
    RETURN p
    """
    result = tx.run(query, name=name, born=born)
    return result.single()

# 쓰기는 execute_write 사용
with driver.session(database=config.database) as session:
    # execute_write: 쓰기 쿼리 (트랜잭션 보장)
    result = session.execute_write(create_person, "테스트인물", 2000)
    print(f"생성됨: {result}")

driver.close()
