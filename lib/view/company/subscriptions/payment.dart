import 'package:copter/view/company/subscriptions/payment_successful.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool? continuePaymentWithThisAccount = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Payment',
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 178,
            child: ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
              ),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return RecentCards(
                  cardHolderName: 'Shakhawoat Hossain Raju',
                  lastFourDigits: '2487',
                  balance: '26578',
                  vendorType: kVisaCard,
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: 'Add  card',
                      size: 16,
                      weight: FontWeight.w500,
                    ),
                    Image.asset(
                      kAddIcon,
                      height: 30,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const PaymentFields(
                  labelText: 'Card name',
                  hintText: 'Dulce Vetrovs',
                ),
                const PaymentFields(
                  labelText: 'Card number',
                  hintText: '2546 3645 2651 3651',
                ),
                Row(
                  children: const [
                    Expanded(
                      flex: 4,
                      child: PaymentFields(
                        labelText: 'CCV',
                        hintText: '***',
                        obSecure: true,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Expanded(
                      flex: 4,
                      child: PaymentFields(
                        labelText: 'Exp. Date',
                        hintText: 'mm / yy',
                      ),
                    ),
                  ],
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: MyText(
                    text: 'Continue payment this account',
                  ),
                  trailing: SizedBox(
                    width: 40,
                    height: 20,
                    child: FlutterSwitch(
                      padding: 1.3,
                      toggleSize: 16.2,
                      inactiveColor: kSecondaryColor.withOpacity(0.1),
                      toggleColor: kSecondaryColor,
                      activeColor: kSecondaryColor.withOpacity(0.1),
                      toggleBorder: Border.all(
                        color: kPrimaryColor,
                        width: 2.0,
                      ),
                      borderRadius: 50.0,
                      value: continuePaymentWithThisAccount!,
                      onToggle: (val) {
                        setState(() {
                          continuePaymentWithThisAccount = !continuePaymentWithThisAccount!;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
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
                onPressed: () => Get.to(() => const PaymentSuccessful()),
                text: 'Make payment',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RecentCards extends StatelessWidget {
  RecentCards({
    Key? key,
    this.cardHolderName,
    this.lastFourDigits,
    this.balance,
    this.vendorType,
  }) : super(key: key);

  String? cardHolderName, lastFourDigits, balance, vendorType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315,
      margin: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: RadiusHandler.radius9,
        image: const DecorationImage(
          image: AssetImage(kDebitCardsBg),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            color: kSecondaryColor.withOpacity(0.3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyText(
            paddingTop: 10,
            paddingBottom: 20,
            text: '$cardHolderName',
            weight: FontWeight.w500,
            color: kPrimaryColor,
          ),
          MyText(
            text: '**** **** **** $lastFourDigits',
            weight: FontWeight.w500,
            size: 24,
            color: kPrimaryColor,
          ),
          MyText(
            text: 'Card Balance',
            weight: FontWeight.w500,
            color: kPrimaryColor,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: '\$$balance',
                  size: 21,
                  color: kPrimaryColor,
                  weight: FontWeight.w600,
                ),
                Image.asset(
                  vendorType!,
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentFields extends StatefulWidget {
  final String labelText, hintText;
  final bool? obSecure, haveSuffixIcon;
  final TextEditingController? controller;

  const PaymentFields({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.obSecure = false,
    this.haveSuffixIcon = false,
  }) : super(key: key);

  @override
  PaymentFieldsState createState() => PaymentFieldsState();
}

class PaymentFieldsState extends State<PaymentFields> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.labelText,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: RadiusHandler.radius10,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(2, 2),
                  blurRadius: 6,
                  color: kBlackColor.withOpacity(0.04),
                ),
              ],
            ),
            child: TextFormField(
              controller: widget.controller,
              style: const TextStyle(
                fontSize: 12,
              ),
              obscureText: widget.obSecure!,
              obscuringCharacter: "*",
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  fontSize: 12,
                ),
                enabledBorder: TextFieldStyling.noBorder,
                focusedBorder: TextFieldStyling.noBorder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
