import 'package:flutter/material.dart';
import 'package:casabaldini/api_service.dart';

class DoveMangiarePage extends StatelessWidget {
  const DoveMangiarePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usiamo una variabile per l'altezza per chiarezza
    final double modalHeight = MediaQuery.of(context).size.height * 0.8;

    return Container(
      height: modalHeight,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        // fit: StackFit.expand assicura che lo stack non cerchi di ridimensionarsi continuamente
        fit: StackFit.expand,
        children: [
          // 1. SFONDO (Impostato per non gravare sul calcolo del layout)
          Image.asset("assets/bgblack.png", fit: BoxFit.cover),

          // 2. CONTENUTO
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize
                  .max, // La colonna occupa tutto lo spazio dello stack
              children: [
                const Text(
                  "Dove Mangiare",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: Colors.white24),

                // L'Expanded è vitale qui: dice alla lista di prendere SOLO lo spazio rimasto
                Expanded(
                  child: FutureBuilder<List>(
                    future: fetchFoods(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Errore",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "Nessun dato",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return ListView.builder(
                        // Aggiungiamo questa riga per rendere lo scroll più leggero
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final f = snapshot.data![index];
                          return Container(
                            // Usiamo Container invece di Padding per maggiore stabilità
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    "https://json.casabaldini.eu/static/img/ristoranti/${f.img}",
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    // Evitiamo che l'app si blocchi se l'immagine network fallisce
                                    errorBuilder: (context, error, stack) =>
                                        Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        f.titolo,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "➡️ ${f.indirizzo}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Text(
                                        "📞 ${f.telefono}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Text(
                                        "🚶‍♀️ A piedi: ${f.apiedi}",
                                        style: const TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
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

                const SizedBox(height: 10),
                SizedBox(
                  width:
                      double.infinity, // Bottone largo per facilitare il tocco
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white12,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "CHIUDI",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
