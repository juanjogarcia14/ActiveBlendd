// Importaciones
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'carrito_screen.dart';
import 'favoritos_screen.dart';
import 'product_provider.dart';
import 'package:activeblendd/widgets/producto_search_delegate.dart';

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
    final snapshot = await FirebaseFirestore.instance.collection('Material').get();
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

  Future<List<Map<String, dynamic>>> cargarTodosLosProductos() async {
    final colecciones = ['Alimentacion', 'Material', 'Ropa', 'ofertas', 'productos'];
    List<Map<String, dynamic>> todos = [];
    for (String col in colecciones) {
      final snapshot = await FirebaseFirestore.instance.collection(col).get();
      final productos = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'title': data['nombre'] ?? '',
          'description': data['descripcion'] ?? '',
          'price': data['precio'] ?? 0,
          'imageUrl': data['imagen'] ?? '',
        };
      }).toList();
      todos.addAll(productos);
    }
    return todos;
  }

  void navigateTo(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text('MATERIALES', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () async {
              final productos = await cargarTodosLosProductos();
              if (productos.isNotEmpty) {
                showSearch(context: context, delegate: ProductoSearchDelegate(productos));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se encontraron productos')));
              }
            },
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
                      child: Text('${provider.cart.length}', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  )
              ],
            ),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => CarritoScreen()));
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
              decoration: BoxDecoration(color: Color(0xFFA8E6DB)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hola', style: TextStyle(color: Color(0xFF00796B), fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text(user?.email ?? 'Sin sesión activa', style: TextStyle(color: Colors.black87, fontSize: 16)),
                ],
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Home'), onTap: () => navigateTo('/home')),
            ListTile(leading: Icon(Icons.set_meal), title: Text('Alimentación'), onTap: () => navigateTo('/alimentacion')),
            ListTile(leading: Icon(Icons.fitness_center), title: Text('Material'), onTap: () => navigateTo('/material')),
            ListTile(leading: Icon(Icons.checkroom), title: Text('Ropa Deportiva'), onTap: () => navigateTo('/ropaDeportiva')),
            ListTile(leading: Icon(Icons.info), title: Text('Sobre Nosotros'), onTap: () => navigateTo('/sobreNosotros')),
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('lib/assets/banner_material.png', fit: BoxFit.cover, width: double.infinity),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final product = products[index];
                final isFav = provider.favorites.any((item) => item['title'] == product['title']);
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            product['imageUrl'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['description'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(product['title']),
                                        content: Text(product['description']),
                                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Cerrar'))],
                                      ),
                                    ),
                                    child: Text('Ver más', style: TextStyle(color: Colors.blue, fontSize: 13)),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${product['price']}€', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey),
                                        onPressed: () => provider.toggleFavorite(product),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add_shopping_cart, color: Colors.grey[800]),
                                        onPressed: () => provider.addToCart(product),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              childCount: products.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 24,
              child: Image.asset('lib/assets/logo_ab.png', fit: BoxFit.contain),
            ),
            label: 'Aciveblend',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritosScreen()));
          }
        },
      ),
    );
  }
}
