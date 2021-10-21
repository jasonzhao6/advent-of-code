// public static void main(String[] args) {
//     Set<String> cities = new HashSet<>();
//     List<List<String>> permutations = Permutation.<String>permute(cities);
//
//     for (List<String> permutation : permutations) {
//         doStuff(permutation);
//     }
// }

import java.util.*;

public class Permutation {
    static <T> List<List<T>> permute(Set<T> set) {
        List<List<T>> list = new ArrayList<>();
        permute(list, new ArrayList<>(), set);
        return list;
    }

    private static <T> void permute(List<List<T>> list, List<T> resultList, Set<T> set){
        // Base case
        if (resultList.size() == set.size()){
            list.add(new ArrayList<>(resultList));
        } else {
            for (T obj : set) {
                if (resultList.contains(obj)) {
                    // If element exists in the list then skip
                    continue;
                }
                // Choose element
                resultList.add(obj);
                // Explore
                permute(list, resultList, set);
                // Unchoose element
                resultList.remove(resultList.size() - 1);
            }
        }
    }
}
