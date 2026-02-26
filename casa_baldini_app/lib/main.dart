import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const CasaBaldiniApp());
}

// 1. IL MODELLO DATI (La tua struct Rust)
class LinkUtile {
  final int id;
  final String titolo;
  final String img;
  final String link;

  LinkUtile({
    required this.id,
    required this.titolo,
    required this.img,
    required this.link,
  });

  factory LinkUtile.fromJson(Map<String, dynamic> json) {
    return LinkUtile(
      id: json['id'] ?? 0,
      titolo: json['titolo'] ?? 'Senza titolo',
      img: json['img'] ?? '',
      link: json['link'] ?? '',
    );
  }
}

class CasaBaldiniApp extends StatelessWidget {
  const CasaBaldiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
      ),
      home: const LinkUtilePage(),
    );
  }
}

// 2. LA PAGINA CHE CARICA I DATI (Simile a use_resource)
class LinkUtilePage extends StatefulWidget {
  const LinkUtilePage({super.key});

  @override
  State<LinkUtilePage> createState() => _LinkUtilePageState();
}

class _LinkUtilePageState extends State<LinkUtilePage> {
  // Inserisci qui l'URL del tuo backend (es: Django o Rust API)
  final String apiUrl = "http://casabaldini.eu";

  Future<List<LinkUtile>> fetchLinks() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => LinkUtile.fromJson(data)).toList();
    } else {
      throw Exception('Errore nel caricamento dal server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Links Utili - Casa Baldini')),
      body: FutureBuilder<List<LinkUtile>>(
        future: fetchLinks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Errore: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nessun dato trovato"));
          }

          // 3. LA LISTA (L'interfaccia vera e propria)
          final links = snapshot.data!;
          return ListView.builder(
            itemCount: links.length,
            itemBuilder: (context, index) {
              final l = links[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://tuosito.it/assets/img/links/${l.img}",
                    ),
                  ),
                  title: Text(l.titolo),
                  subtitle: Text(l.link, style: const TextStyle(fontSize: 12)),
                  onTap: () {
                    // Qui potremo aggiungere l'apertura del browser
                    print("Cliccato su: ${l.link}");
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
