# 1. 내용

가장 긴 증가하는 수열

\[7, 2, 3, 8, 4, 5\] -> \[2, 3, 4, 5\]가 LIS로 답은 4

---

$N^2$으로 해결할 수 없는 문제(배열의 길이가 최대 10만개일때)이면 Lower Bound를 활용한 LIS 구현을 진행해야한다.

---

# 2. Process

1. DP를 0으로 초기화한다.
	1. 1번 인덱스는 1로 변경한다.
2. 수열의 값을 1번 인덱스부터 하나씩 선택한다.
3. 나보다 인덱스가 앞에 있는 수열과 비교해서 내가 크다면 상대방 dp 값 + 1과 내 값을 비교하여 최댓값으로 변경한다.

# 3. Code

```python

def LIS(array, dp):
	dp[0] = 1
	
	for i in range(1, len(array)):
		for j in range(i):
			if array[i] > array[j]:
				dp[i] = max(dp[i], dp[j] + 1)
	
array = [7, 2, 3, 8, 4, 5]
dp = [0] * len(array)

LIS(array, dp)

```


# 4. 복잡도

### A. 시간복잡도

- DP : O($N^2$)
- Lower Bound : O(NlogN)
