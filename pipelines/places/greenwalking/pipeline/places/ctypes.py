from typing import NewType

Typ = NewType("Typ", str)  # Type is a reserved keyword. Avoided here.

TYP_PARK = Typ("park")
TYP_MONUMENT = Typ("monument")
TYP_NATURE = Typ("nature")
