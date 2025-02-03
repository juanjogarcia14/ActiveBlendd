import 'package:flutter/material.dart';

class CarritoScreen extends StatefulWidget {
  @override
  _CarritoScreenState createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  List<Map<String, dynamic>> cart = [
    {
      'image': 'lib/assets/sudadera.png',
      'title': 'Sudadera Running',
      'price': 35,
      'quantity': 1,
    },
    {
      'image': 'lib/assets/zapatillas.png',
      'title': 'Deportivos Joma',
      'price': 40,
      'quantity': 2,
    },
  ];

  void incrementarCantidad(int index) {
    setState(() {
      cart[index]['quantity']++;
    });
  }

  void decrementarCantidad(int index) {
    setState(() {
      if (cart[index]['quantity'] > 1) {
        cart[index]['quantity']--;
      } else {
        cart.removeAt(index);
      }
    });
  }

  double calcularTotal() {
    return cart.fold(0, (total, item) => total + (item['price'] * item['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
        backgroundColor: Color(0xFF00796B),
      ),
      body: cart.isEmpty
          ? Center(
        child: Text(
          'Tu carrito está vacío',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final product = cart[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(
                product['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(product['title'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${product['price']}€'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => decrementarCantidad(index),
                  ),
                  Text('${product['quantity']}'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => incrementarCantidad(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Aquí puedes implementar la funcionalidad de pago o checkout
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Compra realizada con éxito')),
            );
            setState(() {
              cart.clear(); // Vaciar carrito después de la compra
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00796B),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            'Pagar ${calcularTotal().toStringAsFixed(2)}€',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
