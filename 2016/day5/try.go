package main

import (
	"crypto/md5"
	"encoding/hex"
	. "fmt"
	. "strconv"
	. "strings"
)

var p = Println

const LEN = 8
const ZEROS = "00000"

func main() {
	in := "cxdnnyjw"

	solve(in)
	solve2(in)
}

func solve(in string) {
	ans := [LEN]string{}

	idx := 0
	chr := "-"
	for i := 0; i < LEN; i++ {
		for chr == "-" {
			chr, _ = extract(in, idx)
			idx++
		}
		ans[i] = chr
		chr = "-"
	}

	p(Join(ans[:], ""))
}

func solve2(in string) {
	ans := [LEN]string{}

	idx := 0
	cnt := 0
	c1 := "-"
	c2 := "-"
	for {
		for c1 == "-" {
			c1, c2 = extract(in, idx)
			idx++
		}

		pos, err := Atoi(c1)
		if err == nil && pos < LEN && ans[pos] == "" {
			ans[pos] = c2
			cnt++

			if cnt == LEN {
				p(Join(ans[:], ""))
				return
			}
		}
		c1 = "-"
	}
}

func extract(in string, num int) (string, string) {
	str := in + Itoa(num)

	bytes := md5.Sum([]byte(str))
	hsh := hex.EncodeToString(bytes[:])

	if HasPrefix(hsh, "00000") {
		return string(hsh[len(ZEROS)]), string(hsh[len(ZEROS)+1])
	} else {
		return "-", "-"
	}
}
