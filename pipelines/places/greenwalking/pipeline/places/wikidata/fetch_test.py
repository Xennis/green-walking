import json
import os
import tempfile
import unittest

from apache_beam import Create
from apache_beam.testing.test_pipeline import TestPipeline
from apache_beam.testing.util import assert_that, equal_to

from greenwalking.pipeline.places.wikidata import Fetch


class TestFetch(unittest.TestCase):
    def test_known(self):
        with tempfile.TemporaryDirectory() as base_path:
            state_file = os.path.join(base_path, "state.json")
            with open(state_file, "w") as f:
                f.write(
                    """\
{"some": "json"}
{"another": "jsonx"}
"""
                )
            expected = [{"some": "json"}, {"another": "jsonx"}]

            with TestPipeline() as p:
                actual = p | Create(["Q1234", "Q54321"]) | Fetch(state_file, user_agent="some-agent")
                assert_that(actual, equal_to(expected))

            actual_state = []
            with open(state_file) as f:
                for line in f:
                    actual_state.append(json.loads(line.rstrip("\n")))
            self.assertCountEqual(expected, actual_state)
