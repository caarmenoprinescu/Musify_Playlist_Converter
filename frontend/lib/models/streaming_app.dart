class StreamingApp {
  String? name;
  String? imageUrl;

  StreamingApp({
    required this.name,
    this.imageUrl,
  });

  factory StreamingApp.fromJson(Map<String, dynamic> json) {
    return StreamingApp(
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'image_url': imageUrl,
  };
}