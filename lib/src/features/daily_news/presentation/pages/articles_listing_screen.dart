import 'dart:async';

import 'package:bloc_api_integration/src/features/daily_news/presentation/bloc/news_article_bloc.dart';
import 'package:bloc_api_integration/src/features/daily_news/presentation/bloc/news_article_state.dart';
import 'package:bloc_api_integration/src/features/daily_news/presentation/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/article_entity.dart';
import '../bloc/news_article_event.dart';

class ArticlesListingScreen extends StatefulWidget {
  const ArticlesListingScreen({super.key});

  @override
  State<ArticlesListingScreen> createState() => _ArticlesListingScreenState();
}

class _ArticlesListingScreenState extends State<ArticlesListingScreen> {
  @override
  void initState() {
    fetchArticles();
    super.initState();
  }

  Future<void> fetchArticles() async {
    context.read<NewsArticleBloc>().add(GetArticlesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Articles'),
        forceMaterialTransparency: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildBody()],
      ),
    );
  }

  BlocBuilder<NewsArticleBloc, NewsArticleState> _buildBody() {
    return BlocBuilder<NewsArticleBloc, NewsArticleState>(
      builder: (context, state) {
        return switch (state) {
          NewsArticlesLoading() => Center(child: CircularProgressIndicator()),
          NewsArticlesError() => Center(child: Text("${state.error?.message}")),
          NewsArticlesLoaded(articles: final articles) => _newsListView(
            articles,
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }

  Widget _newsListView(List<ArticleEntity>? articles) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: fetchArticles,
        child: ListView.separated(
          itemCount: articles?.length ?? 0,
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            ArticleEntity? article = articles?[index];
            return CustomListTile(
              imageUrl: article?.urlToImage ?? "",
              title: article?.title ?? "",
              description: article?.description ?? "",
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 10);
          },
        ),
      ),
    );
  }
}
