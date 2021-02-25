package main

import (
	. "fmt"
	. "io/ioutil"
	. "regexp"
	. "strconv"
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

const size = 1000

func solve(lines []string) {
	grid := [size][size]bool{}

	for _, line := range lines {
		matches := parse(line)
		x, _ := Atoi(matches["x"])
		xx, _ := Atoi(matches["xx"])
		y, _ := Atoi(matches["y"])
		yy, _ := Atoi(matches["yy"])

		for i := x; i <= xx; i++ {
			for j := y; j <= yy; j++ {
				switch matches["cmd"] {
				case "turn on":
					grid[i][j] = true
				case "turn off":
					grid[i][j] = false
				case "toggle":
					grid[i][j] = !grid[i][j]
				default:
					panic("!")
				}
			}
		}
	}

	cnt := 0

	for i := 0; i < size; i++ {
		for j := 0; j < size; j++ {
			if grid[i][j] {
				cnt++
			}
		}
	}

	p(cnt)
}

func solve2(lines []string) {
	grid := [size][size]int{}

	for _, line := range lines {
		matches := parse(line)
		x, _ := Atoi(matches["x"])
		xx, _ := Atoi(matches["xx"])
		y, _ := Atoi(matches["y"])
		yy, _ := Atoi(matches["yy"])

		for i := x; i <= xx; i++ {
			for j := y; j <= yy; j++ {
				switch matches["cmd"] {
				case "turn on":
					grid[i][j]++
				case "turn off":
					grid[i][j]--
					if grid[i][j] < 0 {
						grid[i][j] = 0
					}
				case "toggle":
					grid[i][j] += 2
				default:
					panic("!")
				}
			}
		}
	}

	cnt := 0

	for i := 0; i < size; i++ {
		for j := 0; j < size; j++ {
			cnt += grid[i][j]
		}
	}

	p(cnt)
}

func parse(line string) map[string]string {
	// E.g: turn on 0,0 through 999,999
	regex := MustCompile("(?P<cmd>[a-z ]+) (?P<x>[0-9]+),(?P<y>[0-9]+) through (?P<xx>[0-9]+),(?P<yy>[0-9]+)")
	matches := regex.FindStringSubmatch(line)
	named := make(map[string]string)

	// Get named matches.
	for i, name := range regex.SubexpNames() {
		if i != 0 && name != "" {
			named[name] = matches[i]
		}
	}

	return named
}
