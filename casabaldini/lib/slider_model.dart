class SliderModel {
  final int id;
  final String titolo;
  final String immagineUrl;
  final String testo;
  final String caption;

  SliderModel({
    required this.id,
    required this.titolo,
    required this.immagineUrl,
    required this.testo,
    required this.caption,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'],
      titolo: json['titolo'] ?? '',
      immagineUrl: json['img'] ?? '',
      testo: json['testo'] ?? '',
      caption: json['caption'] ?? '',
    );
  }
}
