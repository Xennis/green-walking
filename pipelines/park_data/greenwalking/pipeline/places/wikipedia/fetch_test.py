import json
import os
import tempfile
import unittest

from apache_beam import Create
from apache_beam.testing.test_pipeline import TestPipeline
from apache_beam.testing.util import assert_that, equal_to

from greenwalking.core import language
from greenwalking.pipeline.places import fields
from greenwalking.pipeline.places.wikipedia import Fetch


class TestFetch(unittest.TestCase):
    def test_known(self):
        with tempfile.TemporaryDirectory() as base_path:
            state_file = os.path.join(base_path, Fetch._STATE_FILE)
            with open(state_file, "w") as f:
                f.write(
                    """\
["Q1234", {"de": {"some": "json"}}]
["Q54321", {"en": {"another": "jsonx"}}]
"""
                )

            data = [
                ("Q1234", {fields.WIKIPEDIA: {language.GERMAN: {fields.TITLE: "de title"}}}),
                ("Q54321", {fields.WIKIPEDIA: {language.ENGLISH: {fields.TITLE: "en title"}}}),
            ]
            expected = [("Q1234", {language.GERMAN: {"some": "json"}}), ("Q54321", {language.ENGLISH: {"another": "jsonx"}})]

            with TestPipeline() as p:
                actual = p | Create(data) | Fetch(base_path, user_agent="some-agent")
                assert_that(actual, equal_to(expected))

            actual_state = []
            with open(state_file) as f:
                for line in f:
                    actual_state.append(tuple(json.loads(line.rstrip("\n"))))
            self.assertCountEqual(expected, actual_state)
