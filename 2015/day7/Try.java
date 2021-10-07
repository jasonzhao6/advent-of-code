import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

public class Try {
    private static class Expression {
        public String src1;
        public String src2;
        public String op;
        public Map<String, Expression> expMap;
        public Integer val;

        public Expression(
            String src1,
            String src2,
            String op,
            Map<String, Expression> expMap
        ) {
            // Props
            this.src1 = src1;
            this.src2 = src2;
            this.op = op;
            this.expMap = expMap;

            // States
            this.val = null;
        }

        public int eval() {
            if (this.val != null) {
                return this.val;
            }

            Integer src1 = null;
            if (this.src1 != null) {
                try {
                    src1 = Integer.parseInt(this.src1);
                } catch(NumberFormatException e) {
                    src1 = this.expMap.get(this.src1).eval();
                }
            }

            Integer src2 = null;
            if (this.src2 != null) {
                try {
                    src2 = Integer.parseInt(this.src2);
                } catch(NumberFormatException e) {
                    src2 = this.expMap.get(this.src2).eval();
                }
            }

            if (this.op == null) {
                this.val = src2;
            } else {
                switch(this.op) {
                    case "AND":
                        this.val = src1 & src2;
                        break;
                    case "OR":
                        this.val = src1 | src2;
                        break;
                    case "LSHIFT":
                        this.val = src1 << src2;
                        break;
                    case "RSHIFT":
                        this.val = src1 >> src2;
                        break;
                    case "NOT":
                        this.val = ~src2;
                        break;
                    default:
                        throw new RuntimeException("!");
                };
            }

            return this.val;
        }
    }

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

    static void tryThings() {
        p("x", new int[] {1, 2}, new Integer[] {1, 2}, new String[] {"a", "b"});
    }

    public static void main(String[] args) {
        // tryThings();

        String fileName = "./input.txt";
        File file = new File(fileName);

        try (Stream<String> lines = Files.lines (file.toPath())) {
            Pattern r = Pattern.compile(
                // Source 1
                "((?<src1>[0-9a-z]+) )?" +
                // Operator
                "((?<op>AND|OR|LSHIFT|RSHIFT|NOT) )?" +
                // Source 2
                "(?<src2>[0-9a-z]+)" +
                // Assignment
                " -> " +
                // Destination
                "(?<dest>[a-z]+)"
            );
            Map<String, Expression> expMap = new HashMap<String, Expression>();

            lines.forEach(line -> {
                Matcher m = r.matcher(line);
                m.find();

                Expression exp = new Expression(
                    m.group("src1"),
                    m.group("src2"),
                    m.group("op"),
                    expMap
                );
                expMap.put(m.group("dest"), exp);
            });

            // Part 2 override
            expMap.get("b").val = 3176;

            p(expMap.get("a").eval());
        } catch(IOException e) {
            p("! IOException");
        }
    }
}
