import 'package:activeblendd/screen/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:activeblendd/screen/alimentacionscreen.dart';
import 'package:activeblendd/screen/materialscreen.dart';
import 'package:activeblendd/screen/ropa_deportiva_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'carrito_screen.dart';
import 'favoritos_screen.dart';


class home extends StatefulWidget {
  @override
  homeState createState() => homeState();
}

class homeState extends State<home> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }
  Future<void> cargarProductos() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ofertas') // ← Aquí apunta directamente a la colección 'Ropa'
        .get();

    final datos = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'title': data['nombre'],
        'description': data['descripcion'],
        'price': data['precio'],
        'imageUrl': data['imagen'],
      };
    }).toList();

    setState(() {
      products = datos;
    });
  }


  void navigateTo(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text(
          'ACTIVEBLEN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart, color: Colors.black),
                if (provider.cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${provider.cart.length}',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  )
              ],
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarritoScreen(),
                ),
              );
              setState(() {});
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFA8E6DB),
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Color(0xFF00796B),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                navigateTo('/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.set_meal),
              title: Text('Alimentación'),
              onTap: () {
                Navigator.pop(context);
                navigateTo('/alimentacion');
              },
            ),
            ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text('Material'),
              onTap: () {
                Navigator.pop(context);
                navigateTo('/material');
              },
            ),
            ListTile(
              leading: Icon(Icons.checkroom),
              title: Text('Ropa Deportiva'),
              onTap: () {
                Navigator.pop(context);
                navigateTo('/ropaDeportiva');
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Sobre Nosotros'),
              onTap: () {
                Navigator.pop(context);
                navigateTo('/sobreNosotros');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => navigateTo('/alimentacion'),
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/assets/logo.png',
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 8),
                        Text("Alimentación", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => navigateTo('/ropaDeportiva'),
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/assets/logo.png',
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 8),
                        Text("Ropa", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => navigateTo('/material'),
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/assets/logo.png',
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 8),
                        Text("Material", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: products.isEmpty
                ? Center(child: Text('No se encontraron productos.'))
                : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final isFav = provider.favorites.any((item) => item['title'] == product['title']);
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      product['imageUrl'],
                      height: 80,
                      width: 80,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                    ),
                    title: Text(product['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product['description']),
                        Text('${product['price']}€', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () => provider.toggleFavorite(product),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_shopping_cart),
                          onPressed: () => provider.addToCart(product),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritosScreen()),
            );
          }
        },
      ),
    );
  }
}
