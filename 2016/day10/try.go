package main

import (
	. "fmt"
	. "io/ioutil"
	"sort"
	. "strconv"
	. "strings"
)

var p = Println

type Bot struct {
	id       int
	values   []int
	lowType  string
	lowId    int
	highType string
	highId   int
}

func (bot *Bot) AddValue(value int) {
	bot.values = append(bot.values, value)

	if len(bot.values) == 2 {
		queue = append(queue, bot)
	}
}

var bots = map[int]*Bot{}
var outs = map[int]int{}
var queue = []*Bot{}

var lowValue = 17
var highValue = 61

func main() {
	buf, _ := ReadFile("input.txt")
	str := Trim(string(buf), "\n")
	lines := Split(str, "\n")

	solve(lines)
}

func solve(lines []string) {
	for _, line := range lines {
		parse(line)
	}

	for len(queue) > 0 {
		bot := queue[0]
		queue = queue[1:]

		sort.Ints(bot.values)
		if bot.values[0] == lowValue && bot.values[1] == highValue {
			// Part 1
			p(bot.id)
		}

		process(bot.values[0], bot.lowType, bot.lowId)
		process(bot.values[1], bot.highType, bot.highId)
	}

	// Part 2
	p(outs[0] * outs[1] * outs[2])
}

func process(value int, kind string, id int) {
	switch kind {
	case "bot":
		bots[id].AddValue(value)
	case "output":
		outs[id] = value
	default:
		panic("!")
	}
}

func parse(line string) {
	words := Split(line, " ")
	switch words[0] {
	case "value":
		value, _ := Atoi(words[1])
		id, _ := Atoi(words[5])

		initBot(id)
		bots[id].AddValue(value)
		// p(words[0], words[1], words[5], bots[id])
	case "bot":
		id, _ := Atoi(words[1])
		lowId, _ := Atoi(words[6])
		highId, _ := Atoi(words[11])

		initBot(id)
		bots[id].lowType = words[5]
		bots[id].lowId = lowId
		bots[id].highType = words[10]
		bots[id].highId = highId
		// p(words[0], words[1], words[5], words[6], words[10], words[11], bots[id])
	default:
		panic("!")
	}
}

func initBot(id int) {
	if bots[id] == nil {
		bots[id] = &Bot{id: id}
	}
}
