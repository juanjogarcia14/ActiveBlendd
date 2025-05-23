import 'package:flutter/material.dart';

class ProductoSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> productos;

  ProductoSearchDelegate(this.productos);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final resultados = productos
        .where((producto) =>
        producto['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: resultados.length,
      itemBuilder: (context, index) {
        final producto = resultados[index];
        return ListTile(
          title: Text(producto['title']),
          subtitle: Text(producto['description']),
          trailing: Text('${producto['price']}€'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
