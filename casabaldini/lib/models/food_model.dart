class Food {
final int id;
final String img;
final String titolo;
final String indirizzo;
final String telefono;
final String apiedi;

Food({
required this.id,
required this.img,
required this.titolo,
required this.indirizzo,
required this.telefono,
required this.apiedi,
});

factory Food.fromJson(Map<String, dynamic> json) {
return Food(
id: json['id'],
img: json['img'] ?? '',
titolo: json['titolo'] ?? '',
indirizzo: json['indirizzo'] ?? '',
telefono: json['telefono'] ?? '',
apiedi: json['apiedi'] ?? '',
);
}
}