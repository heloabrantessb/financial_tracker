import 'package:financial_tracker/common/utils/formatter.dart';
import 'package:flutter/material.dart';

/// Widget to display financial summary information
class SummaryCard extends StatelessWidget {
  /// Total income amount
  final double totalIncome;

  /// Total expense amount
  final double totalExpense;

  /// Current balance amount
  final double balance;

  const SummaryCard({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0A192F), // Azul marinho escuro profundo
              const Color(0xFF1E3A8A), // Azul Marinho Premium (marca)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header
            Text(
              'Resumo Financeiro',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 20),
    
            // Three key financial indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Income (Receita - Green)
                _buildSummaryItem(
                  context,
                  'Receita',
                  Formatter.formatCurrency(totalIncome),
                  Icons.arrow_upward,
                  const Color(0xFF4CAF50), // Modern Green
                ),
                // Expense (Despesa - Red)
                _buildSummaryItem(
                  context,
                  'Despesa',
                  Formatter.formatCurrency(totalExpense),
                  Icons.arrow_downward,
                  const Color(0xFFEF5350), // Modern Red
                ),
                // Balance (Balanço - Wallet)
                _buildSummaryItem(
                  context,
                  'Saldo',
                  Formatter.formatCurrency(balance),
                  Icons.account_balance_wallet,
                  balance >= 0 ? const Color(0xFF4CAF50) : const Color(0xFFEF5350),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Icon with background
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        // Title
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        // Amount
        Text(
          amount,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
