# 1. 내용

배열의 인덱스를 통해 값을 비교하여 가장 작은 원소를 선택해서 고정하는 방식이다.

# 2. Process

1. 고정되지 않은 배열의 첫 인덱스를 min_index로 지정한다.
2. 인덱스를 증가하며, min_index와 값을 비교한다.
	1. min_index보다 값이 작다면 min_index를 현재 인덱스로 변경한다.
3. 배열의 값을 전부 비교했다면, min_index의 값과 시작 인덱스의 값을 교체한다.
4. 1번으로 돌아가서 배열의 모든 값을 수정할때까지 반복한다.

# 3. Code

```python

def selection_sort(array):
	n = len(array)
	
	for i in range(n):
		min_index = i
		for j in range(i+1, n):
			if array[min_index] > array[j]:
				min_index = j
		array[min_index], array[j] = array[j], array[min_index]
	
	return array

```

# 4. 복잡도

### A. 시간복잡도

최선, 최악, 평균 : O($n^2$)

### B. 공간복잡도

O(n)

# 5. 장단점

### A. 장점

- 구현이 간단하고, 코드가 직관적이다.
- 조건에 맞지 않을 경우, 인덱스만 변경되기 때문에 불필요한 원소의 교환이 발생하지 않는다.
- 제자리 정렬이기 때문에, 불필요한 공간이 필요하지 않는다.

### B. 단점

- 시간복잡도가 O($n^2$)으로 비효율적이다.
- 원소가 교환되기 때문에, 교환 연산이 많이 발생한다.
