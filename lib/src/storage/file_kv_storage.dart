import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_ide/protos/file_storage.pbserver.dart';
import 'package:auto_ide/src/storage/kv_storage.dart';

///A file-based kv storage
class FileStorage implements KVStorage {
  final File _file;
  FileStorageBucket _bucket;

  FileStorage(String path) : _file = File(path);

  @override
  Future<void> load() async {
    if (_file.existsSync()) {
      final bytes = await _file.readAsBytes();
      _bucket = FileStorageBucket.fromBuffer(bytes);
    } else {
      _bucket = FileStorageBucket();
    }
  }

  @override
  T get<T>(String key, {String namespace}) {
    final data = _bucket.bucket['$namespace:$key'];
    if (data == null) {
      return null;
    }
    if (T == String) {
      final result = utf8.decode(data);
      return result as T;
    } else if (T == int) {
      assert(data.length == 8);
      final byteData = ByteData.sublistView(Uint8List.fromList(data));
      return byteData.getInt64(0) as T;
    } else if (T == bool) {
      assert(data.length == 1);
      if (data[0] == 1) {
        return true as T;
      } else {
        return false as T;
      }
    } else if (T == Uint8List) {
      return Uint8List.fromList(data) as T;
    } else if (T == double) {
      assert(data.length == 8);
      final byteData = ByteData.sublistView(Uint8List.fromList(data));
      return byteData.getFloat64(0) as T;
    } else {
      throw TypeError();
    }
  }

  @override
  Future<void> set(String key, Object value, {String namespace}) async {
    List<int> data;
    if (value is String) {
      data = utf8.encode(value);
    } else if (value is int) {
      final byteData = ByteData(8);
      byteData.setInt64(0, value);
      data = byteData.buffer.asUint8List();
    } else if (value is bool) {
      if (value == true) {
        data = [1];
      } else {
        data = [0];
      }
    } else if (value is Uint8List) {
      data = value;
    } else if (value is double) {
      final byteData = ByteData(8);
      byteData.setFloat64(0, value);
      data = byteData.buffer.asUint8List();
    } else {
      throw TypeError();
    }

    _bucket.bucket['$namespace:$key'] = data;
    await _save();
  }

  Future<void> _save() async {
    return _file.writeAsBytes(_bucket.writeToBuffer());
  }
}
