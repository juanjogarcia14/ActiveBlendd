import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';

class CarritoScreen extends StatefulWidget {
  @override
  _CarritoScreenState createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  void aumentarCantidad(int index, List<Map<String, dynamic>> cart) {
    setState(() {
      cart[index]['quantity'] += 1;
    });
  }

  void disminuirCantidad(int index, List<Map<String, dynamic>> cart) {
    setState(() {
      if (cart[index]['quantity'] > 1) {
        cart[index]['quantity'] -= 1;
      }
    });
  }

  void eliminarProducto(int index, List<Map<String, dynamic>> cart) {
    setState(() {
      cart.removeAt(index);
    });
  }

  void vaciarCarrito(List<Map<String, dynamic>> cart) {
    setState(() {
      cart.clear();
    });
  }

  double calcularTotal(List<Map<String, dynamic>> cart) {
    return cart.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<ProductProvider>(context).cart;

    return Scaffold(
      appBar: AppBar(
        title: Text("Carrito", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = cart[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                              Text("Precio: ${item['price'].toStringAsFixed(2)}€"),
                              Text("Total: ${(item['price'] * item['quantity']).toStringAsFixed(2)}€"),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: () => disminuirCantidad(index, cart),
                            ),
                            Text(item['quantity'].toString()),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () => aumentarCantidad(index, cart),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => eliminarProducto(index, cart),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              children: [
                Text("Total: ${calcularTotal(cart).toStringAsFixed(2)}€",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.delete_outline),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.grey.shade700,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: cart.isEmpty ? null : () => vaciarCarrito(cart),
                        label: Text("Vaciar carrito"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.lock_outline),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF2ebb79), // verde ActiveBlend
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: cart.isEmpty ? null : () {
                          // Acción de compra
                        },
                        label: Text("Finalizar compra"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
