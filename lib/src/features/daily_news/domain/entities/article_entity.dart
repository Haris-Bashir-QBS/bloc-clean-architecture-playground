import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String? id;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String content;

  const ArticleEntity({
    required this.id,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  @override
  List<Object?> get props => [
    id,
    author,
    title,
    description,
    url,
    urlToImage,
    publishedAt,
    content,
  ];
}
