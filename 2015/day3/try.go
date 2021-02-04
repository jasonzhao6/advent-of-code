package main

import (
	. "fmt"
	. "io/ioutil"
	. "strings"
)

var p = Println

func main() {
	buf, _ := ReadFile("input.txt")
	str := Trim(string(buf), "\n")
	lines := Split(str, "\n")

	solve(lines[0])
	solve2(lines[0])
}

func solve(line string) {
	hsh := make(map[complex128]int)
	num := 0 + 0i

	// Origin always gets the 1st present.
	hsh[num]++

	// Count how many presents each house gets.
	for _, chr := range line {
		switch string(chr) {
		case "^":
			num += 1i
		case ">":
			num += 1
		case "v":
			num -= 1i
		case "<":
			num -= 1
		default:
			panic("!")
		}

		hsh[num]++
	}

	// How many houses received 1+ presents?
	cnt := 0
	for _, v := range hsh {
		if v > 0 {
			cnt++
		}
	}

	p(cnt)
}

func solve2(line string) {
	hsh := make(map[complex128]int)
	nums := [2]complex128{0 + 0i, 0 + 0i}

	// Origin always gets the 1st 2 presents.
	hsh[nums[0]]++
	hsh[nums[1]]++

	// Count how many presents each house gets.
	for k, chr := range line {
		switch string(chr) {
		case "^":
			nums[k%2] += 1i
		case ">":
			nums[k%2] += 1
		case "v":
			nums[k%2] -= 1i
		case "<":
			nums[k%2] -= 1
		default:
			panic("!")
		}

		hsh[nums[k%2]]++
	}

	// How many houses received 1+ presents?
	cnt := 0
	for _, v := range hsh {
		if v > 0 {
			cnt++
		}
	}

	p(cnt)
}
