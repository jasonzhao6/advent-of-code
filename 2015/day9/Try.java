import java.util.*;
import java.util.regex.*;

public class Try {
    private static void p(Object... objs) {
        Printer.p(objs);
    }

    private static void tryThenExit() {
        p("\\x27", (char) Integer.parseInt("EF", 16));

        System.exit(1);
    }

    public static void main(String[] args) {
        // tryThenExit();

        // Parse all inputs
        Pattern r = Pattern.compile(
            // E.g "London to Belfast = 518"
            "(\\w+) to (\\w+) = ([0-9]+)"
        );
        Set<String> cities = new HashSet<>();
        Map<String, Integer> distances = new HashMap<>();

        for (String line : File.read("input.txt")) {
            Matcher m = r.matcher(line);
            m.find();

            cities.add(m.group(1));
            cities.add(m.group(2));
            distances.put(key(m.group(1), m.group(2)), Integer.parseInt(m.group(3)));
        }

        // Compute all scores
        List<Integer> scores = new ArrayList<>();

        for (List<String> permutation : Permutation.<String>permute(cities)) {
            int score = 0;

            for (int i = 0; i < permutation.size() - 1; i++) {
                score += distances.get(key(permutation.get(i), permutation.get(i + 1)));
            }

            scores.add(score);
        }

        p(Collections.max(scores));
    }

    static String key(String str1, String str2) {
        if (str1.compareTo(str2) < 0) {
            return str1 + str2;
        } else
            return str2 + str1;
    }
}
