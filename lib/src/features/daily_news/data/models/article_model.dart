import 'package:bloc_api_integration/src/features/daily_news/domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    required super.id,
    required super.author,
    required super.title,
    required super.description,
    required super.url,
    required super.urlToImage,
    required super.publishedAt,
    required super.content,
  });

  /// Factory method to create an instance from JSON
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json["source"]["id"],
      author: json["author"] ?? "Unknown",
      title: json["title"] ?? "No Title",
      description: json["description"] ?? "No Description",
      url: json["url"] ?? "",
      urlToImage: json["urlToImage"] ?? "",
      publishedAt: DateTime.tryParse(json["publishedAt"] ?? "") ?? DateTime.now(),
      content: json["content"] ?? "No Content",
    );
  }

  /// Converts an instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      "source": {
        "id": id,
      },
      "author": author,
      "title": title,
      "description": description,
      "url": url,
      "urlToImage": urlToImage,
      "publishedAt": publishedAt.toIso8601String(),
      "content": content,
    };
  }


}
