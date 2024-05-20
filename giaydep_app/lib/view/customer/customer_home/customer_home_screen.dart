import 'package:flutter/material.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:giaydep_app/main.dart';
import 'package:giaydep_app/utils/image_path.dart';
import 'package:giaydep_app/view/customer/cart/cart_screen.dart';

import '../../../model/product.dart';
import '../../../model/status.dart';
import '../../../utils/common_func.dart';
import '../../../viewmodel/product_viewmodel.dart';
import '../../common_view/product_item_customer_view.dart';

class CustomerHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomerHomeScreen();
}

class _CustomerHomeScreen extends State<CustomerHomeScreen> {
  ProductViewModel productViewModel = ProductViewModel();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      productViewModel.getAllProduct();
      productViewModel.getProductStream.listen((status) {
        if (status == Status.loading) {
        } else if (status == Status.completed) {
          if (mounted) {
            reloadView();
          }
        } else {}
      });
    });
  }

  void reloadView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          child: Image.asset(
            ImagePath.imgLogo,
          ),
        ),
        title: Text('Coffee-shop'),
        actions: [
          IconButton(
            onPressed: () {
              CommonFunc.goToProfileScreen();
            },
            icon: Icon(
              Icons.account_circle_rounded,
              color: Colors.brown,
            ),
          ),
        ],
      ),
      body: ContainedTabBarView(
        tabBarProperties: TabBarProperties(
          indicatorColor: Colors.blue,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
        ),
        tabs: [
          Text("Cà phê"),
          Text("Trà Sữa"),
          Text("Nước ép"),
          Text("Soda"),
          Text("Khác"),
        ],
        views: [
          buildTabView(productViewModel.listCaPhe),
          buildTabView(productViewModel.listTraSua),
          buildTabView(productViewModel.listNuocEp),
          buildTabView(productViewModel.listSoda),
          buildTabView(productViewModel.listKhac),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              goToCartScreen();
            },
            child: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTabView(List<Product> products) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductItemCustomerView(product: products[index]);
      },
    );
  }

  static void goToCartScreen() {
    Navigator.push(
      navigationKey.currentContext!,
      MaterialPageRoute(builder: (context) => CartScreen()),
    );
  }
}
