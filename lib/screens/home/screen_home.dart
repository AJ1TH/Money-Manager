import 'package:flutter/material.dart';
import 'package:personal_money/db/category/category_db.dart';
import 'package:personal_money/models/category/category_models.dart';
import 'package:personal_money/screens/add_transaction/screen_add_transaction.dart';
import 'package:personal_money/screens/category/category_add_popup.dart';
import 'package:personal_money/screens/category/screen_category.dart';
import 'package:personal_money/screens/home/widgets/bottom_navigation.dart';
import 'package:personal_money/screens/transaction/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = const [
    ScreenTransactions(),
    ScreenCategory(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Money Manager'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ValueListenableBuilder(valueListenable: selectedIndexNotifier,
          builder: (BuildContext context,int updatedIndex, _){
            return _pages[updatedIndex];
            },
          ),
      ),
      bottomNavigationBar:const MoneyManagerBottomNavigation(),
      floatingActionButton: FloatingActionButton(onPressed: (){
        if(selectedIndexNotifier.value == 0){
          print("Add Transactions");

          Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
       }else{
          print("Add Category");

          showCategoryAddPopup(context);

          //final _sample = CategoryModel(
            //name: 'Travel',
            //id: DateTime.now().microsecondsSinceEpoch.toString(),
            //type: CategoryType.expense,
        //  );
          //CategoryDb().insertCategory(_sample).then((value) => null);
        }
        },
      child: Icon(Icons.add),
      ),
    );
  }
}
