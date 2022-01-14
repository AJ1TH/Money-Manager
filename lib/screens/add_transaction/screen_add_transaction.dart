import 'package:flutter/material.dart';
import 'package:personal_money/db/category/category_db.dart';
import 'package:personal_money/db/transactions/transactions_db.dart';
import 'package:personal_money/models/category/category_models.dart';
import 'package:personal_money/models/transactions/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {

  static const routeName = 'add-transaction';
  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {

  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  String? _categoryid;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();


  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                //purpose
                TextFormField(
                  controller: _purposeTextEditingController,
                  keyboardType: TextInputType.text,
                  decoration:const InputDecoration(
                    hintText: 'Purpose',
                  ),
                ),
                //amount
                TextFormField(
                  controller: _amountTextEditingController,
                  keyboardType: TextInputType.number,
                  decoration:const InputDecoration(
                    hintText: 'Amount',
                  ),
                ),
                //date
                TextButton.icon(
                  onPressed: () async{
                   final _selectedDateTemp = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 30)),
                        lastDate: DateTime.now(),
                    );

                   if(_selectedDateTemp == null){
                     return;
                   }else{
                     print(_selectedDateTemp.toString());
                    setState(() {
                      _selectedDate = _selectedDateTemp;
                    });
                   }
                  },
                  icon: Icon(Icons.calendar_today),
                  label: Text(_selectedDate == null ?'Select Date' : _selectedDate!.toString()),
                ),
                //income/expense
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio(
                            value:CategoryType.income ,
                            groupValue:_selectedCategoryType ,
                            onChanged: (newValue){
                             setState(() {
                               _selectedCategoryType = CategoryType.income;
                               _categoryid = null ;
                             });
                            },
                        ),
                        const Text('Income'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value:CategoryType.expense ,
                          groupValue:_selectedCategoryType,
                          onChanged: (newValue){
                            setState(() {
                              _selectedCategoryType = CategoryType.expense;
                              _categoryid =null;
                            });
                          },
                        ),
                        const Text('Expense'),
                      ],
                    ),
                  ],
                ),
                //category type
                DropdownButton<String>(
                  hint:const Text('Select Category'),
                    value: _categoryid,
                    items:(_selectedCategoryType == CategoryType.income
                        ? CategoryDB().incomeCategoryListListener
                        : CategoryDB().expenseCategoryListListener
                    ).value.map((e){
                      return DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name),
                        onTap: (){
                          _selectedCategoryModel = e;
                        },
                      );
                    }).toList(),
                    onChanged: (selectedValue){
                    print(selectedValue);
                  setState(() {
                    _categoryid = selectedValue;
                  });
                    },
                ),
                //Submit

                ElevatedButton(
                    onPressed: (){
                      addTransaction();
                    },
                    child: Text('Submit'),
                )
              ],
            ),
          )
      ),
    );
  }

  Future<void> addTransaction() async{
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;

    if(_purposeText.isEmpty)
    {
      return;
    }
    if(_amountText.isEmpty)
      {
        return;
      }
    if(_categoryid == null)
      {
        return;
      }
    if(_selectedDate == null)
      {
        return;
      }
    if(_selectedCategoryModel == null)
      {
        return;
      }
    final _parsedAmount = double.tryParse(_amountText);
    if(_parsedAmount == null)
      {
        return;
      }

    final _model = TransactionModel(
        purpose: _purposeText,
        amount: _parsedAmount,
        date: _selectedDate!,
        type:_selectedCategoryType!,
        category: _selectedCategoryModel!,
    );

    await TransactionDB.instance.addTransaction(_model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }
}
