import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.regex.*;

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

    static String[] readLines(String fileName) {
        String lines = null;

        try {
            lines = Files.readString(Path.of(fileName));
        } catch (IOException e) {
            p("! IOException");
            System.exit(1);
        }

        return lines.split("\n");
    }

    static void tryThings() {
        p("\\x27", (char) Integer.parseInt("EF", 16));

        System.exit(1);
    }

    public static void main(String[] args) {
        // tryThings();

        Map<String, Integer> distances = new HashMap<String, Integer>();
        Set<String> cities = new HashSet<String>();
        Pattern r = Pattern.compile(
            // E.g "London to Belfast = 518"
            "(\\w+) to (\\w+) = ([0-9]+)"
        );

        for (String line : readLines("input.txt")) {
            Matcher m = r.matcher(line);
            m.find();

            distances.put(key(m.group(1), m.group(2)), Integer.parseInt(m.group(3)));
            cities.add(m.group(1));
            cities.add(m.group(2));
        }

        List<List<String>> permutations = permute(cities);

        List<Integer> scores = new ArrayList<Integer>();
        for (List<String> permutation : permutations) {
            int score = 0;

            for (int i = 0; i < permutation.size() - 1; i++) {
                score += distances.get(key(permutation.get(i), permutation.get(i + 1)));
            }

            scores.add(score);
        }

        p(Collections.max(scores));
    }

    public static String key(String str1, String str2) {
        if (str1.compareTo(str2) < 0) {
            return str1 + str2;
        } else
            return str2 + str1;
    }

    ///////////////////

    public static List<List<String>> permute(Set<String> set) {
        List<List<String>> list = new ArrayList<>();
        permuteHelper(list, new ArrayList<>(), set);
        return list;
    }

    private static void permuteHelper(List<List<String>> list, List<String> resultList, Set<String> set){
        // Base case
        if (resultList.size() == set.size()){
            list.add(new ArrayList<>(resultList));
        } else {
            for (String obj : set) {
                if (resultList.contains(obj)) {
                    // If element  exists in the list then skip
                    continue;
                }
                // Choose element
                resultList.add(obj);
                // Explore
                permuteHelper(list, resultList, set);
                // Unchoose element
                resultList.remove(resultList.size() - 1);
            }
        }
    }
}
