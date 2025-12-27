class Amiibo {
  final String head;
  final String tail;
  final String name;
  final String amiiboSeries;
  final String gameSeries;
  final String character;
  final String type;
  final String image;
  final String? releaseNA;
  final String? releaseJP;
  final String? releaseEU;
  final String? releaseAU;

  Amiibo({
    required this.head,
    required this.tail,
    required this.name,
    required this.amiiboSeries,
    required this.gameSeries,
    required this.character,
    required this.type,
    required this.image,
    this.releaseNA,
    this.releaseJP,
    this.releaseEU,
    this.releaseAU,
  });

  factory Amiibo.fromJson(Map<String, dynamic> json) {
    return Amiibo(
      head: json['head'] ?? '',
      tail: json['tail'] ?? '',
      name: json['name'] ?? '',
      amiiboSeries: json['amiiboSeries'] ?? '',
      gameSeries: json['gameSeries'] ?? '',
      character: json['character'] ?? '',
      type: json['type'] ?? '',
      image: json['image'] ?? '',
      releaseNA: json['release']?['na'],
      releaseJP: json['release']?['jp'],
      releaseEU: json['release']?['eu'],
      releaseAU: json['release']?['au'],
    );
  }

  String get id => '$head$tail';

  Map<String, dynamic> toJson() {
    return {
      'head': head,
      'tail': tail,
      'name': name,
      'amiiboSeries': amiiboSeries,
      'gameSeries': gameSeries,
      'character': character,
      'type': type,
      'image': image,
      'release': {
        'na': releaseNA,
        'jp': releaseJP,
        'eu': releaseEU,
        'au': releaseAU,
      }
    };
  }
}