import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Try {
    private static final Pattern RE_INT = Pattern.compile("-?[0-9]+");
    private static final String RED = "red";

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

    public static void main(String[] args) {
        test1();
        test2();

        try {
            Files.lines(Paths.get("./input.txt")).forEach(line -> {
                // Part 1
                p(sum(line));

                // Part 2
                p(sum(removeRedObjects(line)));
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void test1() {
        p(sum("[1,2,3]") == 6);
        p(sum("{'a':2,'b':4}") == 6);
        p(sum("[[[3]]]") == 3);
        p(sum("{'a':{'b':4},'c':-1}") == 3);
        p(sum("{'a':[-1,1]}") == 0);
        p(sum("[-1,{'a':1}]") == 0);
    }

    private static void test2() {
        p(sum(removeRedObjects("[1,{'x':10,'y':{'c':'red','b':2}},3]")) == 14);
        p(sum(removeRedObjects("[1,2,3]")) == 6);
        p(sum(removeRedObjects("[1,{'c':'red','b':2},3]")) == 4);
        p(sum(removeRedObjects("[1,{'c':'blue','b':2},3]")) == 6);
        p(sum(removeRedObjects("{'d':'red','e':[1,2,3,4],'f':5}")) == 0);
        p(sum(removeRedObjects("{'d':'blue','e':[1,2,3,4],'f':5}")) == 15);
        p(sum(removeRedObjects("[1,'red',5]")) == 6);
    }

    private static int sum(String str) {
        int sum = 0;

        Matcher matcher = RE_INT.matcher(str);
        while (matcher.find()) {
            sum += Integer.parseInt(matcher.group());
        }

        return sum;
    }

    private static String removeRedObjects(String str) {
        boolean[] isRedObject = new boolean[str.length()];

        for (int i = 0; i < str.length() - 2; i++) {
            if (str.startsWith(RED, i)) {
                int start = i;
                int startBraceCount = 0;
                int startBracketCount = 0;
                for (int j = start - 1; j >= 0; j--) {
                    if (str.charAt(j) == '{') {
                        if (startBraceCount == 0) {
                            start = j;
                            break;
                        } else {
                            startBraceCount--;
                        }
                    } else if (str.charAt(j) == '}') {
                        startBraceCount++;
                    } else if (str.charAt(j) == '[') {
                        if (startBracketCount == 0) {
                            break;
                        } else {
                            startBracketCount--;
                        }
                    } else if (str.charAt(j) == ']') {
                        startBracketCount++;
                    }
                }

                int end = i + 2;
                int endBraceCount = 0;
                int endBracketCount = 0;
                for (int j = end + 1; j < str.length(); j++) {
                    if (str.charAt(j) == '}') {
                        if (endBraceCount == 0) {
                            end = j;
                            break;
                        } else {
                            endBraceCount--;
                        }
                    } else if (str.charAt(j) == '{') {
                        endBraceCount++;
                    } else if (str.charAt(j) == ']') {
                        if (endBracketCount == 0) {
                            break;
                        } else {
                            endBracketCount--;
                        }
                    } else if (str.charAt(j) == '[') {
                        endBracketCount++;
                    }
                }

                for (int j = start; j <= end; j++) {
                    isRedObject[j] = true;
                }
            }
        }

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < str.length(); i++) {
            if (!isRedObject[i]) {
                sb.append(str.charAt(i));
            }
        }

        return sb.toString();
    }
}
