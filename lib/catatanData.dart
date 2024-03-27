class CatatanData {
  late String title;
  late String summary;
  late String description;
  late Owner owner;
  late List<ImageData> images;
  late List<String> tag;

  CatatanData({
    required this.title,
    this.summary = '',
    required this.description,
    required this.owner,
    required this.images,
    required this.tag,
  });

  CatatanData.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? ''; // Jika title null, berikan string kosong
    summary = json['summary'] ?? ''; // Jika summary null, berikan string kosong
    description = json['description'] ?? ''; // Jika description null, berikan string kosong
    owner = Owner.fromJson(json['owner']);
    images = (json['images'] as List<dynamic>? ?? []).map((item) => ImageData.fromJson(item)).toList();
    tag = (json['tag'] as List<dynamic>? ?? []).map((tag) => tag.toString()).toList();
  }
}

class Owner {
  late String name;
  late String photoUrl;

  Owner({required this.name, required this.photoUrl});

  Owner.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    photoUrl = json['photo_url'];
  }
}

class ImageData {
  late String? imageUrl;
  late String? imagePreview;

  ImageData({required this.imageUrl, required this.imagePreview});

  ImageData.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    imagePreview = json['image_preview'];
  }
}