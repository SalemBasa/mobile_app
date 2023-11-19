import 'package:trash_track_mobile/features/products/models/product.dart';
import 'package:trash_track_mobile/shared/services/base_service.dart';

class ProductService extends BaseService<Product> {
  ProductService() : super("Products"); 

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}