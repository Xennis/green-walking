import os
import tempfile
import unittest

from apache_beam.testing.test_pipeline import TestPipeline
from apache_beam.testing.util import assert_that, equal_to

from greenwalking.pipeline.parkdata.wikidata import Query


class TestQuery(unittest.TestCase):
    def test_known(self):
        with tempfile.TemporaryDirectory() as base_path:
            state_file = os.path.join(base_path, "state.json")
            with open(state_file, "w") as f:
                f.write("Q1234\nQ54321")
            expected = ["Q1234", "Q54321"]

            with TestPipeline() as p:
                actual = p | Query("does not matter", state_file=state_file, user_agent="some-agent")
                assert_that(actual, equal_to(expected))

            actual_state = []
            with open(state_file) as f:
                for line in f:
                    actual_state.append(line.rstrip("\n"))
            self.assertCountEqual(actual_state, expected)
