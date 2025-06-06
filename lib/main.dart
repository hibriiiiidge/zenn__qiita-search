import 'package:flutter/material.dart';
import 'package:qiita_search/screens/search_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // WebViewプラットフォームの初期化
  // webview_flutter 4.0.0以降では自動的に初期化されるため、
  // 古いバージョンを使用している場合のみ以下のコードが必要
  // if (Platform.isAndroid) {
  //   WebView.platform = AndroidWebView();
  // }

  await dotenv.load(fileName: '.env');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qiita Search',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Hiragino Sans',
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF55C500)),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
      ),
      home: const SearchScreen(),
    );
  }
}
