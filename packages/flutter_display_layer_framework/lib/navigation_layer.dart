part of 'framework.dart';

class NavigationLayer extends StatefulWidget {
  final Widget child;
  final GlobalKey<CustomNavigationRailState> navigationRailKey = GlobalKey();

  NavigationLayer({Key? key, required this.child}) : super(key: key);

  @override
  NavigationLayerState createState() =>
      NavigationLayerState(child: child, navigationRailKey: navigationRailKey);
}

class NavigationLayerState extends State<NavigationLayer>
    with TickerProviderStateMixin {
  final Widget child;
  final GlobalKey<CustomNavigationRailState> navigationRailKey;

  NavigationLayerState({required this.child, required this.navigationRailKey});

  bool hiddenNavigation = false;
  bool contactButtonExtended = true;

  @override
  void initState() {
    contactButtonExtended = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    hiddenNavigation = !ScreenSize.isDesktop(context);
  }

  _switchContactButtonState() {
    setState(() {
      contactButtonExtended = !contactButtonExtended;
    });
  }

  _switchNavigatorRailState() {
    setState(() {
      hiddenNavigation = !hiddenNavigation;
      navigationRailKey.currentState?..extendNavigationRail();
      navigationRailKey.currentState?..closeRail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final customNavigationRail = CustomNavigationRail(
      key: navigationRailKey,
      child: child,
    );

    return Scaffold(
        // key: scaffoldKey,
        backgroundColor: Colors.black87,
        body: WindowLayer(
            child: RawMaterialButton(
                mouseCursor: SystemMouseCursors.basic,
                onPressed: () => navigationRailKey.currentState?..closeRail(),
                child: customNavigationRail)),
        // floatingActionButtonAnimator: ,
        floatingActionButton: floatingActionButtons(
          context,
          switchNavigatorRailState: _switchNavigatorRailState,
          switchContactButtonState: _switchContactButtonState,
          hiddenNavigation: hiddenNavigation,
          contactButtonExtended: contactButtonExtended,
        ));
  }
}