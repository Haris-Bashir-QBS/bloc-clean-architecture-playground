import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_api_integration/src/features/daily_news/domain/usecases/fetch_articles_usecase.dart';
import 'package:bloc_api_integration/src/features/daily_news/presentation/bloc/news_article_event.dart';
import 'package:bloc_api_integration/src/features/daily_news/presentation/bloc/news_article_state.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../network/api_exceptions.dart';
import '../../domain/entities/article_entity.dart';

class NewsArticleBloc extends Bloc<NewsArticleEvent,NewsArticleState>{
  final FetchArticlesUseCase _fetchArticlesUseCase;
  NewsArticleBloc(this._fetchArticlesUseCase):super(NewsArticlesInitial()){
   on<GetArticlesEvent>(getArticles);
  }

  FutureOr<void> getArticles(GetArticlesEvent event ,Emitter<NewsArticleState> emit )async {
    emit(NewsArticlesLoading());
    Either<Failure, List<ArticleEntity>> response = await _fetchArticlesUseCase(1);
    response.fold((Failure failure){
      emit(NewsArticlesError(failure));
    },(List<ArticleEntity> articles){
      emit(NewsArticlesLoaded(articles));
    });

  }

}