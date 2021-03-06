///
/// Created by NieBin on 18-12-14
/// Github: https://github.com/nb312
/// Email: niebin312@gmail.com
///
import "package:flutter/material.dart";
import 'package:flutter_ui_app/stream/menu_stream.dart';
import 'package:flutter_ui_app/data/Menu.dart';
import 'package:flutter_ui_app/const/string_const.dart';
import 'package:flutter_ui_app/view/AboutMeTitle.dart';
import 'package:flutter_ui_app/const/size_const.dart';
import 'package:flutter_ui_app/const/images_const.dart';

class HomePage extends StatelessWidget {
  final _scaffoldState = GlobalKey<ScaffoldState>();

  Widget _topBar() => SliverAppBar(
        elevation: 1.0,
        pinned: true,
        expandedHeight: 150.0,
        flexibleSpace: FlexibleSpaceBar(
          title: Row(
            children: <Widget>[
              FlutterLogo(
                colors: Colors.cyan,
              ),
              SizedBox(
                width: 6.0,
              ),
              Text(
                StringConst.APP_NAME,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          background: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.grey[900],
                Colors.cyan,
              ]),
            ),
          ),
          collapseMode: CollapseMode.pin,
        ),
      );

  Widget _menuItem(context, item) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey[800],
            offset: Offset(0.0, 2.0),
          )
        ]),
        constraints: BoxConstraints.expand(height: 60.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                item,
                style:
                    TextStyle(color: Colors.white, fontSize: TEXT_NORMAL_SIZE),
              ),
            ]
//            Divider(
//              height: 1.0,
//              color: Colors.white,
//            )
//          ],
            ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, "/$item");
      },
    );
  }

  Widget _menuList(Menu menu) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _menuItem(context, menu.items[index]);
      },
      itemCount: menu.items.length,
    );
  }

  Widget _header() {
    return Ink(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.cyanAccent,
            Colors.grey[900],
          ]),
        ),
        constraints: BoxConstraints.expand(height: 80.0),
        child: Center(
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage(ImagePath.nbImage),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                StringConst.CREATE_BY,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: TEXT_NORMAL_SIZE,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clickMenu(context, Menu menu) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Material(
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _header(),
                Expanded(
                  child: _menuList(menu),
                ),
                AboutMeTitle(),
              ],
            ),
          ),
    );
  }

  Widget _gridItem(context, Menu menu) => InkWell(
        onTap: () {
          _clickMenu(context, menu);
        },
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              menu.image,
              fit: BoxFit.cover,
            ),
            Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                gradient: RadialGradient(colors: [
                  Colors.lightBlueAccent.withOpacity(0.9),
                  Colors.grey[850].withOpacity(0.9)
                ], radius: 0.3),
              ),
            ),
            Container(
              constraints: BoxConstraints.expand(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      menu.icon,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      menu.title,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );

  Widget _gridView(BuildContext context, List<Menu> list) => SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            childAspectRatio: 1.0,
            crossAxisCount: 2),
        delegate: SliverChildBuilderDelegate((context, index) {
          var menu = list[index];
          return _gridItem(context, menu);
        }, childCount: list.length),
      );

  Widget _streamBuild(context) {
    var controller = MenuController();
    return StreamBuilder(
      builder: (context, shot) {
        return shot.hasData
            ? CustomScrollView(
                slivers: <Widget>[_topBar(), _gridView(context, shot.data)],
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
      stream: controller.menuItems,
    );
  }

  Widget _showAndroid(context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: Scaffold(
        key: _scaffoldState,
        body: _streamBuild(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _showAndroid(context);
  }
}
