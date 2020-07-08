import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/custom_weekday_label_row.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/models/authorizations.dart';
import 'package:nearbymenus/app/models/order.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/restaurant/venue_authorization_page.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class OrderTotals extends StatefulWidget {
  @override
  _OrderTotalsState createState() => _OrderTotalsState();
}

class _OrderTotalsState extends State<OrderTotals> {
  Session session;
  Database database;
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");
  Stream<List<Order>> _stream;
  List<Order> _orderList = List<Order>();
  Map<String, double> _orderTotals = {};
  Authorizations _authorizations =
  Authorizations(authorizedRoles: {}, authorizedNames: {}, authorizedDates: {});
  List<dynamic> _intDates = List<dynamic>();
  List<String> _stringDates = List<String>();
  String _selectedStringDate = '';
  DateTime _selectedDate;
  dynamic _searchDate;
  static const String NOT_AUTH = '9999/12/31';

  void _calculateTotals() {
    _orderTotals.clear();
    _orderTotals.putIfAbsent('active', () => 0.00);
    _orderTotals.putIfAbsent('closed', () => 0.00);
    _orderList.forEach((order) {
      if (order.status > ORDER_PLACED && order.status < 10) {
        _orderTotals.update('active', (value) => value + order.orderTotal);
      } else {
        if (order.status == ORDER_CLOSED) {
          _orderTotals.update('closed', (value) => value + order.orderTotal);
        }
      }
    });
    print('Orders totals: $_orderTotals');
  }

  void _determineSearchDate() {
    if (FlavourConfig.isVenue()) {
      _intDates = _authorizations.authorizedDates[database.userId];
      _intDates.sort((a, b) => b.compareTo(a));
      _stringDates.clear();
      _intDates.forEach((intDate) {
        final date = DateTime.fromMillisecondsSinceEpoch(intDate);
        final strDate = '${date.year}' + '/' + '${date.month}' + '/' +
            '${date.day}';
        _stringDates.add(strDate);
      });
      if (_selectedStringDate == '') {
        _selectedStringDate = NOT_AUTH;
        if (_stringDates.length > 0) {
          _selectedStringDate = _stringDates[0];
        }
      }
      final yearMonthArr = _selectedStringDate.split('/');
      final year = int.parse(yearMonthArr[0]);
      final month = int.parse(yearMonthArr[1]);
      final day = int.parse(yearMonthArr[2]);
      _searchDate = DateTime(year, month, day).millisecondsSinceEpoch;
    } else {
      DateTime startDate = DateTime.now();
      if (_selectedDate != null) {
        startDate = _selectedDate;
      }
      _searchDate = DateTime(startDate.year, startDate.month, startDate.day).millisecondsSinceEpoch;
      _selectedStringDate = '${startDate.year}' + '/' + '${startDate.month}' + '/' +
          '${startDate.day}';
    }
  }

  Widget _buildContents(BuildContext context) {
    return FutureBuilder<List<Authorizations>>(
      future: database.authorizationsSnapshot(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.waiting &&
            snapshot.hasData) {
          _authorizations = snapshot.data.firstWhere((authorization) => authorization.id == session.currentRestaurant.id);
          _determineSearchDate();
          if (_selectedStringDate == NOT_AUTH) {
            return VenueAuthorizationPage();
          } else {
            _stream = database.dayRestaurantOrders(
                session.currentRestaurant.id,
                DateTime.fromMillisecondsSinceEpoch(_searchDate)
            );
            return StreamBuilder<List<Order>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting &&
                    snapshot.hasData) {
                  _orderList = snapshot.data;
                  _calculateTotals();
                  return SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Sales for the day',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline4,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _selectedStringDate,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              width: 300,
                              child: Card(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Text(
                                        'Orders in progress',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${f.format(_orderTotals['active'])}',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              width: 300,
                              child: Card(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Text(
                                        'Orders closed',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${f.format(_orderTotals['closed'])}',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              width: 300,
                              child: Card(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'Total',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${f.format(_orderTotals['active'] +
                                            _orderTotals['closed'])}',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(child: PlatformProgressIndicator());
                }
              },
            );
          }
        } else {
          return Center(child: PlatformProgressIndicator());
        }
      },
    );
  }

  Widget _datesMenuButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: PopupMenuButton<String>(
          icon: Icon(Icons.calendar_today),
          onSelected: (String date) {
            setState(() {
            _selectedStringDate = date;
            });
          },
          itemBuilder: (BuildContext context) {
            return _stringDates.map((String date) {
                return PopupMenuItem<String>(
                  child: Text(date),
                  value: date,
                );
            }).toList();
          }),
    );
  }

  Future<void> _calendarButton(BuildContext context) async {
    var startDate = DateUtils.getFirstDayOfCurrentMonth();
    var endDate = DateUtils.getLastDayOfCurrentMonth();
    final DateFormat monthName = DateFormat(DateFormat.MONTH);
    final month = monthName.format(startDate);
    _selectedDate = await Navigator.of(context).push(
      MaterialPageRoute<DateTime>(builder: (_) => Scaffold(
          appBar: new AppBar(
            title: new Text('Select query date'),
          ),
          body: Column(
            children: [
              Container(height: 32.0),
              Text(month,
                style: Theme.of(context).textTheme.headline4,
              ),
              Container(height: 32.0),
              Calendarro(
                  startDate: startDate,
                  endDate: endDate,
                  displayMode: DisplayMode.MONTHS,
                  selectionMode: SelectionMode.SINGLE,
                  weekdayLabelsRow: CustomWeekdayLabelsRow(),
                  onTap: (date) {
                    Navigator.of(context).pop(date);
                  }
              ),
            ],
          ),
        )
      ),
    );
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
              '${session.currentRestaurant.name}',
          style: TextStyle(color: Theme.of(context).appBarTheme.color),
        ),
        actions: [
          if (FlavourConfig.isManager())
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _calendarButton(context),
              ),
            ),
          if (FlavourConfig.isVenue())
            _datesMenuButton()
        ],
      ),
      body: _buildContents(context),
    );
  }
}
