import 'package:flutter/material.dart';
import 'package:casabaldini/api_service.dart';

class DoveMangiarePage extends StatelessWidget {
  const DoveMangiarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16.0),
      color: Colors.black87,

      child: Column(
        children: [
          Text(
            "Dove Mangiare",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.white24),
          Expanded(
            child: FutureBuilder<List>(
              future: fetchFoods(), // La funzione creata sopra
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Errore: ${snapshot.error}",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nessun ristorante trovato",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final f = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Immagine ristorante
                          Image.network(
                            "https://json.casabaldini.eu/static/img/ristoranti/${f.img}",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 15),
                          // Dettagli testo
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  f.titolo,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "➡️ ${f.indirizzo}",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  "📞 ${f.telefono}",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  "🚶‍♀️ A piedi: ${f.apiedi}",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CHIUDI"),
          ),
        ],
      ),
    );
  }
}
