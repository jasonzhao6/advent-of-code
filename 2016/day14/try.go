package main

import (
	"crypto/md5"
	"encoding/hex"
	. "fmt"
	. "strconv"
)

var p = Println

var salt1 = "abc"
var salt2 = "jlmsuwbz"
var alphabet = map[byte][]int{}

func main() {
	for i := 1; i <= 1000; i++ {
		memoQuints(i)
	}

	index := 0
	count := 0

	for {
		triplet := firstTriplet(index)
		if triplet != '?' {
			for _, i := range alphabet[triplet] {
				if i-index > 0 && i-index <= 1000 {
					count++
					break
				}
			}
		}

		if count == 64 {
			p(index)
			break
		}

		index++
		memoQuints(index + 1000)
	}
}

func firstTriplet(index int) byte {
	hash := hashIndex2(index)

	for i := 0; i < len(hash)-2; i++ {
		if hash[i] == hash[i+1] && hash[i+1] == hash[i+2] {
			return hash[i]
		}
	}

	return '?'
}

func memoQuints(index int) {
	hash := hashIndex2(index)

	for i := 0; i < len(hash)-4; i++ {
		if hash[i] == hash[i+1] && hash[i+1] == hash[i+2] && hash[i+2] == hash[i+3] && hash[i+3] == hash[i+4] {
			alphabet[hash[i]] = append(alphabet[hash[i]], index)
		}
	}
}

func hashIndex(index int) string {
	string := salt2 + Itoa(index)
	bytes := md5.Sum([]byte(string))
	hash := hex.EncodeToString(bytes[:])
	return hash
}

var memo = map[int]string{}

func hashIndex2(index int) string {
	if memo[index] != "" {
		return memo[index]
	}

	string := salt2 + Itoa(index)
	for i := 0; i <= 2016; i++ {
		bytes := md5.Sum([]byte(string))
		string = hex.EncodeToString(bytes[:])
	}
	memo[index] = string
	return string
}
