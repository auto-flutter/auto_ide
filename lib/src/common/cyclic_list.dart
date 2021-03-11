import 'dart:math';

///A fixed-length circular list
class CyclicList<E> {
  final List<E> _list;
  int _head = 0;
  int _tail = 0;
  int _length = 0;

  int get _size => _list.length;

  int get length => _length;

  CyclicList(int size) : _list = List.filled(size, null);

  void add(E element) {
    _list[_tail] = element;
    if (length != 0 && _tail == _head) {
      _head = (_head + 1) % _size;
    }
    _tail = (_tail + 1) % _size;
    if (_length < _size) {
      _length++;
    }
  }

  E operator [](int index) {
    if (index >= length ) {
      throw RangeError.range(index,0,min(length-1, 0));
    }
    return _list[(_head + index) % _size];
  }
}
