import 'package:flutter/material.dart';
import 'package:personal_money/db/category/category_db.dart';
import 'package:personal_money/models/category/category_models.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB().expenseCategoryListListener,
        builder: (BuildContext ctx, List<CategoryModel> newList , Widget? _){
          return ListView.separated(
            itemBuilder: (ctx,index){
            final category = newList[index];
            return Card(
              child: ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  onPressed: (){
                    CategoryDB.instance.deleteCategory(category.id);
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            );
          },
            separatorBuilder: (ctx,index){
              return SizedBox(height: 10,);
            },
            itemCount: newList.length,
          );
        });
  }
}
