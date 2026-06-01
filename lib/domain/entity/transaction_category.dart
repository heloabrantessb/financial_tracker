import 'package:flutter/material.dart';
import 'transaction_entity.dart';

enum TransactionCategory {
  salary,
  investment,
  freelance,
  food,
  transport,
  utilities,
  entertainment,
  shopping,
  other,
}

extension TransactionCategoryExtension on TransactionCategory {
  String get displayName {
    switch (this) {
      case TransactionCategory.salary:
        return 'Salário';
      case TransactionCategory.investment:
        return 'Investimentos';
      case TransactionCategory.freelance:
        return 'Freelance';
      case TransactionCategory.food:
        return 'Alimentação';
      case TransactionCategory.transport:
        return 'Transporte';
      case TransactionCategory.utilities:
        return 'Contas / Moradia';
      case TransactionCategory.entertainment:
        return 'Lazer';
      case TransactionCategory.shopping:
        return 'Compras';
      case TransactionCategory.other:
        return 'Outros';
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionCategory.salary:
        return Icons.attach_money_rounded;
      case TransactionCategory.investment:
        return Icons.trending_up_rounded;
      case TransactionCategory.freelance:
        return Icons.laptop_mac_rounded;
      case TransactionCategory.food:
        return Icons.restaurant_rounded;
      case TransactionCategory.transport:
        return Icons.directions_car_rounded;
      case TransactionCategory.utilities:
        return Icons.home_work_rounded;
      case TransactionCategory.entertainment:
        return Icons.sports_esports_rounded;
      case TransactionCategory.shopping:
        return Icons.shopping_bag_rounded;
      case TransactionCategory.other:
        return Icons.help_outline_rounded;
    }
  }

  bool isValidFor(TransactionType type) {
    if (type == TransactionType.income) {
      return this == TransactionCategory.salary ||
          this == TransactionCategory.investment ||
          this == TransactionCategory.freelance ||
          this == TransactionCategory.other;
    } else {
      return this == TransactionCategory.food ||
          this == TransactionCategory.transport ||
          this == TransactionCategory.utilities ||
          this == TransactionCategory.entertainment ||
          this == TransactionCategory.shopping ||
          this == TransactionCategory.other;
    }
  }
}
