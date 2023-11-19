import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_mobile/features/cart/services/cart_service.dart';
import 'package:trash_track_mobile/features/order/services/order_service.dart';
import 'package:trash_track_mobile/features/products/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_track_mobile/features/products/screens/product_screen.dart';

class CartScreen extends StatelessWidget {
  List<Product> _cartProducts = [];
  double total = 0;

  Future<int?> _fetchUserIdFromToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      final userIdString = decodedToken['Id'];

      if (userIdString != null) {
        return int.tryParse(userIdString);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: _fetchUserIdFromToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final userId = snapshot.data;
          final cartProvider = context.watch<CartProvider>();
          final orderService = context.watch<OrderService>();

          total = 0;

          cartProvider.cart.items.forEach((element) {
            total += (element.product!.price ?? 0.0) * element.count;
          });

          return WillPopScope(
            onWillPop: () async {
              // Handle back button press
              Navigator.pop(context);
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('Cart'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProvider.cart.items.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartProvider.cart.items[index];
                        _cartProducts.add(cartItem.product);
                        return Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(cartItem.product.name!),
                            subtitle: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  child: Image.memory(
                                    Uint8List.fromList(
                                        base64.decode(cartItem.product.photo!)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Count: ${cartItem.count}'),
                                    Text('Price: ${cartItem.product.price}'),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  onPressed: () {
                                    cartProvider
                                        .removeFromCart(cartItem.product);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Total Price: \$${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => UsePaypal(
                            sandboxMode: true,
                            clientId:
                                'AZgXMnT0IYIilyF0A4tYews5fwMHNdXwyXjij8tn2KMxd3h33flvR9vOXEHtQwQyy8roESreLH9pKvjy',
                            secretKey:
                                'EHiN3B3Zuy-vcM8ub36N64_FWVRLPyo4WRj0CNA9JaKnSenTWg8617fQWEaX4D1-9fXIO6MJQF8wFMcQ',
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: [
                              {
                                "amount": {
                                  "total": total,
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": total,
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                    "The payment transaction description.",
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "Service payment",
                                      "quantity": 1,
                                      "price": total,
                                      "currency": "USD"
                                    }
                                  ],
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              final List<Map<String, int?>> _products =
                                  _cartProducts.map((product) {
                                return {
                                  "ProductId": product.id,
                                };
                              }).toList();

                              final newOrder = {
                                'orderDate': DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()),
                                'userId': userId,
                                'orderDetails': _products
                              };

                              try {
                                await orderService.insert(newOrder);
                                print('Order successfully created');
                              } catch (error) {
                                print('Error creating order: $error');
                              }
                            },
                            onError: (error) {},
                            onCancel: (params) {
                              print('cancelled: $params');
                            },
                          ),
                        ),
                      )
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        const Text('Buy'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF49464E),
                      minimumSize: Size(400, 48),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          // Show a loading indicator or some other UI while waiting for the result
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}