import 'package:purchases_flutter/purchases_flutter.dart';

Map<dynamic, dynamic> purchaserInfoTestDataU = {
  "entitlements": {
    "all": {
      "pro": {
        "identifier": "pro",
        "isActive": false,
        "willRenew": false,
        "periodType": "PeriodType.normal",
        "latestPurchaseDate": "2020-02-25T08:33:34.000Z",
        "originalPurchaseDate": "2020-02-25T07:59:39.000Z",
        "expirationDate": "2020-02-25T08:36:34.000Z",
        "store": "Google PlayStore",
        "productIdentifier": "rc_sub_1m",
        "isSandbox": true,
        "unsubscribeDetectedAt": "2020-02-25T08:40:20.000Z",
        "billingIssueDetectedAt": null
      }
    },
    "active": {}
  },
  "latestExpirationDate": "2020-02-25T08:36:34.000Z",
  "allExpirationDates": {"rc_sub_1m": "2020-02-25T08:36:34.000Z"},
  "allPurchaseDates": {"rc_sub_1m": "2020-02-25T08:33:34.000Z"},
  "activeSubscriptions": [],
  "allPurchasedProductIdentifiers": ["rc_sub_1m"],
  "firstSeen": "2020-02-22T13:28:06.000Z",
  "originalAppUserId": "test@test.com",
  "requestDate": "2020-04-03T12:51:01.000Z",
  "originalApplicationVersion": null
};

Map<dynamic, dynamic> purchaserInfoTestDataS = {
  "entitlements": {
    "all": {
      "pro": {
        "identifier": "pro",
        "isActive": false,
        "willRenew": false,
        "periodType": "PeriodType.normal",
        "latestPurchaseDate": "2020-02-25T08:33:34.000Z",
        "originalPurchaseDate": "2020-02-25T07:59:39.000Z",
        "expirationDate": "2020-02-25T08:36:34.000Z",
        "store": "Google PlayStore",
        "productIdentifier": "rc_sub_1m",
        "isSandbox": true,
        "unsubscribeDetectedAt": "2020-02-25T08:40:20.000Z",
        "billingIssueDetectedAt": null
      }
    },
    "active": {
      "pro": {
        "identifier": "pro",
        "isActive": true,
        "willRenew": false,
        "periodType": "PeriodType.normal",
        "latestPurchaseDate": "2020-02-25T08:33:34.000Z",
        "originalPurchaseDate": "2020-02-25T07:59:39.000Z",
        "expirationDate": "2020-02-25T08:36:34.000Z",
        "store": "Google PlayStore",
        "productIdentifier": "rc_sub_1m",
        "isSandbox": true,
        "unsubscribeDetectedAt": "2020-02-25T08:40:20.000Z",
        "billingIssueDetectedAt": null
      }
    }
  },
  "latestExpirationDate": "2020-02-25T08:36:34.000Z",
  "allExpirationDates": {"rc_sub_1m": "2020-02-25T08:36:34.000Z"},
  "allPurchaseDates": {"rc_sub_1m": "2020-02-25T08:33:34.000Z"},
  "activeSubscriptions": [],
  "allPurchasedProductIdentifiers": ["rc_sub_1m"],
  "firstSeen": "2020-02-22T13:28:06.000Z",
  "originalAppUserId": "test@test.com",
  "requestDate": "2020-04-03T12:51:01.000Z",
  "originalApplicationVersion": null
};

Map<dynamic, dynamic> offeringsTestData = {
  "current": {
    "identifier": "Offering",
    "serverDescription": "RevenueCat Pro offering",
    "availablePackages": [
      {
        "identifier": "rc_monthly",
        "packageType": "MONTHLY",
        "product": {
          "identifier": "rc_sub_1m",
          "description": "RevenueCat 1 month subscription test",
          "title":
              "RevenueCat 1 month subscription test (Flutter Purchases RC Example)",
          "price": 4.59,
          "price_string": "R 4,59",
          "currency_code": "ZAR",
          "intro_price": 0,
          "intro_price_string": "R0,00",
          "intro_price_period": "P1W",
          "intro_pric_period_unit": "DAY",
          "intro_price_period_number_of_units": 7,
          "intro_price_cycles": 1,
        },
        "offeringIdentifier": "Offering",
      },
      {
        "identifier": "rc_monthly2",
        "packageType": "MONTHLY",
        "product": {
          "identifier": "rc_sub_1m2",
          "description": "RevenueCat 1 month subscription test 2",
          "title":
          "RevenueCat 1 month subscription test 2 (Flutter Purchases RC Example)",
          "price": 4.59,
          "price_string": "R 4,59",
          "currency_code": "ZAR",
          "intro_price": 0,
          "intro_price_string": "R0,00",
          "intro_price_period": "P1W",
          "intro_pric_period_unit": "DAY",
          "intro_price_period_number_of_units": 7,
          "intro_price_cycles": 1,
        },
        "offeringIdentifier": "Offering",
      }
    ],
  },
  "all": {
    "Offering": {
      "identifier": "Offering",
      "serverDescription": "RevenueCat Pro offering",
      "availablePackages": [
        {
          "identifier": "rc_monthly1",
          "packageType": "MONTHLY",
          "product": {
            "identifier": "rc_sub_1m1",
            "description": "RevenueCat 1 month subscription test 1",
            "title":
                "RevenueCat 1 month subscription test 1 (Flutter Purchases RC Example)",
            "price": 4.59,
            "price_string": "R 4,59",
            "currency_code": "ZAR",
            "intro_price": 0,
            "intro_price_string": "R0,00",
            "intro_price_period": "P1W",
            "intro_pric_period_unit": "DAY",
            "intro_price_period_number_of_units": 7,
            "intro_price_cycles": 1,
          },
          "offeringIdentifier": "Offering",
        },
        {
          "identifier": "rc_monthly2",
          "packageType": "MONTHLY",
          "product": {
            "identifier": "rc_sub_1m2",
            "description": "RevenueCat 1 month subscription test 2",
            "title":
            "RevenueCat 1 month subscription test 2 (Flutter Purchases RC Example)",
            "price": 4.59,
            "price_string": "R 4,59",
            "currency_code": "ZAR",
            "intro_price": 0,
            "intro_price_string": "R0,00",
            "intro_price_period": "P1W",
            "intro_pric_period_unit": "DAY",
            "intro_price_period_number_of_units": 7,
            "intro_price_cycles": 1,
          },
          "offeringIdentifier": "Offering",
        }
      ],
    }
  }
};
