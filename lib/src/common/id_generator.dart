class IdGenerator {
  static int _seed = DateTime.now().millisecondsSinceEpoch;

  static String nextId(){
    return (_seed++).toString();
  }
}