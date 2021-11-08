# 1. 내용

최소 공통 조상 찾는 알고리즘 (두 정점이 만나는 최초의 부모 정점을 찾는 것)

![](https://media.geeksforgeeks.org/wp-content/cdn-uploads/lca.png)

위 트리에서 4와 5의 LCA는 2
4와 6의 LCA는 1

# 2. Process

- 해당 정점의 depth와 parent를 저장해주는 방식이다.

```

[depth : 정점]
0 -> 1 (root 정점)
1 -> 2, 3
2 -> 4, 5, 6, 7

```

parent는 정점마다 가지는 부모 정점을 저장해둔다.

```

# 1~7번 정점 (root는 부모가 없기 때문에 0)

int parent[] = {0, 1, 1, 2, 2, 3, 3}

```

위 두 배열을 활용해서 두 정점이 주어졌을 때 LCA를 찾을 수 있다.

```

# 두 정점의 depth 확인하기

while(true):
	if(depth가 일치):
		if 두 정점의 parent 일치:
			LCA 찾음
			break
		else:
			두 정점을 자신의 parent 정점 값으로 변경
	else:
		더 depth가 깊은 정점을 해당 정점의 parent 정점으로 변경 (depth가 감소됨)


```
