import java.util.Arrays;

public class Try {

    private static final String ALPHABET = "abcdefghijklmnopqrstuvwxyz";
    private static final int I = ALPHABET.indexOf('i');
    private static final int O = ALPHABET.indexOf('o');
    private static final int L = ALPHABET.indexOf('l');

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
        test();

        p(nextValid("vzbxkghb")); // Part 1
        p(nextValid("vzbxxyzz")); // Part 2
    }

    private static void test() {
        int[] test1 = toInts("hijklmmn");
        p(req1(test1) == true, req2(test1) == false, test1);

        int[] test2 = toInts("abbceffg");
        p(req1(test2) == false, req3(test2) == true, test2);

        int[] test3 = toInts("abbcegjk");
        p(req3(test3) == false, test3);

        p(nextValid("abcdefgh").equals("abcdffaa"));
        p(nextValid("ghijklmn").equals("ghjaabcc"));
    }

    private static int[] toInts(String str) {
        int[] ints = new int[str.length()];

        for (int i = 0; i < str.length(); i++) {
            ints[i] = ALPHABET.indexOf(str.charAt(i));
        }

        return ints;
    }

    private static String toStr(int[] ints) {
        StringBuilder sb = new StringBuilder();

        for (int i : ints) {
            sb.append(ALPHABET.charAt(i));
        }

        return sb.toString();
    }

    // Three increasing straights
    private static boolean req1(int[] ints) {
        int last = ints[0];
        int count = 1;

        for (int i = 1; i < ints.length; i++) {
            if (ints[i] == last + 1) {
                count++;
            } else {
                count = 1;
            }

            if (count == 3) {
                return true;
            }

            last = ints[i];
        }

        return false;
    }

    // No i, o, or l
    private static boolean req2(int[] ints) {
        for (int i : ints) {
            if (i == I || i == O || i == L) {
                return false;
            }
        }

        return true;
    }

    // Two pairs
    private static boolean req3(int[] ints) {
        int count = 0;

        for (int i = 0; i < ints.length - 1; i++) {
            if (ints[i] == ints[i + 1]) {
                count++;
                i++;
            }
        }

        return count >= 2;
    }

    // Increment with wrap around
    private static void increment(int[] ints) {
        int carry = 1;

        for (int i = ints.length - 1; i >= 0; i--) {
            ints[i] += carry;
            carry = ints[i] / 26;
            ints[i] %= 26;
        }
    }

    private static String nextValid(String str) {
        int[] input = toInts(str);
        do {
            increment(input);
        } while (!req1(input) || !req2(input) || !req3(input));
        return toStr(input);
    }
}
