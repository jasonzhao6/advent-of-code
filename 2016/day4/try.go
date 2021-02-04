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

type tally struct {
	chr string
	cnt int
}

func checksum(strs string) string {
	str := Replace(strs, "-", "", -1)
	hsh := make(map[string]int)
	arr := []tally{}
	top5 := make([]string, 5)

	// Tally chars in the string.
	for _, chr := range str {
		hsh[string(chr)]++
	}

	// Store tallies as an array of structs, so that we can sort it.
	for k, v := range hsh {
		arr = append(arr, tally{k, v})
	}

	// First sort by count, then alphabetically.
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

	return Join(top5, "")
}

const ascii_a = 97
const alphabet = 26

func shift(strs string, key int) string {
	shifted := make([]string, len(strs))

	for i, chr := range strs {
		if string(chr) == "-" {
			shifted[i] = " "
		} else {
			shifted[i] = string((int(chr)-ascii_a+key)%alphabet + ascii_a)
		}
	}

	return Join(shifted, "")
}

func solve(lines []string) {
	// E.g: nzydfxpc-rclop-qwzhpc-qtylyntyr-769[oshgk]
	regex := MustCompile("(?P<strs>[a-z-]+)-(?P<num>[0-9]+)\\[(?P<checksum>[a-z]+)\\]")
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

		num, err := Atoi(named["num"])
		if err != nil {
			panic("!")
		}

		// Part 1
		if checksum(named["strs"]) == named["checksum"] {
			p1_sum += num
		}

		// Part 2
		if HasPrefix(shift(named["strs"], num), "north") {
			p2_id = num
		}
	}

	p(p1_sum)
	p(p2_id)
}
