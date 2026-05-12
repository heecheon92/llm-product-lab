# 05. Neo4j와 Cypher 기초

Source: <https://wikidocs.net/319212>

## 학습 목표

Chapter 5는 Python 코드보다 **Neo4j Browser와 Cypher 쿼리 감각**을 익히는 파트입니다.
이 프로젝트에서는 Python이 아닌 학습 자료를 다음처럼 분리합니다.

- `docs/05_*.md`: 개념 정리, Browser 사용법, 주의사항, 연습 문제
- `cypher/05_*.cypher`: Neo4j Browser에서 실행할 수 있는 순수 Cypher 예제
- `src/05_*.py`: Python 코드가 실제로 등장하는 경우만 사용 (`5.4`는 별도 진행)

## Cypher를 SQL처럼 생각하기

| SQL에서 하던 일 | Cypher에서 주로 쓰는 문법 |
| --- | --- |
| 행/테이블 조회 | `MATCH ... RETURN ...` |
| 데이터 생성 | `CREATE` 또는 `MERGE` |
| 값 변경 | `SET` |
| 데이터 삭제 | `DELETE`, `DETACH DELETE` |
| 조인 | 노드-관계-노드 패턴 `()-[]->()` |

핵심 차이는 **관계를 컬럼 조인이 아니라 화살표 패턴으로 직접 표현한다는 점**입니다.

```cypher
MATCH (person:Person)-[:ACTED_IN]->(movie:Movie)
RETURN person.name AS person, movie.title AS movie
LIMIT 10;
```

## 기억할 패턴

```text
(nodeVariable:Label {property: value})-[relVariable:RELATIONSHIP_TYPE]->(otherNode:Label)
```

- `()`는 노드입니다.
- `[]`는 관계입니다.
- `:Label`은 노드의 종류입니다.
- `:RELATIONSHIP_TYPE`은 관계의 종류입니다.
- `->`, `<-`, `-`는 관계 방향입니다.

## 이 장의 파일

| 파일 | 목적 |
| --- | --- |
| `docs/05_01_neo4j_browser.md` | Neo4j Browser 사용법과 Browser 명령 정리 |
| `cypher/05_01_neo4j_browser.cypher` | 샘플 영화 데이터 확인/시각화 쿼리 |
| `docs/05_02_cypher_read.md` | 읽기 쿼리 패턴 정리 |
| `cypher/05_02_cypher_read.cypher` | `MATCH`, `WHERE`, 관계 탐색, 집계 예제 |
| `docs/05_03_cypher_write.md` | 생성/수정/삭제 쿼리 패턴 정리 |
| `cypher/05_03_cypher_write.cypher` | `CREATE`, `MERGE`, `SET`, `DELETE` 예제 |

## 안전 메모

- `MATCH ... RETURN ...`은 읽기 전용입니다.
- `CREATE`, `MERGE`, `SET`, `DELETE`, `DETACH DELETE`는 DB 상태를 바꿉니다.
- `DETACH DELETE`는 연결된 관계까지 삭제하므로 연습용 데이터에만 사용하세요.
- Browser 명령어인 `:play movies`는 Cypher가 아니므로 `.cypher` 파일이 아니라 Markdown 노트에 적습니다.
