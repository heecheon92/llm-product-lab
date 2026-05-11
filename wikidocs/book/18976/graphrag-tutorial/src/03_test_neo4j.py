import os
from pathlib import Path

from dotenv import load_dotenv
from neo4j import GraphDatabase


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
        driver.verify_connectivity()
        print("✅ Neo4j 연결 성공!")

        with driver.session(database=config["database"]) as session:
            result = session.run("RETURN 'Hello from Python!' AS message")
            record = result.single()
            message = record["message"] if record else "(no response)"
            print(f"📝 응답: {message}")
            print(f"🗄️ database={config['database']}")

    except Exception as e:
        print(f"❌ 연결 실패: {e}")
        raise

    finally:
        driver.close()


if __name__ == "__main__":
    main()
