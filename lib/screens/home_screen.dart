import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/app_theme.dart';
import 'add_expense_screen.dart';

class ExpensesHomePage extends StatefulWidget {
  const ExpensesHomePage({super.key});

  @override
  State<ExpensesHomePage> createState() => _ExpensesHomePageState();
}

class _ExpensesHomePageState extends State<ExpensesHomePage> {
  // ── View toggle ──────────────────────────────
  bool _showList = true;

  // ── Seed data ────────────────────────────────
  final List<Expense> _expenses = [
    Expense(id: '1', title: 'Groceries',       amount: 850.00),
    Expense(id: '2', title: 'Electricity Bill', amount: 1240.00),
    Expense(id: '3', title: 'Coffee',           amount: 150.00),
  ];

  // ── Navigation: Add ──────────────────────────
  Future<void> _openAddScreen() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddExpenseScreen(),
        settings: const RouteSettings(
          arguments: AddExpenseArgs(),
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() => _expenses.add(Expense.fromMap(result)));
      _showSnackBar(
        '✅  Added: ${result['title']}  •  ₱${(result['amount'] as double).toStringAsFixed(2)}',
        kGreen,
      );
    }
  }

  // ── Navigation: Edit ─────────────────────────
  Future<void> _openEditScreen(int index) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddExpenseScreen(),
        settings: RouteSettings(
          arguments: AddExpenseArgs(expense: _expenses[index]),
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _expenses[index].title  = result['title']  as String;
        _expenses[index].amount = result['amount'] as double;
      });
      _showSnackBar('✏️  Updated: ${_expenses[index].title}', kInk);
    }
  }

  // ── Delete with confirmation ──────────────────
  Future<void> _deleteExpense(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Delete Expense',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Remove "${_expenses[index].title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: kLabel)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final title = _expenses[index].title;
      setState(() => _expenses.removeAt(index));
      _showSnackBar('🗑️  Deleted: $title', kRed);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  double get _total => _expenses.fold(0.0, (sum, e) => sum + e.amount);

  // ── Build ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (_expenses.isNotEmpty) _buildTotalCard(),
          _buildToggleBar(),
          if (_showList) _buildSectionHeader(),
          Expanded(
            child: !_showList ? _buildEmptyState() : _buildList(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildFAB(),
    );
  }

  // ── AppBar ───────────────────────────────────
  AppBar _buildAppBar() => AppBar(
        backgroundColor: kInk,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: kGold,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Expense Tracker',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _monthLabel(),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70),
            ),
          ),
        ],
      );

  String _monthLabel() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[DateTime.now().month - 1];
  }

  // ── Toggle Bar ───────────────────────────────
  Widget _buildToggleBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: kMist,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              _toggleOption(
                label: 'Expense List',
                selected: _showList,
                onTap: () => setState(() => _showList = true),
              ),
              _toggleOption(
                label: 'Empty State',
                selected: !_showList,
                onTap: () => setState(() => _showList = false),
              ),
            ],
          ),
        ),
      );

  Widget _toggleOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) =>
      Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? kInk : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: kInk.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : kLabel,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      );

  // ── Total Card ───────────────────────────────
  Widget _buildTotalCard() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            gradient: kGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: kInk.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TOTAL SPENT',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    '₱',
                    style: TextStyle(
                        color: kGold, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _total.toStringAsFixed(2),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _totalPill('${_expenses.length} items'),
                  const SizedBox(width: 8),
                  _totalPill('This month'),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _totalPill(String text) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white60,
              fontSize: 11,
              fontWeight: FontWeight.w500),
        ),
      );

  // ── Section header ───────────────────────────
  Widget _buildSectionHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'RECENT',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: kLabel,
                letterSpacing: 1.1,
              ),
            ),
            Text(
              '${_expenses.length} entries',
              style: const TextStyle(
                  fontSize: 12, color: kLabel, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );

  // ── Empty state ──────────────────────────────
  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: kGoldLight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kGold.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.receipt_long, size: 60, color: kGold),
            ),
            const SizedBox(height: 20),
            const Text(
              'No expenses yet!',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kInk),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the button below to add one.',
              style: TextStyle(fontSize: 14, color: kLabel),
            ),
          ],
        ),
      );

  // ── Expense list ─────────────────────────────
  Widget _buildList() => ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: kMist, width: 1),
              boxShadow: [
                BoxShadow(
                  color: kInk.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              onTap: () => _openEditScreen(index),
              leading: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: kGoldLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '₱',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: kGold),
                ),
              ),
              title: Text(
                expense.title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: kInk),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  '₱${expense.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: kGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 13),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _iconAction(
                    icon: Icons.drive_file_rename_outline_rounded,
                    color: kGold,
                    bg: kGoldLight,
                    onTap: () => _openEditScreen(index),
                  ),
                  const SizedBox(width: 6),
                  _iconAction(
                    icon: Icons.delete_outline_rounded,
                    color: kRed,
                    bg: const Color(0xFFFFE8EB),
                    onTap: () => _deleteExpense(index),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Widget _iconAction({
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 17),
        ),
      );

  // ── FAB ──────────────────────────────────────
  Widget _buildFAB() => Container(
        decoration: BoxDecoration(
          color: kInk,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: kInk.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _openAddScreen,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          icon: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: kGold,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: 16, color: kInk),
          ),
          label: const Text(
            'Add Expense',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      );
}