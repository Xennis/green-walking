import os
import tempfile
import unittest

import apache_beam as beam
from apache_beam.testing.test_pipeline import TestPipeline
from apache_beam.testing.util import assert_that, equal_to
from sqlitedict import SqliteDict

from greenwalking.core import language
from greenwalking.pipeline.places import fields
from greenwalking.pipeline.places.wikipedia.transform import _CachedFetch


class TestFetch(unittest.TestCase):
    def test_known(self):
        with tempfile.TemporaryDirectory(prefix="gw") as base_path:
            cache_file = os.path.join(base_path, "cache.json")
            cache = SqliteDict(cache_file, autocommit=True)
            cache["Q1234"] = {"de": {"some": "json"}}
            cache["Q54321"] = {"en": {"another": "jsonx"}}
            cache.close()

            data = [
                ("Q1234", {fields.WIKIPEDIA: {language.GERMAN: {fields.TITLE: "de title"}}}),
                ("Q54321", {fields.WIKIPEDIA: {language.ENGLISH: {fields.TITLE: "en title"}}}),
            ]
            expected = [("Q1234", {language.GERMAN: {"some": "json"}}), ("Q54321", {language.ENGLISH: {"another": "jsonx"}})]

            with TestPipeline() as p:
                actual = p | beam.Create(data) | beam.ParDo(_CachedFetch(cache_file, user_agent="some-agent"))
                assert_that(actual, equal_to(expected))
