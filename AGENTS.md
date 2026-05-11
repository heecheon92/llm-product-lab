# AGENTS.md — graphrag-lab workspace instructions

## Scope

This file applies to the entire Git repository.

The Git repo is the whole workspace, not an individual project under `wikidocs/`.

Before creating repo-wide files, always confirm the root with:

```bash
git rev-parse --show-toplevel
```

## Repository safety rules

- Treat `graphrag-lab/` as the source-control boundary.
- Put repo-wide policy files at the Git root, for example:
  - `.gitignore`
  - `AGENTS.md`
  - workspace-level docs
- Put project-specific files inside the relevant project folder only when they are truly local to that project.
- Do not assume a nested folder is its own Git repo unless `git rev-parse --show-toplevel` proves it.

## Ignore and secret handling

- Keep secrets out of Git.
- Never commit real `.env` files, API keys, Neo4j passwords, tokens, local database dumps, virtualenvs, caches, or local runtime state.
- Use `.env.example` for shareable environment-variable names and safe defaults.
- If adding a new project that needs secrets, add/update `.env.example`, not `.env`.
- The repo-root `.gitignore` is the authoritative ignore policy for the whole workspace; nested `.gitignore` files are allowed only for project portability or project-specific generated files.

## Python / uv projects

This workspace may contain multiple independent Python projects, each with its own uv environment.

Expected per-project files:

```text
pyproject.toml
uv.lock
.python-version
.venv/          # ignored
.env            # ignored
.env.example    # trackable
```

Use project-local commands from the project directory:

```bash
uv run python <script.py>
uv sync
```

Do not hardcode one project's `.venv` as the interpreter for the entire `graphrag-lab` workspace.

## VSCode / editor settings

- Multiple uv projects may exist under this repo.
- Do not pin the repo-root VSCode interpreter to a single nested project.
- Prefer either:
  - opening the individual uv project folder directly, or
  - using a VSCode multi-root workspace where each uv project is its own workspace folder.
- Local `.vscode/` settings are ignored by default unless the user explicitly asks to track shared editor settings.

## Neo4j scripts

- Configure Neo4j connection values through environment variables, usually loaded from `.env`:
  - `NEO4J_URI`
  - `NEO4J_USERNAME`
  - `NEO4J_PASSWORD`
  - `NEO4J_DATABASE`
- Select the target Neo4j database on the session, not by changing the driver URI:

```python
with driver.session(database=os.getenv("NEO4J_DATABASE", "neo4j")) as session:
    ...
```

- Do not hardcode passwords in Python files.
- Do not execute scripts that create, update, or delete database data unless the user clearly requested that side effect.

## Validation before completion

For file/config changes, report the evidence used, such as:

```bash
git status --short --ignored
python -m py_compile <changed_script.py>
git check-ignore -v <sensitive_or_generated_path>
```

For Python code changes, prefer targeted checks with the relevant project venv via `uv run` or `.venv/bin/python`.
