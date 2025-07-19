


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
// import 'package:qaviews/view/requirement_slip_screen.dart';
// import 'package:qaviews/view/search_image_screen.dart';

import '../bloc/cubit/cart_cubit.dart';
import '../utils/app_theme.dart';
import '../utils/filter_model.dart';
// import '../view/new_arrivals_screen.dart';
// import '../view/product_search_screen.dart';


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
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              Container(
                height: 56,
                color: AppTheme.themeColor,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {

                          Provider.of<MenuController>(context, listen: false).toggle();
                          if(Provider.of<MenuController>(context, listen: false).state==MenuState.closing)
                          {
                            Provider.of<Counter>(context,listen: false).setDrawerValue(0);
                          }
                          else
                          {
                            Provider.of<Counter>(context,listen: false).setDrawerValue(1);
                          }

                        },
                        child: Image.asset('assets/ham_ic.png',width: 33,height: 33,color: AppTheme.themeColor,
                        )),
                    const SizedBox(width: 10),
                    Expanded(
                      child:
                      widget.orangeTheme?Center(
                        child: Padding(
                          padding:  EdgeInsets.only(left:widget.showBoxes?0:28,right:widget.showBoxes?24: 0),
                          child: Text(widget.pageTitle,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),textAlign: TextAlign.right,),
                        ),
                      ):


                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6)),
                        child: TextFormField(
                            onFieldSubmitted: (value) {
                              if(searchController.text.length>1)
                              {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => ProductSearchScreen(searchController.text,true)));
                              }
                            },
                            textInputAction: TextInputAction.search,
                          controller: searchController,
                            style: const TextStyle(
                              fontSize: 15.0,
                              height: 1.6,
                              color: Colors.black,
                            ),
                            decoration:  InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  if(searchController.text.length>1)
                                    {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => ProductSearchScreen(searchController.text,true)));
                                    }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset('assets/search_ic.svg',width: 15.6,height: 16.02),
                                ),
                              ),
                              hintText: 'Search BuildStorey',
                              contentPadding: EdgeInsets.only(left: 15,top: 3),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(width: 10),
                   widget.showBoxes==false? InkWell(
                     onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchImageScreen()));
                     },
                     child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6)),
                        child: SvgPicture.asset('assets/scan.svg'),
                      ),
                   ):Container(),
                    const SizedBox(width: 7),

                    widget.showBoxes==false?    GestureDetector(
                      onTap: (){
                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>RequirementSlipScreen()));
                      },
                      child:  Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6)),
                        child: SvgPicture.asset('assets/cloud_ic.svg'),
                      ),
                    ):Container(),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              //_widgetOptions.elementAt(_selectedIndex),
             widget.contentScreen.contentBuilder(context),
            ],
          ),
         /* bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: MyColor.themeColor,
              unselectedItemColor: Color.fromRGBO(155,153,152,1),
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5,top: 6),
                    child: ImageIcon(AssetImage("images/home_bt.png")),
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(79,79,79, 0.5)
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5,top: 6),
                    child: ImageIcon(AssetImage("images/settings_bt.png")),
                  ),
                  title: Text(
                    'Setting',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(79,79,79, 0.5)
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5,top: 6),
                    child: ImageIcon(AssetImage("images/notification_bt.png")),
                  ),
                  title: Text(
                    'Notifications',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(79,79,79, 0.5)
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5,top: 6),
                    child: ImageIcon(AssetImage("images/filter_bt.png")),
                  ),
                  title: Text(
                    'Filter',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(79,79,79, 0.5)
                    ),
                  ),
                ),


                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5,top: 6),
                    child: ImageIcon(AssetImage("images/profile_bt.png")),
                  ),
                  title: Text(
                    'My Account',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(79,79,79, 0.5)
                    ),
                  ),
                ),
              ],
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          )*/
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
    final contentScale = 1.0 - (0.30 * scalePercent);
    final cornerRadius =
        30.0 * Provider.of<MenuController>(context, listen: true).percentOpen;

    return new Transform(
      transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: const Offset(0.0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: new ClipRRect(
            borderRadius: new BorderRadius.circular(cornerRadius),
            child: content),
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