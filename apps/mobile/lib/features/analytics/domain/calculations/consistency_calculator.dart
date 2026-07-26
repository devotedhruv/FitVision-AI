abstract final class ConsistencyCalculator {
  static int activeDays(Iterable<DateTime> utcStarts) => utcStarts
      .map((d) {
        final l = d.toLocal();
        return '${l.year}-${l.month}-${l.day}';
      })
      .toSet()
      .length;
}
