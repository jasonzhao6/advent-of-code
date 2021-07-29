package main

import (
	. "fmt"
	. "io/ioutil"
	. "strconv"
	. "strings"
)

var p = Println

func main() {
	buf, _ := ReadFile("input.txt")
	str := Trim(string(buf), "\n")
	lines := Split(str, "\n")

	// solve(lines)
	solve2(lines)
}

func solve(lines []string) {
	// curr := []string{"a", "b", "c", "d", "e"}
	curr := []string{"a", "b", "c", "d", "e", "f", "g", "h"}
	next := make([]string, len(curr))
	copy(next, curr)

	// p(curr)

	for _, line := range lines {
		tokens := Split(line, " ")

		if HasPrefix(line, "swap position") {
			swap_position(curr, next, tokens[2], tokens[5])
		} else if HasPrefix(line, "swap letter") {
			swap_letter(curr, next, tokens[2], tokens[5])
		} else if HasPrefix(line, "reverse positions") {
			reverse_positions(curr, next, tokens[2], tokens[4])
		} else if HasPrefix(line, "rotate left") {
			rotate_left(curr, next, tokens[2])
		} else if HasPrefix(line, "rotate right") {
			rotate_right(curr, next, tokens[2])
		} else if HasPrefix(line, "move position") {
			move_position(curr, next, tokens[2], tokens[5])
		} else if HasPrefix(line, "rotate based on") {
			rotate_based_on(curr, next, tokens[6])
		}

		for i := 0; i < len(curr); i++ {
			curr[i] = next[i]
		}

		// p(curr)
	}

	p(Join(curr, ""))
}

func solve2(lines []string) {
	curr := []string{"f", "b", "g", "d", "c", "e", "a", "h"}
	next := make([]string, len(curr))
	copy(next, curr)

	// p(curr)

	for i := len(lines) - 1; i >= 0; i-- {
		line := lines[i]
		tokens := Split(line, " ")

		if HasPrefix(line, "swap position") {
			swap_position(curr, next, tokens[2], tokens[5])
		} else if HasPrefix(line, "swap letter") {
			swap_letter(curr, next, tokens[2], tokens[5])
		} else if HasPrefix(line, "reverse positions") {
			reverse_positions(curr, next, tokens[2], tokens[4])
		} else if HasPrefix(line, "rotate left") {
			rotate_right(curr, next, tokens[2])
		} else if HasPrefix(line, "rotate right") {
			rotate_left(curr, next, tokens[2])
		} else if HasPrefix(line, "move position") {
			move_position(curr, next, tokens[5], tokens[2])
		} else if HasPrefix(line, "rotate based on") {
			rotate_based_on_rev(curr, next, tokens[6])
		}

		for i := 0; i < len(curr); i++ {
			curr[i] = next[i]
		}

		// p(curr)
	}

	p(Join(curr, ""))
}

func rotate_based_on_rev(curr, next []string, x string) {
	// 0 => 1
	// 1 => 1 + 2 = 3
	// 2 => 2 + 3 = 5
	// 3 => 3 + 4 = 7
	// 4 => 4 + 6 = 10 % 8 = 2
	// 5 => 5 + 7 = 12 % 8 = 4
	// 6 => 6 + 8 = 14 % 8 = 6
	// 7 => 7 + 9 = 16 % 8 = 0
	rev := map[int]int{
		0: 7,
		1: 0,
		2: 4,
		3: 1,
		4: 5,
		5: 2,
		6: 6,
		7: 3,
	}

	pos := 0

	for i := 0; i < len(curr); i++ {
		if curr[i] == x {
			pos = i
			break
		}
	}

	rotate_left(curr, next, Itoa((pos-rev[pos]+len(curr))%len(curr)))
}

func rotate_based_on(curr, next []string, x string) {
	pos := 0

	for i := 0; i < len(curr); i++ {
		if curr[i] == x {
			pos = i
			break
		}
	}

	// Increment by 1 conditionally
	if pos >= 4 {
		pos++
	}

	// Always increment by 1 again
	pos++

	rotate_right(curr, next, Itoa(pos))
}

func move_position(curr, next []string, x, y string) {
	xi, _ := Atoi(x)
	yi, _ := Atoi(y)

	if yi > xi {
		for i := xi; i < yi; i++ {
			next[i] = curr[i+1]
		}

		next[yi] = curr[xi]
	} else if xi > yi {
		for i := yi + 1; i <= xi; i++ {
			next[i] = curr[i-1]
		}

		next[yi] = curr[xi]
	} else {
		panic("!")
	}
}

func rotate_left(curr, next []string, x string) {
	xi, _ := Atoi(x)

	for i := 0; i < len(curr); i++ {
		next[i] = curr[(i+xi+len(curr))%len(curr)]
	}
}

func rotate_right(curr, next []string, x string) {
	xi, _ := Atoi(x)

	for i := 0; i < len(curr); i++ {
		next[i] = curr[(i-xi+len(curr)*2)%len(curr)]
	}
}

func reverse_positions(curr, next []string, x, y string) {
	xi, _ := Atoi(x)
	yi, _ := Atoi(y)

	for i := 0; i <= yi-xi; i++ {
		next[xi+i] = curr[(yi-i+len(curr))%len(curr)]
	}
}

func swap_letter(curr, next []string, x, y string) {
	for i := 0; i < len(curr); i++ {
		if next[i] == x {
			next[i] = y
		} else if next[i] == y {
			next[i] = x
		}
	}
}

func swap_position(curr, next []string, x, y string) {
	xi, _ := Atoi(x)
	yi, _ := Atoi(y)

	next[xi], next[yi] = next[yi], next[xi]
}
