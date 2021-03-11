package main

import (
	. "fmt"
	. "io/ioutil"
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

func solve(lines []string) {
	counter := 0

	for _, line := range lines {
		tokens := Split(line, " ")

		switch tokens[0] {
		case "rect":
			// rect 3x2
			x, y := getXY(tokens[1])
			counter += x * y
		default:
			// Do nothing
		}
	}

	p(counter)
}

func getXY(token string) (int, int) {
	xy := Split(token, "x")
	x, _ := Atoi(xy[0])
	y, _ := Atoi(xy[1])

	return x, y
}

func getIndex(token string) int {
	i, _ := Atoi(token[2:])
	return i
}

func getDistance(token string) int {
	d, _ := Atoi(token)
	return d
}

func solve2(lines []string) {
	grid := initGrid()

	for _, line := range lines {
		tokens := Split(line, " ")

		switch tokens[0] {
		case "rect":
			// rect 3x2
			x, y := getXY(tokens[1])
			handleRect(&grid, x, y)
		case "rotate":
			switch tokens[1] {
			case "column":
				// rotate column x=1 by 1
				index := getIndex(tokens[2])
				distance := getDistance(tokens[4])
				handleRotateX(&grid, index, distance)
			case "row":
				// rotate row y=0 by 4
				index := getIndex(tokens[2])
				distance := getDistance(tokens[4])
				handleRotateY(&grid, index, distance)
			default:
				panic("!")
			}
		default:
			panic("!")
		}
	}

	print(grid)
}

const W = 50
const H = 6

type Grid [H][W]string
type Row [W]string
type Col [H]string

func initGrid() Grid {
	grid := Grid{}

	for i := 0; i < H; i++ {
		for j := 0; j < W; j++ {
			grid[i][j] = "."
		}
	}

	return grid
}

func handleRect(grid *Grid, x int, y int) {
	for i := 0; i < y; i++ {
		for j := 0; j < x; j++ {
			grid[i][j] = "#"
		}
	}
}

func handleRotateX(grid *Grid, index int, distance int) {
	copy := Col{}
	for i := 0; i < H; i++ {
		copy[i] = grid[i][index]
	}

	for i := 0; i < H; i++ {
		grid[i][index] = copy[(i-distance+H)%H]
	}
}

func handleRotateY(grid *Grid, index int, distance int) {
	copy := Row{}
	for i := 0; i < W; i++ {
		copy[i] = grid[index][i]
	}

	for i := 0; i < W; i++ {
		grid[index][i] = copy[(i-distance+W)%W]
	}
}

func print(grid Grid) {
	for _, row := range grid {
		p(row)
	}
}
