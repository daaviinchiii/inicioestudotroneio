class GameModel {
  final int id;
  final String title, description,  date, platform, company, image;

  GameModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.platform,
    required this.company,
    required this.image,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      platform: json['platform'],
      company: json['company'],
      image: json['image'],
    );
  }
}
