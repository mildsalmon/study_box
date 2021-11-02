# 1. 내용

배열의 가운데를 기준으로 분할하고, 다시 병합할 때 정렬한다.

영역을 쪼갤 수 있을 만큼 쪼갬 -> 정렬

# 2. Process

1. 배열을 가운데를 기준으로 나눈다.
	1. 이것을 배열 안의 원소가 1개 남을때까지 반복한다.
2. 분할된 배열을 다시 합친다.
	1. 이 과정에서 값을 비교하여 정렬한다.

# 3. Code

```python

def merge_sort(array):
	if len(array) <= 1:
		return array
	
	partition = len(array) // 2
	
	left_array = merge_sort(array[:partition])
	right_array = merge_sort(array[partition:])
	
	l = 0
	r = 0
	
	result = []
	
	while l < len(left_array) and r < len(right_array):
		if left_array[l] < right_array[r]:
			result.append(left_array[l])
			l += 1
		elif right_array[r] <= left_array[l]:
			result.append(right_array[r])
			r += 1
	
	result += left_array[l:]
	result += right_array[r:]
	
	return result

```

# 4. 복잡도

### A. 시간복잡도

- 최선 : O(nlogn)
- 최악 : O(nlogn)
- 평균 : O(nlogn)

### B. 공간복잡도

O(n)

# 5. 장단점

### A. 장점

- 안정 정렬이다.
- 합병의 대상이 되는 두 영역이 각 영역에 대해서 정렬이 되어있기 때문에 단순히 두 배열을 순차적으로 비교하면서 정렬할 수 있다.
- 순차적인 비교로 정렬을 진행하므로, Linked List의 정렬이 필요할 때 사용하면 효율적이다.
