import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/app_theme.dart';

/// Dual-mode screen: Add (expense == null) or Edit (expense != null).
/// Returns Map<String, dynamic> on Save, null on Cancel.
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  String? _titleError;
  String? _amountError;

  bool _isEditMode  = false;
  Expense? _original;
  bool _initialized = false;

  // ── Resolve route args once ──────────────────
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final args =
        ModalRoute.of(context)?.settings.arguments as AddExpenseArgs?;
    _original   = args?.expense;
    _isEditMode = _original != null;

    _titleController = TextEditingController(
        text: _isEditMode ? _original!.title : '');
    _amountController = TextEditingController(
        text: _isEditMode ? _original!.amount.toStringAsFixed(2) : '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // ── Validate and return result ───────────────
  void _save() {
    final title  = _titleController.text.trim();
    final rawAmt = _amountController.text.trim();

    String? titleErr;
    String? amountErr;

    if (title.isEmpty) titleErr = 'Title cannot be empty.';

    final parsed = double.tryParse(rawAmt);
    if (rawAmt.isEmpty) {
      amountErr = 'Amount cannot be empty.';
    } else if (parsed == null) {
      amountErr = 'Enter a valid number.';
    } else if (parsed <= 0) {
      amountErr = 'Amount must be greater than 0.';
    }

    if (titleErr != null || amountErr != null) {
      setState(() {
        _titleError  = titleErr;
        _amountError = amountErr;
      });
      return;
    }

    Navigator.pop(context, {
      'id': _isEditMode
          ? _original!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      'title':  title,
      'amount': parsed!,
    });
  }

  // ── Build ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderBanner(),
            const SizedBox(height: 24),
            _buildTitleField(),
            const SizedBox(height: 14),
            _buildAmountField(),
            const SizedBox(height: 28),
            _buildSaveButton(),
            const SizedBox(height: 10),
            _buildCancelButton(),
          ],
        ),
      ),
    );
  }

  // ── AppBar ───────────────────────────────────
  AppBar _buildAppBar() => AppBar(
        backgroundColor: kInk,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditMode ? 'Edit Expense' : 'New Expense',
          style: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 17, color: Colors.white),
        ),
        centerTitle: true,
      );

  // ── Header Banner ────────────────────────────
  Widget _buildHeaderBanner() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: kGoldGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kGold.withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _isEditMode
                    ? Icons.drive_file_rename_outline_rounded
                    : Icons.add_circle_outline_rounded,
                size: 26,
                color: kInk,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditMode ? 'Edit Expense' : 'Add Expense',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: kInk,
                      letterSpacing: -0.3),
                ),
                Text(
                  _isEditMode
                      ? 'Update the details below'
                      : 'Fill in the details below',
                  style: TextStyle(
                      fontSize: 12,
                      color: kInk.withOpacity(0.55),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      );

  // ── Shared input decoration ──────────────────
  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    String? errorText,
    required Widget prefixIcon,
    BoxConstraints? prefixIconConstraints,
  }) =>
      InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kLabel, fontWeight: FontWeight.w600, fontSize: 13),
        hintText: hint,
        hintStyle: const TextStyle(color: kLabel),
        errorText: errorText,
        filled: true,
        fillColor: kCard,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kMist, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kMist, width: 1.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kGold, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kRed, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kRed, width: 2)),
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixIconConstraints,
      );

  // ── Title field ──────────────────────────────
  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 6),
          child: Text(
            'EXPENSE TITLE',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: kLabel,
                letterSpacing: 1.0),
          ),
        ),
        TextField(
          controller: _titleController,
          autofocus: !_isEditMode,
          style: const TextStyle(color: kInk, fontWeight: FontWeight.w500),
          decoration: _inputDecoration(
            label: '',
            hint: 'e.g. Coffee, Groceries, Rent…',
            errorText: _titleError,
            prefixIcon: const Icon(Icons.label_outline_rounded, color: kGold),
          ),
          onChanged: (_) {
            if (_titleError != null) setState(() => _titleError = null);
          },
        ),
      ],
    );
  }

  // ── Amount field ─────────────────────────────
  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 6),
          child: Text(
            'AMOUNT',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: kLabel,
                letterSpacing: 1.0),
          ),
        ),
        TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: kInk, fontWeight: FontWeight.w500),
          decoration: _inputDecoration(
            label: '',
            hint: '0.00',
            errorText: _amountError,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 14, right: 8),
              child: Text(
                '₱',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: kGold),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
          ),
          onChanged: (_) {
            if (_amountError != null) setState(() => _amountError = null);
          },
        ),
      ],
    );
  }

  // ── Save button ──────────────────────────────
  Widget _buildSaveButton() => Container(
        decoration: BoxDecoration(
          color: kInk,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: kInk.withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save_rounded, color: kGold),
          label: Text(
            _isEditMode ? 'Save Changes' : 'Save Expense',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
        ),
      );

  // ── Cancel button ────────────────────────────
  Widget _buildCancelButton() => OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: kLabel,
          side: const BorderSide(color: kMist, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: const Text('Cancel',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      );
}