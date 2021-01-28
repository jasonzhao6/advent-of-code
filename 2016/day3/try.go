package main

import (
	. "fmt"
	. "io/ioutil"
	"sort" // Not using `.` b/c `sort.Ints()` makes more sense than just `Ints()`.
	. "strconv"
	. "strings"
)

var p = Println

func main() {
	buf, _ := ReadFile("input.txt")
	str := Trim(string(buf), "\n")
	lines := Split(str, "\n")

	solve(lines)
	solve2(lines)
}

func solve(lines []string) {
	cnt := 0

	for _, line := range lines {
		n1, _ := Atoi(Trim(line[0:5], " "))
		n2, _ := Atoi(Trim(line[5:10], " "))
		n3, _ := Atoi(Trim(line[10:15], " "))

		nums := []int{n1, n2, n3}
		sort.Ints(nums)

		if nums[0]+nums[1] > nums[2] {
			cnt++
		}
	}

	p(cnt)
}

func solve2(lines []string) {
	var grid [][]int

	for _, line := range lines {
		n1, _ := Atoi(Trim(line[0:5], " "))
		n2, _ := Atoi(Trim(line[5:10], " "))
		n3, _ := Atoi(Trim(line[10:15], " "))

		grid = append(grid, []int{n1, n2, n3})
	}

	grid = transpose(grid)
	cnt := 0

	for _, row := range grid {
		for i := 0; i < len(row); i += 3 {
			nums := []int{row[i], row[i+1], row[i+2]}
			sort.Ints(nums)

			if nums[0]+nums[1] > nums[2] {
				cnt++
			}
		}
	}

	p(cnt)
}

// https://gist.github.com/tanaikech/5cb41424ff8be0fdf19e78d375b6adb8
func transpose(slice [][]int) [][]int {
	xl := len(slice[0])
	yl := len(slice)
	result := make([][]int, xl)
	for i := range result {
		result[i] = make([]int, yl)
	}
	for i := 0; i < xl; i++ {
		for j := 0; j < yl; j++ {
			result[i][j] = slice[j][i]
		}
	}
	return result
}
