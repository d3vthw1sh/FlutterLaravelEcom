import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFFCCFF00);
    const black = Colors.black;

    return BottomNavigationBar(
      backgroundColor: neonGreen,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: black,
      unselectedItemColor: Colors.black54,
      showUnselectedLabels: true,

      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/products');
            break;
          case 1:
            context.go('/cart');
            break;
          case 2:
            context.go('/profile');
            break;
        }
      },

      items: const [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
        ),

        BottomNavigationBarItem(
          label: "Cart",
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
        ),

        BottomNavigationBarItem(
          label: "Profile",
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
        ),
      ],
    );
  }
}
