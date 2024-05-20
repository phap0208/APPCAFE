import 'dart:async';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:giaydep_app/model/shoe_type.dart';
import 'package:rxdart/rxdart.dart';

import '../base/baseviewmodel/base_viewmodel.dart';
import '../data/repositories/product_repo/product_repo.dart';
import '../data/repositories/product_repo/product_repo_impl.dart';
import '../model/product.dart';
import '../model/roles_type.dart';
import '../model/status.dart';
import '../utils/common_func.dart';
import 'notification_viewmodel.dart';

class ProductViewModel extends BaseViewModel {
  static final ProductViewModel _instance = ProductViewModel._internal();


  factory ProductViewModel() {
    return _instance;
  }

  ProductViewModel._internal();

  ProductRepo productRepo = ProductRepoImpl();

  RolesType rolesType = RolesType.none;

  List<Product> listFeaturedProducts = []; // Danh sách sản phẩm nổi bật
  List<Product> products = [];
  List<Product> listCaPhe = [];
  List<Product> listTraSua = [];
  List<Product> listNuocEp = [];
  List<Product> listSoda = [];
  List<Product> listKhac = [];

  final StreamController<Status> getProductController =
  BehaviorSubject<Status>();

  Stream<Status> get getProductStream => getProductController.stream;

  @override
  FutureOr<void> init() {}

  onRolesChanged(RolesType rolesType) {
    this.rolesType = rolesType;
    notifyListeners();
  }

  Future<void> getAllProduct() async {
    products.clear();
    getProductController.sink.add(Status.loading);
    EasyLoading.show();
    productRepo.getAllProduct().then((value) {
      if (value.isNotEmpty) {
        products = value;
        // Lấy danh sách sản phẩm nổi bật
        listFeaturedProducts = getFeaturedProducts();
        // Filter sản phẩm theo loại
        filterProductByType();
        notifyListeners();
        getProductController.sink.add(Status.completed);
      }
      EasyLoading.dismiss();
    }).onError((error, stackTrace) {
      print("get senda error:${error.toString()}");
      getProductController.sink.add(Status.error);
      EasyLoading.dismiss();
    });
  }

  Future<void> addProduct(
      {required Product product, required File? imageFile}) async {
    await productRepo
        .addProduct(product: product, imageFile: imageFile)
        .then((value) async {
      if (value == true) {
        CommonFunc.showToast("Thêm thành công.");
        await getAllProduct();
        NotificationViewModel().newProductNotification();
      }
    }).onError((error, stackTrace) {
      print("add fail");
    });
  }

  Future<void> updateProduct(
      {required Product product, required File? imageFile}) async {
    await productRepo
        .updateProduct(product: product, imageFile: imageFile)
        .then((value) async {
      if (value == true) {
        CommonFunc.showToast("Cập nhật thành công.");
        await getAllProduct();
      }
    }).onError((error, stackTrace) {
      print("update fail");
    });
  }

  void deleteProduct({required String productId}) {
    productRepo.deleteProduct(productId: productId).then((value) {
      if (value == true) {
        CommonFunc.showToast("Xóa thành công.");
        //reload product
        getAllProduct();
      }
    }).onError((error, stackTrace) {
      print("add fail");
    });
  }

  // Phương thức để lấy danh sách sản phẩm nổi bật
  List<Product> getFeaturedProducts() {
    // Thực hiện logic để lấy danh sách sản phẩm nổi bật từ nguồn dữ liệu của bạn
    // Ví dụ:
    // return products.where((product) => product.isFeatured).toList();
    return []; // Trả về danh sách rỗng mặc định
  }

  void clearAllList() {
    listCaPhe.clear();
    listTraSua.clear();
    listNuocEp.clear();
    listSoda.clear();
    listKhac.clear();
  }

  void filterProductByType() {
    clearAllList();

    for (var element in products) {
      if (element.type == ShoeType.ca_phe.toShortString()) {
        listCaPhe.add(element);
      } else if (element.type == ShoeType.tra_sua.toShortString()) {
        listTraSua.add(element);
      } else if (element.type == ShoeType.nuoc_ep.toShortString()) {
        listNuocEp.add(element);
      } else if (element.type == ShoeType.soda.toShortString()) {
        listSoda.add(element);
      } else {
        listKhac.add(element);
      }
    }
  }
}
