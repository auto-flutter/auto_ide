///
//  Generated code. Do not modify.
//  source: file_storage.proto
//
// @dart = 2.7
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class FileStorageBucket extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FileStorageBucket', createEmptyInstance: create)
    ..m<$core.String, $core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bucket', entryClassName: 'FileStorageBucket.BucketEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  FileStorageBucket._() : super();
  factory FileStorageBucket({
    $core.Map<$core.String, $core.List<$core.int>> bucket,
  }) {
    final _result = create();
    if (bucket != null) {
      _result.bucket.addAll(bucket);
    }
    return _result;
  }
  factory FileStorageBucket.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileStorageBucket.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileStorageBucket clone() => FileStorageBucket()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileStorageBucket copyWith(void Function(FileStorageBucket) updates) => super.copyWith((message) => updates(message as FileStorageBucket)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FileStorageBucket create() => FileStorageBucket._();
  FileStorageBucket createEmptyInstance() => create();
  static $pb.PbList<FileStorageBucket> createRepeated() => $pb.PbList<FileStorageBucket>();
  @$core.pragma('dart2js:noInline')
  static FileStorageBucket getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileStorageBucket>(create);
  static FileStorageBucket _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, $core.List<$core.int>> get bucket => $_getMap(0);
}

