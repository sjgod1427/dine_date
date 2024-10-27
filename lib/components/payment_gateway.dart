// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class RazorPayPage extends StatefulWidget {
//   const RazorPayPage({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return _RazorPayPageState();
//   }
// }

// class _RazorPayPageState extends State<RazorPayPage> {
//   late Razorpay _razorpay;
//   final _key = GlobalKey<FormState>();
//   TextEditingController amtController = TextEditingController();

//   void openCheckout(amount) async {
//     amount = amount * 100; // converting to smallest unit
//     var options = {
//       'key': 'rzp_test_1H7N6V5BGaX4W4',
//       'amount': amount,
//       'name': 'Foodie',
//       'prefill': {'contact': '1234567890', 'email': 'test@gmail.com'},
//       'external': {
//         'wallets': ['paytm']
//       }
//     };
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: $e'); // Provide detailed error message
//       Fluttertoast.showToast(msg: "Error: $e");
//     }
//   }

//   void handlePaymentSuccess(PaymentSuccessResponse response) {
//     Fluttertoast.showToast(
//         msg: "Payment Successful: ${response.paymentId}",
//         toastLength: Toast.LENGTH_SHORT);
//   }

//   void handlePaymentError(PaymentFailureResponse response) {
//     Fluttertoast.showToast(
//         msg: "Payment Failure: ${response.message}",
//         toastLength: Toast.LENGTH_SHORT);
//   }

//   void handleExternalWallet(ExternalWalletResponse response) {
//     Fluttertoast.showToast(
//         msg: "External Wallet: ${response.walletName}",
//         toastLength: Toast.LENGTH_SHORT);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _razorpay.clear();
//   }

//   @override
//   void initState() {
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext build) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 100),
//             Image.network(
//               'https://img.freepik.com/premium-vector/carrying-love_67813-7202.jpg?w=740',
//               width: 300,
//             ),
//             SizedBox(height: 10),
//             Text(
//               "Welcome To Razorpay Payment Gateway Integration",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 30),
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: TextFormField(
//                 cursorColor: Theme.of(context).colorScheme.secondary,
//                 autofocus: false,
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   labelText: "Enter Amount to be paid",
//                   labelStyle: TextStyle(
//                     fontSize: 15,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white, width: 1.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.tertiary,
//                       width: 1.0,
//                     ),
//                   ),
//                   errorStyle: TextStyle(color: Colors.red, fontSize: 15),
//                 ),
//                 controller: amtController,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "Please enter amount to be paid";
//                   }
//                   return null;
//                 },
//               ),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 if (amtController.text.toString().isNotEmpty) {
//                   setState(() {
//                     int amount = int.parse(amtController.text.toString());
//                     openCheckout(amount);
//                   });
//                 }
//               },
//               child: Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text("Make Payment"),
//               ),
//               style: ElevatedButton.styleFrom(
//                 iconColor: Theme.of(context).colorScheme.primary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/**
 * A widget that handles payment processing using Razorpay.
 *
 * This widget takes in a [tier] parameter, which determines the payment amount,
 * and an [onPaymentSuccess] callback, which is called when the payment is successful.
 *
 * Example:
 * dart
 * PaymentPage(tier: 2, onPaymentSuccess: () {
 *   // Handle payment success
 * });
 * 
 */
class PaymentPage extends StatefulWidget {
  final int tier;
  final VoidCallback onPaymentSuccess;

  const PaymentPage(
      {super.key, required this.tier, required this.onPaymentSuccess});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }

  /**
   * Opens the Razorpay checkout page with the specified options.
   *
   * The options include the API key, amount, name, description, and prefill information.
   */
  void openCheckout() async {
    var options = {
      'key': 'rzp_test_p0PvIeIspLOToG',
      'amount': widget.tier == 1
          ? 0
          : widget.tier == 2
              ? 29900
              : 59900,
      'name': 'FOODIE',
      'description':
          'Payment for ${widget.tier == 1 ? 'Basic' : widget.tier == 2 ? 'Regular' : 'Premium'} Plan',
      'prefill': {'contact': '9999999999', 'email': 'john@razorpay.com'},
      'external': {
        'wallets': ['paytm', 'phonepe', 'gpay']
      }
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /**
   * Handles payment success response from Razorpay.
   *
   * Shows a toast message with the payment ID and calls the [onPaymentSuccess] callback.
   */
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Successful: ${response.paymentId}",
        timeInSecForIosWeb: 4);
    widget.onPaymentSuccess();
  }

  /**
   * Handles payment error response from Razorpay.
   *
   * Shows a toast message with the error code and message.
   */
  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Error: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
  }

  /**
   * Handles external wallet response from Razorpay.
   *
   * Shows a toast message with the wallet name.
   */
  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallet: ${response.walletName}", timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue.shade900),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Payment',
            style: TextStyle(fontSize: 22.0, color: Color(0xFF545D68))),
      ),
      body: Column(children: [
        const SizedBox(height: 16.0),
        Image.network(
          'https://img.freepik.com/premium-vector/carrying-love_67813-7202.jpg?w=740',
          width: 300,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                        widget.tier == 1
                            ? 'Free'
                            : widget.tier == 2
                                ? '₹299'
                                : '₹599',
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900)),
                    const SizedBox(height: 5),
                    Text(
                        widget.tier == 1
                            ? 'Basic Plan'
                            : widget.tier == 2
                                ? 'Regular Plan'
                                : 'Premium Plan',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 18.0)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18.0),
        InkWell(
            onTap: () {
              openCheckout();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: Container(
                  width: MediaQuery.of(context).size.width - 60.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.blue.shade900),
                  child: Center(
                      child: Text('Proceed to Payment',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue.shade50)))),
            ))
      ]),
    );
  }
}
