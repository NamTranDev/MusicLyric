import 'package:flutter/material.dart';
import '../../../provider/bottom_bar_provider.dart';
import '../../../components/animated_bar.dart';
import '../../../components/background_widget.dart';
import '../../../constants.dart';
import '../../../model/rive_asset.dart';
import 'player_tab.dart';
import 'playlist_tab.dart';
import 'songs_tab.dart';
import '../../../services/player_manager.dart';
import '../../../services/service_locator.dart';
import '../../../utils/rive_utils.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class MainScreen extends StatefulWidget {
  static String routeName = '/main';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> _pages;

  late List<RiveAsset> bottomNavs;

  @override
  void initState() {
    super.initState();

    print('MainScreen');

    getIt<PlayerManager>().init();

    _pages = [ListSongScreen(), PlayerScreen(), PlaylistScreen()];

    bottomNavs = [
      RiveAsset("assets/rive/bottom_bar_item.riv",
          artboard: "Player",
          stateMachineName: "Player_Interactivity",
          title: "Player"),
      RiveAsset("assets/rive/bottom_bar_item.riv",
          artboard: "Player",
          stateMachineName: "Player_Interactivity",
          title: "Player"),
      RiveAsset("assets/rive/bottom_bar_item.riv",
          artboard: "Player",
          stateMachineName: "Player_Interactivity",
          title: "Player"),
    ];
  }

  @override
  void dispose() {
    getIt<PlayerManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BottomNavigationBarProvider>(
        create: (context) => BottomNavigationBarProvider(),
        builder: (context, child) => bodyMain(context));
  }

  Widget bodyMain(BuildContext context) {
    var provider = Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: provider.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: _pages,
              ),
            ),
            BackgroundWidget(
              child: bottombar(context),
              hasBackground: provider.currentPage == 1,
              color: backgroundColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget bottombar(BuildContext context) {
    var provider = Provider.of<BottomNavigationBarProvider>(context);
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        color: colorPrimary,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...List.generate(
            bottomNavs.length,
            (index) => GestureDetector(
              onTap: () {
                bottomNavs[index].input?.change(true);
                if (index != provider.currentPage) {
                  provider.currentPage = index;
                }
                Future.delayed(const Duration(seconds: 1), () {
                  bottomNavs[index].input?.change(false);
                });
              },
              child: SizedBox(
                height: 36,
                width: 36,
                child: Opacity(
                  opacity: bottomNavs[index] == bottomNavs[provider.currentPage]
                      ? 1
                      : 0.5,
                  child: RiveAnimation.asset(
                    bottomNavs.first.src,
                    artboard: bottomNavs[index].artboard,
                    onInit: (artboard) {
                      StateMachineController controller =
                          RiveUtils.getRiveController(artboard,
                              stateMachineName:
                                  bottomNavs[index].stateMachineName);

                      bottomNavs[index].input =
                          controller.findSMI("active") as SMIBool;
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
