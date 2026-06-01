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
      body: Column(
        children: <Widget>[
          Expanded(
            child: Watch((context) {
              final incomes = viewModelController.incomes.value;
              final expenses = viewModelController.expenses.value;
              return TransactionCardSheets(
                incomeTransactions: incomes,
                expenseTransactions: expenses,
                isExpanded: true, // Habilita expansão para ocupação total da tela
                onDelete: (id) {
                  viewModelController.deleteTransaction.execute(id);
                },
                undoDelete: viewModelController.undoDelectedTransaction,
                onEdit: (transaction) {
                  _showEditSheet(context, transaction);
                },
                scaffoldContext: context,
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSelectionSheet(context),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  /// Exibe um painel elegante na parte inferior para selecionar o tipo de transação (Receita ou Despesa)
  void _showAddSelectionSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Nova Transação',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  // Opção de Receita
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _showIncomeSheet(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.arrow_upward_rounded,
                              size: 32,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Receita',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Opção de Despesa
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _showExpenseSheet(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.secondary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.arrow_downward_rounded,
                              size: 32,
                              color: colorScheme.secondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Despesa',
                              style: TextStyle(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  /// Exibe a folha (sheet) para adicionar uma receita
  void _showIncomeSheet(BuildContext context) {
    TransactionSheet.show(
      context: context,
      type: TransactionType.income,
      submitCommand: viewModelController.saveTransaction,
    );
  }

  /// Exibe a folha (sheet) para adicionar uma despesa
  void _showExpenseSheet(BuildContext context) {
    TransactionSheet.show(
      context: context,
      type: TransactionType.expense,
      submitCommand: viewModelController.saveTransaction,
    );
  }

  /// Exibe a folha (sheet) para editar uma transação existente
  void _showEditSheet(BuildContext context, TransactionEntity transaction) {
    TransactionSheet.show(
      context: context,
      type: transaction.type,
      submitCommand: viewModelController.saveTransaction,
      transaction: transaction,
    );
  }
}