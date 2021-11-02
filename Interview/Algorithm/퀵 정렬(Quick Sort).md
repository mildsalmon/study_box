# 1. 내용

피벗값을 정하고 피벗값보다 작으면 왼쪽, 크면 오른쪽으로 수를 분리한다. 이를 원소가 1개 남을때까지 반복한다.

피벗을 이용해 정렬 -> 배열을 쪼갬

# 2. Process

1. 피벗값을 정한다.
2. 피벗값을 기준으로 작은 값은 왼쪽에 큰 값은 오른쪽에 위치시킨다.
3. 만약 원소가 1개 이하면, 값을 리턴한다.
4. 이 과정을 반복한다.

# 3. Code

```python

def quick_sort(array):
	if len(array) <= 1:
		return array
	
	pivot = array[0]
	tail = array[1:]
	
	left_array = []
	right_array = []
	
	for i in tail:
		if i <= pivot:
			left_array.append(i)
		elif i > pivot:
			right_array.append(i)
	
	return quick_sort(left_array) + [pivot] + quick_sort(right_array)

```

# 4. 복잡도

### A. 시간복잡도

- 최선 : O(nlogn)
- 최악 : O($n^2$)
- 평균 : O(nlogn)

### B. 공간복잡도

O(n)

# 5. 장단점

### A. 장점

- 불필요한 데이터의 이동을 줄이고 먼 거리의 데이터를 교환할 뿐만 아니라, 한 번 결정된 피벗들이 추후 연산에서 제외되는 특성 때문에, 시간 복잡도가 O(nlogn)을 가지는 다른 정렬 알고리즘과 비교했을때도 가장 빠르다.

### B. 단점

- 불안정 정렬이다.
- 정렬된 배열에서는 오히려 시간복잡도가 O($n^2$)으로 오래걸린다.
