# 1. 내용

mid 값을 target 값과 비교하여 같다면 mid 값의 인덱스를 반환하고, mid 값이 target 값보다 크면 end = mid - 1, mid 값이 target 값보다 작다면 start = mid + 1을 주고 start <= end를 만족하지 않을 떄까지 반복하여 target 값의 위치를 찾는다.

기본적으로 이분탐색은 배열이 정렬되어 있어야 한다.

# 2. Process

1. start = 0, end = len(array), mid = (start + end) // 2
2. array[mid] == target인 인덱스를 찾는다
	1. array[mid] == target인 경우에 mid를 반환한다.
3. 그렇지 않을 경우
	1. array[mid] > target인 경우 end = mid - 1
	2. array[mid] < target인 경우 start = mid + 1
4. start <= end를 만족하지 않을 때까지 반복한다.

# 3. Code

```python

def binary_code(array, target):
	array.sort()
	
	start = 0
	end = len(array)
	
	while start <= end:
		mid = (start + end) // 2
		
		if array[mid] == target:
			return mid
		
		if array[mid] < target:
			mid = start + 1
		elif array[mid] > target:
			mid = end - 1
		
	return None

```

if-elif를 사용한 이유는 비교 연산에서 초과(<), 미만(>), 동등(\=\=) 외의 경우는 없을 것이라고 생각했다. 비교 연산자의 오퍼랜드(피연산자)가 전부 동일하기 때문에 위와 같이 작성했다.

# 4. 복잡도

### A. 시간복잡도

- 최선 : O(logn)

# 5. 장단점

### A. 장점

- 처음부터 끝까지 돌면서 탐색하는 것보다 훨씬 빠르다.