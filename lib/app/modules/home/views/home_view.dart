import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/account/views/account_view.dart';
import 'package:ride_mobile/app/modules/destination/views/destination_view.dart';
import 'package:ride_mobile/app/modules/support/views/contact_us_view.dart';
import 'package:ride_mobile/app/utils/assets.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/keys.dart';

import '../../../utils/appString.dart';
import '../../../widgets/account_widgets/drawer_menu.dart';
import '../../account/views/manage_plans_view.dart';
import '../controllers/home_controller.dart';

typedef StringCallback = void Function(String val);

class HomeView extends StatefulWidget {
  final bool? isActive;
  final int? accountTab;
  const HomeView({
    Key? key,
    this.isActive,
    this.accountTab,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController controller = Get.put(HomeController());
  GlobalKey<ScaffoldState> account_key = GlobalKey();
  GlobalKey<ScaffoldState> home_key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: home_key,
      endDrawer: const DrawerMenu(),
      bottomNavigationBar: Obx(() => Stack(
            children: [
              Container(
                width: Dimens.width(100, context),
                height: 120,
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(color: AppColors.homeBGColor),
              ),
              Container(
                width: Dimens.width(100, context),
                height: 120,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.ln1, AppColors.ln2]),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              ),
              Padding(
                padding: const EdgeInsets.all(1.5),
                child: Container(
                  width: Dimens.width(100, context),
                  height: 120,
                  decoration: BoxDecoration(
                      color: AppColors.homeBGColor,
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: BottomNavigationBar(
                    elevation: 10,
                    key: HomeKeys().bottomNavigatorKey,
                    backgroundColor: Colors.transparent,
                    type: BottomNavigationBarType.fixed,
                    onTap: (index) => {
                      if (account_key.currentState != null)
                        {
                          if (account_key.currentState!.isEndDrawerOpen)
                            {
                              account_key.currentState?.closeEndDrawer(),
                            },
                        },
                      controller.switchTab(index),
                    },
                    currentIndex: controller.selectedTab.value,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: AppColors.kIconColor,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    selectedFontSize: Dimens.currentSize(context, 10, 12, 14),
                    unselectedFontSize: Dimens.currentSize(context, 10, 12, 14),
                    items: [
                      _bottomButton(Assets.home_nav, AppString().home(context), Assets.home_unselected),
                      _bottomButton(Assets.myplan_nav, AppString().myplans(context), Assets.myplan_nav),
                      _bottomButton(Assets.shopping_selected, AppString().buyplans(context), Assets.explore_plan),
                      _bottomButton(Assets.contactus_selected, AppString().contactus(context), Assets.contact_us),
                    ],
                  ),
                ),
              ),
            ],
          )),
      body: Container(
        color: AppColors.homeBGColor,
        child: Obx(() => IndexedStack(
              index: controller.selectedTab.value,
              children: [
                AccountView(
                  isActive: widget.isActive,
                  accountTab: widget.accountTab,
                  account_key: account_key,
                  callback: (val) => openDrawer(val),
                ),
                const ManagePlansView(),
                const DestinationView(
                  isFromHome: true,
                  isFromDrawer: false,
                ),
                SupportView(isFromHome: true),
              ],
            )),
      ),
    );
  }

  void openDrawer(String val) {
    home_key.currentState!.openEndDrawer();
  }

  BottomNavigationBarItem _bottomButton(String icon, String label, String inactiveIcon) {
    return BottomNavigationBarItem(
        activeIcon: Container(
          margin: const EdgeInsets.only(bottom: 7),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.bgButtonColor,
                  blurRadius: 35.0,
                  spreadRadius: 5, //New
                )
              ],
            ),
            child: SvgPicture.asset(
              icon,
              color: Colors.white,
            ),
          ),
        ),
        icon: Container(
          margin: const EdgeInsets.only(bottom: 7),
          height: 28,
          width: 28,
          child: SvgPicture.asset(
            inactiveIcon,
            height: 28,
            width: 28,
            color: AppColors.kIconColor,
          ),
        ),
        label: label);
  }
}
