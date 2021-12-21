package day03;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

public class Day03 {
    static final String filename = "src/day03/input.txt";

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
            return Files.readAllLines(Paths.get(Day03.filename));
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
        int lineLength = lines.get(0).length();
        StringBuffer gamma = new StringBuffer(lineLength);
        StringBuffer epsilon = new StringBuffer(lineLength);

        for (int i = 0; i < lineLength; i++) {
            int zero_count = 0;

            for (String line : lines) {
                if (line.charAt(i) == '0') {
                    zero_count++;
                }
            }

            if (zero_count > lines.size() / 2) {
                gamma.append('0');
                epsilon.append('1');
            } else {
                gamma.append('1');
                epsilon.append('0');
            }
        }

        p(gamma, epsilon, binaryToInt(gamma.toString()) * binaryToInt(epsilon.toString()));
    }

    public static void part2(List<String> lines) {
        int lineLength = lines.get(0).length();
        StringBuffer oxygen = new StringBuffer(lineLength);
        StringBuffer co2 = new StringBuffer(lineLength);

        // Calculate oxygen
        for (int i = 0; i < lineLength; i++) {
            int total_count = 0;
            int zero_count = 0;

            for (String line : lines) {
                if (line.startsWith(oxygen.toString())) {
                    total_count++;

                    if (line.charAt(i) == '0') {
                        zero_count++;
                    }
                }
            }

            if (zero_count > total_count - zero_count) {
                oxygen.append('0');
            } else {
                oxygen.append('1');
            }
        }

        // Calculate CO2
        String curr_line = null;
        for (int i = 0; i < lineLength; i++) {
            int total_count = 0;
            int zero_count = 0;

            for (String line : lines) {
                if (line.startsWith(co2.toString())) {
                    curr_line = line;
                    total_count++;

                    if (line.charAt(i) == '0') {
                        zero_count++;
                    }
                }
            }

            if (total_count == 1) {
                break;
            }

            if (zero_count <= total_count - zero_count) {
                co2.append('0');
            } else {
                co2.append('1');
            }
        }

        p(oxygen, curr_line, binaryToInt(oxygen.toString()) * binaryToInt(curr_line));
    }
    
    // Method that converts binary to integer
    public static int binaryToInt(String binary) {
        int result = 0;
        for (int i = 0; i < binary.length(); i++) {
            if (binary.charAt(i) == '1') {
                result += Math.pow(2, binary.length() - i - 1);
            }
        }
        return result;
    }
}
