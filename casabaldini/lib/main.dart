import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'slider_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:casabaldini/models/menu_model.dart';
import 'package:casabaldini/models/link_utili_model.dart';
import 'package:casabaldini/pages/prenotazioni_page.dart';
import 'package:casabaldini/pages/dove_mangiare_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

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
  late Future<List> futureLinks;
  // --- AGGIUNTA PER IL MENU ---
  late Future<List<MenuEntry>> futureMenu;
  String sezioneAttiva = "index";
  String titoloPagina = "CasaBaldini";
  @override
  void initState() {
    super.initState();
    futureMenu = fetchMenu();
    // Usiamo la funzione passando "index" per riempire la variabile all'avvio
    futureSliders = fetchSliders("index");
    futureLinks = fetchLinks();
  }

  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titoloPagina),
        backgroundColor: Colors.blueGrey[900],
      ),
      // --- IL DRAWER VA QUI, COME PROPRIETÀ DELLO SCAFFOLD ---
      drawer: Drawer(
        child: FutureBuilder<List<MenuEntry>>(
          future: futureMenu, // <--- USA LA VARIABILE, NON LA FUNZIONE
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Errore: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("Nessun dato"));
            }

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blueGrey[900]),
                  child: const Text(
                    "Casabaldini",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                // Ciclo sui padri
                ...snapshot.data!.map((menuPadre) {
                  return ExpansionTile(
                    title: Text(
                      menuPadre.titolo,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: menuPadre.children.map((sub) {
                      return ListTile(
                        title: Text(sub.titolo),
                        onTap: () {
                          Navigator.pop(context);

                          if (sub.tipoPage == 'interna') {
                            // AGGIUNGI QUESTA RIGA QUI SOTTO:
                            aggiornaContenuto(sub.link, sub.titolo);
                          } else if (sub.tipoPage == 'modale') {
                            if (sub.link.contains('dovemangiare')) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => const DoveMangiarePage(),
                              );
                            } else if (sub.link.contains('prenotazioni')) {
                              {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      const PrenotazioniPage(),
                                );
                              }
                            }
                          }
                        },
                      );
                    }).toList(),
                  );
                }).toList(),
              ],
            );
          },
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
                                  "https://json.casabaldini.eu/static/img/${sezioneAttiva}/${item.immagineUrl}",
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
      bottomNavigationBar: FooterLinks(links: futureLinks),
    );
  }

  void aggiornaContenuto(String nuovaSezione, String nuovoTitolo) {
    setState(() {
      sezioneAttiva = nuovaSezione;
      titoloPagina = nuovoTitolo; // Aggiorniamo il titolo
      futureSliders = fetchSliders(nuovaSezione);
    });
  }
}

class FooterLinks extends StatelessWidget {
  final Future<List> links;

  const FooterLinks({super.key, required this.links});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.blueGrey[900],
      // Usiamo un SafeArea per evitare che sui telefoni nuovi i link finiscano sotto la "barretta" di sistema
      child: SafeArea(
        child: FutureBuilder<List>(
          future: links,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const SizedBox();
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              // Fondamentale: non serve shrinkWrap qui, e aggiungiamo physics per lo scorrimento
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final l = snapshot.data![index];
                return InkWell(
                  onTap: () => launchUrl(
                    Uri.parse(l.link),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          "https://json.casabaldini.eu/static/img/links/${l.img}",
                          height: 30,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.link,
                                color: Colors.white,
                                size: 20,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l.titolo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
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
              "https://json.casabaldini.eu/static/img/index/${item.immagineUrl}",
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
              "https://json.casabaldini.eu/static/img/index/${item.immagineUrl}",
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

// Questa è la FUNZIONE (il braccio che prende i dati)
Future<List<SliderModel>> fetchSliders(String dir) async {
  final response = await http.get(
    Uri.parse("https://json.casabaldini.eu/api/v1/slider?dir=$dir"),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => SliderModel.fromJson(data)).toList();
  } else {
    throw Exception('Errore caricamento slider');
  }
}

Future<List> fetchLinks() async {
  final response = await http.get(
    Uri.parse("https://json.casabaldini.eu/api/v1/links"),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => LinkUtile.fromJson(data)).toList();
  } else {
    throw Exception('Errore caricamento links');
  }
}
