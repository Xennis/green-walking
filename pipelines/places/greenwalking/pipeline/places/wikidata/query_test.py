import os
import tempfile
import unittest

import apache_beam as beam
from apache_beam.testing.test_pipeline import TestPipeline
from apache_beam.testing.util import assert_that, equal_to
from sqlitedict import SqliteDict

from greenwalking.core import country
from greenwalking.pipeline.places.ctypes import TYP_MONUMENT
from greenwalking.pipeline.places.wikidata import Query


class TestQuery(unittest.TestCase):
    def test_known(self):
        with tempfile.TemporaryDirectory() as base_path:
            cache_file = os.path.join(base_path, "cache.json")
            cache = SqliteDict(cache_file, autocommit=True)
            cache["{}#{}".format(country.GERMANY, TYP_MONUMENT)] = ["Q1234", "Q54321"]
            cache.close()

            data = [((country.GERMANY, TYP_MONUMENT), "query-does-not-matter")]
            expected = [("Q1234", (country.GERMANY, TYP_MONUMENT)), ("Q54321", (country.GERMANY, TYP_MONUMENT))]

            with TestPipeline() as p:
                actual = p | beam.Create(data) | Query(cache_file, user_agent="some-agent")
                assert_that(actual, equal_to(expected))
