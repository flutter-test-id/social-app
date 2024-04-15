
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/utils/colors.dart';
import 'package:social_app/utils/global_varibles.dart';



class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  
int _page = 0;
late PageController pageController;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page){
   pageController.jumpToPage(page);
  }


  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems
      ),

      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor ,
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
      currentIndex: _page,
      onTap: navigationTapped,
      
      ),
    );
  }
}
