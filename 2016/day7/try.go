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

	p(solve(lines))
	p(solve2(lines))
}

func solve(lines []string) int {
	cnt := 0

	for _, line := range lines {
		if is_abba_line(line) {
			cnt++
		}
	}

	return cnt
}

func solve2(lines []string) int {
	cnt := 0

	for _, line := range lines {
		if is_aba_line(line) {
			cnt++
		}
	}

	return cnt
}

func is_aba_line(line string) bool {
	line = Replace(line, "[", "]", -1)
	chunks := Split(line, "]")
	abas := []string{}

	// Collect ABAs
	for i := 1; i < len(chunks); i = i + 2 {
		abas = append(abas, collect_abas(chunks[i])...)

	}

	// Look for ABAs
	for i := 0; i < len(chunks); i = i + 2 {
		for _, aba := range abas {
			if Contains(chunks[i], aba) {
				return true
			}
		}
	}

	return false
}

func collect_abas(chunk string) []string {
	abas := []string{}

	for i := 0; i < len(chunk)-2; i++ {
		if chunk[i] == chunk[i+2] && chunk[i] != chunk[i+1] {
			abas = append(abas, Sprintf("%c%c%c", chunk[i+1], chunk[i], chunk[i+1]))
		}
	}

	return abas
}

func is_abba_line(line string) bool {
	line = Replace(line, "[", "]", -1)
	chunks := Split(line, "]")

	// Negatives
	for i := 1; i < len(chunks); i = i + 2 {
		// p(chunks[i], is_abba_chunk(chunks[i]))

		if is_abba_chunk(chunks[i]) {
			return false
		}
	}

	// Positives
	for i := 0; i < len(chunks); i = i + 2 {
		// p(chunks[i], is_abba_chunk(chunks[i]))

		if is_abba_chunk(chunks[i]) {
			return true
		}
	}

	return false
}

func is_abba_chunk(chunk string) bool {
	for i := 0; i < len(chunk)-3; i++ {
		if chunk[i] == chunk[i+3] && chunk[i+1] == chunk[i+2] && chunk[i] != chunk[i+1] {
			return true
		}
	}
	return false
}
