.PHONY: check format format-check lint test launcher-icon release-android release-web

check: lint test

format:
	@echo ">>> Flutter format"
	flutter format .

format-check:
	@echo ">>> Check Dart format"
	flutter format --set-exit-if-changed .

lint:
	@echo ">>> Flutter analyze"
	flutter analyze .

test:
	@echo ">>> Flutter test"
	flutter test .

launcher-icon:
	flutter pub run flutter_launcher_icons:main

release-android:
	@echo ">>> [Android] Flutter build release"
	flutter build appbundle
	@echo ">>> [Android] Fastlane upload to Play Store"
	cd android && bundle exec fastlane alpha

release-web:
	@echo ">>> [Web] Flutter build release"
	flutter build web
