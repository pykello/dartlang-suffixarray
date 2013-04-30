library SuffixArray;

import 'dart:math' as math;

class SuffixArray {
  String _data;
  List<int> _sortedSuffixes;
  List<int> _buckets;
  List<int> _reverseMap;
  
  SuffixArray(String data) {
    _data = data;
    _suffixSort();
  }
  
  int count(String pattern) {
    int firstEqual = _findFirstEqual(pattern);
    int lastEqual = _findLastEqual(pattern);
    int result = (firstEqual == -1 ? 0 : lastEqual - firstEqual + 1);
    return result;
  }
  
  List<int> lookup(String pattern, [int resultLimit]) {
    List<int> result = [];
    
    int firstEqual = _findFirstEqual(pattern);
    int lastEqual = _findLastEqual(pattern);
    
    for (int index = math.max(0, firstEqual); index <= lastEqual; index++) {
      if (resultLimit != null && result.length >= resultLimit) {
        break;
      }
      result.add(_sortedSuffixes[index]);
    }
    
    return result;
  }
  
  List<int> getSortedSuffixes() {
    return _sortedSuffixes.toList();
  }
  
  void _suffixSort() {
    _sortByFirstCharacter();
    _initBuckets();
    _initReverseMap();
    int bucketSize = 1;
    while (_buckets.last != _data.length) {
      bucketSize *= 2;
      _sortByPrefixSize(bucketSize);
      _updateBuckets(bucketSize);
      _initReverseMap();
    }
  }
  
  int _findFirstEqual(String pattern) {
    return _binarySearch(pattern, 
        (String pattern, String substr) => substr.compareTo(pattern) >= 0);
  }
  
  int _findLastEqual(String pattern) {
    return _binarySearch(pattern,
        (String pattern, String substr) => substr.compareTo(pattern) > 0);
  }
  
  int _binarySearch(String pattern, Function isOnLeft) {
    int result = -1;
    int left = 0;
    int right = _sortedSuffixes.length - 1;
    int len = pattern.length;
        
    while (left <= right) {
      int mid = (left + right) ~/ 2;
      int substrStart = _sortedSuffixes[mid];
      int substrEnd = math.min(substrStart + len, _data.length);

      String substr = _data.substring(substrStart, substrEnd);
      
      if (substr == pattern) {
        result = mid;
      }
      
      if (isOnLeft(pattern, substr)) {
        right = mid - 1;
      } else {
        left = mid + 1;
      }
    }
    
    return result;
  }
  
  void _sortByFirstCharacter() {
    Map<int, int> charFreq;
    List<int> charList;
    Map<int, int> bucketStart = new Map<int, int>();
    int sum = 0;
    
    charFreq = _getCharFrequencies();
    charList = charFreq.keys.toList();
    charList.sort();
        
    for(int index = 0; index < charList.length; index++) {
      int c = charList[index];
      bucketStart[c] = sum;
      sum += charFreq[c];
    }
    
    _sortedSuffixes = new List<int>(sum);
    for (int index = 0; index <= _data.length; index++) {
      int c = (index == _data.length ? 0 : _data.codeUnitAt(index));
      _sortedSuffixes[bucketStart[c]] = index;
      bucketStart[c]++;
    }
  }
  
  void _initReverseMap() {
    _reverseMap = new List<int>(_sortedSuffixes.length);
    for (int index = 0; index < _sortedSuffixes.length; index++) {
      _reverseMap[_sortedSuffixes[index]] = index;
    }
  }
  
  Map<int, int> _getCharFrequencies() {
    Map<int, int> charFreq = new Map<int, int>();

    for (int index = 0; index <= _data.length; index++) {
      int c = (index == _data.length ? 0 : _data.codeUnitAt(index));
      if (charFreq.containsKey(c)) {
        charFreq[c]++;
      } else {
        charFreq[c] = 1;
      }
    }
    
    return charFreq;
  }
  
  void _initBuckets() {
    int bucketId = 0;
    _buckets = new List<int>(_sortedSuffixes.length);
    _buckets[0] = bucketId;
    
    for (int index = 1; index < _buckets.length; index++) {
      int current = _sortedSuffixes[index];
      int previous = _sortedSuffixes[index - 1];
      
      bool bucketChanged = (index == 1 || _data[current] != _data[previous]);
      if (bucketChanged) {
        bucketId++;
      }
      
      _buckets[index] = bucketId;
    }
  }
  
  void _updateBuckets(int size) {
    int bucketId = 0;
    List<int> buckets = new List<int>(_buckets.length);
    buckets[0] = bucketId;
    
    for (int index = 1; index < buckets.length; index++) {
      if (!_hasSamePrefix(_sortedSuffixes[index], 
                          _sortedSuffixes[index - 1], size)) {
        bucketId++;
      }
      buckets[index] = bucketId;
    }
        
    _buckets = buckets;
  }
  
  bool _hasSamePrefix(int suffix1, int suffix2, int prefixSize) {
    bool hasSamePrefix = false;
    
    int secondHalf1 = suffix1 + (prefixSize ~/ 2);
    int secondHalf2 = suffix2 + (prefixSize ~/ 2);
    
    if (_getBucket(suffix1) == _getBucket(suffix2) && 
        _getBucket(secondHalf1) == _getBucket(secondHalf2)) {
      hasSamePrefix = true;
    } 

    return hasSamePrefix;
  }
  
  void _sortByPrefixSize(int size) {
    _sortedSuffixes.sort((a, b) {
      int bucket1 = _getBucket(a);
      int bucket2 = _getBucket(b);
      if (bucket1 != bucket2) {
        return bucket1 < bucket2 ? -1 : 1;
      }
      bucket1 = _getBucket(a + size ~/ 2);
      bucket2 = _getBucket(b + size ~/ 2);
      if (bucket1 != bucket2) {
        return bucket1 < bucket2 ? -1 : 1;
      }
      return 0;
    });
  }
  
  int _getBucket(int index) {
    if (index > _data.length) {
      return -1;
    }
    return _buckets[_reverseMap[index]];
  }
  
}
