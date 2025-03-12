import 'package:bloc_api_integration/src/features/daily_news/data/models/article_model.dart';
import 'package:bloc_api_integration/src/network/api_base.dart';
import 'package:bloc_api_integration/src/network/api_endpoints.dart';

import '../../../../../network/dio_client.dart';
import '../../../../../network/response_validator.dart';

abstract interface class NewsRemoteDatasource {
  Future<List<ArticleModel>> getNewsArticles(int page);
}

class NewsRemoteDatasourceImpl implements NewsRemoteDatasource {
  @override
  Future<List<ArticleModel>> getNewsArticles(int page) async {
    final response = await DioClient().get(
      customBaseUrl: ApiBase.newsBaseUrl,
      endpoint: ApiEndPoints.newsArticles,
      queryParams: {"apikey": ApiBase.newsApiKey, "country": "us"},
    );
    final validatedResponse = ResponseValidator.validateResponse(response);
    List<ArticleModel> articles =
        (validatedResponse["articles"] as List)
            .map((articleJson) => ArticleModel.fromJson(articleJson))
            .toList();

    return articles;
  }
}
