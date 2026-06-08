from dotenv import load_dotenv
from langchain.chat_models import init_chat_model
from langchain.messages import HumanMessage

load_dotenv()

def main():
    llm = init_chat_model("openai:gpt-5.4-mini", temperature=0.7, max_tokens=150)
    response_mini = llm.invoke([HumanMessage(content="Hello, how are you?")])
    print(response_mini.content)

if __name__ == "__main__":
    main()
