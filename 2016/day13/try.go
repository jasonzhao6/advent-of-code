package main

import (
	. "fmt"
	. "strconv"
	. "strings"
)

var p = Println

type XY struct {
	x int
	y int
}

type OPEN struct {
	isSet  bool
	isOpen bool
}

type VISIT struct {
	xy  XY
	cnt int
}

// var fav = 10
// var target = XY{7, 4}
var fav = 1352
var target = XY{31, 39}
var dy = 4
var opens = map[XY]OPEN{}
var queue = []VISIT{}
var queued = map[XY]bool{}

func main() {
	start := XY{1, 1}
	queued[start] = true
	queue = append(queue, VISIT{start, 0})

	i := 0
	for {
		visit := queue[i]
		i++

		// Part 1
		if visit.xy == target {
			p("steps", visit.cnt)
			return
		}

		// Part 2
		if visit.cnt > 50 {
			reach := 0
			for _, visit := range queue {
				if visit.cnt <= 50 {
					reach++
				}
			}
			p("reached", reach)
			return
		}

		expand(visit)
	}
}

func expand(visit VISIT) {
	u := XY{visit.xy.x, visit.xy.y - 1}
	d := XY{visit.xy.x, visit.xy.y + 1}
	l := XY{visit.xy.x - 1, visit.xy.y}
	r := XY{visit.xy.x + 1, visit.xy.y}

	for _, xy := range [4]XY{u, d, l, r} {
		if xy.x >= 0 && xy.y >= 0 && !queued[xy] && isOpen(xy) {
			queued[xy] = true
			queue = append(queue, VISIT{xy, visit.cnt + 1})
		}
	}
}

func isOpen(xy XY) bool {
	if opens[xy].isSet {
		return opens[xy].isOpen
	}

	sum := int64(xy.x*xy.x + 3*xy.x + 2*xy.x*xy.y + xy.y + xy.y*xy.y + fav)
	bin := FormatInt(sum, 2)
	chrs := Split(bin, "")

	cnt_1s := 0
	for _, chr := range chrs {
		if chr == "1" {
			cnt_1s++
		}
	}

	isEven := cnt_1s%2 == 0
	opens[xy] = OPEN{true, isEven}
	return isEven
}
