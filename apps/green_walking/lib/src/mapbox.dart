enum MabboxTileset { outdoor, satellite, streets }

extension MabboxTilesetExtension on MabboxTileset {
  String get id {
    switch (this) {
      case MabboxTileset.outdoor:
        return 'outdoors-v11';
      case MabboxTileset.satellite:
        return 'satellite-streets-v11';
      case MabboxTileset.streets:
        return 'streets-v11';
      default:
        return null;
    }
  }
}
