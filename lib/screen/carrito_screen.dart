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
    return cart.fold(0, (sum, item) {
      return sum + ((item['price'] ?? 0) * (item['quantity'] ?? 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<ProductProvider>(context).cart;

    return Scaffold(
      appBar: AppBar(title: Text('Carrito')),
      body: cart.isEmpty
          ? Center(child: Text('Tu carrito está vacío'))
          : SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: cart.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = cart[index];
                return Card(
                  margin:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        item['imageUrl'] != null
                            ? Image.network(
                          item['imageUrl'],
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image),
                        )
                            : Icon(Icons.image_not_supported, size: 60),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] ?? 'Producto sin nombre',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text('Precio: ${item['price']?.toString() ?? '0'}€'),
                              Text(
                                'Total: ${(item['price'] * item['quantity']).toStringAsFixed(2)}€',
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () => disminuirCantidad(index, cart),
                                ),
                                Text('${item['quantity'] ?? 1}'),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () => aumentarCantidad(index, cart),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => eliminarProducto(index, cart),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Total: ${calcularTotal(cart).toStringAsFixed(2)}€',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => vaciarCarrito(cart),
                    icon: Icon(Icons.remove_shopping_cart, color: Colors.white),
                    label: Text('Vaciar carrito', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('¡Gracias por tu compra!'),
                          content: Text(
                              'Tu pedido ha sido procesado correctamente.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                cart.clear();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('Cerrar'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.shopping_bag, color: Colors.white),
                    label: Text('Finalizar compra', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00796B),
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
