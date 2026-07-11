import 'package:equatable/equatable.dart';

/// Streak bookkeeping. Dates are always local, date-only (midnight) values.
class StreakState extends Equatable {
  const StreakState({
    required this.count,
    this.lastAllDoneDate,
    this.lastResetDate,
  });

  final int count;
  final DateTime? lastAllDoneDate;
  final DateTime? lastResetDate;

  @override
  List<Object?> get props => [count, lastAllDoneDate, lastResetDate];
}

/// Strips the time-of-day component.
DateTime dateOnly(DateTime t) => DateTime(t.year, t.month, t.day);

/// State after rolling over to [now]'s date, or null if already rolled today.
/// The caller is responsible for also resetting every todo's isCompleted.
StreakState? rollover(StreakState s, DateTime now) {
  final today = dateOnly(now);
  if (s.lastResetDate == today) return null;
  // Day arithmetic, not Duration: DateTime normalizes day 0, and a 24h
  // subtraction is wrong across DST changes.
  final yesterday = DateTime(today.year, today.month, today.day - 1);
  return StreakState(
    count: s.lastAllDoneDate == yesterday ? s.count : 0,
    lastAllDoneDate: s.lastAllDoneDate,
    lastResetDate: today,
  );
}

/// State after the last open item was completed at [now], or null if today
/// was already counted (double-increment guard).
StreakState? allDone(StreakState s, DateTime now) {
  final today = dateOnly(now);
  if (s.lastAllDoneDate == today) return null;
  return StreakState(
    count: s.count + 1,
    lastAllDoneDate: today,
    lastResetDate: s.lastResetDate,
  );
}

/// Streak the widget must display after the next midnight, given [s] as of [now].
int streakAfterMidnight(StreakState s, DateTime now) =>
    s.lastAllDoneDate == dateOnly(now) ? s.count : 0;
