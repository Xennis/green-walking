.PHONY: check format-check lint test launcher-icon release-android release-web i10n

check: lint test

format-check:
	@echo ">>> Check Dart format"
	# Exclude the auto-generated intl files
	find . -name '*.dart' -not -name 'messages_*.dart' -exec flutter format --set-exit-if-changed {} \;

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

i10n:
	@echo ">>> intl generate intl_messages.arb"
	flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/intl.dart
	@echo ">>> intl generate messages_all.dart"
	flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/intl.dart lib/l10n/intl_*.arb
