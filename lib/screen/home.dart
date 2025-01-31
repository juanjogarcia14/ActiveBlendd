import 'package:flutter/material.dart';
import 'package:activeblendd/screen/alimentacionscreen.dart';
import 'package:activeblendd/screen/materialscreen.dart';
import 'package:activeblendd/screen/ropa_deportiva_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Product> products = [
    Product(imageUrl: "https://cdn-icons-png.flaticon.com/512/6073/6073873.png", screen: AlimentacionScreen()),
    Product(imageUrl: "https://cdn-icons-png.freepik.com/512/1077/1077063.png", screen: MaterialScreen()),
    Product(imageUrl: "https://cdn-icons-png.flaticon.com/512/6073/6073873.png", screen: RopaDeportivaScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tienda"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: products.map((product) => ProductCard(product: product)).toList(),
        ),
      ),
    );
  }
}

class Product {
  final String imageUrl;
  final Widget screen;

  Product({required this.imageUrl, required this.screen});
}

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => product.screen),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(product.imageUrl, fit: BoxFit.cover, width: 100, height: 100),
      ),
    );
  }
}
