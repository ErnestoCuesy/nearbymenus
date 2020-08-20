import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/order.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_browser/expandable_list_view.dart';
import 'package:nearbymenus/app/pages/orders/view_order.dart';
import 'package:nearbymenus/app/pages/sign_in/conversion_process.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/navigation_service.dart';
import 'package:provider/provider.dart';

class ExpandableMenuBrowser extends StatefulWidget {

  @override
  _ExpandableMenuBrowserState createState() => _ExpandableMenuBrowserState();
}

class _ExpandableMenuBrowserState extends State<ExpandableMenuBrowser> {
  Auth auth;
  Session session;
  Database database;
  NavigationService navigationService;
  Restaurant restaurant;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");
  ScrollController _scrollController = ScrollController();

  bool get orderOnHold =>
      session.currentOrder.orderItems.length > 0 &&
      session.currentOrder.restaurantId == session.currentRestaurant.id &&
      session.currentOrder.status == ORDER_ON_HOLD;

  int get _numberOfItems => orderOnHold
      ? session.currentOrder.orderItems.length
      : 0;

  Widget _buildContents(BuildContext context, Map<dynamic, dynamic> menus,
    Map<dynamic, dynamic> options, dynamic sortedKeys) {
    return DraggableScrollbar.semicircle(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: sortedKeys.length,
        itemBuilder: (BuildContext context, int index) {
          final menu = menus[sortedKeys[index]];
          return ExpandableListView(
            callBack: _callBack,
            menu: menu,
            options: options,
          );
        },
      ),
    );
  }

  void _callBack() {
    setState(() {
      _checkExistingOrder();
    });
  }

  void _shoppingCartAction(BuildContext context) async {
    final ConversionProcess conversionProcess = ConversionProcess(
        navigationService: navigationService,
        session: session,
        auth: auth,
        database: database,
        captureUserDetails: true,
    );
    if (!await conversionProcess.userCanProceed()) {
      return;
    }
    if (orderOnHold) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: false,
          builder: (context) => ViewOrder.create(
            context: context,
            order: session.currentOrder,
            scaffoldKey: _scaffoldKey,
            callBack: _callBack,
          ),
        ),
      );
    } else {
      session.currentOrder = null;
      if (session.userDetails.orderOnHold != null) {
        session.userDetails.orderOnHold = null;
        database.setUserDetails(session.userDetails);
      }
      await PlatformExceptionAlertDialog(
        title: 'Empty Order',
        exception: PlatformException(
          code: 'ORDER_IS_EMPTY',
          message:
          'Please tap on the menu items you wish to order first.',
          details:
          'Please tap on the menu items you wish to order first.',
        ),
      ).show(context);
    }
  }

  void _checkExistingOrder() {
    final double timestamp = dateFromCurrentDate() / 1.0;
    var orderNumber = documentIdFromCurrentDate();
    if (session.currentOrder == null) {
      session.currentOrder = Order(
          id: orderNumber,
          restaurantId: session.currentRestaurant.id,
          restaurantName: session.currentRestaurant.name,
          managerId: session.currentRestaurant.managerId,
          userId: database.userId,
          timestamp: timestamp,
          status: ORDER_ON_HOLD,
          name: session.userDetails.name,
          deliveryAddress: '${session.userDetails.address1} ${session.userDetails.address2} ${session.userDetails.address3} ${session.userDetails.address4}',
          telephone: session.userDetails.telephone,
          deliveryPosition: session.position,
          paymentMethod: '',
          orderItems: List<Map<dynamic, dynamic>>(),
          notes: ''
      );
    }
    session.currentOrder.userId = database.userId;
    if (session.userDetails.orderOnHold != null && session.userDetails.orderOnHold.length > 0) {
      session.currentOrder = Order.fromMap(session.userDetails.orderOnHold, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthBase>(context);
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    navigationService = Provider.of<NavigationService>(context);
    Map<dynamic, dynamic> menus;
    Map<dynamic, dynamic> options;
    Map<dynamic, dynamic> sortedMenus = Map<dynamic, dynamic>();
    _checkExistingOrder();
    restaurant = session.currentRestaurant;
    menus = restaurant.restaurantMenus;
    options = restaurant.restaurantOptions;
    sortedMenus.clear();
    menus.forEach((key, value) {
      if (value['hidden'] == false) {
        sortedMenus.putIfAbsent(value['sequence'], () => value);
      }
    });
    var sortedKeys = sortedMenus.keys.toList()..sort();
    return Stack(
      children: <Widget>[
        Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              '${restaurant.name}',
              style: TextStyle(color: Theme.of(context).appBarTheme.color),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 26.0),
                child: IconButton(
                  icon: Icon(Icons.add_shopping_cart, size: 32.0,),
                  onPressed: () => _shoppingCartAction(context),
                ),
              ),
            ],
          ),
          body: _buildContents(context, sortedMenus, options, sortedKeys),
        ),
        if (_numberOfItems > 0)
        Positioned(
          right: 18,
          top: 5,
          child: Container(
            height: 20.0,
            width: 20.0,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 35.0, right: 5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.red
            ),
            child: Text(
              _numberOfItems.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ]
    );
  }
}
