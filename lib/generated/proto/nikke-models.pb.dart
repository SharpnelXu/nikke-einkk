//
//  Generated code. Do not modify.
//  source: proto/nikke-models.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ResStaticDataPackInfo extends $pb.GeneratedMessage {
  factory ResStaticDataPackInfo({
    $core.String? url,
    $fixnum.Int64? size,
    $core.List<$core.int>? sha256Sum,
    $core.List<$core.int>? salt1,
    $core.List<$core.int>? salt2,
    $core.String? version,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (size != null) result.size = size;
    if (sha256Sum != null) result.sha256Sum = sha256Sum;
    if (salt1 != null) result.salt1 = salt1;
    if (salt2 != null) result.salt2 = salt2;
    if (version != null) result.version = version;
    return result;
  }

  ResStaticDataPackInfo._();

  factory ResStaticDataPackInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResStaticDataPackInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResStaticDataPackInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'nikke.einkk.models'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'sha256Sum', $pb.PbFieldType.OY, protoName: 'sha256Sum')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'salt1', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'salt2', $pb.PbFieldType.OY)
    ..aOS(6, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResStaticDataPackInfo clone() => ResStaticDataPackInfo()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResStaticDataPackInfo copyWith(void Function(ResStaticDataPackInfo) updates) =>
      super.copyWith((message) => updates(message as ResStaticDataPackInfo)) as ResStaticDataPackInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResStaticDataPackInfo create() => ResStaticDataPackInfo._();
  @$core.override
  ResStaticDataPackInfo createEmptyInstance() => create();
  static $pb.PbList<ResStaticDataPackInfo> createRepeated() => $pb.PbList<ResStaticDataPackInfo>();
  @$core.pragma('dart2js:noInline')
  static ResStaticDataPackInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResStaticDataPackInfo>(create);
  static ResStaticDataPackInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get size => $_getI64(1);
  @$pb.TagNumber(2)
  set size($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get sha256Sum => $_getN(2);
  @$pb.TagNumber(3)
  set sha256Sum($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSha256Sum() => $_has(2);
  @$pb.TagNumber(3)
  void clearSha256Sum() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get salt1 => $_getN(3);
  @$pb.TagNumber(4)
  set salt1($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSalt1() => $_has(3);
  @$pb.TagNumber(4)
  void clearSalt1() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get salt2 => $_getN(4);
  @$pb.TagNumber(5)
  set salt2($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSalt2() => $_has(4);
  @$pb.TagNumber(5)
  void clearSalt2() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get version => $_getSZ(5);
  @$pb.TagNumber(6)
  set version($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => $_clearField(6);
}

class ResGetResourceHosts2 extends $pb.GeneratedMessage {
  factory ResGetResourceHosts2({
    $core.String? version,
    $core.String? baseUrl,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? coreVersionMap,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? dataPackVersionMap,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (baseUrl != null) result.baseUrl = baseUrl;
    if (coreVersionMap != null) result.coreVersionMap.addEntries(coreVersionMap);
    if (dataPackVersionMap != null) result.dataPackVersionMap.addEntries(dataPackVersionMap);
    return result;
  }

  ResGetResourceHosts2._();

  factory ResGetResourceHosts2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResGetResourceHosts2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResGetResourceHosts2',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'nikke.einkk.models'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'baseUrl', protoName: 'baseUrl')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'coreVersionMap',
        protoName: 'coreVersionMap',
        entryClassName: 'ResGetResourceHosts2.CoreVersionMapEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('nikke.einkk.models'))
    ..m<$core.String, $core.String>(4, _omitFieldNames ? '' : 'dataPackVersionMap',
        protoName: 'dataPackVersionMap',
        entryClassName: 'ResGetResourceHosts2.DataPackVersionMapEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('nikke.einkk.models'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResGetResourceHosts2 clone() => ResGetResourceHosts2()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResGetResourceHosts2 copyWith(void Function(ResGetResourceHosts2) updates) =>
      super.copyWith((message) => updates(message as ResGetResourceHosts2)) as ResGetResourceHosts2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResGetResourceHosts2 create() => ResGetResourceHosts2._();
  @$core.override
  ResGetResourceHosts2 createEmptyInstance() => create();
  static $pb.PbList<ResGetResourceHosts2> createRepeated() => $pb.PbList<ResGetResourceHosts2>();
  @$core.pragma('dart2js:noInline')
  static ResGetResourceHosts2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResGetResourceHosts2>(create);
  static ResGetResourceHosts2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get baseUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBaseUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get coreVersionMap => $_getMap(2);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.String> get dataPackVersionMap => $_getMap(3);
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
