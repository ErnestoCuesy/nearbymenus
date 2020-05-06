import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlaceOrderDialog extends StatefulWidget {
  final Map<String, dynamic> item;
  final Map<String, dynamic> options;

  const PlaceOrderDialog({Key key, this.item, this.options}) : super(key: key);

  @override
  _PlaceOrderDialogState createState() => _PlaceOrderDialogState();
}

class _PlaceOrderDialogState extends State<PlaceOrderDialog> {
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");

  Widget _buildContents(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        height: 500.0,
        width: 400.0,
        child: Card(
          child: Column(
            children: [
              SizedBox(
                height: 16.0,
              ),
              Text(
                '${widget.item['name']}',
                style: Theme.of(context).accentTextTheme.headline5,
              ),
              SizedBox(
                height: 16.0,
              ),
              Column(
                children: _buildOptions(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOptions() {
    List<Widget> optionList = List<Widget>();
    widget.item['options'].forEach((key) {
      Map<String, dynamic> optionValue = widget.options[key];
      optionList.add(
        Text(
          '${optionValue['name']}',
          style: Theme.of(context).accentTextTheme.headline6,
        ),
      );
      var selectionNote;
      var singular = '';
      if (optionValue['numberAllowed'] > 1) {
        selectionNote = 'up to';
        singular = 's';
      } else {
        selectionNote = 'only';
      }
      optionList.add(
        Text(
          'Please select $selectionNote ${optionValue['numberAllowed']} option$singular',
          style: Theme.of(context).accentTextTheme.headline6,
        ),
      );
      optionValue.forEach((key, value) {
        if (key.toString().length > 20) {
          optionList.add(CheckboxListTile(
            title: Text(
              '${value['name']}',
            ),
            value: false,
            onChanged: null,
          ),
          );
        }
      });
    });
    return optionList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select your options',
          style: TextStyle(color: Theme.of(context).appBarTheme.color),
        ),
      ),
      body: _buildContents(context),
    );
  }
}
