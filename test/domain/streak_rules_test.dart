import 'package:flutter_test/flutter_test.dart';
import 'package:ndsl/domain/streak_rules.dart';

void main() {
  DateTime d(int y, int m, int day) => DateTime(y, m, day);

  group('dateOnly', () {
    test('strips time of day', () {
      expect(dateOnly(DateTime(2026, 7, 10, 23, 59, 58)), d(2026, 7, 10));
    });
  });

  group('rollover', () {
    test('returns null when already rolled over today', () {
      final s = StreakState(count: 3, lastResetDate: d(2026, 7, 10));
      expect(rollover(s, DateTime(2026, 7, 10, 8, 30)), isNull);
    });

    test('first rollover ever stamps lastResetDate with count 0', () {
      const s = StreakState(count: 0);
      expect(
        rollover(s, DateTime(2026, 7, 10, 0, 1)),
        StreakState(count: 0, lastResetDate: d(2026, 7, 10)),
      );
    });

    test('streak survives when all was done yesterday', () {
      final s = StreakState(
        count: 3,
        lastAllDoneDate: d(2026, 7, 9),
        lastResetDate: d(2026, 7, 9),
      );
      expect(
        rollover(s, DateTime(2026, 7, 10, 0, 1)),
        StreakState(
          count: 3,
          lastAllDoneDate: d(2026, 7, 9),
          lastResetDate: d(2026, 7, 10),
        ),
      );
    });

    test('streak dies after a multi-day gap', () {
      final s = StreakState(
        count: 7,
        lastAllDoneDate: d(2026, 7, 6),
        lastResetDate: d(2026, 7, 7),
      );
      expect(
        rollover(s, DateTime(2026, 7, 10, 12, 0)),
        StreakState(
          count: 0,
          lastAllDoneDate: d(2026, 7, 6),
          lastResetDate: d(2026, 7, 10),
        ),
      );
    });

    test('streak dies when yesterday was not completed', () {
      final s = StreakState(
        count: 7,
        lastAllDoneDate: d(2026, 7, 8),
        lastResetDate: d(2026, 7, 9),
      );
      expect(rollover(s, DateTime(2026, 7, 10, 0, 5))!.count, 0);
    });

    test('streak dies when nothing was ever completed (empty list case)', () {
      final s = StreakState(count: 4, lastResetDate: d(2026, 7, 9));
      expect(rollover(s, DateTime(2026, 7, 10, 9, 0))!.count, 0);
    });

    test('yesterday is computed across month boundary', () {
      final s = StreakState(
        count: 2,
        lastAllDoneDate: d(2026, 2, 28),
        lastResetDate: d(2026, 2, 28),
      );
      expect(rollover(s, DateTime(2026, 3, 1, 7, 0))!.count, 2);
    });

    test('yesterday is computed across leap-day boundary', () {
      final s = StreakState(
        count: 2,
        lastAllDoneDate: d(2024, 2, 29),
        lastResetDate: d(2024, 2, 29),
      );
      expect(rollover(s, DateTime(2024, 3, 1, 7, 0))!.count, 2);
    });

    test('yesterday is computed across year boundary', () {
      final s = StreakState(
        count: 9,
        lastAllDoneDate: d(2025, 12, 31),
        lastResetDate: d(2025, 12, 31),
      );
      expect(rollover(s, DateTime(2026, 1, 1, 0, 30))!.count, 9);
    });
  });

  group('allDone', () {
    test('increments count and stamps today', () {
      final s = StreakState(count: 3, lastAllDoneDate: d(2026, 7, 9));
      expect(
        allDone(s, DateTime(2026, 7, 10, 21, 15)),
        StreakState(count: 4, lastAllDoneDate: d(2026, 7, 10)),
      );
    });

    test('returns null when today already counted', () {
      final s = StreakState(count: 4, lastAllDoneDate: d(2026, 7, 10));
      expect(allDone(s, DateTime(2026, 7, 10, 22, 0)), isNull);
    });

    test('preserves lastResetDate', () {
      final s = StreakState(count: 0, lastResetDate: d(2026, 7, 10));
      expect(
        allDone(s, DateTime(2026, 7, 10, 9, 0))!.lastResetDate,
        d(2026, 7, 10),
      );
    });
  });

  group('streakAfterMidnight', () {
    test('keeps count when all was done today', () {
      final s = StreakState(count: 5, lastAllDoneDate: d(2026, 7, 10));
      expect(streakAfterMidnight(s, DateTime(2026, 7, 10, 22, 0)), 5);
    });

    test('is zero when today is not done', () {
      final s = StreakState(count: 5, lastAllDoneDate: d(2026, 7, 9));
      expect(streakAfterMidnight(s, DateTime(2026, 7, 10, 22, 0)), 0);
    });
  });
}
