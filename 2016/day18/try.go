package main

import (
	. "fmt"
)

var ROW_1 = "...^^^^^..^...^...^^^^^^...^.^^^.^.^.^^.^^^.....^.^^^...^^^^^^.....^.^^...^^^^^...^.^^^.^^......^^^^"
var ROW_COUNT = 400000
var SAFE = false
var TRAP = true

var p = Println

func main() {
	width := len(ROW_1)
	height := ROW_COUNT

	matrix := make([][]bool, height)
	for i := 0; i < height; i++ {
		matrix[i] = make([]bool, width)
	}

	safe_count := 0
	for i, v := range ROW_1 {
		switch v {
		case '.':
			safe_count++
			matrix[0][i] = SAFE
		case '^':
			matrix[0][i] = TRAP
		default:
			panic("!")
		}
	}

	for y := 1; y < height; y++ {
		for x := 0; x < width; x++ {
			center := matrix[y-1][x]
			left := SAFE
			right := SAFE

			if x-1 >= 0 {
				left = matrix[y-1][x-1]
			}
			if x+1 < width {
				right = matrix[y-1][x+1]
			}

			matrix[y][x] = (left && center && !right) ||
				(!left && center && right) ||
				(left && !center && !right) ||
				(!left && !center && right)

			if matrix[y][x] == SAFE {
				safe_count++
			}
		}
	}

	p(safe_count)
}
