package day04;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

public class Day04 {
    static final String filename = "src/day04/input.txt";

    static void p(Object... objects) {
        boolean isFirst = false;

        for (Object object : objects) {
            if (!isFirst) {
                isFirst = true;
            } else {
                System.out.print(", ");
            }

            if (object.getClass().getComponentType() == int.class) {
                System.out.print(Arrays.toString((int[]) object));
            } else if (object.getClass().isArray()) {
                System.out.print(Arrays.toString((Object[]) object));
            } else {
                System.out.print(object);
            }
        }

        System.out.println();
    }

    static List<String> readLines() {
        try {
            return Files.readAllLines(Paths.get(Day04.filename));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public static void main(String[] args) {
        List<String> lines = readLines();

        // Parse numbers drawn, which is on line 1
        List<Integer> numbers = Arrays
                .stream(lines.get(0).split(","))
                .map(Integer::parseInt)
                .collect(Collectors.toList());

        // Parse bingo boards, which starts on line 3
        // There is an empty line between each board, hence the SIZE + 1
        List<Bingo> boards = new ArrayList<>();
        for (int i = 2; i < lines.size(); i += Bingo.SIZE + 1) {
            int[][] board = new int[Bingo.SIZE][];

            for (int j = 0; j < Bingo.SIZE; j++) {
                board[j] = Arrays
                        .stream(lines.get(i + j).split(" "))
                        .filter(s -> !s.isEmpty())
                        .mapToInt(Integer::parseInt)
                        .toArray();
            }

            boards.add(new Bingo(board));
        }

        part1(numbers, boards);
        part2(numbers, boards);
    }

    public static void part1(List<Integer> numbers, List<Bingo> boards) {
        // Feed each number to each board, and check for winner each time
        for (int number : numbers) {
            for (Bingo board : boards) {
                board.mark(number);

                if (board.hasWon()) {
                    p(number, board.unmarkedSum(), number * board.unmarkedSum());
                    return;
                }
            }
        }
    }

    public static void part2(List<Integer> numbers, List<Bingo> boards) {
        Set<Bingo> winners = new HashSet<>();

        // Feed each number to each board, and find the last winner
        for (int number : numbers) {
            for (Bingo board : boards) {
                board.mark(number);

                if (board.hasWon()) {
                    winners.add(board);
                }

                if (winners.size() == boards.size()) {
                    p(winners.size(), number, board.unmarkedSum(), number * board.unmarkedSum());
                    System.exit(0);
                }
            }
        }
    }
}
