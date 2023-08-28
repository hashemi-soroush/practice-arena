from collections import defaultdict
from typing import NamedTuple
from typing import MutableMapping, Sequence

def main():
    graph, n = read_graph()
    answer_queries(graph)

class Graph(NamedTuple):
    n: int
    m: int
    edges: MutableMapping

def read_graph() -> Graph:
    n, m = [int(x) for x in input().split()]
    graph = Graph(n, m, defaultdict(list))
    for _ in range(m):
        v, u = [int(x) for x in input().split()]
        graph.edges[v].append(u)
    return graph, n

def answer_queries(graph: Graph):
    q = int(input())
    for _ in range(q):
        v, u = [int(x) for x in input().split()]

        seen = [False] * graph.n
        print("YES" if dfs(v, u, graph, seen) else "NO")

def dfs(cur: int, target: int, graph: Graph, seen: Sequence) -> bool:
    if cur == target:
        return True
    seen[cur] = True

    return any(
        dfs(nex, target, graph, seen)
        for nex in graph.edges[cur]
        if not seen[nex]
    )

if __name__ == '__main__':
    main()
