package main

import (
	. "fmt"
)

var p = Println

type Disc struct {
	id  int
	mod int
	pos int
}

func main() {
	discs := []Disc{
		{id: 1, mod: 13, pos: 11},
		{id: 2, mod: 5, pos: 0},
		{id: 3, mod: 17, pos: 11},
		{id: 4, mod: 3, pos: 0},
		{id: 5, mod: 7, pos: 2},
		{id: 6, mod: 19, pos: 17},
		{id: 7, mod: 11, pos: 0}, // Part 2
	}

	solve(discs)
}

func solve(discs []Disc) {
	ts := 0
	inc := 1

	for _, disc := range discs {
		// for {
		//   if (ts+disc.id+disc.pos)%disc.mod == 0 {
		//     inc *= disc.mod
		//     break
		//   }
		//
		//   ts += inc
		// }

		// Angel's version
		for (ts+disc.id+disc.pos)%disc.mod != 0 {
			ts += inc
		}
		inc *= disc.mod
	}

	p(ts)
}
