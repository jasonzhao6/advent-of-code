import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

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
        part1(lines);
        part2(lines);
    }

    public static void part1(List<String> lines) {
        int position = 0;
        int depth = 0;

        for (String line : lines) {
            if (line.startsWith("forward")) {
                position += Integer.parseInt(line.substring(8));
            } else if (line.startsWith("down")) {
                depth += Integer.parseInt(line.substring(5));
            } else if (line.startsWith("up")) {
                depth -= Integer.parseInt(line.substring(3));
            }
        }

        p(position, depth, position * depth);
    }

    public static void part2(List<String> lines) {
        int position = 0;
        int depth = 0;
        int aim = 0;

        for (String line : lines) {
            if (line.startsWith("forward")) {
                int value = Integer.parseInt(line.substring(8));
                position += value;
                depth += value * aim;
            } else if (line.startsWith("down")) {
                aim += Integer.parseInt(line.substring(5));
            } else if (line.startsWith("up")) {
                aim -= Integer.parseInt(line.substring(3));
            }
        }

        p(position, depth, position * depth);
    }
}
