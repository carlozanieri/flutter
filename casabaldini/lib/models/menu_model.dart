class MenuEntry {
  final int id;
  final String titolo;
  final String codice;
  final List<SubMenuEntry> children;

  MenuEntry({
    required this.id,
    required this.titolo,
    required this.codice,
    required this.children,
  });

  factory MenuEntry.fromJson(Map<String, dynamic> json) {
    var list = json['children'] as List;
    List<SubMenuEntry> childrenList = list
        .map((i) => SubMenuEntry.fromJson(i))
        .toList();

    return MenuEntry(
      id: json['parent']['id'],
      titolo: json['parent']['titolo'],
      codice: json['parent']['codice'],
      children: childrenList,
    );
  }
}

class SubMenuEntry {
  final int id;
  final String titolo;
  final String link;
  final String tipoPage; // Variabile Dart

  SubMenuEntry({
    required this.id,
    required this.titolo,
    required this.link,
    required this.tipoPage,
  });

  factory SubMenuEntry.fromJson(Map<String, dynamic> json) {
    return SubMenuEntry(
      id: json['id'],
      titolo: json['titolo'],
      link: json['link'].split('/').last,
      // Qui mappiamo la chiave JSON minuscola alla variabile Dart
      tipoPage: json['tipopage'] ?? 'interna',
    );
  }
}
