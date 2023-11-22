import 'package:bloc_products_api/product_bloc/products_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'Products.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ProductsBloc>(
        create: (BuildContext context) => ProductsBloc(),
      ),

    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Razorpay _razorpay;

  @override
  Widget build(BuildContext context) {
    context.read<ProductsBloc>().add(FetchEvent());
    return Scaffold(
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {

          return ListView.builder(
              itemCount: state.prolist?.length,
              itemBuilder: (BuildContext context, int index) {
                Products pro = state.prolist![index];
                return InkWell(
                  onTap:(){openCheckout(pro.price!.toInt(),pro.title);},
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Image.network("${pro.thumbnail}"),
                          ),
                          Text("${pro.description}"),
                          // Row(
                          //   children: [
                          //     Text("Status  - "),
                          //     Container(child: us.completed==true ? Icon(Icons.done): Icon(Icons.error)),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }


  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(int amt,String ?title) async {
    var options = {
      'key': 'rzp_live_ILgsfZCZoFIKMb',
      'amount': amt!*100,
      'name': 'Sandeep shop',
      'description': '${title}',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '9074858214', 'email': 'sandheepsponpulariyil@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    /*Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }

}

