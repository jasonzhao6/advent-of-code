package main

import (
	"io/ioutil"
)

func main() {
	buf, _ := ioutil.ReadFile("input.txt")

	cnt := 0
	for i, val := range buf {
		if val == '(' {
			cnt++
		} else {
			cnt--
		}

		if cnt == -1 {
			println(i + 1)
			return
		}
	}
}
