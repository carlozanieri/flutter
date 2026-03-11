import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrenotazioniPage extends StatelessWidget {
  const PrenotazioniPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Non mettiamo padding qui per far arrivare l'immagine ai bordi
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias, // Ritaglia l'immagine sui bordi arrotondati
      child: Stack(
        fit: StackFit.loose, // Si adatta al contenuto della Column
        children: [
          // 1. SFONDO
          Positioned.fill(
            child: Image.asset("assets/bgblack.png", fit: BoxFit.cover),
          ),

          // 2. CONTENUTO
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // La modale rimane della dimensione necessaria
              children: [
                // La "maniglia" superiore
                Container(
                  width: 55,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Prenotazioni CasaBaldini",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Divider(color: Colors.white24),
                const SizedBox(height: 10),

                // LISTA CONTATTI
                _buildContactTile(
                  icon: Icons.phone,
                  color: Colors.greenAccent,
                  title: "Chiamaci",
                  subtitle: "+39 320 7060411",
                  onTap: () =>
                      launchUrl(Uri(scheme: 'tel', path: '+393207060411')),
                ),
                _buildContactTile(
                  icon: Icons.phone_callback,
                  color: Colors.greenAccent,
                  title: "Chiamaci tel. fisso",
                  subtitle: "+39 055 2741209",
                  onTap: () =>
                      launchUrl(Uri(scheme: 'tel', path: '+390552741209')),
                ),
                _buildContactTile(
                  icon: Icons.email_outlined,
                  color: Colors.lightBlueAccent,
                  title: "Inviaci una mail",
                  subtitle: "carlo.zanieri@gmail.com",
                  onTap: () => launchUrl(
                    Uri(
                      scheme: 'mailto',
                      path: 'carlo.zanieri@gmail.com',
                      query: 'subject=Richiesta informazioni CasaBaldini',
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                  child: Text(
                    "Le prenotazioni sono soggette a disponibilità. "
                    "Contattaci direttamente per ricevere la migliore offerta garantita.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white12,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("CHIUDI"),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper per creare i ListTile con stile coerente sul nero
  Widget _buildContactTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white30),
      onTap: onTap,
    );
  }
}
