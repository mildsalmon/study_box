# 1. 내용

완전 이진 트리를 기본으로 하는 힙(Heap) 자료구조를 기반으로 한 정렬 방식

### A. 완전 이진 트리란?

삽입할 때 왼쪽부터 차례대로 추가하는 이진 트리

힙 정렬은 **불안정 정렬**에 속함

# 2. Process

### A. 최대 힙

1. 최대 힙을 구성
2. 현재 힙 루트는 가장 큰 값이 존재함.
	1. 루트의 값을 마지막 요소와 바꾼 후, 힙의 사이즈를 하나 줄임
3. 힙의 사이즈가 1보다 크면 위 과정을 반복

### B. 최소 힙

1. 최소 힙을 구성
2. 현재 힙 루트는 가장 작은 값이 존재함.
	1. 루트의 값을 마지막 요소와 바꾼 후, 힙의 사이즈를 하나 줄임
3. 힙의 사이즈가 1보다 크면 위 과정을 반복

# 3. Code

### A. 최대 힙

```python

def heapify(li, idx, n):
	l = idx * 2 + 1
	r = idx * 2 + 2
	s_idx = idx
	
	if (l < n and li[s_idx] < li[l]):
		s_idx = l
	if (r < n and li[s_idx] < li[r]):
		s_idx = r
	if s_idx != idx:
		li[idx], li[s_idx] = li[s_idx], li[idx]
		
		return heapify(li, s_idx, n)
	
def heap_sort(v):
	n = len(v)
	v = [0] + v
	
	for i in range(n//2 - 1, -1, -1):
		heapify(v, i, n)
		
	for i in range(n-1, 0, -1):
		print(v[1])
		v[i], v[1] = v[1], v[i]
		heapify(v, 1, i-1)
		
heap_sort([5, 3, 4, 2, 1])

```

### B. 최소 힙

```python

def heapify(li, idx, n):
	l = idx * 2 + 1
	r = idx * 2 + 2
	s_idx = idx
	
	if (l < n and li[s_idx] > li[l]):
		s_idx = l
	if (r < n and li[s_idx] > li[r]):
		s_idx = r
	if s_idx != idx:
		li[idx], li[s_idx] = li[s_idx], li[idx]
		
		return heapify(li, s_idx, n)
	
def heap_sort(v):
	n = len(v)
	v = [0] + v
	
	for i in range(n//2 - 1, -1, -1):
		heapify(v, i, n)
		
	for i in range(n-1, 0, -1):
		print(v[1])
		v[i], v[1] = v[1], v[i]
		heapify(v, 1, i-1)
		
heap_sort([5, 3, 4, 2, 1])

```

### C. 해설

- heap_sort에서 첫 번째 heapify
	- 일반 배열을 힙으로 구성하는 역할
	- 자식노드로부터 부모노드 비교
	- n/2-1부터 0까지 반복문이 도는 이유
		- 부모 노드의 인덱스를 기준으로 왼쪽 자식 노드 (i * 2 + 1), 오른쪽 자식 노드 (i * 2 + 2)이기 때문
- 두 번째 heapify
	- 요소가 하나 제거된 이후에 다시 최대 힙을 구성하기 위함
	- 루트를 기준으로 진행
- heapify
	- 다시 최대 힙을 구성할 때까지 부모 노드와 자식 노드를 swap하여 재귀 진행
	- 퀵정렬과 합병정렬의 성능이 좋기 때문에 힙 정렬의 사용빈도가 높지는 않음.
	- 하지만 힙 자료구조가 많이 활용되고 있으며, 이때 함께 따라오는 개념이 **힙 정렬**


# 4. 복잡도

### A. 시간복잡도

- 최선 : O(nlogn)
- 최악 : O(nlogn)
- 평균 : O(nlogn)

# 5. 장단점

### A. 힙 소트가 유용할 때

- 가장 크거나 가장 작은 값을 구할 때
	- 최소 힙 or 최대 힙의 루트 값이기 때문에 한번의 힙 구성을 통해 구하는 것이 가능
- 최대 k 만큼 떨어진 요소들을 정렬할 때
	- 삽입정렬보다 더욱 개선된 결과를 얻어낼 수 있음