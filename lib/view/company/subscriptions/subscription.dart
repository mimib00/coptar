import 'dart:async';
import 'dart:developer';

import 'package:copter/view/company/subscriptions/payment.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  var currentPlan = 0;

  bool available = true;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final List<ProductDetails> _products = [];
  final List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>>? subscription;

  void _initialize() async {
    available = await _inAppPurchase.isAvailable();
    final prods = await getProducts({
      "monthly_99",
      "monthly_129", // create montly 129 and add
    });
    for (var product in prods) {
      _products.add(product);
    }
    setState(() {});
  }

  Future<List<ProductDetails>> getProducts(Set<String> productIds) async {
    ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);
    log(response.productDetails.toString());
    return response.productDetails;
  }

  void _listenToPurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
          break;
        case PurchaseStatus.restored:
          if (purchaseDetails.purchaseID != null) {
            // update database after subscription
          }
          break;
        case PurchaseStatus.error:
          Get.snackbar("Error", purchaseDetails.error!.message);
          break;
        case PurchaseStatus.canceled:
          break;
      }
    }
  }

//call this function after tapping subscribe button and the pass the index for choosing the product
  void subscribe(int selectedIndex) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: _products[selectedIndex]);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;

    subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _purchases.addAll(purchaseDetailsList);
      _listenToPurchaseUpdates(purchaseDetailsList);
    }, onDone: () {
      subscription!.cancel();
    }, onError: (err) {
      subscription!.cancel();
    });
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Subscription',
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          MyText(
            align: TextAlign.center,
            text: 'Get subscription',
            size: 18,
            weight: FontWeight.w500,
          ),
          MyText(
            paddingTop: 10,
            align: TextAlign.center,
            text: 'Lorem Ipsum is simply dummy text of the printing industry\'s standard dummy text',
            size: 12,
            paddingBottom: 50,
          ),
          ..._products
              .map(
                (e) => Text(e.title),
              )
              .toList(),
          // plans(
          //   'Basic',
          //   '99',
          //   '/month',
          //   [
          //     'Get 10 employee account',
          //     'Get 54 task',
          //     '24/7 support',
          //   ],
          //   0,
          // ),
          // plans(
          //   'Premium',
          //   '129',
          //   '/month',
          //   [
          //     'Get unlimited employee',
          //     'Get unlimited task',
          //     '24/7 support',
          //   ],
          //   1,
          // ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: SizedBox(
          height: 70,
          child: Center(
            child: SizedBox(
              width: Get.width * 0.8,
              child: MyButton(
                haveRoundedEdges: true,
                haveCustomElevation: true,
                onPressed: () => Get.to(() => const Payment()),
                text: 'Proceed to payment',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget plans(String? type, price, duration, List features, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentPlan = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: RadiusHandler.radius10,
          border: Border.all(
            width: 2.0,
            color: currentPlan == index ? kBorderColor : kPrimaryColor,
          ),
          boxShadow: [
            currentPlan == index
                ? const BoxShadow()
                : BoxShadow(
                    color: kBlackColor.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyText(
              align: TextAlign.center,
              text: type,
              weight: FontWeight.w500,
              color: kSecondaryColor,
              paddingBottom: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  text: '\$$price',
                  size: 18,
                  weight: FontWeight.w500,
                ),
                MyText(
                  text: '/$duration',
                  size: 12,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                features.length,
                (f) => featuresTiles(features[f]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget featuresTiles(String? title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                kCheckIcon,
                height: 16,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Align(
              alignment: Alignment.centerLeft,
              child: MyText(
                text: title,
                size: 12,
                paddingLeft: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//subscription
