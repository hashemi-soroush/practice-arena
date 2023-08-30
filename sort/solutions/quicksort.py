from random import randint
from typing import Sequence, MutableSequence, Protocol, TypeVar

class GreaterThan(Protocol):
	def __gt__(self, other) -> bool: ...

T = TypeVar('T', bound=GreaterThan)


def main():
	arr = read_array()
	quicksort(arr, 0, len(arr)-1)
	print(' '.join(str(x) for x in arr))


def read_array() -> Sequence[GreaterThan]:
	n = int(input())
	arr = [int(x) for x in input().split()]
	return arr


def quicksort(arr: MutableSequence[GreaterThan], left: int, right: int):
	if left < right:
		p_ind = select_pivot(arr, left, right)
		mid_ind = partition(arr, left, right, p_ind)
		quicksort(arr, left, mid_ind)
		quicksort(arr, mid_ind+1, right)


def select_pivot(arr: Sequence[GreaterThan], left: int, right: int) -> int:
	p_ind = randint(left, right)
	return p_ind


def partition(arr: MutableSequence[GreaterThan], left: int, right: int, p_ind: int) -> int:
	arr[right], arr[p_ind] = arr[p_ind], arr[right]
	swap_ind = right - 1
	i = left
	while i <= swap_ind:
		if arr[i] < arr[right]:
			i += 1
			continue
		arr[i], arr[swap_ind] = arr[swap_ind], arr[i]
		swap_ind -= 1
	arr[swap_ind+1], arr[right] = arr[right], arr[swap_ind+1]
	return swap_ind+1


if __name__ == '__main__':
	main()
