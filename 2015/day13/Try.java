import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Try {
    static void p(Object... objs) {
        boolean isFirst = false;

        for (Object obj : objs) {
            if (isFirst == false) {
                isFirst = true;
            } else {
                System.out.print(", ");
            }

            if (obj.getClass().getComponentType() == int.class) {
                System.out.print(Arrays.toString((int[]) obj));
            } else if (obj.getClass().isArray()) {
                System.out.print(Arrays.toString((Object[]) obj));
            } else {
                System.out.print(obj);
            }
        }

        System.out.println();
    }

    // Part 2
    private static final String SELF = "self";

    public static void main(String[] args) {
        // Compile the regex pattern once outside of loop
        Pattern pattern = Pattern.compile("([a-zA-Z]+) would (gain|lose) ([0-9]+) happiness units by sitting next to ([a-zA-Z]+)");
        Map<String, Integer> pairing = new HashMap<>();
        Set<String> people = new HashSet<>();

        // Parse input with regex: person a, person b, gain/lose, units
        try {
            Files.lines(Paths.get("./input.txt")).forEach(line -> {
                Matcher matcher = pattern.matcher(line);
                matcher.find();

                String lineKey = matcher.group(1) + matcher.group(4);
                int lineValue = value(matcher.group(2), Integer.parseInt(matcher.group(3)));

                // Map from [person a, person b].sort => +/-units
                pairing.put(lineKey, lineValue);

                // Create a set of unique names
                people.add(matcher.group(1));
                people.add(matcher.group(4));

                // Part 2
                people.add(SELF);
            });
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Loop through all permutations of the set, keep track of the highest points
        int maxValue = 0;
        List<List<String>> permutations = Permutation.<String>permute(people);
        for (List<String> permutation : permutations) {
            int subMaxValue = 0;
            for (int i = 0; i < permutation.size(); i++) {
                int j = (i + 1) % permutation.size();

                // Part 2
                if (permutation.get(i).equals(SELF) || permutation.get(j).equals(SELF)) {
                    continue;
                }

                String forwardKey = permutation.get(i) + permutation.get(j);
                String backwardKey = permutation.get(j) + permutation.get(i);
                subMaxValue += pairing.get(forwardKey) + pairing.get(backwardKey);
            }
            maxValue = Math.max(maxValue, subMaxValue);
        }

        p(maxValue);
    }

    private static int value(String gainLose, int units) {
        if (gainLose.equals("gain")) {
            return units;
        } else {
            return -units;
        }
    }
}
