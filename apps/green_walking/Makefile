check: lint test

format-check:
	@echo ">>> Check Dart format"
	# Exclude the auto-generated intl files
	find . -name '*.dart' -not -name 'messages_*.dart' -exec dart format --set-exit-if-changed {} \;

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

i10n:
	@echo ">>> intl generate intl_messages.arb"
	flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/intl.dart
	@echo ">>> intl generate messages_all.dart"
	flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/intl.dart lib/l10n/intl_*.arb
