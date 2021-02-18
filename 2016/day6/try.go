package main

import (
	. "fmt"
	. "io/ioutil"
	. "strings"
)

var p = Println

const ALPHABET_SIZE = 26

func main() {
	buf, _ := ReadFile("input.txt")
	str := Trim(string(buf), "\n")
	lines := Split(str, "\n")

	p(solve(lines))
	p(solve2(lines))
}

func solve(lines []string) string {
	width := len(lines[0])

	// Array of array to keep track of all counts.
	m := make([][]int, width)
	for i := 0; i < width; i++ {
		m[i] = make([]int, ALPHABET_SIZE)
	}

	// Array to keep track of current winners.
	a := make([]rune, width)

	for _, line := range lines {
		for i, chr := range line {
			offset := chr - 'a'
			m[i][offset]++
			cnt := m[i][offset]

			if a[i] == 0 || cnt > m[i][a[i]-'a'] {
				a[i] = chr
			}
		}
	}

	return string(a)
}

func solve2(lines []string) string {
	width := len(lines[0])

	// Array of array to keep track of all counts.
	m := make([][]int, width)
	for i := 0; i < width; i++ {
		m[i] = make([]int, ALPHABET_SIZE)
	}

	// Array to keep track of final winners.
	a := make([]rune, width)

	for _, line := range lines {
		for i, chr := range line {
			m[i][chr-'a']++
		}
	}

	for k, v := range m {
		var winChr int
		var winCnt int

		for chr, cnt := range v {
			if cnt != 0 && (winCnt == 0 || winCnt > cnt) {
				winCnt = cnt
				winChr = chr
			}
		}

		a[k] = rune(winChr) + 'a'
	}

	return string(a)
}
