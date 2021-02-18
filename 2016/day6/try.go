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

	solve(lines)
	solve2(lines)
}

func solve(lines []string) {
	// Map of map to keep track of all counts.
	m := make(map[int]map[rune]int)
	for i, _ := range lines[0] {
		m[i] = make(map[rune]int)
	}

	// Array to keep track of current winners.
	a := make([]rune, len(lines[0]))

	for _, line := range lines {
		for i, chr := range line {
			m[i][chr]++
			cnt := m[i][chr]

			if cnt > m[i][a[i]] {
				a[i] = chr
			}
		}
	}

	p(string(a))
}

func solve2(lines []string) {
	// Map of map to keep track of all counts.
	m := make(map[int]map[rune]int)
	for i, _ := range lines[0] {
		m[i] = make(map[rune]int)
	}

	// Array to keep track of final winners.
	a := make([]rune, len(lines[0]))

	for _, line := range lines {
		for i, chr := range line {
			m[i][chr]++
		}
	}

	for k, v := range m {
		var winChr rune
		var winCnt int

		for chr, cnt := range v {
			if winCnt == 0 || winCnt > cnt {
				winCnt = cnt
				winChr = chr
			}
		}

		a[k] = winChr
	}

	p(string(a))
}
