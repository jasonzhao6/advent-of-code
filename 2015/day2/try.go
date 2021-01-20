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

	paper := 0
	ribbon := 0

	for _, line := range Split(str, "\n") {
		nums := make([]int, 3)

		for i, num := range Split(line, "x") {
			nums[i], _ = Atoi(num)
		}

		sort.Ints(nums)

		paper += nums[0]*nums[1]*3 +
			nums[0]*nums[2]*2 +
			nums[1]*nums[2]*2

		ribbon += nums[0]*2 +
			nums[1]*2 +
			nums[0]*nums[1]*nums[2]
	}

	p(paper, ribbon)
}
