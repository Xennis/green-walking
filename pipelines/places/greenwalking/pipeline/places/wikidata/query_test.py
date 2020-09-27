import os
import tempfile
import unittest

from apache_beam import Create
from apache_beam.testing.test_pipeline import TestPipeline
from apache_beam.testing.util import assert_that, equal_to
from sqlitedict import SqliteDict

from greenwalking.pipeline.places.wikidata import Query


class TestQuery(unittest.TestCase):
    def test_known(self):
        with tempfile.TemporaryDirectory() as base_path:
            cache_file = os.path.join(base_path, "cache.json")
            cache = SqliteDict(cache_file, autocommit=True)
            cache["monument"] = ["Q1234", "Q54321"]
            cache.close()

            data = [("monument", "query-does-not-matter")]
            expected = [("Q1234", "monument"), ("Q54321", "monument")]

            with TestPipeline() as p:
                actual = p | Create(data) | Query(cache_file, user_agent="some-agent")
                assert_that(actual, equal_to(expected))
