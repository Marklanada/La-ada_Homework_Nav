import 'package:flutter/material.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

class Expense {
  final String id;
  final String title;
  final double amount;
  final String date;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
}

// ─── Dummy Data ───────────────────────────────────────────────────────────────

const List<Expense> kDummyExpenses = [
  Expense(id: '1', title: 'Groceries',        amount: 850.00,   date: 'Mar 1'),
  Expense(id: '2', title: 'Electricity Bill', amount: 1240.00,  date: 'Mar 3'),
  Expense(id: '3', title: 'Coffee',           amount: 150.00,   date: 'Mar 5'),
  Expense(id: '4', title: 'Tuition Fee',      amount: 32000.00, date: 'Mar 7'),
  Expense(id: '5', title: 'Daily Allowance',  amount: 200.00,   date: 'Mar 10'),
  Expense(id: '6', title: 'Internet Bill',    amount: 999.00,   date: 'Mar 12'),
];

// ─── Part A: Reusable ExpenseItem Widget ──────────────────────────────────────

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  const ExpenseItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFEDE9F8)),
      ),
      color: Colors.white,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.receipt_long_outlined,
                color: Color(0xFF7B6FBF), size: 20),
          ),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(
            color: Color(0xFF1A1A2E),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            expense.date,
            style: const TextStyle(color: Color(0xFFB0A8D8), fontSize: 12),
          ),
        ),
        trailing: Text(
          '₱${expense.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Color(0xFF7B6FBF),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─── Part C: Empty State Widget ───────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9F8),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.inbox_outlined,
                color: Color(0xFF9B8FD4), size: 40),
          ),
          const SizedBox(height: 20),
          const Text(
            'No expenses yet',
            style: TextStyle(
              color: Color(0xFF4A3F8F),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap + to add one',
            style: TextStyle(
              color: Color(0xFFB0A8D8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Part B: Main Screen ──────────────────────────────────────────────────────

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<Expense> _expenses = List.from(kDummyExpenses);
  bool _showEmpty = false;

  double get _total => _expenses.fold(0, (sum, e) => sum + e.amount);

  void _toggleEmpty() {
    setState(() {
      _showEmpty = !_showEmpty;
      _expenses = _showEmpty ? [] : List.from(kDummyExpenses);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Expenses',
          style: TextStyle(
            color: Color(0xFF4A3F8F),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          // Toggle button to preview empty state
          TextButton.icon(
            onPressed: _toggleEmpty,
            icon: Icon(
              _showEmpty ? Icons.list : Icons.inbox_outlined,
              size: 16,
              color: const Color(0xFF7B6FBF),
            ),
            label: Text(
              _showEmpty ? 'Show List' : 'Empty State',
              style: const TextStyle(
                color: Color(0xFF7B6FBF),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFEDE9F8), thickness: 1),
        ),
      ),

      body: Column(
        children: [
          // Total bar — only visible when list has items
          if (!_showEmpty)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: const Color(0xFFF7F6FD),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_expenses.length} expense${_expenses.length != 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: Color(0xFFB0A8D8),
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Total: ₱${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF4A3F8F),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

          // Part B: ListView.separated  /  Part C: EmptyState
          Expanded(
            child: _expenses.isEmpty
                ? const EmptyState()           // ← Part C
                : ListView.separated(          // ← Part B
                    padding:
                        const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: _expenses.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) =>
                        ExpenseItem(expense: _expenses[index]), // ← Part A
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF7B6FBF),
        foregroundColor: Colors.white,
        elevation: 2,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ─── Entry Point ──────────────────────────────────────────────────────────────

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ExpenseListScreen(),
  ));
}