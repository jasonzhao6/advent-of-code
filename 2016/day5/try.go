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
	ans := [LEN]byte{}

	idx := 0
	chr := byte('-')
	for i := 0; i < LEN; i++ {
		for chr == '-' {
			chr, _ = extract(in, idx)
			idx++
		}
		ans[i] = chr
		chr = '-'
	}

	p(string(ans[:]))
}

func solve2(in string) {
	ans := [LEN]byte{}

	idx := 0
	cnt := 0
	c1 := byte('-')
	c2 := byte('-')
	for {
		for c1 == '-' {
			c1, c2 = extract(in, idx)
			idx++
		}

		pos := c1 - '0'
		if pos < LEN && ans[pos] == 0 {
			ans[pos] = c2
			cnt++

			if cnt == LEN {
				p(string(ans[:]))
				return
			}
		}
		c1 = '-'
	}
}

func extract(in string, num int) (byte, byte) {
	str := in + Itoa(num)

	bytes := md5.Sum([]byte(str))
	hsh := hex.EncodeToString(bytes[:])

	if HasPrefix(hsh, "00000") {
		return hsh[len(ZEROS)], hsh[len(ZEROS)+1]
	} else {
		return '-', '-'
	}
}
