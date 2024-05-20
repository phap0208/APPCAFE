import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giaydep_app/view/admin/product_management_screen.dart';
import 'package:giaydep_app/view/admin/sales_management_screen.dart';

import '../../utils/common_func.dart';
import '../customer/blogs/blogs_screen.dart';

class AdminRootScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdminRootScreen();
}

class _AdminRootScreen extends State<AdminRootScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    ProductManagementScreen(),
    SalesManagementScreen(),
    BlogsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void reloadView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white, // Đặt màu nền cho AppBar là màu trắng
          elevation: 0, // Remove shadow
          leading: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/admin.jpg', // Đường dẫn tới logo của bạn
                  width: 40, // Kích thước của logo
                  height: 40,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                CommonFunc.goToProfileScreen();
              },
              icon: const Icon(
                Icons.account_circle_rounded,
                color: Colors.brown,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(
            left: 0,
            top: MediaQuery
                .of(context)
                .padding
                .top + 20,
            right: 0,
            bottom: 0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.production_quantity_limits),
              label: 'Sản phẩm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.point_of_sale_rounded),
              label: 'Bán hàng',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add_rounded),
              label: 'Bài viết',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.lightBlue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
