package main

import (
	. "fmt"
	. "io/ioutil"
	. "strings"
)

var p = Printf

var dirs = map[string]int{
	"U": 0,
	"R": 1,
	"D": 2,
	"L": 3,
}

// 1 2 3
// 4 5 6
// 7 8 9
var nbors = [][]int{
	{},           // 0
	{0, 2, 4, 0}, // U, R, D, L
	{0, 3, 5, 1},
	{0, 0, 6, 2},
	{1, 5, 7, 0},
	{2, 6, 8, 4},
	{3, 0, 9, 5},
	{4, 8, 0, 0},
	{5, 9, 0, 7},
	{6, 0, 0, 8},
}

//     1
//   2 3 4
// 5 6 7 8 9
//   A B C
//     D
var nbors2 = [][]int{
	{},           // 0
	{0, 0, 3, 0}, // U, R, D, L
	{0, 3, 6, 0},
	{1, 4, 7, 2},
	{0, 0, 8, 3},
	{0, 6, 0, 0},
	{2, 7, 10, 5},
	{3, 8, 11, 6},
	{4, 9, 12, 7},
	{0, 0, 0, 8},
	{6, 11, 0, 0},
	{7, 12, 13, 10},
	{8, 0, 0, 11},
	{11, 0, 0, 0},
}

func main() {
	buf, _ := ReadFile("input.txt")
	str := Trim(string(buf), "\n")
	lines := Split(str, "\n")

	solve(lines, nbors)
	p("\n")
	solve(lines, nbors2)
}

func solve(lines []string, hsh [][]int) {
	num := 5

	for _, line := range lines {
		for _, cmd := range Split(line, "") {
			next := hsh[num][dirs[cmd]]

			if next != 0 {
				num = next
			}
		}

		p("%X", num)
	}
}
