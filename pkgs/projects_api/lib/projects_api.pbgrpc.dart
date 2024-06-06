//
//  Generated code. Do not modify.
//  source: projects_api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'projects_api.pb.dart' as $0;

export 'projects_api.pb.dart';

@$pb.GrpcServiceName('projectsapi.ProjectsApi')
class ProjectsApiClient extends $grpc.Client {
  static final _$listProjects = $grpc.ClientMethod<$0.ListProjectsRequest, $0.ListProjectsResponse>(
      '/projectsapi.ProjectsApi/ListProjects',
      ($0.ListProjectsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ListProjectsResponse.fromBuffer(value));

  ProjectsApiClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.ListProjectsResponse> listProjects($0.ListProjectsRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listProjects, request, options: options);
  }
}

@$pb.GrpcServiceName('projectsapi.ProjectsApi')
abstract class ProjectsApiServiceBase extends $grpc.Service {
  $core.String get $name => 'projectsapi.ProjectsApi';

  ProjectsApiServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListProjectsRequest, $0.ListProjectsResponse>(
        'ListProjects',
        listProjects_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListProjectsRequest.fromBuffer(value),
        ($0.ListProjectsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListProjectsResponse> listProjects_Pre($grpc.ServiceCall call, $async.Future<$0.ListProjectsRequest> request) async {
    return listProjects(call, await request);
  }

  $async.Future<$0.ListProjectsResponse> listProjects($grpc.ServiceCall call, $0.ListProjectsRequest request);
}
