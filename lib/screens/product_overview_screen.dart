import 'package:flutter/material.dart';
import 'package:hnin_warehouse_app/providers/items.dart';
import 'package:hnin_warehouse_app/widgets/app_drawer.dart';
import 'package:hnin_warehouse_app/widgets/item_gird.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  HomeUp,
  Warehouse,
  ShopBack,
  yk,
  ymk,
  nymk,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/product_overview_screen';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(Duration(milliseconds: 500)).then((_) {
        Provider.of<Items>(context, listen: false)
            .fetchAndSetAllItems(true)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  var filterString = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        backgroundColor: Color.fromRGBO(255, 77, 210, 1),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.HomeUp) {
                    filterString = 'HomeUp';
                  }
                  if (selectedValue == FilterOptions.Warehouse) {
                    filterString = 'Warehouse';
                  }
                  if (selectedValue == FilterOptions.ShopBack) {
                    filterString = 'ShopBack';
                  }
                  if (selectedValue == FilterOptions.yk) {
                    filterString = 'yk';
                  }
                  if (selectedValue == FilterOptions.ymk) {
                    filterString = 'ymk';
                  }
                  if (selectedValue == FilterOptions.nymk) {
                    filterString = 'nymk';
                  }
                  if (selectedValue == FilterOptions.All) {
                    filterString = 'All';
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('အိမ်ပေါ် '),
                      value: FilterOptions.HomeUp,
                    ),
                    PopupMenuItem(
                      child: Text('ဂိုဒေါင် '),
                      value: FilterOptions.Warehouse,
                    ),
                    PopupMenuItem(
                      child: Text('ဆိုင်အနောက် '),
                      value: FilterOptions.ShopBack,
                    ),
                    PopupMenuItem(
                      child: Text('ရောက်/ကိုက် '),
                      value: FilterOptions.yk,
                    ),
                    PopupMenuItem(
                      child: Text('ရောက်/မကိုက် '),
                      value: FilterOptions.ymk,
                    ),
                    PopupMenuItem(
                      child: Text('ပစ္စည်းမတိုက်ရသေးပါ '),
                      value: FilterOptions.nymk,
                    ),
                    PopupMenuItem(
                      child: Text('အားလုံး '),
                      value: FilterOptions.All,
                    ),
                  ]),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ItemGird(
              filterString: filterString,
              favoriteStatus: false,
            ),
    );
  }
}
