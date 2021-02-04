package main

import (
	. "fmt"
	. "io/ioutil"
	. "regexp"
	"sort"
	. "strconv"
	. "strings"
)

var p = Println

func main() {
	buf, _ := ReadFile("input.txt")
	str := Trim(string(buf), "\n")
	lines := Split(str, "\n")

	solve(lines)
}

func solve(lines []string) {
	// E.g: nzydfxpc-rclop-qwzhpc-qtylyntyr-769[oshgk]
	regex := MustCompile("(?P<str>[a-z-]+)-(?P<id>[0-9]+)\\[(?P<checksum>[a-z]+)\\]")
	names := regex.SubexpNames()
	p1_sum := 0
	p2_id := 0

	for _, line := range lines {
		matches := regex.FindStringSubmatch(line)
		named := make(map[string]string)

		// Get named matches.
		for i, name := range names {
			if i != 0 && name != "" {
				named[name] = matches[i]
			}
		}

		if checksum(named["str"]) == named["checksum"] {
			id, _ := Atoi(named["id"])

			// Part 1
			p1_sum += id

			// Part 2
			if HasPrefix(shift(named["str"], id), "north") {
				p2_id = id
			}
		}
	}

	p(p1_sum)
	p(p2_id)
}

type tally struct {
	chr rune
	cnt int
}

func checksum(str string) string {
	str = Replace(str, "-", "", -1)
	hsh := make(map[rune]int)
	arr := []tally{}
	top5 := make([]rune, 5)

	// Tally char counts into a hash.
	for _, chr := range str {
		hsh[chr]++
	}

	// Store tally result as an array of structs, so that we can sort them.
	for k, v := range hsh {
		arr = append(arr, tally{k, v})
	}

	// Sort tally result by count, tie break by char alphabetically.
	sort.Slice(arr, func(i, j int) bool {
		if arr[i].cnt == arr[j].cnt {
			return arr[i].chr < arr[j].chr
		} else {
			return arr[i].cnt > arr[j].cnt
		}
	})

	// Extract the top 5 chars.
	for i, obj := range arr[0:5] {
		top5[i] = obj.chr
	}

	return string(top5)
}

const ascii_a rune = 97
const ascii_dash rune = 45
const ascii_space rune = 32
const alphabet rune = 26

func shift(str string, key int) string {
	shifted := make([]rune, len(str))

	for i, chr := range str {
		if chr == ascii_dash {
			shifted[i] = ascii_space
		} else {
			shifted[i] = (chr-ascii_a+rune(key))%alphabet + ascii_a
		}
	}

	return string(shifted)
}
