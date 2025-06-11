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

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use resStaticDataPackInfoDescriptor instead')
const ResStaticDataPackInfo$json = {
  '1': 'ResStaticDataPackInfo',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'size', '3': 2, '4': 1, '5': 4, '10': 'size'},
    {'1': 'sha256Sum', '3': 3, '4': 1, '5': 12, '10': 'sha256Sum'},
    {'1': 'salt1', '3': 4, '4': 1, '5': 12, '10': 'salt1'},
    {'1': 'salt2', '3': 5, '4': 1, '5': 12, '10': 'salt2'},
    {'1': 'version', '3': 6, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `ResStaticDataPackInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resStaticDataPackInfoDescriptor =
    $convert.base64Decode('ChVSZXNTdGF0aWNEYXRhUGFja0luZm8SEAoDdXJsGAEgASgJUgN1cmwSEgoEc2l6ZRgCIAEoBF'
        'IEc2l6ZRIcCglzaGEyNTZTdW0YAyABKAxSCXNoYTI1NlN1bRIUCgVzYWx0MRgEIAEoDFIFc2Fs'
        'dDESFAoFc2FsdDIYBSABKAxSBXNhbHQyEhgKB3ZlcnNpb24YBiABKAlSB3ZlcnNpb24=');

@$core.Deprecated('Use resGetResourceHosts2Descriptor instead')
const ResGetResourceHosts2$json = {
  '1': 'ResGetResourceHosts2',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
    {'1': 'baseUrl', '3': 2, '4': 1, '5': 9, '10': 'baseUrl'},
    {
      '1': 'coreVersionMap',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.nikke.einkk.models.ResGetResourceHosts2.CoreVersionMapEntry',
      '10': 'coreVersionMap'
    },
    {
      '1': 'dataPackVersionMap',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.nikke.einkk.models.ResGetResourceHosts2.DataPackVersionMapEntry',
      '10': 'dataPackVersionMap'
    },
  ],
  '3': [ResGetResourceHosts2_CoreVersionMapEntry$json, ResGetResourceHosts2_DataPackVersionMapEntry$json],
};

@$core.Deprecated('Use resGetResourceHosts2Descriptor instead')
const ResGetResourceHosts2_CoreVersionMapEntry$json = {
  '1': 'CoreVersionMapEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use resGetResourceHosts2Descriptor instead')
const ResGetResourceHosts2_DataPackVersionMapEntry$json = {
  '1': 'DataPackVersionMapEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ResGetResourceHosts2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resGetResourceHosts2Descriptor =
    $convert.base64Decode('ChRSZXNHZXRSZXNvdXJjZUhvc3RzMhIYCgd2ZXJzaW9uGAEgASgJUgd2ZXJzaW9uEhgKB2Jhc2'
        'VVcmwYAiABKAlSB2Jhc2VVcmwSZAoOY29yZVZlcnNpb25NYXAYAyADKAsyPC5uaWtrZS5laW5r'
        'ay5tb2RlbHMuUmVzR2V0UmVzb3VyY2VIb3N0czIuQ29yZVZlcnNpb25NYXBFbnRyeVIOY29yZV'
        'ZlcnNpb25NYXAScAoSZGF0YVBhY2tWZXJzaW9uTWFwGAQgAygLMkAubmlra2UuZWlua2subW9k'
        'ZWxzLlJlc0dldFJlc291cmNlSG9zdHMyLkRhdGFQYWNrVmVyc2lvbk1hcEVudHJ5UhJkYXRhUG'
        'Fja1ZlcnNpb25NYXAaQQoTQ29yZVZlcnNpb25NYXBFbnRyeRIQCgNrZXkYASABKAlSA2tleRIU'
        'CgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgBGkUKF0RhdGFQYWNrVmVyc2lvbk1hcEVudHJ5EhAKA2'
        'tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');
