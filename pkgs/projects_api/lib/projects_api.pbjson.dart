//
//  Generated code. Do not modify.
//  source: projects_api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use projectStatusDescriptor instead')
const ProjectStatus$json = {
  '1': 'ProjectStatus',
  '2': [
    {'1': 'Unknown', '2': 0},
    {'1': 'Running', '2': 1},
    {'1': 'Success', '2': 2},
    {'1': 'Failure', '2': 3},
  ],
};

/// Descriptor for `ProjectStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List projectStatusDescriptor = $convert
    .base64Decode('Cg1Qcm9qZWN0U3RhdHVzEgsKB1Vua25vd24QABILCgdSdW5uaW5nEAESCwoHU3VjY2VzcxACEg'
        'sKB0ZhaWx1cmUQAw==');

@$core.Deprecated('Use listProjectsRequestDescriptor instead')
const ListProjectsRequest$json = {
  '1': 'ListProjectsRequest',
};

/// Descriptor for `ListProjectsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProjectsRequestDescriptor =
    $convert.base64Decode('ChNMaXN0UHJvamVjdHNSZXF1ZXN0');

@$core.Deprecated('Use projectInfoDescriptor instead')
const ProjectInfo$json = {
  '1': 'ProjectInfo',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'status', '3': 2, '4': 1, '5': 14, '6': '.projectsapi.ProjectStatus', '10': 'status'},
  ],
};

/// Descriptor for `ProjectInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectInfoDescriptor = $convert
    .base64Decode('CgtQcm9qZWN0SW5mbxISCgRuYW1lGAEgASgJUgRuYW1lEjIKBnN0YXR1cxgCIAEoDjIaLnByb2'
        'plY3RzYXBpLlByb2plY3RTdGF0dXNSBnN0YXR1cw==');

@$core.Deprecated('Use listProjectsResponseDescriptor instead')
const ListProjectsResponse$json = {
  '1': 'ListProjectsResponse',
  '2': [
    {'1': 'projects', '3': 1, '4': 3, '5': 11, '6': '.projectsapi.ProjectInfo', '10': 'projects'},
  ],
};

/// Descriptor for `ListProjectsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProjectsResponseDescriptor = $convert
    .base64Decode('ChRMaXN0UHJvamVjdHNSZXNwb25zZRI0Cghwcm9qZWN0cxgBIAMoCzIYLnByb2plY3RzYXBpLl'
        'Byb2plY3RJbmZvUghwcm9qZWN0cw==');
