import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/screens/article_screen.dart';

class ArticleContainer extends StatelessWidget {
  const ArticleContainer({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: GestureDetector(
        // GestureDetectorでContainerを囲う
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => ArticleScreen(article: article)),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: Color(0xFF55C500),
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          child: Column(
            // constを削除
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 投稿日
              Text(
                DateFormat('yyyy/MM/dd').format(article.createdAt),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              // タイトル
              Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // タグ
              Text(
                '#${article.tags.join(' #')}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // ハートアイコンといいね数
                  Column(
                    children: [
                      const Icon(Icons.favorite, color: Colors.white),
                      Text(
                        article.likesCount.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // 投稿者のアイコンと投稿者名
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundImage: NetworkImage(
                          article.user.profileImageUrl,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        article.user.id,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
