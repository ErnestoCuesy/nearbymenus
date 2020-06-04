import 'dart:async';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:nearbymenus/app/services/iap_test_data.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum SubscriptionType { Unsubscribed, Expired, Standard, Pro }

class Subscription {
  final PurchaserInfo purchaserInfo;
  final Offerings offerings;

  Subscription({this.purchaserInfo, this.offerings});

  SubscriptionType get subscriptionType {
    if (purchaserInfo != null && purchaserInfo.entitlements.active.isNotEmpty) {
      if (purchaserInfo.entitlements.active.containsKey("pro")) {
        return SubscriptionType.Pro;
      } else {
        if (purchaserInfo.entitlements.active.containsKey("std")) {
          return SubscriptionType.Standard;
        }
      }
    }
    return SubscriptionType.Unsubscribed;
  }

  String get subscriptionTypeString {
    switch (subscriptionType) {
      case SubscriptionType.Pro: {
        return 'Pro';
      }
      break;
      case SubscriptionType.Standard: {
        return 'Standard';
      }
      break;
      default: {
        return 'Unsubscribed';
      }
    }
  }

  int get numberOfActiveSubscriptions => purchaserInfo.activeSubscriptions.length;

  String get firstSeen => purchaserInfo.firstSeen;

  String get latestExpirationDate => purchaserInfo.latestExpirationDate;

  List<Package> get availableOfferings {
    if (offerings != null) {
      return offerings.current.availablePackages;
    }
    return null;
  }

}

abstract class IAPManagerBase {
  Stream<Subscription> get onSubscriptionChanged;
  SubscriptionType get subscriptionType;
  void purchasePackage(Package package);
  Future<void> purchaseProduct(String productIdentifier);

  static String parseErrorCode(PurchasesErrorCode errorCode) {
    switch (errorCode) {
      case PurchasesErrorCode.unknownError: {
        return 'Unknown error';
      }
      break;
      case PurchasesErrorCode.purchaseCancelledError: {
        return 'Purchase cancelled';
      }
      break;
      case PurchasesErrorCode.storeProblemError: {
        return 'Store problem';
      }
      break;
      case PurchasesErrorCode.purchaseNotAllowedError: {
        return 'Purchase not allowed';
      }
      break;
      case PurchasesErrorCode.purchaseInvalidError: {
        return 'Purchase invalid';
      }
      break;
      case PurchasesErrorCode.productNotAvailableForPurchaseError: {
        return 'Product not available for purchase';
      }
      break;
      case PurchasesErrorCode.productAlreadyPurchasedError: {
        return 'Product already purchased';
      }
      break;
      case PurchasesErrorCode.receiptAlreadyInUseError: {
        return 'Receipt already in use';
      }
      break;
      case PurchasesErrorCode.invalidReceiptError: {
        return 'Invalid receipt';
      }
      break;
      case PurchasesErrorCode.missingReceiptFileError: {
        return 'Missing receipt';
      }
      break;
      case PurchasesErrorCode.networkError: {
        return 'Network error';
      }
      break;
      case PurchasesErrorCode.invalidCredentialsError: {
        return 'Invalid credentials';
      }
      break;
      case PurchasesErrorCode.unexpectedBackendResponseError: {
        return 'Unexpected backend response';
      }
      break;
      case PurchasesErrorCode.receiptInUseByOtherSubscriberError: {
        return 'Receipt in use by other subscriber';
      }
      break;
      case PurchasesErrorCode.invalidAppUserIdError: {
        return 'Invalid app user ID';
      }
      break;
      case PurchasesErrorCode.operationAlreadyInProgressError: {
        return 'Operation already in progress';
      }
      break;
      case PurchasesErrorCode.unknownBackendError: {
        return 'Unknown backend error';
      }
      break;
      case PurchasesErrorCode.insufficientPermissionsError: {
        return 'Insufficient permissions';
      }
      break;
      case PurchasesErrorCode.paymentPendingError: {
        return 'Payment pending';
      }
      break;
      default: {
        return 'Other unknown error';
      }
    }
  }

}

class IAPManagerMock implements IAPManagerBase {
  final String userID;
  PurchaserInfo _purchaserInfo;
  Offerings _offerings;
  Subscription _subscription;
  StreamController<Subscription> controller = StreamController<Subscription>.broadcast();

  IAPManagerMock({@required this.userID}) {
    init();
  }

  Future<void> init() async {
    _purchaserInfo = PurchaserInfo.fromJson(purchaserInfoTestDataU);
    _offerings = Offerings.fromJson(offeringsTestData);
    await Future.delayed(Duration(seconds: 3)); // Simulate slow network
    streamSubscription(pi: _purchaserInfo, of: _offerings);
  }
  
  @override
  Stream<Subscription> get onSubscriptionChanged => controller.stream;

  @override
  void purchasePackage(Package package) {
    print('Purchasing package: ${package.identifier}');
    _purchaserInfo = PurchaserInfo.fromJson(purchaserInfoTestDataS);
    streamSubscription(pi: _purchaserInfo, of: _offerings);
  }

  @override
  Future<void> purchaseProduct(String productIdentifier) async {
  }

  @override
  SubscriptionType get subscriptionType => _subscription.subscriptionType;

  void streamSubscription({PurchaserInfo pi, Offerings of}) {
    _subscription = Subscription(purchaserInfo: pi, offerings: of);
    controller.add(_subscription);
  }

}

class IAPManager implements IAPManagerBase {
  final String userID;
  PurchaserInfo _purchaserInfo;
  Offerings _offerings;
  Subscription _subscription;
  StreamController<Subscription> controller = StreamController<Subscription>();

  @override
  Stream<Subscription> get onSubscriptionChanged => controller.stream;

  IAPManager({@required this.userID}) {
    init();
  }

  Future<void> init() async {
    Purchases.setDebugLogsEnabled(false);
    await Purchases.setup("AeegEYeSxBwqtfZXZtbeMWVTOnAhyxiA", appUserId: userID);
    await Purchases.setAllowSharingStoreAccount(false);
    _purchaserInfo = await Purchases.getPurchaserInfo();
    _offerings = await Purchases.getOfferings();
    streamSubscription(pi: _purchaserInfo, of: _offerings);
    Purchases.addPurchaserInfoUpdateListener((pi) {
      streamSubscription(pi: pi, of: _offerings);
    });
  }

  void streamSubscription({PurchaserInfo pi, Offerings of}) {
    _subscription = Subscription(purchaserInfo: pi, offerings: of);
    controller.add(_subscription);
  }

  @override
  SubscriptionType get subscriptionType => _subscription.subscriptionType;

  @override
  void purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      // Don't have to add anything to the stream as the listener above
      // will pick-up the subscription change and add it to the stream
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      controller.addError(IAPManagerBase.parseErrorCode(errorCode));
    }
  }

  @override
  Future<void> purchaseProduct(String productIdentifier) async {
    try {
      await Purchases.purchaseProduct(productIdentifier, type: PurchaseType.inapp);
      // Don't have to add anything to the stream as the listener above
      // will pick-up the subscription change and add it to the stream
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      controller.addError(IAPManagerBase.parseErrorCode(errorCode));
      rethrow;
    }
  }

}
