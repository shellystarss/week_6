import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_6/UI/pages/pages.dart';
import 'package:week_6/models/models.dart';

class ProductCard extends StatelessWidget {
  final Products product;
  ProductCard({this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditPage(product: product),
                  settings: RouteSettings(arguments: product)));
        },
        title: Text(product.name, style: TextStyle(fontSize: 20)),
        subtitle: Text(
            NumberFormat.currency(locale: 'id', decimalDigits: 2, symbol: 'Rp ')
                .format(int.parse(product.price))),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(product.image, scale: 40),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
        ),
      ),
    );
  }
}
