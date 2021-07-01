package main

import (
	"crypto/md5"
	"encoding/hex"
	. "fmt"
)

var p = Println

type S struct { // State
	x    int
	y    int
	path string
}

var KEY = "awrkjxxr"
var W = 4
var H = 4

func main() {
	start := S{0, 0, ""}
	queue := []S{start}

	i := 0
	cnt := 0 // Part 2
	for {
		// Part 2
		if i == len(queue) {
			p(cnt)
			return
		}

		curr := queue[i]
		i++

		if curr.x == W-1 && curr.y == H-1 {
			// Part 1
			// p(curr.path)
			// return

			// Part 2
			if len(curr.path) > cnt {
				cnt = len(curr.path)
			}
			continue
		}

		dir := hash(curr)
		// Up
		if curr.y != 0 && is_open(dir[0]) {
			queue = append(queue, S{curr.x, curr.y - 1, curr.path + "U"})
		}
		// Down
		if curr.y != H-1 && is_open(dir[1]) {
			queue = append(queue, S{curr.x, curr.y + 1, curr.path + "D"})
		}
		// Left
		if curr.x != 0 && is_open(dir[2]) {
			queue = append(queue, S{curr.x - 1, curr.y, curr.path + "L"})
		}
		// Right
		if curr.x != W-1 && is_open(dir[3]) {
			queue = append(queue, S{curr.x + 1, curr.y, curr.path + "R"})
		}
	}
}

func hash(s S) string {
	bytes := md5.Sum([]byte(KEY + s.path))
	string := hex.EncodeToString(bytes[:])
	return string
}

func is_open(byte byte) bool {
	return byte >= 'b'
}
