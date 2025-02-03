import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> products = [
    {
      'image': 'lib/assets/mancuerna.png',
      'title': 'Mancuerna 7,5kg',
      'description': 'Ideales para quienes buscan entrenar fuerza, tonificar sus músculos o mejorar su resistencia física.',
      'price': 20
    },
    {
      'image': 'lib/assets/proteina.png',
      'title': 'Proteína Whey',
      'description': 'Suplemento dietético de alta calidad diseñado para apoyar la recuperación muscular, el desarrollo de masa muscular magra y la mejora del rendimiento físico.',
      'price': 59
    },
  ];

  List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      int index = cart.indexWhere((item) => item['title'] == product['title']);
      if (index != -1) {
        cart[index]['quantity'] += 1;
      } else {
        cart.add({...product, 'quantity': 1});
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['title']} añadido al carrito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) =>
              IconButton(
                icon: Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        title: Text(
          'ACTIVEBLEND',
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
              // Implementar funcionalidad de búsqueda
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
            onPressed: () {
              Navigator.pushNamed(context, '/carrito');
            },
          ),
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
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.set_meal),
              title: Text('Alimentación'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/alimentacion');
              },
            ),
            ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text('Material'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/material');
              },
            ),
            ListTile(
              leading: Icon(Icons.checkroom),
              title: Text('Ropa Deportiva'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/ropaDeportiva');
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Sobre Nosotros'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/sobreNosotros'); // Navega a la pantalla de Sobre Nosotros
              },
            ),

          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Botones de categorías
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/alimentacion');
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/alimentacion.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/material');
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/material.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/ropaDeportiva');
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/banner_ropa.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Botón a Ofertas
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/ofertas');
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_offer, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'OFERTA ESPECIAL',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Lista de productos
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.asset(
                        product['image'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        product['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(product['description']),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${product['price']}€'),
                          IconButton(
                            icon: Icon(Icons.add_shopping_cart),
                            onPressed: () => addToCart(product),
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
      ),
    );
  }
}