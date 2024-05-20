import 'package:giaydep_app/model/shoe_type.dart';

class Product {
  String id = '';
  String name = '';
  String image = '';
  String description = '';
  double price = 0.0;
  String type = ShoeType.khac.toShortString();
  String uploadBy = '';
  String uploadDate = DateTime.now().toString();
  String editDate = DateTime.now().toString();
  bool isFeatured = false; // Thêm trường isFeatured để xác định sản phẩm nổi bật

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.type,
    required this.uploadBy,
    required this.uploadDate,
    required this.editDate,
    this.isFeatured = false, // Mặc định sản phẩm không phải là sản phẩm nổi bật
  });

  Product.empty() {
    id = '';
    name = '';
    image = '';
    description = '';
    price = 0.0;
    type = ShoeType.khac.toShortString();
    uploadBy = '';
    uploadDate = DateTime.now().toString();
    editDate = DateTime.now().toString();
    isFeatured = false; // Mặc định sản phẩm không phải là sản phẩm nổi bật
  }

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    price = json['price'];
    type = json['type'];
    uploadBy = json['uploadBy'];
    uploadDate = json['uploadDate'];
    editDate = json['editDate'];
    isFeatured = json['isFeatured'] ?? false; // Xác định sản phẩm nổi bật từ JSON
  }
}
