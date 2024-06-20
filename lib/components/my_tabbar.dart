import 'package:flutter/material.dart';
import 'package:final_app/pages/library/favorit_content_page.dart';
import 'package:final_app/pages/library/download_content_page.dart';

class MyTabBar extends StatefulWidget {
  const MyTabBar({super.key});

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  List<String> tabs = ["Favorit", "Download"];
  int current = 0;

  double changePositionedOfLine() {
    switch (current) {
      case 0:
        return 0;
      case 1:
        return 76;
      default:
        return 0;
    }
  }

  double changeContainerWidth() {
    switch (current) {
      case 0:
        return 60;
      case 1:
        return 90;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          SizedBox(
            width: size.width,
            height: size.height * 0.07,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: size.width,
                    height: size.height * 0.04,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tabs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              current = index;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: current == 0 ? 10 : 25, top: 5),
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                fontSize: current == index ? 18 : 14,
                                fontWeight: current == index
                                    ? FontWeight.w700
                                    : FontWeight.w300,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                AnimatedPositioned(
                  bottom: 0,
                  left: changePositionedOfLine(),
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(milliseconds: 500),
                  child: AnimatedContainer(
                    curve: Curves.fastLinearToSlowEaseIn,
                    margin: const EdgeInsets.only(left: 10),
                    duration: const Duration(milliseconds: 500),
                    width: changeContainerWidth(),
                    height: size.height * 0.008,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orangeAccent,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: current == 0
                  ? const FavoritContentPage()
                  : const DownloadContentPage())
        ],
      ),
    );
  }
}
