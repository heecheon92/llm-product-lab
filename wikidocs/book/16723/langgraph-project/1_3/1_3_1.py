from typing import TypedDict

from langgraph.graph import END, START, StateGraph


class CounterState(TypedDict):
    count: int

def increment(state: CounterState):
    print(f"Current count: {state["count"]}")
    new_count = state["count"] + 1
    print(f"New count: {new_count}")
    return { "count": new_count }

graph = StateGraph(CounterState)
graph.add_node("increment", increment)
graph.add_edge(START, "increment")
graph.add_edge("increment", END)

app = graph.compile()
result = app.invoke({"count": 0})
print(f"Result: {result}")
