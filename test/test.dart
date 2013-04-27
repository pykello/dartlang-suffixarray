import 'package:unittest/unittest.dart';
import 'package:suffixarray/suffixarray.dart';

main() {
  group('basic operations:', () {
    final data = '321321';
    final expectedSortedSuffixes = [6, 5, 2, 4, 1, 3, 0];
    
    SuffixArray suffixArray;
    
    setUp(() {
      suffixArray = new SuffixArray(data);
    });
    
    test('get sorted suffixes', () {
      expect(suffixArray.getSortedSuffixes(), equals(expectedSortedSuffixes));
    });
    
    test('get sorted suffixes does not leak the original list', () {
      List<int> sortedSuffixes = suffixArray.getSortedSuffixes();
      sortedSuffixes.sort();
      expect(suffixArray.getSortedSuffixes(), equals(expectedSortedSuffixes));
    });
    
    test('count pattern 1', () {
      expect(suffixArray.count('21'), equals(2));
    });
    
    test('count pattern 2', () {
      expect(suffixArray.count('213'), equals(1));
    });
    
    test('count pattern 3', () {
      expect(suffixArray.count('2134'), equals(0));
    });
    
    test('lookup 1', () {
      expect(suffixArray.lookup('21'), unorderedEquals([1, 4]));
    });
    
    test('lookup 2', () {
      List<int> lookupResult = suffixArray.lookup('21', 1);
      expect(lookupResult.length, equals(1));
      expect(lookupResult[0], isIn([1, 4]));
    });
    
    test('lookup 3', () {
      expect(suffixArray.lookup('4'), equals([]));
    });
  });
  
  group('special cases:', () {
    group('repetitions of same character: ', () {
      SuffixArray suffixArray;
      
      setUp(() {
        suffixArray = new SuffixArray("aaaaa");
      });
      
      test('suffix sort', () {
        expect(suffixArray.getSortedSuffixes(), equals([5, 4, 3, 2, 1, 0]));
      });
      
      test('count pattern 1', () {
        expect(suffixArray.count("a"), equals(5));
      });
      
      test('count pattern 2', () {
        expect(suffixArray.count("aaa"), equals(3));
      });
      
      test('count pattern 3', () {
        expect(suffixArray.count("aaaaaa"), equals(0));
      });
      
      test('lookup', () {
        expect(suffixArray.lookup("aa"), unorderedEquals([0, 1, 2, 3]));
      });
    });
    
    group('empty string:', () {
      SuffixArray suffixArray;
      
      setUp(() {
        suffixArray = new SuffixArray("");
      });
      
      test('suffix sort', () {
        expect(suffixArray.getSortedSuffixes(), equals([0]));
      });
      
      test('count pattern', () {
        expect(suffixArray.count("12"), equals(0));
      });
      
      test('lookup', () {
        expect(suffixArray.lookup("12"), equals([]));
      });
    });
    
    test('sorted string', () {
      SuffixArray suffixArray = new SuffixArray("12345");
      expect(suffixArray.getSortedSuffixes(), equals([5, 0, 1, 2, 3, 4]));
    });
  });
  
  group('unicode strings:', () {
    SuffixArray suffixArray;
    
    setUp(() {
      suffixArray = new SuffixArray("ຂບວນ");      
    });
    
    test('suffix sort', () {
      expect(suffixArray.getSortedSuffixes(), equals([4, 0, 3, 1, 2]));
    });
    
    test('count pattern', () {
      expect(suffixArray.count("ຂບວນ"), equals(1));
    });
    
    test('lookup', () {
      expect(suffixArray.lookup("ຂບວນ"), equals([0]));
    });
  });
}
