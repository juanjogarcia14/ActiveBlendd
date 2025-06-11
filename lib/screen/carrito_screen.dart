import 'package:flutter/material.dart' as mat;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'product_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarritoScreen extends mat.StatefulWidget {
  @override
  _CarritoScreenState createState() => _CarritoScreenState();
}

class _CarritoScreenState extends mat.State<CarritoScreen> {
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

  Future<void> realizarPago(double total, List<Map<String, dynamic>> cart) async {
    try {
      print('Enviando POST a createPaymentIntent');

      final url = Uri.parse('http://10.0.2.2:5001/activeblendd-master-2/us-central1/createPaymentIntent');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': (total * 100).toInt()}),
      );

      final data = jsonDecode(response.body);
      print('Respuesta recibida: $data');

      final clientSecret = data['clientSecret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'ActiveBlend',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      mat.ScaffoldMessenger.of(context).showSnackBar(
        mat.SnackBar(content: mat.Text('✅ Pago completado con éxito')),
      );

      setState(() {
        cart.clear();
      });
    } catch (e) {
      print('❌ Error en el pago (HTTP): $e');
      mat.ScaffoldMessenger.of(context).showSnackBar(
        mat.SnackBar(content: mat.Text('❌ Error al procesar el pago')),
      );
    }
  }
  @override
  mat.Widget build(mat.BuildContext context) {
    final cart = Provider.of<ProductProvider>(context).cart;

    return mat.Scaffold(
      appBar: mat.AppBar(
        title: mat.Text("Carrito", style: mat.TextStyle(color: mat.Colors.black)),
        backgroundColor: mat.Colors.white,
        elevation: 1,
        iconTheme: mat.IconThemeData(color: mat.Colors.black),
      ),
      backgroundColor: mat.Colors.white,
      body: mat.Column(
        children: [
          mat.Expanded(
            child: mat.ListView.builder(
              itemCount: cart.length,
              padding: mat.EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = cart[index];
                final double precio = (item['price'] ?? 0).toDouble();
                final int cantidad = (item['quantity'] ?? 1).toInt();

                return mat.Card(
                  elevation: 4,
                  margin: mat.EdgeInsets.symmetric(vertical: 8),
                  shape: mat.RoundedRectangleBorder(
                    borderRadius: mat.BorderRadius.circular(16),
                  ),
                  color: mat.Colors.white,
                  child: mat.Padding(
                    padding: mat.EdgeInsets.all(12),
                    child: mat.Row(
                      children: [
                        mat.ClipRRect(
                          borderRadius: mat.BorderRadius.circular(12),
                          child: mat.Image.network(
                            item['imageUrl'] ?? '',
                            width: 60,
                            height: 60,
                            fit: mat.BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                mat.Icon(mat.Icons.broken_image),
                          ),
                        ),
                        mat.SizedBox(width: 12),
                        mat.Expanded(
                          child: mat.Column(
                            crossAxisAlignment: mat.CrossAxisAlignment.start,
                            children: [
                              mat.Text(item['title'] ?? '',
                                  style: mat.TextStyle(fontWeight: mat.FontWeight.bold)),
                              mat.Text("Precio: ${precio.toStringAsFixed(2)}€"),
                              mat.Text("Total: ${(precio * cantidad).toStringAsFixed(2)}€"),
                            ],
                          ),
                        ),
                        mat.Row(
                          children: [
                            mat.IconButton(
                              icon: mat.Icon(mat.Icons.remove_circle_outline),
                              onPressed: () => disminuirCantidad(index, cart),
                            ),
                            mat.Text(cantidad.toString()),
                            mat.IconButton(
                              icon: mat.Icon(mat.Icons.add_circle_outline),
                              onPressed: () => aumentarCantidad(index, cart),
                            ),
                            mat.IconButton(
                              icon: mat.Icon(mat.Icons.delete, color: mat.Colors.red),
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
          ),
          mat.Padding(
            padding: const mat.EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: mat.Column(
              children: [
                mat.Text("Total: ${calcularTotal(cart).toStringAsFixed(2)}€",
                    style: mat.TextStyle(fontSize: 18, fontWeight: mat.FontWeight.bold)),
                mat.SizedBox(height: 10),
                mat.Row(
                  children: [
                    mat.Expanded(
                      child: mat.ElevatedButton.icon(
                        icon: mat.Icon(mat.Icons.delete_outline),
                        style: mat.ElevatedButton.styleFrom(
                          foregroundColor: mat.Colors.white,
                          backgroundColor: mat.Colors.red,
                          shape: mat.RoundedRectangleBorder(
                              borderRadius: mat.BorderRadius.circular(12)),
                          padding: mat.EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: cart.isEmpty ? null : () => vaciarCarrito(cart),
                        label: mat.Text("Vaciar carrito"),
                      ),
                    ),
                    mat.SizedBox(width: 10),
                    mat.Expanded(
                      child: mat.ElevatedButton.icon(
                        icon: mat.Icon(mat.Icons.lock_outline),
                        style: mat.ElevatedButton.styleFrom(
                          foregroundColor: mat.Colors.white,
                          backgroundColor: mat.Color(0xFF2ebb79),
                          shape: mat.RoundedRectangleBorder(
                              borderRadius: mat.BorderRadius.circular(12)),
                          padding: mat.EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: cart.isEmpty
                            ? null
                            : () => realizarPago(calcularTotal(cart), cart),
                        label: mat.Text("Finalizar compra"),
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
