package main

import (
	. "fmt"
)

var p = Println

const INPUT = 3014387

func main() {
	solve()
	solve2()
}

func solve() {
	var arr [INPUT]int
	for i := range arr {
		arr[i] = (i + 1) % INPUT
	}

	i := 0
	for i != arr[i] {
		arr[i] = arr[arr[i]]
		i = arr[i]
	}
	p(i + 1)
}

/////////
// Part 2
/////////

// 2.5
// 1 2 3 4 5
// ^
//
// 2
// 1 2 _ 4 5 EVEN => 2
//   ^
//
// 1.5
// 1 2 _ 4 _ ODD => 1
//       ^
//
// 1
// _ 2 _ 4 _ EVEN => 2
//   ^
//
// 1
// _ 2 _ _ _
//   ^
//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//
// 3
// 1 2 3 4 5 6
// ^
//
// 2.5
// 1 2 3 _ 5 6
//   ^
//
// 2
// 1 2 3 _ _ 6
//     ^
//
// 1.5
// _ 2 3 _ _ 6
//           ^
//
// 1
// _ _ 3 _ _ 6
//     ^
//
// 1
// _ _ 3 _ _ _
//     ^
//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//
// 3.5
// 1 2 3 4 5 6 7
// ^
//
// 3
// 1 2 3 _ 5 6 7
//   ^
//
// 2.5
// 1 2 3 _ 5 _ 7
//     ^
//
// 2
// 1 2 3 _ 5 _ _
//         ^
//
// 1.5
// 1 _ 3 _ 5 _ _
// ^
//
// 1
// 1 _ _ _ 5 _ _
//         ^
//
// 1
// _ _ _ _ 5 _ _
//         ^
//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//
// Use `len/2-1` to set cursor
// 'Kill' the next number
// LOOP:
//   if len is odd
//     kill the next number
//   if len is even
//     advance cursor
//     kill the next number
// Until 1 number left

func solve2() {
	var arr [INPUT]int
	for i := range arr {
		arr[i] = (i + 1) % INPUT
	}

	i := len(arr)/2 - 1
	arr[i] = arr[arr[i]]
	cnt := INPUT - 1

	for i != arr[i] {
		if cnt%2 == 1 {
			arr[i] = arr[arr[i]]
		} else {
			i = arr[i]
			arr[i] = arr[arr[i]]
		}

		cnt--
	}

	p(i + 1)
}
