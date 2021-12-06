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
        int inc_count = 0;
        Integer cur_value = null;

        for (String line : lines) {
            int value = Integer.parseInt(line);

            if (cur_value == null) {
                cur_value = value;
                continue;
            }

            if (cur_value < value) {
                inc_count++;
            }

            cur_value = value;
        }

        p(inc_count);
    }

    public static void part2(List<String> lines) {
        int inc_count = 0;

        for (int i = 3; i < lines.size(); i++) {
            int prev = Integer.parseInt(lines.get(i - 3));
            int curr = Integer.parseInt(lines.get(i));

            if (prev < curr) {
                inc_count++;
            }
        }

        p(inc_count);
    }
}
