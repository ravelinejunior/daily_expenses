import 'dart:developer';

import 'package:daily_expenses/utils/decimal_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();

  final valueController = TextEditingController();

  DateTime _selectedDate = DateTime(0);

  _submitForm() {
    if (titleController.text.isNotEmpty &&
        valueController.text.isNotEmpty &&
        _selectedDate.year != 0) {
      final title = (titleController.text);
      final value = double.tryParse(valueController.text) ?? 0.0;

      titleController.clear();
      valueController.clear();

      widget.onSubmit(title, value, _selectedDate);
      Navigator.of(context).pop();
    } else {
      log('Fields cannot be empty');
    }
  }

  _showDatePicker() async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((datePicked) {
      print(datePicked);
      if (datePicked == null) {
        return;
      } else {
        setState(() {
          _selectedDate = datePicked;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  alignLabelWithHint: true,
                  hintText: 'Digite um título',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.text_format),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: valueController,
                decoration: InputDecoration(
                  labelText: 'Valor',
                  alignLabelWithHint: true,
                  prefix: Text('R\$'),
                  prefixIcon: Icon(Icons.monetization_on),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blueGrey)),
                ),
                inputFormatters: [DecimalTextInputFormatter()],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height / 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate.year == 0
                        ? 'Nenhuma data selecionada!'
                        : 'Data selecionada: ${DateFormat('dd/MMM/y').format(_selectedDate)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedDate.year == 0
                          ? Colors.black
                          : Colors.purple,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Color.fromRGBO(255, 100, 255, 0.4)),
                    ),
                    onPressed: _showDatePicker,
                    child: Text(
                      'Selecionar Data',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blueGrey),
                    ),
                    onPressed: _submitForm,
                    child: Text(
                      'Nova Transação',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
