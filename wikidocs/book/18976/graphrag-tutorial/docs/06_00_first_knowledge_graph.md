# 06. 첫 번째 지식 그래프 만들기

Source: <https://wikidocs.net/319218>

## 핵심 요약

Part 06은 단순히 Cypher 문법을 익히는 단계를 넘어, **어떤 노드와 관계를 만들지 설계하고 실제 지식 그래프로 구축하는 단계**입니다.

이번 장의 흐름은 다음과 같습니다.

1. 지식 그래프 스키마 설계
2. 수동으로 지식 그래프 구축
3. 구축한 그래프를 질문에 답하는 구조로 확인

**다이어그램: Part 06에서 다루는 지식 그래프 구축 흐름입니다.**

```mermaid
flowchart LR
  source["역사 문서/학습 데이터"] --> schema["스키마 설계"]
  schema --> cypher["Cypher로 수동 구축"]
  cypher --> kg[("Neo4j 지식 그래프")]
  kg --> query["질문별 탐색 쿼리"]
```

## 수동 구축과 자동 추출

| 방식 | 의미 | 장점 | 주의점 |
| --- | --- | --- | --- |
| 수동 구축 | 사람이 엔티티/관계를 분석해 Cypher로 입력 | 정확한 스키마, 높은 품질 | 시간이 많이 걸림 |
| 자동 추출 | LLM이 문서에서 엔티티/관계를 추출 | 대량 처리에 유리 | 검증과 품질 관리 필요 |

Part 06의 제공 링크 범위에서는 수동 설계/구축을 중심으로 정리합니다.

## 이 장의 파일

| 파일 | 목적 |
| --- | --- |
| `docs/06_00_first_knowledge_graph.md` | Chapter 6 전체 개요 |
| `docs/06_01_schema_design.md` | 지식 그래프 스키마 설계 노트와 제약조건 예제 |
| `cypher/06_01_schema_design.cypher` | 스키마 확인/제약조건 Cypher |
| `docs/06_02_manual_knowledge_graph.md` | 세종대왕 중심 수동 지식 그래프 구축 노트 |
| `cypher/06_02_manual_knowledge_graph.cypher` | 수동 구축/검증/질문 Cypher |
| `src/06_02_01_build_sejong_graph.py` | Python/LangChain으로 같은 그래프 구축 |

## 안전 메모

- `cypher/06_01_schema_design.cypher`의 제약조건 생성은 DB 스키마를 변경합니다.
- `cypher/06_02_manual_knowledge_graph.cypher`와 `src/06_02_01_build_sejong_graph.py`는 DB에 노드와 관계를 씁니다.
- 예제는 `PracticeChapter06` 라벨을 붙여 재실행/삭제 범위를 좁혔습니다.
