import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubcategoryTotal {
  final String categoryName;
  final double amount;

  SubcategoryTotal(this.categoryName, this.amount);
}

class ItemBreakdownReport extends ModalRoute<void> {
  final Map<String, dynamic> items;
  List<SubcategoryTotal> subcategoryTotals = List<SubcategoryTotal>();

  ItemBreakdownReport(this.items) {
    items.forEach((key, value) {
      subcategoryTotals.add(SubcategoryTotal(key, value));
    });
  }

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        color: Colors.grey[50],
        height: height - 100,
        width: width - 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: height - 200,
              width: width - 150,
              child: _itemsList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).backgroundColor,
                child: Icon(Icons.clear),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemsList() {
    final f = NumberFormat.simpleCurrency(locale: 'en_ZA');
    return ListView.builder(
        itemCount: subcategoryTotals.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            isThreeLine: false,
            title: Text(
                subcategoryTotals[index].categoryName
            ),
            trailing: Text(
              f.format(subcategoryTotals[index].amount)
            ),
          );
    });
  }
}