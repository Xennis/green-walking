from typing import NewType

EntryId = NewType("EntryId", str)
Typ = NewType("Typ", str)  # Type is a reserved keyword. Avoided here.

TYP_PARK = Typ("park")
TYP_MONUMENT = Typ("monument")
TYP_NATURE = Typ("nature")
TYP_HERITAGE = Typ("heritage")
