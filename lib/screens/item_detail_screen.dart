import 'package:flutter/material.dart';
import 'package:hnin_warehouse_app/providers/items.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatelessWidget {
  static const routeName = '/item_detail_screen';
  final String id;
  final bool detailByItem;
  ItemDetailScreen({this.id, this.detailByItem = false});
  String convertString(String text) {
    if (text == 'HomeUp') {
      return 'အိမ်ပေါ်';
    }
    if (text == 'ShopBack') {
      return 'ဆိုင်အနောက်';
    }
    if (text == 'Warehouse') {
      return 'ဂိုဒေါင်';
    }
    if (text == 'yk') {
      return 'ရောက်ကိုက်';
    }
    if (text == 'ymk') {
      return 'ရောက်မကိုက်';
    }
    if (text == 'nymk') {
      return 'ပစ္စည်းမတိုက်ရသေးပါ';
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemLoaded = detailByItem
        ? Provider.of<Items>(context).findByItemId(id)
        : Provider.of<Items>(context).findById(id);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Item Code : ${itemLoaded.itemCode}",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Lato'
                    //color: Colors.pinkAccent,
                    ),
              ),
              background: Hero(
                tag: itemLoaded.id,
                child: Image.network(
                  itemLoaded.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              'Item Name',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                              ),
                            ),
                            width: 125,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                          ),
                          Flexible(
                            child: Text(
                              itemLoaded.itemName,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                              ),
                            ),
                            width: 125,
                            decoration: BoxDecoration(
                              //color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              itemLoaded.quantity.toString(),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              'Date Added',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                              ),
                            ),
                            width: 125,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(itemLoaded.dateTime),
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              'ပစ္စည်းနေရာ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                              ),
                            ),
                            width: 125,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                          ),
                          Text(
                            convertString(itemLoaded.position),
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              'စာရင်းတိုက်ရန်',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                              ),
                            ),
                            width: 125,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                          ),
                          Text(
                            convertString(itemLoaded.itemList),
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    'Description',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  margin: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 5,
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          itemLoaded.description,
                          textAlign: TextAlign.start,
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //For Testing
                SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
