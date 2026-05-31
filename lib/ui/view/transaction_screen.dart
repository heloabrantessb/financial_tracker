import 'package:flutter/material.dart';
import '../../common/config/dependencies.dart';
import '../../domain/entity/transaction_entity.dart';
import '../controller/home_page_controller.dart';
import '../widget/transaction_sheet.dart';
import '../widget/transaction_sheets_card.dart';
import 'package:signals_flutter/signals_flutter.dart';


class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late HomePageController viewModelController;

  @override
  void initState() {
    viewModelController = injector.get<HomePageController>();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transações',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 8),
            Watch((context) {
              return const SizedBox.shrink();
            }),
            Padding(
              padding: const EdgeInsets.all(16.0),
               child: Row(
                children: [
                  // Add Income button
                  Expanded(
                    child: _buildActionButton(
                      context,
                      TransactionType.income,
                      Icons.add_circle,
                      colorScheme.primary,
                      //() {},
                      () => _showIncomeSheet(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Add Expense button
                  Expanded(
                    child: _buildActionButton(
                      context,
                      TransactionType.expense,
                      Icons.remove_circle,
                      colorScheme.secondary,
                      () => _showExpenseSheet(context),
                    ),
                  ),
                ],
              ),
            ),
            Watch((context) {
              final incomes = viewModelController.incomes.value;
              final expenses = viewModelController.expenses.value;
              return TransactionCardSheets(
                incomeTransactions: incomes,
                expenseTransactions: expenses,
                onDelete: (id) {
                  viewModelController.deleteTransaction.execute(id);
                },
                undoDelete: viewModelController.undoDelectedTransaction,
                scaffoldContext: context,
              );
            })
          ]
        )
      )
    );
  }

 Widget _buildActionButton(
    BuildContext context,
    TransactionType transactionType,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(transactionType.namePlural),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Show income transaction sheet
  void _showIncomeSheet(BuildContext context) {
    //final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    TransactionSheet.show(
      context: context,
      type: TransactionType.income,
      submitCommand: viewModelController.saveTransaction,
    );
  }

  /// Show expense transaction sheet
  void _showExpenseSheet(BuildContext context) {
    TransactionSheet.show(
      context: context,
      type: TransactionType.expense,
      submitCommand: viewModelController.saveTransaction,
    );
  }
}