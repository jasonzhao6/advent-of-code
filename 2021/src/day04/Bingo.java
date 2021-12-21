package day04;

public class Bingo {
    public final static int SIZE = 5;
    private final int[][] board;
    private final boolean[][] marks;

    public Bingo(int[][] board) {
        this.board = board;
        this.marks = new boolean[SIZE][SIZE];
    }

    public void mark(int value) {
        for (int i = 0; i < SIZE; i++) {
            for (int j = 0; j < SIZE; j++) {
                if (board[i][j] == value) {
                    this.marks[i][j] = true;
                }
            }
        }
    }

    public int unmarkedSum() {
        int sum = 0;

        for (int i = 0; i < SIZE; i++) {
            for (int j = 0; j < SIZE; j++) {
                if (!marks[i][j]) {
                    sum += this.board[i][j];
                }
            }
        }

        return sum;
    }

    public boolean hasWon() {
        for (int i = 0; i < SIZE; i++) {
            boolean hasRowWon = true;
            boolean hasColWon = true;

            for (int j = 0; j < SIZE; j++) {
                if (!marks[i][j]) {
                    hasRowWon = false;
                    break;
                }
            }

            for (int j = 0; j < SIZE; j++) {
                if (!marks[j][i]) {
                    hasColWon = false;
                    break;
                }
            }

            if (hasRowWon || hasColWon) {
                return true;
            }
        }

        return false;
    }
}
