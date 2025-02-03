import 'package:flutter/material.dart';
import 'carrito_screen.dart';

class RopaDeportivaScreen extends StatefulWidget {
  @override
  RopaDeportivaScreenState createState() => RopaDeportivaScreenState();
}

class RopaDeportivaScreenState extends State<RopaDeportivaScreen> {
  final List<Map<String, dynamic>> products = [
    {
      'image': 'lib/assets/sudadera.png',
      'title': 'Sudadera Running',
      'description': 'Sudadera ajustable para correr, con material transpirable.',
      'price': 35
    },
    {
      'image': 'lib/assets/zapatillas.png',
      'title': 'Deportivos Joma',
      'description': 'Zapatillas deportivas cómodas y duraderas, ideales para cualquier deporte.',
      'price': 40
    },
    {
      'image': 'lib/assets/chaqueta.png',
      'title': 'Chaqueta Sky',
      'description': 'Chaqueta deportiva con aislamiento térmico, perfecta para actividades al aire libre.',
      'price': 59
    },
    {
      'image': 'lib/assets/pantalon.png',
      'title': 'Pantalón Deportivo',
      'description': 'Pantalón cómodo y ligero, diseñado para entrenamientos intensos.',
      'price': 25
    },
    {
      'image': 'lib/assets/camiseta.png',
      'title': 'Camiseta Tirantes',
      'description': 'Fabricada con materiales duraderos, perfecta para rutinas de pesas.',
      'price': 5
    },
    {
      'image': 'lib/assets/gorra.png',
      'title': 'Gorra Deportiva',
      'description': 'Gorra ligera y transpirable, ideal para protegerte del sol mientras entrenas.',
      'price': 15
    },
    {
      'image': 'lib/assets/mochila.png',
      'title': 'Mochila Fitness',
      'description': 'Mochila espaciosa y resistente, perfecta para llevar tu equipo deportivo.',
      'price': 50
    },
  ];

  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> favorites = [];

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      if (!cart.any((item) => item['title'] == product['title'])) {
        cart.add({...product, 'quantity': 1});
      }
    });
  }

  void toggleFavorite(Map<String, dynamic> product) {
    setState(() {
      if (favorites.any((item) => item['title'] == product['title'])) {
        favorites.removeWhere((item) => item['title'] == product['title']);
      } else {
        favorites.add(product);
      }
    });
  }

  void navigateToCart() {
    Navigator.pushNamed(context, '/carrito');
  }

  void navigateTo(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
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
          'ROPA DEPORTIVA',
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
            onPressed: () {
              // Función del buscador
            },
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
            onPressed: navigateToCart,
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
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      'lib/assets/banner_ropa.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final product = products[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Image.asset(
                            product['image'],
                            height: 80,
                            width: 80,
                          ),
                          title: Text(product['title'], style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  favorites.any((item) => item['title'] == product['title'])
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () => toggleFavorite(product),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_shopping_cart),
                                onPressed: () => addToCart(product),
                              ),
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
          // Navegación entre pantallas
        },
      ),
    );
  }
}