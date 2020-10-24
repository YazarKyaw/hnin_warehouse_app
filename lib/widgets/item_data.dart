import 'package:flutter/material.dart';
import 'package:hnin_warehouse_app/providers/auth.dart';
import 'package:hnin_warehouse_app/providers/item.dart';
import 'package:hnin_warehouse_app/providers/items.dart';
import 'package:hnin_warehouse_app/screens/item_detail_screen.dart';

import 'package:provider/provider.dart';

class ItemData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Item>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (ctx) => ItemDetailScreen(id: product.id)));
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/bag-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(product.quantity.toString()),
          ),
          trailing: Consumer<Item>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Color.fromRGBO(255, 77, 210, 1),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavorite(
                  authData.token,
                  authData.userId,
                );
              },
            ),
          ),
          subtitle: Text(
            product.itemName,
            textAlign: TextAlign.center,
          ),
          title: Text(
            product.itemCode,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
