import 'package:flutter/material.dart';
import 'package:personal_money/db/category/category_db.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: CategoryDB().incomeCategoryListListener,
        builder: (BuildContext ctx, List newList , Widget? _){
          return ListView.separated(itemBuilder: (ctx,index){
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
