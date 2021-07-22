package main

import (
	. "fmt"
	. "io/ioutil"
	. "sort"
	. "strconv"
	. "strings"
)

var p = Println

type Range struct {
	start int
	end   int
}

func main() {
	buf, _ := ReadFile("input.txt")
	str := Trim(string(buf), "\n")
	lines := Split(str, "\n")

	// Idea:
	// Sort input numerically
	// Go through the sorted list
	// Find the lowest num that's not blocked

	ranges := []Range{}

	for _, line := range lines {
		nums := Split(line, "-")
		num1, _ := Atoi(nums[0])
		num2, _ := Atoi(nums[1])
		pair := Range{num1, num2}
		ranges = append(ranges, pair)
	}

	Slice(ranges, func(i, j int) bool {
		return ranges[i].start < ranges[j].start
	})

	solve(ranges)
	solve2(ranges)
}

func solve(ranges []Range) {
	lowest := 0

	for _, pair := range ranges {
		if lowest < pair.start {
			p(lowest)
			return
		}

		if lowest < pair.end+1 {
			lowest = pair.end + 1
		}
	}
}

func solve2(ranges []Range) {
	lowest := 0
	allow_count := 0

	for _, pair := range ranges {
		if lowest < pair.start {
			allow_count += pair.start - lowest
		}

		if lowest < pair.end+1 {
			lowest = pair.end + 1
		}
	}

	p(allow_count)
}
