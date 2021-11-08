# 1. 내용

DP를 활용한 최단 경로 탐색 알고리즘

![](https://upload.wikimedia.org/wikipedia/commons/5/57/Dijkstra_Animation.gif)

다익스트라 알고리즘은 특정한 정점에서 다른 모든 정점으로 가는 최단 경로를 기록한다.

이때, 한 번 최단 거리를 구한 곳은 다시 구할 필요가 없기 때문에 DP가 적용된다. 이를 활용해 정점에서 정점까지 간선을 따라 이동할 때 최단 거리를 효율적으로 구할 수 있다.

다익스트라를 구현하기 위해 두 가지를 저장해야 한다.

1. 해당 정점까지의 최단 거리
2. 정점을 방문했는지 여부

> 간선의 값이 양수일 때만 가능하다.

# 2. Process

1. 출발 노드를 설정한다.
2. 최단 거리 테이블을 초기화한다. (무한대값으로 초기화)
3. 방문하지 않은 노드 중에서 최단 거리가 가장 짧은 노드를 선택한다.
4. 해당 노드를 거쳐 다른 노드로 가는 비용을 계산하여 최단 거리 테이블을 갱신한다.
5. 위 과정에서 3과 4번을 반복한다

# 3. Code

```python

import heapq  
import sys  
  
sys_input = sys.stdin.readline  
INF = int(1e9)  
  
n, m = map(int, sys_input().split())  
start = int(sys_input())  
graph = [[] for i in range(n+1)]  
distance = [INF] * (n+1)  
  
for _ in range(m):  
    a, b, c = map(int, sys_input().split())  
    graph[a].append((b, c))  
  
def dijkstra(start):  
    q = []  
    heapq.heappush(q, (0, start))  
    distance[start] = 0  
  
	while q:  
        dist, now = heapq.heappop(q)  
  
        if distance[now] < dist:  
            continue  
  
		for i in graph[now]:  
            cost = dist + i[1]  
  
            if cost < distance[i[0]]:  
                distance[i[0]] = cost  
                heapq.heappush(q, (cost, i[0]))  
  
dijkstra(start)  
  
for i in range(1, n+1):  
    if distance[i] == INF:  
        print("INFINITY")  
    else:  
        print(distance[i])

```


# 4. 복잡도

### A. 시간복잡도

- 인접 행렬
	- O($N^2$)
- 인접 리스트
	- O(NlogN)
	- 선형 탐색으로 시간 초과가 나는 문제는 인접 리스트로 접근해야 한다. (우선순위 큐)


