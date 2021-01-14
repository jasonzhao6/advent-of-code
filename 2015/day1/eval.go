package main

import (
	"go/token"
	"go/types"
	"io/ioutil"
	"strings"
)

func main() {
	buf, _ := ioutil.ReadFile("input.txt")
	str := string(buf)
	str = strings.ReplaceAll(str, "(", "+1")
	str = strings.ReplaceAll(str, ")", "-1")

	fs := token.NewFileSet()
	tv, err := types.Eval(fs, nil, token.NoPos, str)
	if err != nil {
		panic(err)
	}
	println(tv.Value.String())
}
