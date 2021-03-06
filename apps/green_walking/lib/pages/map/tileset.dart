enum MabboxTileset { outdoor, satellite }

extension MabboxTilesetExtension on MabboxTileset {
  String get id {
    switch (this) {
      case MabboxTileset.outdoor:
        return 'xennis/ckfbioyul1iln1ap0pm5hrcgy';
      case MabboxTileset.satellite:
        return 'xennis/ckfc5mxh33tjg19qvk6m5f5hj';
      default:
        return null;
    }
  }
}
