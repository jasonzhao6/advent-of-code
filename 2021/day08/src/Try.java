import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.regex.Pattern;

/*
Map of digit to segment count

0: 6
1: 2 <>
2: 5
3: 5
4: 4 <>
5: 5
6: 6
7: 3 <>
8: 7 <>
9: 6
*/

/*
Map of segment count to digit

2: 1 <>
3: 7 <>
4: 4 <>

5: 2
5: 3
5: 5

6: 0
6: 6
6: 9

7: 8 <>
*/

/*
Deduction logic

Given: 1, 4, 7, 8
5s: 5 - 1 = 3 segments => 3
3 + 4 = 9
5s: 9 - 5 = 1 segment, 9 - 2 = 2 segments => 2, 5
6s: 6 - 5 = 1 segment, 0 - 5 = 2 segments => 0, 6
*/

public class Try {
    static final String filename = "input.txt";

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
            return Files.readAllLines(Paths.get(Try.filename));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public static void main(String[] args) {
        List<String> lines = readLines();

        // part1(lines);
        part2(lines);
    }

    public static void part1(List<String> lines) {
        int count = 0;

        for (String line : lines) {
            String[] parts = line.split(Pattern.quote(" | "));
            String[] outputs = parts[1].split(" ");

            for (String output : outputs) {
                if (output.length() == 2 || // 1
                        output.length() == 4 || // 4
                        output.length() == 3 || // 7
                        output.length() == 7) { // 8

                    count++;
                }
            }
        }

        p(count);
    }

    public static void part2(List<String> lines) {
        int total = 0;

        for (String line : lines) {
            String[] parts = line.split(Pattern.quote(" | "));
            String[] inputs = parts[0].split(" ");
            String[] outputs = parts[1].split(" ");

            Map<Integer, Set<String>> digits = new HashMap<Integer, Set<String>>();
            List<Set<String>> fives = new ArrayList<Set<String>>();
            List<Set<String>> sixes = new ArrayList<Set<String>>();

            // Identify by segment count
            for (String input : inputs) {
                if (input.length() == 2) { // Identify 1
                    digits.put(1, toSet(input));
                } else if (input.length() == 4) { // Identify 4
                    digits.put(4, toSet(input));
                } else if (input.length() == 3) { // Identify 7
                    digits.put(7, toSet(input));
                } else if (input.length() == 7) { // Identify 8
                    digits.put(8, toSet(input));
                } else if (input.length() == 5) { // Identify 2, 3, 5
                    fives.add(toSet(input));
                } else if (input.length() == 6) { // Identify 0, 6, 9
                    sixes.add(toSet(input));
                }
            }

            // Identify 3
            // 5s: 5 - 1 = 3 segments => 3
            for (Set<String> digit : fives) {
                Set<String> copy = new HashSet<String>(digit);
                copy.removeAll(digits.get(1));

                if (copy.size() == 3) {
                    digits.put(3, digit);
                }
            }
            fives.remove(digits.get(3));

            // Identify 9
            // 3 + 4 = 9
            Set<String> nine = new HashSet<String>(digits.get(3));
            nine.addAll(digits.get(4));
            digits.put(9, nine);
            sixes.remove(nine);

            // Identify 2, 5
            // 2, 5: 9 - 5 = 1 segment, 9 - 2 = 2 segments => 2, 5
            for (Set<String> digit : fives) {
                Set<String> copy = new HashSet<String>(digits.get(9));
                copy.removeAll(digit);

                if (copy.size() == 1) {
                    digits.put(5, digit);
                } else if (copy.size() == 2) {
                    digits.put(2, digit);
                }
            }

            // Identify 0, 6
            // 0, 6: 6 - 5 = 1 segment, 0 - 5 = 2 segment => 0, 6
            for (Set<String> digit : sixes) {
                Set<String> copy = new HashSet<String>(digit);
                copy.removeAll(digits.get(5));

                if (copy.size() == 1) {
                    digits.put(6, digit);
                } else if (copy.size() == 2) {
                    digits.put(0, digit);
                }
            }

            // Decode the outputs
            int number = 0;
            for (String output : outputs) {
                Set<String> set = toSet(output);

                for (Integer digit : digits.keySet()) {
                    if (set.equals(digits.get(digit))) {
                        number *= 10;
                        number += digit;
                    }
                }
            }
            total += number;
        }

        p(total);
    }

    private static Set<String> toSet(String string) {
        return new HashSet<>(Arrays.asList(string.split("")));
    }
}
