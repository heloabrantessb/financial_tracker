import 'package:financial_tracker/common/errors/errors_classes.dart';
import 'package:financial_tracker/common/patterns/command.dart';
import 'package:financial_tracker/domain/entity/transaction_category.dart';
import 'package:financial_tracker/domain/entity/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TransactionForm extends StatefulWidget {
  /// Comando que deve ser observado o estado de execução
  /// e o resultado da execução
  final Command1<void, Failure, TransactionEntity> submitCommand;

  /// Tipo de transação (receita ou despesa)
  final TransactionType type;

  /// Cor do tema para o formulário
  final Color color;

  /// Transação existente a ser editada ()
  final TransactionEntity? transaction;

  const TransactionForm({
    super.key,
    required this.type,
    required this.color,
    required this.submitCommand,
    this.transaction,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  late TransactionCategory _selectedCategory; // Categoria atualmente selecionada

  @override
  void initState() {
    super.initState();
    // Se houver uma transação para edição, pré-preenche os dados
    if (widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _selectedDate = widget.transaction!.date;
      _selectedCategory = widget.transaction!.category;
    } else {
      // Define a categoria padrão inicial para novas transações
      _selectedCategory = widget.type == TransactionType.income
          ? TransactionCategory.salary
          : TransactionCategory.food;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// Exibe o seletor de datas e atualiza a data selecionada
  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  /// Envia o formulário se a validação for bem-sucedida
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final enteredTitle = _titleController.text;
      final enteredAmount = double.parse(_amountController.text);
      final isEditing = widget.transaction != null;

      final newTransaction = TransactionEntity(
        id: widget.transaction?.id,
        title: enteredTitle,
        amount: enteredAmount,
        date: _selectedDate,
        type: widget.type,
        category: _selectedCategory,
      );

      //widget.onSubmit(newTransaction);
      await widget.submitCommand.execute(newTransaction);

      if (widget.submitCommand.resultSignal.value?.isFailure ?? false) {
        // Se o comando falhar, exibe uma mensagem de erro
        final actionText = isEditing ? 'editar' : 'adicionar';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao $actionText ${widget.type.nameSingular}: ${widget.submitCommand.resultSignal.value?.failureValueOrNull ?? 'Erro desconhecido'}',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
        return;
      }

      // Limpa os campos do formulário
      _titleController.clear();
      _amountController.clear();
      setState(() {
        _selectedDate = DateTime.now();
      });

      // Mostra uma mensagem de sucesso
      final successText = isEditing
          ? '${widget.type.nameSingular} Alterada com Sucesso!'
          : '${widget.type.nameSingular} Adicionada com Sucesso!';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successText),
          backgroundColor: widget.color,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de entrada para a descrição (título)
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.description),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe uma descrição';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo de entrada para o valor
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Valor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.attach_money),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe um valor';
                }
                if (double.tryParse(value) == null) {
                  return 'Digite um número válido';
                }
                if (double.parse(value) <= 0) {
                  return 'O valor deve ser maior que zero';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo de seleção de categoria (Dropdown)
            DropdownButtonFormField<TransactionCategory>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  _selectedCategory.icon,
                  color: widget.color,
                ),
              ),
              items: TransactionCategory.values
                  .where((c) => c.isValidFor(widget.type))
                  .map((category) {
                return DropdownMenuItem<TransactionCategory>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(category.icon),
                      const SizedBox(width: 10),
                      Text(category.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (TransactionCategory? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Seção para exibir e escolher a data
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: Text(
                    'Selecionar Data',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Botão de envio do formulário
            Watch((context) {
              final isRunning = widget.submitCommand.runningSignal.value;

              return SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      isRunning
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Text(
                              widget.transaction != null
                                  ? 'Salvar Alterações'
                                  : 'Adicionar ${widget.type.nameSingular}',
                              style: const TextStyle(fontSize: 16),
                            ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
