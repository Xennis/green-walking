enum MabboxTileset { outdoor, satellite }

extension MabboxTilesetExtension on MabboxTileset {
  String get id {
    switch (this) {
      case MabboxTileset.outdoor:
        return 'xennis/ckfbioyul1iln1ap0pm5hrcgy';
      case MabboxTileset.satellite:
        return 'mapbox/satellite-streets-v11';
      default:
        return null;
    }
  }
}
