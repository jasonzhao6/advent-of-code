// public static void main(String[] args) {
//     for (String line : File.read("input.txt")) {
//         doStuff(line);
//     }
// }

import java.io.*;
import java.nio.file.*;

public class File {
    static String[] read(String filename) {
        String lines = null;

        try {
            lines = Files.readString(Path.of(filename));
        } catch (IOException e) {
            System.out.println("! IOException");
            System.exit(1);
        }

        return lines.split("\n");
    }
}
