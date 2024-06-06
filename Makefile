.PHONY: setup check

setup:
	dart pub get
	dart pub global activate melos
	dart pub global activate protoc_plugin
	melos bootstrap

generate-protos:
	cd pkgs/projects_api/protos; protoc --dart_out=grpc:../lib projects_api.proto

check:
	melos run format
	melos test
	melos run cyclic_dependency_checks
