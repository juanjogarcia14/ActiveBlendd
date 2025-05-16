import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SobreNosotrosScreen extends StatelessWidget {
  final String telefono = '630889000';
  final String ubicacionMaps = 'https://maps.app.goo.gl/jokchQCiYGbBF6qeA';

  void _abrirTelefono(BuildContext context) async {
    final Uri uri = Uri(scheme: 'tel', path: telefono);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Esta función solo está disponible en un dispositivo físico'),
        ),
      );
    }
  }

  void _abrirGoogleMaps(BuildContext context) async {
    final Uri uri = Uri.parse(ubicacionMaps);
    print('Intentando abrir: $uri');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color verdeMenta = Color(0xFFACE0D4);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Sobre Nosotros',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: verdeMenta),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/sobre_nosotros.png',
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              'ActiveBlend es una plataforma diseñada para los apasionados del deporte. Nuestra app está enfocada en ofrecerte lo mejor en ropa deportiva, material de entrenamiento y suplementación alimenticia para maximizar tu rendimiento.',
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _abrirGoogleMaps(context),
                    icon: Icon(Icons.location_on_rounded, color: Colors.white),
                    label: Text('Ir a ActiveBlend'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: verdeMenta,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _abrirTelefono(context),
                    icon: Icon(Icons.phone, color: Colors.white),
                    label: Text('Llámanos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: verdeMenta,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                expansionTileTheme: ExpansionTileThemeData(
                  iconColor: verdeMenta,
                  collapsedIconColor: verdeMenta,
                  textColor: Colors.black,
                  collapsedTextColor: Colors.black,
                ),
              ),
              child: Column(
                children: [
                  ExpansionTile(
                    title: Text('¿Qué tipo de productos ofrecemos?'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Ofrecemos ropa técnica, material de gimnasio y suplementos de alta calidad para deportistas de todos los niveles.',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: Text('¿Cuál es nuestro objetivo?'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Queremos brindar una experiencia deportiva completa y accesible a todos, fomentando un estilo de vida saludable y activo.',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: Text('¿Dónde estamos ubicados?'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Nos puedes encontrar en el centro deportivo ActiveBlend, cuya ubicación puedes consultar en Google Maps.',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: Text('¿Qué nos diferencia de otras tiendas deportivas?'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Nuestra atención personalizada, la calidad de nuestros productos y una comunidad activa que comparte la pasión por el deporte.',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: Text('¿Puedo comprar online o solo en tienda física?'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Puedes realizar tus compras tanto en nuestra app como en la tienda física. ¡Nos adaptamos a ti!',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
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
