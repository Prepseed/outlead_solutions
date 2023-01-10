import 'package:flutter/material.dart';
import 'package:outlead_solutions/constants/sharedPref.dart';
import 'package:outlead_solutions/screens/onboding/onboding_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../../model/menu.dart';
import '../../../utils/rive_utils.dart';
import '../../LeavesManagement/leave_list.dart';
import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Menu selectedSideMenu = sidebarMenus.first;
  String? role;

  @override
  void initState() {
    Future.microtask(() async => {
      setState((){
        SharedPref().getSharedPref('role').then((value) => role = value);
      }),
      // await Provider.of<LeaveReqProvider>(context,listen: false).getLeaves(role == 'hr' ? true : false),

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(
                name: role.toString(),
                bio: "YouTuber",
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Browse".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus
                  .map((menu) => SideMenu(
                        menu: menu,
                        selectedMenu: selectedSideMenu,
                        press: () {
                          // RiveUtils.chnageSMIBoolState(menu.rive.status!);
                          setState(() {
                            selectedSideMenu = menu;
                          });
                          if(selectedSideMenu.title == "Home"){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) =>  const LeaveLists()));
                          }
                          if(selectedSideMenu.title == "Logout"){
                            print("Logout");
                            logout(context);
                          }else{
                            print("object");
                          }
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      ))
                  .toList(),
/*              Padding(
                padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                child: Text(
                  "History".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus2
                  .map((menu) => SideMenu(
                        menu: menu,
                        selectedMenu: selectedSideMenu,
                        press: () {
                          RiveUtils.chnageSMIBoolState(menu.rive.status!);
                          setState(() {
                            selectedSideMenu = menu;
                          });
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      ))
                  .toList(),*/
            ],
          ),
        ),
      ),
    );
  }
}
logout(BuildContext context) {
  Future.delayed(Duration.zero, () async {
    return showDialog(context: navigatorKey.currentContext!, builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        elevation: 16,
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text('Are you Sure?',/*style: GoogleFonts.poppins(color: Constants.black,),*/),
                  Divider(/*color: Constants.black,*/thickness: 1,),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(elevation: MaterialStateProperty.all<double>(0.0),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                backgroundColor:  MaterialStateProperty.all<Color>(Colors.transparent)),
                            onPressed: () { Navigator.of(context).pop(); },
                            child: const Text('Cancel')),
                        VerticalDivider(/*color: Constants.black,*/thickness: 1,),
                        ElevatedButton(onPressed: () async {
                          /*setState(() {
                          currentItem = MenuItems.home;
                        });*/
                          SharedPreferences prefs = await SharedPreferences
                              .getInstance();
                          await prefs.clear();
                          // await APICacheManager().emptyCache();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => OnbodingScreen()
                          ));
                        },
                            style: ButtonStyle(elevation: MaterialStateProperty.all<double>(0.0),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                backgroundColor:  MaterialStateProperty.all<Color>(Colors.transparent)),
                            child: const Text('Yes'))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  });
}