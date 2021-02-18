package main

// https://github.com/SimonWaldherr/golang-examples/blob/master/advanced/pcre.go
import "github.com/glenn-brown/golang-pkg-pcre/src/pkg/pcre"

import (
	. "fmt"
	. "io/ioutil"
	"regexp"
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
		// Contains at least 3 vowels.
		cond1 := regexp.MustCompile(`(.*[aeiou]){3}`)

		// Contains at least 1 repeating letter.
		cond2 := pcre.MustCompile(`([a-z])\1`, 0)

		// Does not contain any of these:
		cond3 := regexp.MustCompile(`(ab|cd|pq|xy)`)

		if cond1.MatchString(line) &&
			cond2.MatcherString(line, 0).Matches() &&
			!cond3.MatchString(line) {
			cnt++
		}
	}

	p(cnt)
}

func solve2(lines []string) {
	cnt := 0

	for _, line := range lines {
		// Contains at least 1 pair of letters twice.
		cond1 := pcre.MustCompile(`([a-z]{2}).*\1`, 0)

		// Contains at least 1 repeating letter with exactly one letter between them.
		cond2 := pcre.MustCompile(`([a-z]).\1`, 0)

		if cond1.MatcherString(line, 0).Matches() &&
			cond2.MatcherString(line, 0).Matches() {
			cnt++
		}
	}

	p(cnt)
}
