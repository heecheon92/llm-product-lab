from neo4j import GraphDatabase

from util import get_neo4j_config

# 연결 정보
config = get_neo4j_config()

# 드라이버 생성
driver = GraphDatabase.driver(config.uri, auth=config.auth)

# 연결 확인
driver.verify_connectivity()
print("Neo4j 연결 성공!")

# 드라이버 종료
driver.close()
