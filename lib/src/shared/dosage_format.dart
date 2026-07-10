String formatDosage(double value, String unit) {
  final base = _unitBase[unit] ?? unit;
  final formatted = value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1).replaceAll('.', ',');
  String unitDisplay;
  if (value == value.roundToDouble()) {
    unitDisplay = _pluralize(value.toInt(), base);
  } else {
    unitDisplay = _genitiveSingular(base);
  }
  return '$formatted $unitDisplay';
}

String _pluralize(int n, String base) {
  final d = n % 10;
  final dd = n % 100;
  if (dd >= 11 && dd <= 19) return _genitivePlural(base);
  if (d == 1) return _nominativeSingular(base);
  if (d >= 2 && d <= 4) return _genitiveSingular(base);
  return _genitivePlural(base);
}

String _nominativeSingular(String base) => base;

String _genitiveSingular(String base) {
  switch (base) {
    case 'таблетка': return 'таблетки';
    case 'капсула': return 'капсулы';
    case 'капля': return 'капли';
    case 'укол': return 'укола';
    default: return base;
  }
}

String _genitivePlural(String base) {
  switch (base) {
    case 'таблетка': return 'таблеток';
    case 'капсула': return 'капсул';
    case 'капля': return 'капель';
    case 'укол': return 'уколов';
    default: return base;
  }
}

const _unitBase = {
  'мг': 'мг',
  'мл': 'мл',
  'таб': 'таблетка',
  'капс': 'капсула',
  'капли': 'капля',
  'мкг': 'мкг',
  'г': 'г',
  'ед': 'ед',
  'укол': 'укол',
};
