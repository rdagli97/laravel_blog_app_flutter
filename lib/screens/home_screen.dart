import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/consts/palette.dart';
import 'package:laravel_my_blog_app/screens/create_post_screen.dart';
import 'package:laravel_my_blog_app/screens/posts_screen.dart';
import 'package:laravel_my_blog_app/screens/profile_screen.dart';
import 'package:laravel_my_blog_app/utils/navigate_to.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PostsScreen(),
    const ProfileScreen(),
  ];

  void _toggleScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: white,
        color: darkPurple,
        animationDuration: const Duration(milliseconds: 300),
        onTap: _toggleScreen,
        letIndexChange: (index) => true,
        items: const [
          Icon(Icons.home),
          Icon(Icons.person),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkPurple,
        onPressed: () {
          pushTo(
            context,
            const CreatePostScreen(
              title: 'Create new Post',
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
