.PHONY: check format format-check lint test release-android release-web

LIB_DIR = lib/
TEST_DIR = test/

check: lint test

format:
	@echo ">>> Flutter format"
	dart format -l 120 $(LIB_DIR) $(TEST_DIR)

format-check:
	@echo ">>> Check Dart format"
	dart format -l 120 --set-exit-if-changed $(LIB_DIR) $(TEST_DIR)

lint:
	@echo ">>> Flutter analyze"
	flutter analyze $(LIB_DIR) $(TEST_DIR)

test:
	@echo ">>> Flutter test"
	flutter test $(TEST_DIR)

release-android:
	@echo ">>> [Android] Flutter build release"
	flutter build appbundle
	@echo ">>> [Android] Fastlane upload to Play Store"
	cd android && bundle exec fastlane alpha

upgrade:
	@echo ">>> Upgrade Flutter dependencies"
	flutter pub upgrade --major-versions
	@echo ">>> Upgrade Fastlane dependencies"
	cd android/ && bundle update
