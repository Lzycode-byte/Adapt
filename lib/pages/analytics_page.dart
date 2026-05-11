// lib/pages/analytics_page.dart

import 'package:adapt/database/habit_database.dart';
import 'package:adapt/models/daily_snapshot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/scaffold.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  // Currently selected month (starts at current month)
  late DateTime _selectedMonth;

  // All snapshots loaded once
  List<DailySnapshot> _allSnapshots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _loadSnapshots();
  }

  Future<void> _loadSnapshots() async {
    final db = context.read<HabitDatabase>();
    final snapshots = await db.getAllSnapshots(); // we'll add this method
    setState(() {
      _allSnapshots = snapshots;
      _isLoading = false;
    });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Completion rate for a given month (0.0 – 1.0)
  double _rateForMonth(DateTime month) {
    final snapshotsInMonth = _allSnapshots.where((s) {
      return s.date.year == month.year && s.date.month == month.month;
    }).toList();

    if (snapshotsInMonth.isEmpty) return 0.0;

    int totalSlots = 0;
    int completedSlots = 0;

    for (final s in snapshotsInMonth) {
      totalSlots += s.completionStatus.length;
      completedSlots += s.completionStatus.where((c) => c).length;
    }

    if (totalSlots == 0) return 0.0;
    return completedSlots / totalSlots;
  }

  /// Last 7 months ending at _selectedMonth (oldest → newest)
  List<DateTime> get _chartMonths {
    return List.generate(7, (i) {
      final offset = 6 - i; // 6, 5, 4, ... 0
      return DateTime(_selectedMonth.year, _selectedMonth.month - offset);
    });
  }

  void _prevMonth() => setState(
    () => _selectedMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month - 1,
    ),
  );

  void _nextMonth() {
    final now = DateTime(DateTime.now().year, DateTime.now().month);
    if (_selectedMonth.isBefore(now)) {
      setState(
        () => _selectedMonth = DateTime(
          _selectedMonth.year,
          _selectedMonth.month + 1,
        ),
      );
    }
  }

  bool get _canGoNext {
    final now = DateTime(DateTime.now().year, DateTime.now().month);
    return _selectedMonth.isBefore(now);
  }

  String _monthLabel(DateTime d) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${names[d.month - 1]} ${d.year}';
  }

  String _shortMonthLabel(DateTime d) {
    const short = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    return short[d.month - 1];
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: "Analytics",
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildMonthNavigator(),
                  const SizedBox(height: 16),
                  _buildProgressCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildMonthNavigator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Back arrow — always visible but dims when no data before
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _prevMonth,
          ),
          Expanded(
            child: Text(
              _monthLabel(_selectedMonth),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: _canGoNext
                  ? null
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            ),
            onPressed: _canGoNext ? _nextMonth : null,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final thisMonthRate = _rateForMonth(_selectedMonth);
    final lastMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    final lastMonthRate = _rateForMonth(lastMonth);

    final diff = thisMonthRate - lastMonthRate;
    final isUp = diff >= 0;
    final diffPercent = (diff.abs() * 100).toStringAsFixed(1);

    final chartMonths = _chartMonths;
    final rates = chartMonths.map(_rateForMonth).toList();
    final maxRate = rates.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──────────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.trending_up, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Monthly Progress',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              // Delta badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isUp
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUp ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: isUp ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$diffPercent%',
                      style: TextStyle(
                        color: isUp ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── This month / Last month ──────────────────────────────────────
          Row(
            children: [
              _buildStatColumn(
                'This month',
                '${(thisMonthRate * 100).toStringAsFixed(1)}%',
              ),
              const SizedBox(width: 40),
              _buildStatColumn(
                'Last month',
                '${(lastMonthRate * 100).toStringAsFixed(1)}%',
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Bar chart ───────────────────────────────────────────────────
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(chartMonths.length, (i) {
                final month = chartMonths[i];
                final rate = rates[i];
                final isSelected =
                    month.year == _selectedMonth.year &&
                    month.month == _selectedMonth.month;

                // Bar height: at least 4px, proportional to maxRate
                final barFraction = maxRate > 0 ? rate / maxRate : 0.0;
                final maxBarHeight = 120.0;
                final barHeight = rate == 0
                    ? 4.0
                    : (barFraction * maxBarHeight).clamp(4.0, maxBarHeight);

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Bar
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        height: barHeight,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.green
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Month initial
                      Text(
                        _shortMonthLabel(month),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onBackground
                              : Theme.of(
                                  context,
                                ).colorScheme.onBackground.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
