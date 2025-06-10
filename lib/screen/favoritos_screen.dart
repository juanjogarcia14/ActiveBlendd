import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';

class FavoritosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final favorites = provider.favorites;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Favoritos', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          if (favorites.isNotEmpty)
            TextButton(
              onPressed: () {
                provider.clearFavorites();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Favoritos eliminados')),
                );
              },
              child: Row(
                children: [
                  Text(
                    'Borrar favoritos',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.delete, color: Colors.redAccent),
                ],
              ),
            ),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
        child: Text(
          'No tienes productos favoritos.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final product = favorites[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product['imageUrl'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['title'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${product['price']}€',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () => provider.addToCart(product),
                    color: Colors.black87,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () {
                      provider.removeFromFavorites(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Producto eliminado de favoritos',
                          ),
                        ),
                      );
                    },
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
