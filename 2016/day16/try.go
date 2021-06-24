package main

import (
	. "fmt"
	. "math"
	. "strings"
)

var p = Println

// Use `byte` instead of `int` saves memory usage by ~4x
var A = []byte{0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0}
var B = []byte{1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1}
var LEN = 35651584

func main() {
	slice := []string{"a"}

	for count(slice) < LEN {
		slice = double(slice)
	}

	p(intsToStr(checksum(slice)))
}

func intsToStr(ints []byte) string {
	return Trim(Join(Split(Sprint(ints), " "), ""), "[]")
}

func checksum(slice []string) []byte {
	size := int(Pow(2, float64(reps())))
	expanded := []byte{}
	answer := []byte{}

	for _, char := range slice {
		switch char {
		case "a":
			expanded = append(expanded, A...)
		case "b":
			expanded = append(expanded, B...)
		case "0":
			expanded = append(expanded, 0)
		case "1":
			expanded = append(expanded, 1)
		default:
			p("!")
		}

		for len(expanded) >= size {
			window := []byte{}
			window, expanded = expanded[0:size], expanded[size:]
			answer = append(answer, reduce(window))
		}
	}

	return answer
}

func reduce(window []byte) byte {
	if len(window) == 1 {
		return window[0]
	}

	newWindow := []byte{}

	for len(window) > 0 {
		var x, y byte
		x, y, window = window[0], window[1], window[2:]

		if x == y {
			newWindow = append(newWindow, 1)
		} else {
			newWindow = append(newWindow, 0)
		}
	}

	return reduce(newWindow)
}

func reps() int {
	digits := LEN
	num := 0

	for {
		if digits%2 == 0 {
			digits /= 2
			num += 1
		} else {
			return num
		}
	}
}

func double(slice []string) []string {
	length := len(slice)
	slice = append(slice, "0")

	for i := length - 1; i >= 0; i-- {
		char := slice[i]
		switch char {
		case "a":
			slice = append(slice, "b")
		case "b":
			slice = append(slice, "a")
		case "0":
			slice = append(slice, "1")
		case "1":
			slice = append(slice, "0")
		default:
			p("!")
		}
	}

	return slice
}

func count(slice []string) int {
	num := 0

	for _, char := range slice {
		switch char {
		case "a":
			num += len(A)
		case "b":
			num += len(A)
		case "0":
			num += 1
		case "1":
			num += 1
		default:
			p("!")
		}
	}

	return num
}
