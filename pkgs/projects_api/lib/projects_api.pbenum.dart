//
//  Generated code. Do not modify.
//  source: projects_api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ProjectStatus extends $pb.ProtobufEnum {
  static const ProjectStatus Unknown = ProjectStatus._(0, _omitEnumNames ? '' : 'Unknown');
  static const ProjectStatus Running = ProjectStatus._(1, _omitEnumNames ? '' : 'Running');
  static const ProjectStatus Success = ProjectStatus._(2, _omitEnumNames ? '' : 'Success');
  static const ProjectStatus Failure = ProjectStatus._(3, _omitEnumNames ? '' : 'Failure');

  static const $core.List<ProjectStatus> values = <ProjectStatus> [
    Unknown,
    Running,
    Success,
    Failure,
  ];

  static final $core.Map<$core.int, ProjectStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ProjectStatus? valueOf($core.int value) => _byValue[value];

  const ProjectStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
