from pathlib import Path

from dotenv import load_dotenv
from langchain_openai import ChatOpenAI

# .env 파일 로드
PROJECT_ROOT = Path(__file__).resolve().parent.parent
load_dotenv(PROJECT_ROOT / ".env")

# ChatGPT 모델 생성
llm = ChatOpenAI(model="gpt-5.4-mini", temperature=0)

# 간단한 테스트
response = llm.invoke("안녕하세요! 한 문장으로 자기소개 해주세요.")
print("🤖 GPT 응답:", response.content)
