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

  // Questo metodo trasforma il JSON che arriva dal server in un oggetto Dart
  factory LinkUtile.fromJson(Map<String, dynamic> json) {
    return LinkUtile(
      id: json['id'],
      titolo: json['titolo'] ?? '',
      img: json['img'] ?? '',
      link: json['link'] ?? '',
    );
  }
}
