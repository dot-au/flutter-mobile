import 'package:dot_mobile/screens/calendar_screen.dart';
import 'package:dot_mobile/screens/contact_screen.dart';
import 'package:dot_mobile/screens/home_screen.dart';
import 'package:dot_mobile/screens/message_screen.dart';
import 'package:dot_mobile/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class AuthenticatedScaffold extends StatelessWidget {
  final HideNavbar hiding = HideNavbar();
  final int active;
  final Widget body;
  final FloatingActionButton? floatingActionButton;
  final PreferredSizeWidget? appBar;

  AuthenticatedScaffold({
    Key? key,
    required this.active,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: body,
          ),
        );
      }),
      bottomNavigationBar: appBar == null
          ? ValueListenableBuilder(
              valueListenable: hiding.visible,
              builder: (context, bool value, child) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: value ? 128 : 0.0,
                child: bottomBar(),
                curve: Curves.easeInOut,
              ),
            )
          : null,
    );
  }

  Widget bottomBar() {
    return Container(
      height: 128,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomNavigationBarButton(
            active: active == 0,
            iconData: Icons.calendar_today_outlined,
            onPressed: () {
              Get.offAll(() => CalendarScreen(), transition: Transition.fadeIn);
            },
          ),
          _buildBottomNavigationBarButton(
            active: active == 1,
            iconData: Icons.messenger_outline,
            onPressed: () {
              Get.offAll(() => MessageScreen(), transition: Transition.fadeIn);
            },
          ),
          _buildBottomNavigationBarButton(
            active: active == 2,
            iconData: Icons.home_outlined,
            onPressed: () {
              Get.offAll(() => HomeScreen(), transition: Transition.fadeIn);
            },
          ),
          _buildBottomNavigationBarButton(
            active: active == 3,
            iconData: Icons.people_outline,
            onPressed: () {
              Get.offAll(() => ContactScreen(), transition: Transition.fadeIn);
            },
            key: ValueKey("contactScreenButton"),
          ),
          _buildBottomNavigationBarButton(
            active: active == 4,
            iconData: Icons.settings,
            onPressed: () {
              Get.offAll(() => SettingsScreen(), transition: Transition.fadeIn);
            },
            key: ValueKey("settingsScreenButton"),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBarButton(
      {required bool active,
      required IconData iconData,
      required VoidCallback onPressed,
      Key? key}) {
    return TextButton(
      key: key,
      style: TextButton.styleFrom(
        backgroundColor: active ? const Color(0xFFF9AA33) : Colors.white,
        shape: CircleBorder(),
        padding: EdgeInsets.all(12.0),
      ),
      child: Icon(
        iconData,
        color: const Color(0xFF5F5F5F),
      ),
      onPressed: onPressed,
    );
  }
}

class HideNavbar {
  final ScrollController controller = ScrollController();
  final ValueNotifier<bool> visible = ValueNotifier<bool>(true);

  HideNavbar() {
    visible.value = true;
    controller.addListener(
      () {
        final scrollDirection = controller.position.userScrollDirection;
        if (scrollDirection == ScrollDirection.reverse) {
          if (visible.value) {
            visible.value = false;
          }
        }

        if (scrollDirection == ScrollDirection.forward ||
            scrollDirection == ScrollDirection.idle) {
          if (!visible.value) {
            visible.value = true;
          }
        }
      },
    );
  }

  void dispose() {
    controller.dispose();
    visible.dispose();
  }
}
