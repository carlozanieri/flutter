import 'package:flutter/material.dart';
import 'api_service.dart';
import 'slider_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<SliderModel>> futureSliders;

  @override
  void initState() {
    super.initState();
    futureSliders = ApiService().fetchSliders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Casa Baldini")),
      body: FutureBuilder<List<SliderModel>>(
        future: futureSliders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Errore: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                return ListTile(
                  // Il parametro 'leading' serve per mettere l'immagine a sinistra
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "http://json.casabaldini.eu/static/img/index/${item.immagineUrl}",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                  title: Text(item.titolo),
                  subtitle: Text(item.caption),
                );
              },
            );
          }
          return const Center(child: Text("Nessun dato"));
        },
      ),
    );
  }
}
