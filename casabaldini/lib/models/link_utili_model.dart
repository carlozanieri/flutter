class LinkUtile {
  final int id;
  final String img;
  final String titolo;
  final String link;

  LinkUtile({
    required this.id,
    required this.img,
    required this.titolo,
    required this.link,
  });

  factory LinkUtile.fromJson(Map<String, dynamic> json) {
    return LinkUtile(
      id: json['id'],
      img: json['img'] ?? '',
      titolo: json['titolo'] ?? '',
      link: json['link'] ?? '',
    );
  }
}
