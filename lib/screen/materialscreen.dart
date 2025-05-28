import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'carrito_screen.dart';
import 'favoritos_screen.dart';
import 'product_provider.dart';

class MaterialScreen extends StatefulWidget {
  @override
  _MaterialScreenState createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Material')
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
    final cart = provider.cart;
    final favorites = provider.favorites;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
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
          'MATERIALES',
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
                if (cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${cart.length}',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hola',
                    style: TextStyle(
                      color: Color(0xFF00796B),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    user?.email ?? 'Sin sesión activa',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
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
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar sesión'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Image.asset(
              'lib/assets/logo_material.png',
              fit: BoxFit.cover,
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
                final isFav = favorites.any((item) => item['title'] == product['title']);
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Color(0xFFF0F0F0), // Tarjeta en gris claro
                  child: ListTile(
                    leading: Image.network(
                      product['imageUrl'],
                      height: 80,
                      width: 80,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                    ),
                    title: Text(
                      product['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product['description']),
                        Text(
                          '${product['price']}€',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 24,
              child: Image.asset('lib/assets/logo_ab.png'),
            ),
            label: 'Aciveblend',
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
