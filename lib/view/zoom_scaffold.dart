


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../utils/app_theme.dart';


class ZoomScaffold extends StatefulWidget {
  final Widget menuScreen;
  final Layout contentScreen;
  final String pageTitle;
  final bool orangeTheme;
  final bool showBoxes;

  ZoomScaffold({
    required this.menuScreen,
    required this.contentScreen,
    required this.pageTitle,
    required this.orangeTheme,
    required this.showBoxes
  });

  @override
  _ZoomScaffoldState createState() => _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold>
    with TickerProviderStateMixin {
  var searchController=TextEditingController();

  late AnimationController _animationController;
  int _selectedIndex = 0;

  /* List<Widget> _widgetOptions = <Widget>[
    DriverDashboardScreen(),
    LoginScreen()
  ];*/
  Curve scaleDownCurve =  Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve =  Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve =  Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve =  Interval(0.0, 1.0, curve: Curves.easeOut);

  createContentDisplay() {
    return zoomAndSlideContent(Container(
      child:  GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
       //   backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              //_widgetOptions.elementAt(_selectedIndex),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: widget.contentScreen.contentBuilder(context),
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 10),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                ),
                child: Container(
                  height: 69,
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Provider.of<MenuController>(context, listen: false).toggle();
                          },
                          child:
                          Provider.of<MenuController>(context, listen: false).state==MenuState.open?
                          Image.asset('assets/ham_ic2.png',width: 22.2,height: 19.42,color: AppTheme.themeColor,
                          ):

                          Image.asset('assets/ham3.png',width: 22.2,height: 19.42,color: AppTheme.themeColor
                          )),


                      Text(widget.pageTitle,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),

                      Container()






                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;

    switch (Provider.of<MenuController>(context, listen: true).state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        scalePercent = scaleDownCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        scalePercent = scaleUpCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        break;
    }

    final slideAmount = 235.0 * slidePercent;
    final contentScale = 1.0 - (0.22 * scalePercent);
    final cornerRadius =
        39.0 * Provider.of<MenuController>(context, listen: true).percentOpen;

    return Transform(
      transform: Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child:  Stack(
        children: [

          Container(
            margin: EdgeInsets.symmetric(vertical: 45),
            transform: Matrix4.translationValues(-33.0, 0.0, 0.0),
            decoration: BoxDecoration(
                color: AppTheme.themeColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(39)
            ),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: const Offset(0.0, 5.0),
                  blurRadius: 15.0,
                  spreadRadius: 10.0,
                ),
              ],
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(cornerRadius),
                child: content),
          ),






        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Scaffold(
            body: widget.menuScreen,
          ),
        ),
        createContentDisplay()
      ],
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
  }


  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {
  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({
    required this.builder,
  });

  @override
  ZoomScaffoldMenuControllerState createState() {
    return new ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState
    extends State<ZoomScaffoldMenuController> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context, Provider.of<MenuController>(context, listen: true));
  }
}

typedef Widget ZoomScaffoldBuilder(
    BuildContext context, MenuController menuController);

class Layout {
  final WidgetBuilder contentBuilder;

  Layout({
    required this.contentBuilder,
  });
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MenuState state = MenuState.closed;

  MenuController({
    required this.vsync,
  }) : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}