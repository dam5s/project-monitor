.PHONY: setup codegen check

setup:
	dart pub get
	dart pub global activate melos
	dart pub global activate protoc_plugin
	melos bootstrap

codegen:
	melos run protoc --no-select
	melos run build_runner --no-select
	melos run format

check:
	melos run format -- --set-exit-if-changed
	make codegen
	melos test
	melos run cyclic_dependency_checks
