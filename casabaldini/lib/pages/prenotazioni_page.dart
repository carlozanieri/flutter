import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.withOpacity(0.1), // Sfondo leggero
              child: const Icon(
                Icons.phone,
                color: Colors.green,
              ), // Icona verde
            ),
            title: const Text(
              "Chiamaci",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text("+393319247347"),
            trailing: const Icon(Icons.chevron_right), // Icona a fine riga
            onTap: () async {
              final Uri launchUri = Uri(scheme: 'tel', path: '+393319247347');
              await launchUrl(launchUri);
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: const Icon(Icons.email_outlined, color: Colors.blue),
            ),
            title: const Text(
              "Inviaci una mail",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text("bruna.bbaldini@gmail.com"),
            trailing: const Icon(Icons.send_rounded, size: 20),
            onTap: () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: 'bruna.bbaldini@gmail.com',
                // Puoi anche pre-compilare l'oggetto della mail!
                queryParameters: {
                  'subject': 'Richiesta informazioni da App CasaBaldini',
                },
              );

              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              } else {
                debugPrint("Impossibile aprire l'app email");
              }
            },
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
