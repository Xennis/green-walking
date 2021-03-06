from typing import NewType

Language = NewType("Language", str)

# ISO 639-1 codes (https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
ENGLISH = Language("en")
GERMAN = Language("de")
