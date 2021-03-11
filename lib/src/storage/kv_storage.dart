
//todo batch set
///T must be bool,int,double,string,Uint8List
abstract class KVStorage {

  Future<void> load();

  T get<T>(String key,{String namespace});

  Future<void> set(String key,Object value,{String namespace});

}