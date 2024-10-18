import 'dart:convert';
import 'dart:io';

import 'package:project_monitor_server/projects/project_record.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

class TestGithubServer {
  static Future<TestGithubServer> start() async {
    final app = Router();
    final server = TestGithubServer._(app);

    await server._start();

    return server;
  }

  late final HttpServer _server;
  final Router _app;
  final List<StubbedWorkflowRun> _stubbedWorkflowRuns = [];

  final recordedRequests = List<Request>.empty(growable: true);

  TestGithubServer._(this._app);

  Future<void> _start() async {
    _app.get('/repos/<owner>/<name>/actions/runs', (Request request, String owner, String name) {
      recordedRequests.add(request);
      return _buildWorkflowRunsResponse(owner, name);
    });

    _server = await io.serve(_app.call, 'localhost', 0);
  }

  String url() {
    return 'http://localhost:${_server.port}';
  }

  Future<void> close() {
    return _server.close();
  }

  void stubWorkflowRun(StubbedWorkflowRun run) {
    _stubbedWorkflowRuns.add(run);
  }

  Response _buildWorkflowRunsResponse(String owner, String name) {
    final matchingRuns = _stubbedWorkflowRuns
        .where((r) => r.project.repoOwner == owner && r.project.repoName == name);

    if (matchingRuns.isEmpty) {
      return Response.notFound('not found');
    }

    final runsJson = matchingRuns.map((r) => r.toJson()).toList();
    final responseJson = {'workflow_runs': runsJson};

    return Response.ok(jsonEncode(responseJson));
  }
}

final class StubbedWorkflowRun {
  final ProjectRecord project;
  final int id;
  final String name;
  final String branch;
  final String status;
  final String url;

  StubbedWorkflowRun({
    required this.project,
    required this.id,
    required this.name,
    required this.branch,
    required this.status,
    required this.url,
  });

  dynamic toJson() {
    return {'id': id, 'name': name, 'head_branch': branch, 'status': status, 'url': url};
  }
}
