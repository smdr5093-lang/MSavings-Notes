import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/firebase_service.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final FirebaseService _service = FirebaseService();

  void _showAddTransactionDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCurrency = 'INR';
    String selectedType = 'income';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text(
              'Add Savings / Transaction',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Title (e.g. Salary, Food)',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Currency:', style: TextStyle(color: Colors.white)),
                      DropdownButton<String>(
                        value: selectedCurrency,
                        dropdownColor: const Color(0xFF222222),
                        style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                        items: const [
                          DropdownMenuItem(value: 'INR', child: Text('INR (₹)')),
                          DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
                        ],
                        onChanged: (val) {
                          if (val != null) setDialogState(() => selectedCurrency = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Type:', style: TextStyle(color: Colors.white)),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text('Income'),
                            selected: selectedType == 'income',
                            selectedColor: Colors.greenAccent,
                            onSelected: (sel) {
                              if (sel) setDialogState(() => selectedType = 'income');
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Expense'),
                            selected: selectedType == 'expense',
                            selectedColor: Colors.redAccent,
                            onSelected: (sel) {
                              if (sel) setDialogState(() => selectedType = 'expense');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  final title = titleController.text.trim();
                  final amount = double.tryParse(amountController.text.trim()) ?? 0.0;

                  if (title.isEmpty || amount <= 0) return;

                  await _service.addTransaction(
                    TransactionModel(
                      id: '',
                      title: title,
                      amount: amount,
                      currency: selectedCurrency,
                      type: selectedType,
                      date: DateTime.now(),
                    ),
                  );

                  if (mounted) Navigator.pop(ctx);
                },
                child: const Text('Add Entry', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MSavings Tracker'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: _showAddTransactionDialog,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: _service.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
          }

          final transactions = snapshot.data ?? [];

          double totalINR = 0.0;
          double totalUSD = 0.0;

          for (var item in transactions) {
            if (item.currency == 'INR') {
              totalINR += (item.type == 'income') ? item.amount : -item.amount;
            } else {
              totalUSD += (item.type == 'income') ? item.amount : -item.amount;
            }
          }

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF181818),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('INR Balance', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text(
                          '₹${totalINR.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: totalINR >= 0 ? Colors.greenAccent : Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    Container(height: 35, width: 1, color: Colors.grey.shade800),
                    Column(
                      children: [
                        const Text('USD Balance', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text(
                          '\$${totalUSD.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: totalUSD >= 0 ? Colors.greenAccent : Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: transactions.isEmpty
                    ? const Center(
                        child: Text(
                          'No transactions yet.\nTap + to add income or expense!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final item = transactions[index];
                          final isIncome = item.type == 'income';
                          final symbol = item.currency == 'INR' ? '₹' : '\$';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isIncome ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                child: Icon(
                                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                                  color: isIncome ? Colors.greenAccent : Colors.redAccent,
                                ),
                              ),
                              title: Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                '${item.date.day}/${item.date.month}/${item.date.year}',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${isIncome ? "+" : "-"}$symbol${item.amount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isIncome ? Colors.greenAccent : Colors.redAccent,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                                    onPressed: () async {
                                      await _service.deleteTransaction(item.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
