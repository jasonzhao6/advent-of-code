package main

import (
	. "fmt"
	. "io/ioutil"
	. "strconv"
	. "strings"
)

var p = Println

var reg = map[string]int{"c": 1}

func main() {
	buf, _ := ReadFile("input.txt")
	str := Trim(string(buf), "\n")
	lines := Split(str, "\n")

	solve(lines)
}

func solve(lines []string) {
	for ptr := 0; ptr < len(lines); ptr++ {
		cmd, arg1, arg2 := parse(lines[ptr])
		execute(cmd, arg1, arg2, &ptr)
	}

	p(reg["a"])
}

func execute(cmd string, arg1 string, arg2 string, ptr *int) {
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
