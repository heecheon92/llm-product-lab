# AGENTS.md — graphrag-tutorial project workflow

## Scope

This file applies to `wikidocs/book/18976/graphrag-tutorial/` and all child files.
Follow the repository-level AGENTS.md as the parent contract; this file adds project-specific tutorial-artifact conventions.

## Source attribution

- The source material for this project is WikiDocs: <https://wikidocs.net/book/18976>.
- Each chapter note or runnable example should include its page-level source URL near the top.
- Do not add source pages that the user intentionally did not provide unless they ask for them.

## Tutorial artifact workflow

When processing WikiDocs chapter pages, use the Chapter 5 pattern:

1. Put study notes in `docs/`.
2. Put Neo4j Browser-runnable Cypher in `cypher/`.
3. Do **not** create or edit Python scripts in `src/` during chapter processing unless the user explicitly asks for script work in that turn.
   - The user will usually create chapter script files personally.
   - If a source page includes Python, document the concept and expected script name in `docs/`, but leave `src/` unchanged.
4. Use chapter/section prefixes in filenames:
   - `docs/06_01_schema_design.md`
   - `cypher/06_02_manual_knowledge_graph.cypher`
5. Update `README.md` so new artifacts are discoverable.

## Markdown notes

- Notes should be useful for study/review, not raw copies of the source page.
- Prefer Korean explanations to match the tutorial notes already in this project.
- Include:
  - 핵심 요약
  - concepts and common mistakes
  - inline fenced `cypher` examples when relevant
  - Korean-labeled Mermaid diagrams when useful
  - warnings for database-writing examples
- Browser-only commands belong in Markdown notes, not `.cypher` files.

## Mermaid diagrams

Use Mermaid only when it clarifies the learning goal.

- Every Mermaid block must have a visible Korean label immediately before it:
  - `**다이어그램: ...**`
- For Neo4j graph patterns, use diagrams that represent actual node-to-node relationships.
- Do not force graph diagrams for simple counts, deletes, or single-node-only operations.
- Non-graph diagrams are allowed when they represent a useful concept, such as:
  - schema/class shape
  - process flow
  - returned object shape
- Avoid Mermaid edge labels with unescaped parentheses; prefer quoted labels or remove parentheses.

## Cypher examples

- `.cypher` files should contain clean runnable Cypher plus comments.
- Prefer `MERGE` over `CREATE` when examples may be re-run.
- Clearly mark write/delete queries.
- Scope destructive cleanup to practice labels such as `PracticeChapter06` when possible.
- Keep Browser commands such as `:play movies` out of `.cypher` files except as comments.

## Python scripts

- Default rule: do not work on `src/` unless the user explicitly requests Python/script edits.
- If the user asks to process WikiDocs links “like Chapter 5,” that means create/update `docs/`, `cypher/`, and `README.md` only; it does not imply permission to create or edit `src/`.
- If Python content appears in the source material, summarize it in Markdown and mention that the user can create the script later.
- When the user explicitly asks for script work, then follow these rules:
  - Use `src/util.py` for shared environment/config helpers:
    - `require_env`
    - `get_neo4j_config`
    - OpenAI model helpers
    - shared RAG/chunking utilities
  - Do not duplicate `.env` loading or local `require_env` functions in scripts.
  - Do not hardcode Neo4j passwords.
  - Use `config.database` when opening Neo4j sessions or `Neo4jGraph` connections.

## Verification before completion

For documentation/Cypher updates, run the smallest safe checks:

```bash
python3 - <<'PY'
from pathlib import Path
for path in Path('docs').glob('*.md'):
    assert path.read_text().count(chr(96) * 3) % 2 == 0, path
print('markdown fences balanced')
PY
git check-ignore -v .env src/__pycache__
```

If the user explicitly requested Python/script edits, also run:

```bash
uv run python -m py_compile src/*.py
```

Do not execute OpenAI calls or Neo4j write scripts unless the user explicitly asks for those side effects.
