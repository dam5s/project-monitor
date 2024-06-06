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

import 'projects_api.pbenum.dart';

export 'projects_api.pbenum.dart';

class ListProjectsRequest extends $pb.GeneratedMessage {
  factory ListProjectsRequest() => create();
  ListProjectsRequest._() : super();
  factory ListProjectsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListProjectsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListProjectsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'projectsapi'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListProjectsRequest clone() => ListProjectsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListProjectsRequest copyWith(void Function(ListProjectsRequest) updates) => super.copyWith((message) => updates(message as ListProjectsRequest)) as ListProjectsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProjectsRequest create() => ListProjectsRequest._();
  ListProjectsRequest createEmptyInstance() => create();
  static $pb.PbList<ListProjectsRequest> createRepeated() => $pb.PbList<ListProjectsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListProjectsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListProjectsRequest>(create);
  static ListProjectsRequest? _defaultInstance;
}

class ProjectInfo extends $pb.GeneratedMessage {
  factory ProjectInfo({
    $core.String? name,
    ProjectStatus? status,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  ProjectInfo._() : super();
  factory ProjectInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProjectInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProjectInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'projectsapi'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..e<ProjectStatus>(2, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: ProjectStatus.Unknown, valueOf: ProjectStatus.valueOf, enumValues: ProjectStatus.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProjectInfo clone() => ProjectInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProjectInfo copyWith(void Function(ProjectInfo) updates) => super.copyWith((message) => updates(message as ProjectInfo)) as ProjectInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProjectInfo create() => ProjectInfo._();
  ProjectInfo createEmptyInstance() => create();
  static $pb.PbList<ProjectInfo> createRepeated() => $pb.PbList<ProjectInfo>();
  @$core.pragma('dart2js:noInline')
  static ProjectInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProjectInfo>(create);
  static ProjectInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  ProjectStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(ProjectStatus v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
}

class ListProjectsResponse extends $pb.GeneratedMessage {
  factory ListProjectsResponse({
    $core.Iterable<ProjectInfo>? projects,
  }) {
    final $result = create();
    if (projects != null) {
      $result.projects.addAll(projects);
    }
    return $result;
  }
  ListProjectsResponse._() : super();
  factory ListProjectsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListProjectsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListProjectsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'projectsapi'), createEmptyInstance: create)
    ..pc<ProjectInfo>(1, _omitFieldNames ? '' : 'projects', $pb.PbFieldType.PM, subBuilder: ProjectInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListProjectsResponse clone() => ListProjectsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListProjectsResponse copyWith(void Function(ListProjectsResponse) updates) => super.copyWith((message) => updates(message as ListProjectsResponse)) as ListProjectsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProjectsResponse create() => ListProjectsResponse._();
  ListProjectsResponse createEmptyInstance() => create();
  static $pb.PbList<ListProjectsResponse> createRepeated() => $pb.PbList<ListProjectsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListProjectsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListProjectsResponse>(create);
  static ListProjectsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ProjectInfo> get projects => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
