import 'package:flutter/material.dart';
import 'package:giaydep_app/model/product.dart';
 // Import your product model here

class CartScreen extends StatefulWidget {
  final List<Product> cartItems;

  CartScreen({required this.cartItems});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          final product = widget.cartItems[index];
          return ListTile(
            leading: Image.network(
              product.image, // Assuming 'image' is the URL of the product image
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(product.name),
            subtitle: Text('${product.price}'), // Assuming 'price' is the price of the product
            trailing: IconButton(
              icon: Icon(Icons.remove_shopping_cart),
              onPressed: () {
                // Remove product from cart
                setState(() {
                  widget.cartItems.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate back to shopping page
                  Navigator.pop(context);
                },
                child: Text('Tiếp tục mua sắm'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Proceed to checkout
                  // Implement your checkout logic here
                },
                child: Text('Thanh toán'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
