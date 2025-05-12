import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';

class FavoritosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final favorites = provider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: favorites.isEmpty
          ? Center(child: Text('No tienes productos favoritos.'))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final product = favorites[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Image.network(
                product['imageUrl'],
                width: 80,
                height: 80,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image),
              ),
              title: Text(product['title'] ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${product['price']}€'),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () => provider.addToCart(product),
              ),
            ),
          );
        },
      ),
      floatingActionButton: favorites.isNotEmpty
          ? FloatingActionButton.extended(
        onPressed: () {
          provider.clearFavorites();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Favoritos eliminados')),
          );
        },
        icon: Icon(Icons.delete),
        label: Text('Borrar todos'),
        backgroundColor: Colors.redAccent,
      )
          : null,
    );
  }
}
