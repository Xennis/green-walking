check: lint test

format-check:
	@echo ">>> Check Dart format"
	dart format --set-exit-if-changed .

lint:
	@echo ">>> Flutter analyze"
	flutter analyze

test:
	@echo ">>> Flutter test"
	flutter test

launcher-icon:
	flutter pub run flutter_launcher_icons:main

release:
	@echo ">>> Flutter release web"
	flutter build web
	@echo ">>> Flutter release Android"
	flutter build appbundle
