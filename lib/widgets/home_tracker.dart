import 'dart:ffi';

import 'package:expense_tracker/widgets/expense_chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense_list/expense_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';

class HomeTracker extends StatefulWidget {
  const HomeTracker({super.key});
  @override
  State<StatefulWidget> createState() => _ExpenseState();
}

class _ExpenseState extends State<HomeTracker> {
  final List<Expense> expenses = [
    Expense(
        title: 'Buying bread',
        amount: 1.99,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Take a backend course',
        amount: 9.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Buy Ps5',
        amount: 214.79,
        date: DateTime.now(),
        category: Category.leisure)
  ];

  void _showAddOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(
              onSubmit: _addNewExpense,
            ));
  }

  void _addNewExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = expenses.indexOf(expense);

    setState(() {
      expenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Expense deleted'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            expenses.insert(expenseIndex, expense);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter expense tracker'),
          actions: <Widget>[
            IconButton(onPressed: _showAddOverlay, icon: const Icon(Icons.add)),
          ],
        ),
        body: (widthSize < 412)
            ? Column(
                children: [
                  Chart(expenses: expenses),
                  Expanded(
                      child: Expenses(
                    expenses: expenses,
                    onRemoveExpense: _removeExpense,
                  ))
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: expenses)),
                  Expanded(
                      child: Expenses(
                    expenses: expenses,
                    onRemoveExpense: _removeExpense,
                  ))
                ],
              ));
  }
}
