import 'package:bloc_api_integration/src/features/daily_news/domain/entities/article_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/use_cases/use_case.dart';
import '../../../../network/api_exceptions.dart';
import '../repositories/article_repository.dart';

class FetchArticlesUseCase extends UseCase<List<ArticleEntity>, int> {
  final NewsRepository repository;

  FetchArticlesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call(int page) {
    return repository.getANewsArticles(page);
  }
}
