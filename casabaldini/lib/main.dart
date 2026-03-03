import 'package:flutter/material.dart';
import 'api_service.dart';
import 'slider_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  int _current = 0; // Tiene traccia della foto visualizzata
  final CarouselSliderController _controller = CarouselSliderController();
  @override
  void initState() {
    super.initState();
    futureSliders = ApiService().fetchSliders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Casabaldini"),
        backgroundColor: Colors.blueGrey[900],
      ),
      // --- AGGIUNGI DA QUI ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey[900]),
              child: const Text(
                'Casabaldini Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context), // Chiude il menu
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Info'),
              onTap: () {
                // Qui potrai aggiungere una rotta per una pagina "Chi Siamo"
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<SliderModel>>(
        future: futureSliders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Errore: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(height: 20),
                CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 2.1,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index; // Aggiorna l'indice quando scorre
                      });
                    },
                  ),
                  carouselController: _controller,
                  items: snapshot.data!.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        // 1. Iniziamo con il GestureDetector per intercettare il tocco
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DettaglioSlider(item: item),
                              ),
                            );
                          },
                          // 2. Il Container (la tua foto) diventa il CHILD del GestureDetector
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                  "http://json.casabaldini.eu/static/img/index/${item.immagineUrl}",
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            // Se avevi del testo dentro il container (il titolo), lascialo pure qui
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                item.titolo,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: snapshot.data!.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(
                                0.6,
                              ), // Scurisce solo il fondo per far leggere il testo
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }
          return const Center(child: Text("Nessun dato"));
        },
      ),
    );
  }
}

class DettaglioSlider extends StatelessWidget {
  final SliderModel item; // Usa il nome della tua classe modello Rust/Dart

  const DettaglioSlider({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.titolo)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "http://json.casabaldini.eu/static/img/index/${item.immagineUrl}",
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.titolo,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.testo, // Il campo 'testo' che arriva dal DB Postgres
                    style: const TextStyle(fontSize: 18, height: 1.5),
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

class DetailPage extends StatelessWidget {
  final SliderModel item;
  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.titolo)),
      body: Column(
        children: [
          // Hero rende l'animazione fluida tra le pagine
          Hero(
            tag: item.id.toString(),
            child: Image.network(
              "http://json.casabaldini.eu/static/img/index/${item.immagineUrl}",
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(item.caption, style: const TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
