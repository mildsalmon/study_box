# 1. 내용

정렬해야하는 배열에서 특정 번호의 원소를 세서 특정 번호의 인덱스에 저장함.

저장 공간을 희생하여 시간 복잡도를 단축시키는 방법

정렬하는 숫자가 특정한 범위 내에 있을 때 사용한다.

# 2. Process

1. 배열을 가운데를 기준으로 나눈다.
	1. 이것을 배열 안의 원소가 1개 남을때까지 반복한다.
2. 분할된 배열을 다시 합친다.
	1. 이 과정에서 값을 비교하여 정렬한다.

# 3. Code

```python

def counting_sort(array):
    answer = [0] * (max(array) + 1)

    for i in array:
        answer[i] += 1

    for i, k in enumerate(answer):
        if k != 0:
            for j in range(k):
                print(i)

    return answer

```

# 4. 복잡도

### A. 시간복잡도

- 최선 : O(n + k)

### B. 공간복잡도

O(k)

# 5. 장단점

### A. 장점

- 시간 복잡도가 작음

### B. 단점

- 메모리 낭비가 심함.
