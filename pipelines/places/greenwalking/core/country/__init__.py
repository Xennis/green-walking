from typing import NewType

Country = NewType("Country", str)

# ISO 3166-1 alpha-2 code https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
GERMANY = Country("de")
