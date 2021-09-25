package main

import (
	. "fmt"
	. "io/ioutil"
	. "strings"
)

var p = Println

type XY struct {
	x int
	y int
}

type POINT struct {
	xy  XY
	val rune
}

type STEP struct {
	xy     XY
	weight int
}

const PART2 = true

func main() {
	buf, _ := ReadFile("input.txt")
	str := Trim(string(buf), "\n")
	lines := Split(str, "\n")

	// Find all the points to traverse through
	points := findPoints(lines)
	// Find all the weights between each pair of points
	weights := findWeights(lines, points)
	// From 0, find the shortest path by trying all permutations
	shortestPath := findShortestPath(points, weights)

	p(shortestPath)
}

func findShortestPath(points []POINT, weights map[[2]rune]int) int {
	nonZeros := []rune{}
	lowestWeight := -1

	for _, point := range points {
		if point.val != '0' {
			nonZeros = append(nonZeros, point.val)
		}
	}

	Perm(nonZeros, func(vals []rune) {
		weight := 0

		for i, val := range vals {
			if i == 0 {
				weight += weights[keyAsc('0', val)]
			} else {
				weight += weights[keyAsc(vals[i-1], val)]
			}
		}

		if PART2 {
			weight += weights[keyAsc('0', vals[len(vals)-1])]
		}

		if lowestWeight == -1 || weight < lowestWeight {
			lowestWeight = weight
		}
	})

	return lowestWeight
}

func keyAsc(val1 rune, val2 rune) [2]rune {
	key := [2]rune{val1, val2}

	if val1 > val2 {
		key = [2]rune{val2, val1}
	}

	return key
}

func findWeights(lines []string, points []POINT) map[[2]rune]int {
	weights := map[[2]rune]int{}

	for _, point1 := range points {
		for _, point2 := range points {
			if point1.val >= point2.val {
				continue
			}

			weight := findWeight(lines, point1, point2)
			weights[[2]rune{point1.val, point2.val}] = weight
		}
	}

	return weights
}

func findWeight(lines []string, point1 POINT, point2 POINT) int {
	xMax := len(lines)
	yMax := len(lines[0])

	i := 0
	queue := []STEP{{point1.xy, 0}}
	seen := map[XY]bool{point1.xy: true}
	for i < len(queue) {
		step := queue[i]

		up := XY{step.xy.x - 1, step.xy.y}
		if seen[up] == false && up.x >= 0 && lines[up.x][up.y] != '#' {
			if rune(lines[up.x][up.y]) == point2.val {
				return step.weight + 1
			}

			queue = append(queue, STEP{up, step.weight + 1})
			seen[up] = true
		}

		down := XY{step.xy.x + 1, step.xy.y}
		if seen[down] == false && down.x < xMax && lines[down.x][down.y] != '#' {
			if rune(lines[down.x][down.y]) == point2.val {
				return step.weight + 1
			}

			queue = append(queue, STEP{down, step.weight + 1})
			seen[down] = true
		}

		left := XY{step.xy.x, step.xy.y - 1}
		if seen[left] == false && left.y >= 0 && lines[left.x][left.y] != '#' {
			if rune(lines[left.x][left.y]) == point2.val {
				return step.weight + 1
			}

			queue = append(queue, STEP{left, step.weight + 1})
			seen[left] = true
		}

		right := XY{step.xy.x, step.xy.y + 1}
		if seen[right] == false && right.y < yMax && lines[right.x][right.y] != '#' {
			if rune(lines[right.x][right.y]) == point2.val {
				return step.weight + 1
			}

			queue = append(queue, STEP{right, step.weight + 1})
			seen[right] = true
		}

		i++
	}

	panic("!")
}

func findPoints(lines []string) []POINT {
	points := []POINT{}

	for x, line := range lines {
		for y, char := range line {
			if char != '.' && char != '#' {
				points = append(points, POINT{XY{x, y}, char})
			}
		}
	}

	return points
}

/////////////////////////////////

// Perm calls f with each permutation of a.
func Perm(a []rune, f func([]rune)) {
	perm(a, f, 0)
}

// Permute the values at index i to len(a)-1.
func perm(a []rune, f func([]rune), i int) {
	if i > len(a) {
		f(a)
		return
	}
	perm(a, f, i+1)
	for j := i + 1; j < len(a); j++ {
		a[i], a[j] = a[j], a[i]
		perm(a, f, i+1)
		a[i], a[j] = a[j], a[i]
	}
}
