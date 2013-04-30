#Suffix Array for Dart

[Suffix Array](http://en.wikipedia.org/wiki/Suffix_array) is a data-structure which can be used for indexing and searching texts.

##Time and Space Complexity
The time complexity for different operations in the current implementation are:

* Create: O(N * log^2 N), where N is length of input string
* Locate: O(P * log N + Occ), where P is length of pattern to be searched, and Occ is size of result
* Count: O(P * log N)

The space complexity of the data structure is O(N).

##Example Usage
The following code creates a suffix array for the string "abcabc" and then searches for substrings in that:

    import 'package:suffixarray/suffixarray.dart';

    ...
    SuffixArray suffixArray = new SuffixArray("abcabc");
    print(suffixArray.lookup("abc")); // prints [0, 3]
    print(suffixArray.count("abc")); // prints 2
