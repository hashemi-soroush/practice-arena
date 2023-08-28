# Depth First Search
You are given a graph with `n` vertices, indexed from `0` to `n-1`, and `m` edges. Then `q` queries ask whether two vertices are connected, directly or indirectly.

## Input
The first line contains `n` and `m` respectively. Then `m` lines follow, each with two indices between `0` and `n-1`, describing an edge.
The next line contains `q` and the next `q` lines query a couple of vertices.

## Output
Output has `q` lines, each can be either `YES` or `NO`, the response to the corresponding query.

## examples:
### Example 1
Input:
```text
4 2
0 1
2 3
4
0 1
0 2
2 3
1 3
```

Output:
```text
YES
NO
YES
NO
```