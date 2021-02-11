package main

import (
	"crypto/md5"
	"encoding/hex"
	. "fmt"
	. "strconv"
	. "strings"
)

var p = Println

const SECRET = "yzbqklnj"
const ZEROS = "000000"

func main() {
	num := 1

	for {
		data := SECRET + Itoa(num)
		bytes := md5.Sum([]byte(data))
		str := hex.EncodeToString(bytes[:])

		if HasPrefix(str, ZEROS) {
			p(num)
			return
		}

		num++
	}
}
