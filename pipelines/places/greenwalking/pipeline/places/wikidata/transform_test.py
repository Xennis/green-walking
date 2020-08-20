import json
import os
import tempfile
import unittest

from apache_beam import Create, ParDo
from apache_beam.testing.test_pipeline import TestPipeline
from apache_beam.testing.util import assert_that, equal_to
from sqlitedict import SqliteDict

from greenwalking.pipeline.places.wikidata.transform import _CachedFetch, Transform


class TestCacheFetch(unittest.TestCase):
    def test_known(self):
        with tempfile.TemporaryDirectory(prefix="gw") as base_path:
            cache_file = os.path.join(base_path, "cache.json")
            cache = SqliteDict(cache_file, autocommit=True)
            cache["Q1234"] = {_CachedFetch._CACHE_KEY_MAIN: {"some": "json"}}
            cache["Q54321"] = {
                _CachedFetch._CACHE_KEY_MAIN: {"another": "jsonx"},
                _CachedFetch._CACHE_KEY_COMMONS: {"commons": "example"},
            }
            cache.close()

            expected_main = [
                (("Q1234", "park"), {"some": "json"}),
                (("Q54321", "park"), {"another": "jsonx"}),
            ]
            expected_commons = [(("Q54321"), {"commons": "example"})]

            with TestPipeline() as p:
                actual = (
                    p
                    | Create([("Q1234", "park"), ("Q54321", "park")])
                    | ParDo(_CachedFetch(cache_file, user_agent="some-agent")).with_outputs(
                        Transform._TAG_COMMONS, main=Transform._TAG_MAIN
                    )
                )
                assert_that(actual[Transform._TAG_MAIN], equal_to(expected_main), label="main")
                assert_that(actual[Transform._TAG_COMMONS], equal_to(expected_commons), label="commons")
