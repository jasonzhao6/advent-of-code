// Part 2
//
// Given-
// 6: 6120 - 720 = 5400
// 7: 10440 - 5040 = 5400
// 8: 45720 - 40320 = 5400
//
// Derive-
// 12: 479,001,600 + 5400 = 479007000

package main

import (
	. "fmt"
	. "io/ioutil"
	. "strconv"
	. "strings"
)

var p = Println

var reg = map[string]int{"a": 8}

func main() {
	buf, _ := ReadFile("input.txt")
	str := Trim(string(buf), "\n")
	lines := Split(str, "\n")

	solve(lines)
}

func solve(lines []string) {
	for ptr := 0; ptr < len(lines); ptr++ {
		cmd, arg1, arg2 := parse(lines[ptr])
		execute(cmd, arg1, arg2, &ptr, lines)

		// p(getVal("a"), getVal("b"), getVal("c"), getVal("d"))
	}

	p(reg["a"])
}

func execute(cmd string, arg1 string, arg2 string, ptr *int, lines []string) {
	val1 := getVal(arg1)
	val2 := getVal(arg2)

	switch cmd {
	case "cpy":
		reg[arg2] = val1
	case "dec":
		reg[arg1]--
	case "inc":
		reg[arg1]++
	case "jnz":
		if val1 != 0 {
			*ptr += val2 - 1
		}
	case "tgl":
		i := *ptr + val1

		if i < 0 || i >= len(lines) {
			return
		}

		targetCmd, targetArg1, targetArg2 := parse(lines[i])

		switch targetCmd {
		case "cpy":
			lines[i] = Join([]string{"jnz", targetArg1, targetArg2}, " ")
		case "dec":
			lines[i] = Join([]string{"inc", targetArg1}, " ")
		case "inc":
			lines[i] = Join([]string{"dec", targetArg1}, " ")
		case "jnz":
			lines[i] = Join([]string{"cpy", targetArg1, targetArg2}, " ")
		case "tgl":
			lines[i] = Join([]string{"inc", targetArg1}, " ")
		default:
			panic("!!")
		}
	default:
		panic("!")
	}
}

func getVal(arg string) int {
	val, err := Atoi(arg)
	if err != nil {
		return reg[arg]
	} else {
		return val
	}
}

func parse(line string) (string, string, string) {
	tokens := Split(line, " ")

	cmd := tokens[0]
	arg1 := tokens[1]
	arg2 := ""

	if len(tokens) == 3 {
		arg2 = tokens[2]
	}

	return cmd, arg1, arg2
}
