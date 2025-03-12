import 'package:bloc_api_integration/src/features/daily_news/domain/entities/article_entity.dart';
import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:equatable/equatable.dart';

abstract class NewsArticleState extends Equatable{
final List<ArticleEntity>? articles;
final Failure? error;

  const NewsArticleState({ this.articles,  this.error});

  @override
  List<Object?> get props => [articles,error];
}


class NewsArticlesInitial extends NewsArticleState{
  const NewsArticlesInitial();
}

class NewsArticlesLoading extends NewsArticleState{
  const NewsArticlesLoading();
}

class NewsArticlesLoaded extends NewsArticleState{
  const NewsArticlesLoaded(List<ArticleEntity>? articles): super(articles: articles);
}

class NewsArticlesError extends NewsArticleState{
  const NewsArticlesError(Failure? error): super(error:error);
}

