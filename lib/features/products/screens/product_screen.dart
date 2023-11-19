import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_track_mobile/features/cart/screens/cart_screen.dart';
import 'package:trash_track_mobile/features/cart/services/cart_service.dart';
import 'package:trash_track_mobile/features/products/models/product.dart';
import 'package:trash_track_mobile/features/products/services/product_service.dart';
import 'package:trash_track_mobile/shared/widgets/paging_component.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({
    Key? key,
    this.product,
  }) : super(key: key);
  final Product? product;

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late ProductService _modelProvider;
  late CartProvider cartProvider;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<Product> _products = [];
  List<Product> _recommendedProducts = [];
  int? userId;

  int _currentPage = 1;
  int _itemsPerPage = 2;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _modelProvider = context.read<ProductService>();
    cartProvider = context.read<CartProvider>();
    _initialValue = {
      'id': widget.product?.id.toString(),
      'name': widget.product?.name,
      'description': widget.product?.description,
      'code': widget.product?.code,
      'photo': widget.product?.photo,
      'price': widget.product?.price,
      'type': widget.product?.type.toString(),
    };
    // _fetchUserIdFromToken();
    _loadPagedProducts();
    _fetchUserIdAndLoadRecommendedProducts();
  }

  Future<void> _fetchUserIdAndLoadRecommendedProducts() async {
    await _fetchUserIdFromToken(); // Wait for userId to be fetched
    _loadRecommendedProducts(
        userId!); // After userId is fetched, load schedules
  }

  Future<void> _fetchUserIdFromToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      final userIdString = decodedToken['Id']; // Extract the ID as a string

      if (userIdString != null) {
        // Convert the string to an integer
        setState(() {
          userId = int.tryParse(
              userIdString); // Use tryParse to handle invalid inputs
        });
      }
    }
  }

  Future<void> _loadRecommendedProducts(int userId) async {
    try {
      final recommendedProducts = await _modelProvider.Recommend(userId);

      setState(() {
        _recommendedProducts = recommendedProducts;
        _totalRecords = _products.length + 1 + _recommendedProducts.length;
        _isLoading = false;
      });
    } catch (error) {
      print('Error loading recommended products: $error');
    }
  }

  Future<void> _loadPagedProducts() async {
    try {
      final models = await _modelProvider.getPaged(
        filter: {
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _products = models.items;
        _totalRecords = _products.length + 1 + _recommendedProducts.length;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadPagedProducts();
  }

  String getProductTypeString(ProductType? productType) {
    if (productType == null) {
      return 'Unknown';
    }
    switch (productType) {
      case ProductType.trashBin:
        return 'Trash Bin';
      case ProductType.trashBag:
        return 'Trash Bag';
      case ProductType.protectiveGear:
        return 'Protective Gear';
      default:
        return 'Unknown';
    }
  }

  Widget _buildPhotoWidget(Product product) {
    if (product.photo! != null) {
      final imageBytes = base64.decode(product.photo!);
      return Container(
        width: 100,
        height: 100,
        child: Image.memory(
          Uint8List.fromList(imageBytes),
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Text('No Photo Available');
    }
  }

  void _addToCart(Product product) {
    cartProvider.addToCart(product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => CartScreen()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _totalRecords,
                      itemBuilder: (context, index) {
                        if (index < _products.length) {
                          // Regular product card
                          final product = _products[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPhotoWidget(
                                      product), // Place the photo widget first
                                  SizedBox(
                                      width:
                                          16), // Add some space between the photo and text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name: ${product.name ?? ''}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                            'Type: ${getProductTypeString(product.type)}'),
                                        SizedBox(
                                            height:
                                                16), // Increase space between type and photo
                                        Text(
                                            'Price: ${product.price.toString() ?? ''}'),
                                        SizedBox(height: 8),
                                        Text(
                                            'Description: ${product.description ?? ''}'),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            _addToCart(product);
                                          },
                                          child: Text('Add to cart'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (index == _products.length) {
                          // Display a separator or section header
                          return SizedBox(
                              height: 20); // Adjust the height as needed
                        } else {
                          // Recommended product card
                          final recommendedProductIndex =
                              index - _products.length - 1;
                          final recommendedProduct =
                              _recommendedProducts[recommendedProductIndex];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPhotoWidget(
                                      recommendedProduct), // Place the photo widget first
                                  SizedBox(
                                      width:
                                          16), // Add some space between the photo and text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name: ${recommendedProduct.name ?? ''}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                            'Type: ${getProductTypeString(recommendedProduct.type)}'),
                                        SizedBox(
                                            height:
                                                16), // Increase space between type and photo
                                        Text(
                                            'Price: ${recommendedProduct.price.toString() ?? ''}'),
                                        SizedBox(height: 8),
                                        Text(
                                            'Description: ${recommendedProduct.description ?? ''}'),
                                        SizedBox(height: 10),
                                        Text(
                                          'Recommended Product',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            _addToCart(recommendedProduct);
                                          },
                                          child: Text('Add to cart'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: PagingComponent(
        currentPage: _currentPage,
        itemsPerPage: _itemsPerPage,
        totalRecords: _totalRecords,
        onPageChange: _handlePageChange,
      ),
    );
  }
}
