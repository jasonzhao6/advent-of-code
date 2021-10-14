import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
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

    static void tryThings() {
        p("\\x27", (char) Integer.parseInt("EF", 16));

        System.exit(1);
    }

    public static void main(String[] args) {
        // tryThings();

        int codeSize = 0;
        int strSize = 0;

        Pattern r = Pattern.compile(
            // E.g "\x27"
            "\\\\x[0-9a-f]{2}"
        );

        Path fileName = Path.of("./input.txt");
        String lines = null;
        try {
            lines = Files.readString(fileName);
        } catch (IOException e) {
            p("! IOException");
            System.exit(1);
        }

        for (String line : lines.split("\n")) {
            String chars = line;

            // Part 1
            // chars = chars.replace("\\\"", "_");
            // chars = chars.replace("\\\\", "_");
            //
            // Matcher m = r.matcher(chars);
            // while (m.find()) {
            //     chars = chars.replace(m.group(), "_");
            // };
            //
            // codeSize = codeSize + line.length();
            // strSize = strSize + chars.length() - 2;

            // Part 2
            chars = chars.replace("\"", "__");
            chars = chars.replace("\\", "__");

            codeSize = codeSize + line.length();
            strSize = strSize + chars.length() + 2;
        }

        p(codeSize, strSize, codeSize - strSize);
    }
}
