# Table of Contents

- [1. Routing](#1-routing)
  - [A. 전체 네트워크에 있는 노드 수가 한정되어 있다면](#a-전체-네트워크에-있는-노드-수가-한정되어-있다면)
  - [B. 노드 수가 무한하다면](#b-노드-수가-무한하다면)
  - [C. Routing](#c-routing)
- [2. Routing Protocol Algorithm](#2-routing-protocol-algorithm)
- [3. Routing Table](#3-routing-table)
  - [a. 라우팅 테이블이 하는 역할](#a-라우팅-테이블이-하는-역할)

---

# 1. Routing

 - 목적지가 주어졌을때, 각각의 네트워크 중앙에 있는 장비들이 패킷을 받으면, 다음 단계(next hop)로 넘겨주는 것
 - 다음 단계가 지금보다는 조금 더 목적지에 가까워야함.
 - 패킷을 받아서 IP 주소를 보고 다음 hop을 어느 link를 사용해야 하는지 판단하는 것

 ## A. 전체 네트워크에 있는 노드 수가 한정되어 있다면
 
> 다음 단계로 갈때마다 목적지에 가까워진다고 생각했을 때

- 최종적으로 유한한 단계 안에 목적지에 도달하게 됨
- 다음 단계로 갈수록 목적지에 가까워지다보면, 최종적으로 목적지에 도착하게 됨

## B. 노드 수가 무한하다면

> 다음 단계로 갈때마다 목적지에 가까워진다고 생각했을 때

- 최종적으로 목적지에 도달하지 못함

![](/bin/Network_image/network_7_7.png)

## C. Routing

> 어떤 패킷이 있고, 다음 hop이 현재 hop보다 목적지에 가깝다면, 최종적으로 목적지에 갈 수 있다.

# 2. [Routing Protocol Algorithm](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Routing%20Protocol%20Algorithm.md)

# 3. Routing Table

- 라우팅 테이블 안에는 목적지(dest), 비용(cost), 다음 노드(next hop)가 적혀있어야 한다.
- 목적지는 전세계 ip를 cover해야 한다.

---

## a. 라우팅 테이블이 하는 역할

- Next hop이라는 함수를 구현하고자 한다.
	- 목적지 IP주소를 인자로 주면 다음 hop node를 반환한다.
	- Nexthop(목적지 IP) = 다음 hop Node
- 어떤 목적지 IP주소가 오더라도 다음 hop이 결정되어야 한다.
- 다만, 이를 구현하려면 라우팅 테이블에 모든 목적지 IP 주소가 입력되어야 한다.
	- 이는 매우 비효율적인 방법이다.
	- 따라서, 목적지 IP 주소가 비슷한 곳에 있다면, Next hop은 같을 것이기 때문에 묶어서 표현해보자.
		- [subnet#2 Routing Table과 subnet](https://github.com/mildsalmon/Study/blob/Network/Network/docs/subnet.md#2-routing-table%EA%B3%BC-subnet)

