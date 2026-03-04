import 'package:flutter/material.dart';

class PrenotazioniPage extends StatelessWidget {
  const PrenotazioniPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Si adatta al contenuto
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Prenotazioni CasaBaldini",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.phone, color: Colors.green),
            title: Text("Chiamaci"),
            subtitle: Text("+39 055 XXX XXXX"),
          ),
          const ListTile(
            leading: Icon(Icons.email, color: Colors.blue),
            title: Text("Inviaci una mail"),
            subtitle: Text("info@casabaldini.eu"),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Le prenotazioni sono soggette a disponibilità. "
              "Contattaci direttamente per ricevere la migliore offerta garantita.",
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Chiudi"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
