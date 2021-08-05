package main

import (
	. "fmt"
	. "io/ioutil"
	"regexp"
	. "strconv"
	. "strings"
)

var p = Println

type Node struct {
	x     int
	y     int
	used  int
	avail int
}

func main() {
	buf, _ := ReadFile("input.txt")
	str := Trim(string(buf), "\n")
	lines := Split(str, "\n")

	nodes := []Node{}
	for _, line := range lines {
		params := getParams("node-x(?P<x>[0-9]+)-y(?P<y>[0-9]+)[ ]+(?P<size>[0-9]+)T[ ]+(?P<used>[0-9]+)T[ ]+(?P<avail>[0-9]+)T[ ]+(?P<pct>[0-9]+)", line)

		if params["x"] == "" {
			continue
		}

		x, _ := Atoi(params["x"])
		y, _ := Atoi(params["y"])
		used, _ := Atoi(params["used"])
		avail, _ := Atoi(params["avail"])
		node := Node{x: x, y: y, used: used, avail: avail}
		nodes = append(nodes, node)
	}

	solve(nodes)
	solve2(nodes)
}

func solve(nodes []Node) {
	count := 0

	for _, n1 := range nodes {
		for _, n2 := range nodes {
			if n1.used == 0 || n1 == n2 {
				continue
			}

			if n1.used <= n2.avail {
				count++
			}
		}
	}

	p(count)
}

const X_MAX = 38
const Y_MAX = 24

func solve2(nodes []Node) {
	grid := [Y_MAX + 1][X_MAX + 1]string{}
	for y := 0; y <= Y_MAX; y++ {
		grid[y] = [X_MAX + 1]string{}
	}

	for _, node := range nodes {
		if node.used > 100 {
			grid[node.y][node.x] = "#"
		} else if node.used == 0 {
			grid[node.y][node.x] = "_"
		} else {
			grid[node.y][node.x] = "."
		}
	}

	for y := 0; y <= Y_MAX; y++ {
		p(grid[y])
	}
}

func getParams(regEx, input string) (paramsMap map[string]string) {
	var compRegEx = regexp.MustCompile(regEx)
	match := compRegEx.FindStringSubmatch(input)

	paramsMap = make(map[string]string)
	for i, name := range compRegEx.SubexpNames() {
		if i > 0 && i <= len(match) {
			paramsMap[name] = match[i]
		}
	}
	return paramsMap
}
