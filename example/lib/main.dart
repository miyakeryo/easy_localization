import 'dart:developer';
import 'dart:ui';

import 'package:example/lang_view.dart';
import 'package:example/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';

import 'generated/locale_keys.g.dart';

void main() {
  runApp(EasyLocalization(
    child: MyApp(),
    supportedLocales: [
      Locale('en', 'US'),
      Locale('ar', 'DZ'),
      Locale('de', 'DE'),
      Locale('ru', 'RU')
    ],
    path: 'resources/langs/langs.csv', //'resources/langs',
    // fallbackLocale: Locale('en', 'US'),
    // saveLocale: false,
    // useOnlyLangCode: true,
    // preloaderColor: Colors.black,

    // optional assetLoader default used is RootBundleAssetLoader which uses flutter's assetloader
    // install easy_localization_loader for enable custom loaders
    // assetLoader: RootBundleAssetLoader()
    // assetLoader: HttpAssetLoader()
    // assetLoader: FileAssetLoader()
    assetLoader: CsvAssetLoader()
    // assetLoader: YamlAssetLoader() //multiple files
    // assetLoader: YamlSingleAssetLoader() //single file
    // assetLoader: XmlAssetLoader() //multiple files
    // assetLoader: XmlSingleAssetLoader() //single file
    // assetLoader: CodegenLoader()
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log(EasyLocalization.of(context).locale.toString(),
        name: '${this} # locale');
    log('title'.tr().toString(), name: '${this} # locale');
    return MaterialApp(
      title: 'title'.tr(),
      localizationsDelegates:EasyLocalization.of(context).delegates,
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: EasyLocalization.of(context).locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Easy localization'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  bool _gender = true;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void switchGender(bool val) {
    setState(() {
      _gender = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.title).tr(context: context),
        //Text(AppLocalizations.of(context).tr('title')),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.language),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => LanguageView(), fullscreenDialog: true),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(
              flex: 1,
            ),
            Text(
              LocaleKeys.gender_with_arg,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ).tr(args: ['aissat'], gender: _gender ? 'female' : 'male'),
            Text(
              tr(LocaleKeys.gender, gender: _gender ? 'female' : 'male'),
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(MyFlutterApp.male_1),
                Switch(value: _gender, onChanged: switchGender),
                Icon(MyFlutterApp.female_1),
              ],
            ),
            Spacer(
              flex: 1,
            ),
            Text(LocaleKeys.msg).tr(args: ['aissat', 'Flutter']),
            Text(LocaleKeys.msg_named).tr(namedArgs: {'lang': 'Dart'}, args: ['Easy localization']),
            Text(LocaleKeys.clicked).plural(counter),
            FlatButton(
              onPressed: () {
                incrementCounter();
              },
              child: Text(LocaleKeys.clickMe).tr(),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
                plural(LocaleKeys.amount, counter,
                    format: NumberFormat.currency(
                        locale: Intl.defaultLocale, symbol: '€')),
                style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {
                EasyLocalization.of(context).deleteSaveLocale();
              },
              child: Text(LocaleKeys.reset_locale).tr(),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        child: Text('+1'),
      ),
    );
  }
}