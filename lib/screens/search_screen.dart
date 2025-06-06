import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // httpという変数を通して、httpパッケージにアクセス
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/widgets/article_container.dart';

Future<List<Article>> searchQiita(String keyword) async {
  // 1. http通信に必要なデータを準備をする
  //   - URL、クエリパラメータの設定
  final uri = Uri.https('qiita.com', '/api/v2/items', {
    'query': keyword.isEmpty ? '' : 'title:$keyword', // キーワードが空の場合は全記事を取得
    'per_page': '10',
  });
  //   - アクセストークンの取得
  final String token = dotenv.env['QIITA_ACCESS_TOKEN'] ?? '';

  // 2. Qiita APIにリクエストを送る
  final http.Response res = await http.get(
    uri,
    headers: {'Authorization': 'Bearer $token'},
  );

  // 3. 戻り値をArticleクラスの配列に変換
  // 4. 変換したArticleクラスの配列を返す(returnする)
  if (res.statusCode == 200) {
    // レスポンスをモデルクラスへ変換
    final List<dynamic> body = jsonDecode(res.body);
    return body.map((dynamic json) => Article.fromJson(json)).toList();
  } else {
    return [];
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Article> articles = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // 画面初回表示時に記事を読み込む
    loadInitialArticles();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // 初回表示時の記事読み込み
  void loadInitialArticles() async {
    setState(() => isLoading = true);
    final results = await searchQiita(''); // 空文字で検索して最新記事を取得
    setState(() {
      articles = results;
      isLoading = false;
    });
  }

  void performSearch() async {
    setState(() => isLoading = true);
    final results = await searchQiita(searchController.text);
    setState(() {
      articles = results;
      isLoading = false;
    });
    Navigator.pop(context); // ドロワーを閉じる
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qiita Search')),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 100, // 任意の高さを設定
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orange.shade300,
              ),
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: const Text(
                '検索',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: '検索ワードを入力してください',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: performSearch,
                      ),
                    ),
                    onSubmitted: (_) => performSearch(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: performSearch,
                    child: const Text('検索'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : articles.isEmpty
                    ? const Center(child: Text('記事が見つかりませんでした'))
                    : ListView(
                        children: articles
                            .map((article) => ArticleContainer(article: article))
                            .toList(),
                      ),
          ),
        ],
      ),
    );
  }
}
