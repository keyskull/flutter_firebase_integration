import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_universal_router/init_router_base.dart';
import 'package:flutter_universal_router/route.dart';
import 'package:localization/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:utilities/screen_size.dart';

import 'framework.dart';

void _func(BuildContext context) {}

class MultiLayeredApp extends StatefulWidget {
  final void Function(BuildContext context) initProcess;
  final Widget Function(Widget child)? navigationLayerBuilder;
  final ThemeData? theme;

  MultiLayeredApp(
      {Key? key,
      this.initProcess = _func,
      this.navigationLayerBuilder,
      this.theme})
      : super(key: key);

  @override
  _MultiLayeredAppAppState createState() => _MultiLayeredAppAppState(
      initProcess, navigationLayerBuilder ?? defaultNavigationLayer, theme);
}

class _MultiLayeredAppAppState extends State<MultiLayeredApp> {
  final void Function(BuildContext context) initProcess;
  final Widget Function(Widget child) navigationLayerBuilder;
  final ThemeData? theme;

  _MultiLayeredAppAppState(
      this.initProcess, this.navigationLayerBuilder, this.theme);

  String title = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //using Provider, don't need to add handler to constructors of all descendants
      create: (context) => PathHandler(),
      child: MaterialApp.router(
        theme: theme,
        title: title,
        routerDelegate: RouterDelegateInherit(),
        routeInformationParser: RouteInformationParserInherit(),
        builder: (context, Widget? child) {
          ScreenSize.initScreenSize(context);
          this.initProcess(context);
          final unknown =
              (InitRouterBase.unknownPage.getPage() as MaterialPage).child;
          log("${child.runtimeType.toString()}");

          return Overlay(
            initialEntries: [
              OverlayEntry(
                  builder: (context) =>
                      navigationLayerBuilder(child ?? unknown)),
            ],
          );
        },
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      title = S.current.title;
    });
  }
}
