import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 必须加上这一行。
  await windowManager.ensureInitialized();

  // 获取屏幕可用大小
  Display primaryDisplay = await screenRetriever.getPrimaryDisplay();
  // 获取屏幕可用高度
  var windowHeight = primaryDisplay.visibleSize?.height ?? 820;

  WindowOptions windowOptions = WindowOptions(
    // size: Size(600, 400), // 设置默认窗口大小
    size: Size(430, windowHeight), // 设置默认窗口大小(高度占满屏幕)
    minimumSize: const Size(300, 220), // 设置最小窗口大小
    center: true, // 设置窗口居中
    title: "window_manager测试Demo", // 设置窗口标题
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  @override
  void initState() {
    super.initState();
    // 注册windowManager监听器
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    // 移除windowManager监听器
    windowManager.removeListener(this);
    super.dispose();
  }

  // === WindowListener回调 ===

  // 窗口准备关闭时触发
  @override
  void onWindowClose() {
    // 窗口关闭前做一些操作。
    // 我是关闭了adb服务。否则adb服务会一直在运行。
    debugPrint("onWindowClose");
    super.onWindowClose();
  }

  // 窗口获得焦点时触发(比如去浏览器看文章后回来点击本App的窗口)
  @override
  void onWindowFocus() {
    // 获得焦点时做一些处理。我是用于记录记录用户操作，方便后续查找问题及统计活跃情况。
    debugPrint("onWindowFocus");
    super.onWindowFocus();
  }

  // 窗口失去焦点时触发(比如去浏览器看文章了，焦点就不在本App了)
  @override
  void onWindowBlur() {
    // 失去焦点时做一些处理。我是用于记录记录用户操作，方便后续查找问题及统计活跃情况。
    debugPrint("onWindowBlur");
    super.onWindowBlur();
  }

  // === WindowListener回调 ===

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
