import 'package:dot_mobile/screens/contact_screen.dart';
import 'package:dot_mobile/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class AuthenticatedScaffold extends StatelessWidget {
  final HideNavbar hiding = HideNavbar();
  final int active;
  final Widget body;
  final FloatingActionButton? floatingActionButton;

  AuthenticatedScaffold({
    Key? key,
    required this.active,
    required this.body,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: SingleChildScrollView(child: body),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: hiding.visible,
        builder: (context, bool value, child) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: value ? 128 : 0.0,
          child: bottomBar(),
          curve: Curves.easeInOut,
        ),
      ),
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
            onPressed: () {},
          ),
          _buildBottomNavigationBarButton(
            active: active == 1,
            iconData: Icons.messenger_outline,
            onPressed: () {},
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
          ),
          _buildBottomNavigationBarButton(
            active: active == 4,
            iconData: Icons.settings,
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBarButton({
    required bool active,
    required IconData iconData,
    required VoidCallback onPressed,
  }) {
    return TextButton(
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
