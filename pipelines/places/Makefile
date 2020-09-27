.PHONY: check test format-check format mypy

check: format-check mypy test

test:
	@echo ">>> unit test"
	python -m unittest discover -p '*_test.py'

format-check:
	@echo ">>> black format check"
	black --check --target-version py38 --line-length 132 greenwalking/ *.py

format:
	@echo ">>> black format"
	black --target-version py38 --line-length 132 greenwalking/ *.py

mypy:
	@echo ">>> mypy type check"
	mypy --config-file mypy.ini greenwalking/ *.py
