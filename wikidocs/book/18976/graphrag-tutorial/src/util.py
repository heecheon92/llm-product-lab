from __future__ import annotations

import os
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Sequence

import numpy as np
from dotenv import load_dotenv
from langchain_text_splitters import RecursiveCharacterTextSplitter

PROJECT_ROOT = Path(__file__).resolve().parent.parent
load_dotenv(PROJECT_ROOT / ".env")


def require_env(key: str) -> str:
    """Return a required environment variable loaded from project .env or shell."""
    value = os.getenv(key)
    if not value:
        raise RuntimeError(f"{key} is missing. Add it to .env or your shell environment.")
    return value


def env_or_default(key: str, default: str) -> str:
    """Return an optional environment variable with a safe tutorial default."""
    return os.getenv(key, default)


@dataclass(frozen=True)
class Neo4jConfig:
    uri: str
    username: str
    password: str
    database: str

    @property
    def auth(self) -> tuple[str, str]:
        return (self.username, self.password)


def get_neo4j_config() -> Neo4jConfig:
    """Central Neo4j connection settings for tutorial scripts."""
    return Neo4jConfig(
        uri=env_or_default("NEO4J_URI", "bolt://localhost:7687"),
        username=env_or_default("NEO4J_USERNAME", "neo4j"),
        password=require_env("NEO4J_PASSWORD"),
        database=env_or_default("NEO4J_DATABASE", "tutorial-db"),
    )


def default_embedding_model() -> str:
    return require_env("OPENAI_DEFAULT_EMBEDDING_MODEL")


def default_llm_model() -> str:
    return require_env("OPENAI_DEFAULT_LLM_MODEL")


def ensure_project_root_on_path() -> None:
    """Allow scripts in src/ to import project-local packages such as data/."""
    project_root = str(PROJECT_ROOT)
    if project_root not in sys.path:
        sys.path.insert(0, project_root)


def cosine_similarity(vec1: Sequence[float], vec2: Sequence[float]) -> float:
    """Calculate cosine similarity between two numeric vectors."""
    arr1 = np.array(vec1)
    arr2 = np.array(vec2)
    return float(np.dot(arr1, arr2) / (np.linalg.norm(arr1) * np.linalg.norm(arr2)))


def split_texts(
    texts: Iterable[str],
    *,
    chunk_size: int = 150,
    chunk_overlap: int = 30,
) -> list[str]:
    """Split source texts into RAG chunks using one shared splitter setup."""
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=chunk_size,
        chunk_overlap=chunk_overlap,
        length_function=len,
    )

    chunks: list[str] = []
    for text in texts:
        chunks.extend(text_splitter.split_text(text))
    return chunks


def format_docs(docs) -> str:
    """Format LangChain documents into the plain context string used by RAG prompts."""
    return "\n\n".join(doc.page_content for doc in docs)
