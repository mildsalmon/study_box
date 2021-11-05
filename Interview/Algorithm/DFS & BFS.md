# 1. DFS

## A. 내용

깊이 우선 탐색.

루트노드에서 리프노드까지 쭉 탐색을 하고, 다음 탐색을 진행한다.

스택, 재귀적으로 품

> 루트 노드 혹은 임의 노드에서 다음 브랜치로 넘어가기 전에, 해당 브랜치를 모두 탐색하는 방법

모든 경로를 방문해야 할 경우에 적합.

## B. Process

1. 루트 노드에서 다음 노드를 정함.
	1. 이것을 자식노드가 없을 때까지 반복함
2. 자식노드가 없다면, 상위 노드로 이동함.
	1. 탐색하지 않은 노드에 접근해서 탐색을 함.
3. 위 과정을 target을 찾을 때까지 반복한다.

## C. Code

```python

def dfs(array, x, y):
	ds = ((1, 0), (-1, 0), (0, 1), (0, -1))
	
	for d in ds:
		dx = x + d[0]
		dy = y + d[1]
		
		if 0 <= dx < n and 0 <= dy < n:
			if array[dx][dy] == 0:
				array[dx][dy] = 1
				dfs(array, dx, dy)
	
	
for i in range(n):
	for j in range(m):
		dfs(array, i, j)

```

## D. 복잡도

### A. 시간복잡도

- 인접 행렬 : O($V^2$)
- 인접 리스트 : O(V + E)

V는 접점, E는 간선

# 2. BFS

## A. 내용

너비 우선 탐색

같은 레벨의 노드를 전부 탐색하고 다음 레벨로 넘어간다.

큐로 구현

> 루트 노드 또는 임의 노드에서 인접한 노드부터 먼저 탐색하는 방법

최소 비용(모든 곳을 탐색하는 것보다 최소 비용이 우선일 때)에 적합

## B. Process

1. 루트 노드에서 자식 노드를 모두 탐색한다.
2. 자식 노드가 없을때까지 탐색을 진행한다.

## C. Code

```python

from collections import deque

ds = ((1, 0), (-1, 0), (0, 1), (0, -1))

q = deque()
q.append([array[0], array[1]])

while q:
	x, y = q.popleft()
	
	for d in ds:
		dx = x + d[0]
		dy = y + d[1]
		
		if 0 <= dx < n and 0 <= dy < n:
			if array[dx][dy] != 0:
				array[dx][dy] = 1
				q.append([dx, dy])			

```

## D. 복잡도

### A. 시간복잡도

- 인접 행렬 : O($V^2$)
- 인접 리스트 : O(V + E)

V는 접점, E는 간선