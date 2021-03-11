package main

import (
	. "fmt"
	. "io/ioutil"
	. "strconv"
	. "strings"
)

var p = Println

const Part1 = 1
const Part2 = 2

func main() {
	buf, _ := ReadFile("input.txt")
	str := Trim(string(buf), "\n")
	lines := Split(str, "\n")

	for _, line := range lines {
		p(count(line, Part2))
	}
}

const Normal = 0
const MarkerLen = 1
const MarkerRep = 2
const Uncompress = 4

func count(line string, part int) int {
	counter := 0
	mode := Normal
	lenChars := []byte{}
	repChars := []byte{}
	length := 0
	reps := 0
	markedChars := []byte{}

	for i := 0; i < len(line); i++ {
		switch mode {

		case Normal:
			if line[i] == '(' {
				mode = MarkerLen
			} else {
				counter++
			}

		case MarkerLen:
			if line[i] >= '0' && line[i] <= '9' {
				lenChars = append(lenChars, line[i])
			} else if line[i] == 'x' {
				mode = MarkerRep
			} else {
				panic("!")
			}

		case MarkerRep:
			if line[i] >= '0' && line[i] <= '9' {
				repChars = append(repChars, line[i])
			} else if line[i] == ')' {
				mode = Uncompress
				length, _ = Atoi(string(lenChars))
				reps, _ = Atoi(string(repChars))
				lenChars = nil
				repChars = nil
			} else {
				panic("!")
			}

		case Uncompress:
			markedChars = append(markedChars, line[i])
			length--

			if length == 0 {
				if part == Part1 {
					counter += len(markedChars) * reps
				} else if part == Part2 {
					counter += count(string(markedChars), part) * reps
				} else {
					panic("!")
				}

				mode = Normal
				markedChars = nil
			}

		default:
			panic("!")
		}
	}

	return counter
}
