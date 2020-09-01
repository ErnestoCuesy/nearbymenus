import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/models/order.dart';

class ExtraFields {
  double tip;
  double discount;

  ExtraFields({this.tip = 0.0, this.discount = 0.0});
}

class OrderExtraAmounts extends StatefulWidget {
  final int orderStatus;
  final double orderAmount;
  final ExtraFields extraFields;

  const OrderExtraAmounts({Key key, this.orderStatus, this.orderAmount, this.extraFields}) : super(key: key);

  @override
  _OrderExtraAmountsState createState() => _OrderExtraAmountsState();
}

class _OrderExtraAmountsState extends State<OrderExtraAmounts> {
  final TextEditingController _tipController =  TextEditingController();
  final FocusNode _tipFocusNode = FocusNode();
  final TextEditingController _discountController =  TextEditingController();
  final FocusNode _discountFocusNode = FocusNode();
  ExtraFields extraFields;
  double orderAmount;
  double totalAmount;
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");

  @override
  void initState() {
    super.initState();
    orderAmount = widget.orderAmount;
    extraFields = widget.extraFields;
    totalAmount = orderAmount;
    _tipController.text = extraFields.tip.toString();
    _discountController.text = (extraFields.discount * 100).toString();
    _recalculate();
  }

  @override
  void dispose() {
    _tipController.dispose();
    _discountController.dispose();
    _tipFocusNode.dispose();
    _discountFocusNode.dispose();
    super.dispose();
  }

  void _recalculate() {
    setState(() {
      totalAmount = orderAmount - (orderAmount * extraFields.discount) + extraFields.tip;
    });
  }

  TextField _buildTipTextField(BuildContext context) {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _tipController,
      focusNode: _tipFocusNode,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Tip amount in ${f.currencySymbol}',
        hintText: 'i.e.: 5.00, 10.99',
        errorText: '',
        enabled: true,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        extraFields.tip = double.tryParse(value ?? 0);
        _recalculate();
      },
      onEditingComplete: () => FocusScope.of(context).requestFocus(_discountFocusNode),
    );
  }

  TextField _buildDiscountTextField(BuildContext context) {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _discountController,
      focusNode: _discountFocusNode,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Discount percentage (%)',
        hintText: 'i.e.: 5, 10, 20',
        errorText: '',
        enabled: true,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        if (value.length > 0) {
          extraFields.discount = double.tryParse(value ?? 0) / 100;
        } else {
          extraFields.discount = 0.0;
        }
        _recalculate();
      },
      onEditingComplete: () => FocusScope.of(context).requestFocus(_discountFocusNode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            FlavourConfig.isPatron() ? 'Add tip' : 'Add tip and discount',
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.grey[50],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Subtotal: ${f.format(orderAmount)}',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          if (!FlavourConfig.isPatron())
                            _buildDiscountTextField(context),
                          if (widget.orderStatus == ORDER_ON_HOLD)
                          _buildTipTextField(context),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Total: ${f.format(totalAmount)}',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).backgroundColor,
                    child: Icon(Icons.save),
                    onPressed: () => Navigator.of(context).pop(extraFields),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
