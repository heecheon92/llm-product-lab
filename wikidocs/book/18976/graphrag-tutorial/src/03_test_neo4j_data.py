import os
from pathlib import Path

from neo4j import GraphDatabase
from dotenv import load_dotenv


PROJECT_ROOT = Path(__file__).resolve().parent.parent
load_dotenv(PROJECT_ROOT / ".env")


def get_neo4j_config():
    password = os.getenv("NEO4J_PASSWORD")
    if not password:
        raise RuntimeError("NEO4J_PASSWORD is missing. Add it to .env or your shell environment.")

    return {
        "uri": os.getenv("NEO4J_URI", "bolt://localhost:7687"),
        "username": os.getenv("NEO4J_USERNAME", "neo4j"),
        "password": password,
        "database": os.getenv("NEO4J_DATABASE", "tutorial-db"),
    }


def main():
    config = get_neo4j_config()

    driver = GraphDatabase.driver(
        config["uri"],
        auth=(config["username"], config["password"]),
    )

    try:
        with driver.session(database=config["database"]) as session:
            # 노드 생성
            session.run("""
                CREATE (p:Person {name: '김철수', age: 30})
                CREATE (c:Company {name: 'AI 스타트업'})
                CREATE (p)-[:WORKS_AT]->(c)
            """)
            print(f"✅ 데이터 생성 완료! database={config['database']}")

            # 데이터 조회
            result = session.run("""
                MATCH (p:Person)-[:WORKS_AT]->(c:Company)
                RETURN p.name AS person, c.name AS company
            """)

            for record in result:
                print(f"👤 {record['person']}님은 {record['company']}에서 일합니다.")
    finally:
        driver.close()


if __name__ == "__main__":
    main()
