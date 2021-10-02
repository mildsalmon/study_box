# 1. BFS (Breadth-First Search)

> 큐를 활용하니까, 방문했던 위치에 다시 방문하지 않음.
> 
> 좌표 평면 문제에서 방문했던 위치에 돌아올 필요 없는 문제에 사용.

### A. BFS

너비 우선 탐색

가까운 노드부터 탐색하는 알고리즘

BFS 구현에서는 선입선출 방식인 큐 자료구조를 이용한다. 인접한 노드를 반복적으로 큐에 넣도록 알고리즘을 작성하면 자연스럽게 먼저 들어온 것이 먼저 나가게 되어, 가까운 노드부터 탐색을 진행하게 된다.

1. 탐색 시작 노드를 큐에 삽입하고 방문 처리를 한다.
2. 큐에서 노드를 꺼내 해당 노드의 인접 노드 중에서 방문하지 않은 노드를 모두 큐에 삽입하고 방문 처리 한다.
3. 더 이상 수행할 수 없을 때까지 반복한다.

숫자가 작은 노드부터 먼저 큐에 삽입한다고 가정한다.

BFS는 큐 자료구조에 기초한다는 점에서 구현이 간단하다. deque 라이브러리를 사용하며 탐색을 수행함에 있어 O(N)의 시간이 소요된다. 

일반적인 경우 실제 수행 시간은 DFS보다 좋은 편이다.

```python

from collections import deque  
  
def bfs(graph, start, visited):  
    queue = deque([start])  
    visited[start] = True  
  
	while queue:  
		v = queue.popleft()  
		print(v, end=' ')  

		for i in graph[v]:  
			if not visited[i]:  
				queue.append(i)  
				visited[i] = True  

graph = [  
    [],  
 [2, 3, 8],  
 [1, 7],  
 [1, 4, 5],  
 [3, 5],  
 [3, 4],  
 [7],  
 [2, 6, 8],  
 [1, 7]  
]  
  
visited = [False] * 9  
bfs(graph, 1, visited)

```

```

1 2 3 8 7 4 5 6 

```

# 참고문헌

나동빈, "이것이 취업을 위한 코딩 테스트다 with 파이썬", 초판, 2쇄, 한빛미디어, 2020년

#코딩테스트 #파이썬 #나동빈 #한빛미디어 #자료구조 #BFS #이것이취업을위한코딩테스트다