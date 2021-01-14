package main

import (
	"io/ioutil"
	"math"
	"strconv"
	"strings"
)

func main() {
	buf, _ := ioutil.ReadFile("input.txt")
	str := strings.Trim(string(buf), "\n")
	cmds := strings.Split(str, ", ")

	p1(cmds)
	p2(cmds)
}

func p1(cmds []string) {
	// States
	loc := 0i
	dir := 1i

	for _, cmd := range cmds {
		dir *= turn(cmd[0])
		num, _ := strconv.ParseFloat(cmd[1:], 64)
		loc += dir * complex(num, 0)
	}

	measure(loc)
}

func p2(cmds []string) {
	// States
	loc := 0i
	dir := 1i
	hsh := make(map[complex128]bool)

	for _, cmd := range cmds {
		dir *= turn(cmd[0])
		num, _ := strconv.ParseFloat(cmd[1:], 64)
		for i := 1.0; i <= num; i++ {
			loc += dir * complex(1, 0)

			if hsh[loc] == true {
				measure(loc)
				return
			}

			hsh[loc] = true
		}
	}
}

func measure(num complex128) int {
	x := math.Abs(real(num))
	y := math.Abs(imag(num))
	dist := int(x + y)
	println(dist)
	return dist
}

func turn(chr byte) complex128 {
	switch chr {
	case 'R':
		return -1i
	case 'L':
		return 1i
	default:
		panic("!")
	}
}
