class AppMetadata {
  final String name;
  final String value;
  final String type;
  final String description;
  final List<String> keywords;

  AppMetadata({
    required this.name,
    required this.value,
    required this.type,
    required this.description,
    this.keywords = const [],
  });

  factory AppMetadata.fromJson(Map<String, dynamic> json) {
    return AppMetadata(
      name: json['name'],
      value: json['value'],
      type: json['type'],
      description: json['description'],
      keywords: List<String>.from(json['keywords']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
      'type': type,
      'description': description,
      'keywords': keywords,
    };
  }

  factory AppMetadata.fromMap(Map<String, dynamic> map) {
    return AppMetadata(
      name: map['name'],
      value: map['value'],
      type: map['type'],
      description: map['description'],
      keywords: List<String>.from(map['keywords']),
    );
  }
}
