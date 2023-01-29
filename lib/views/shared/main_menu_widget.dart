import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../serverConfig.dart';
import '../screens/home_screen.dart';
import '../screens/catalogue_screen.dart';
import '/views/screens/profile_screen.dart';

class MainMenuWidget extends StatefulWidget {
  final User user;
  const MainMenuWidget({super.key, required this.user});

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name.toString()),
            accountEmail: Text(widget.user.email.toString()),
            currentAccountPicture: CachedNetworkImage(
              imageUrl:
                  "${ServerConfig.server}/assets/profile_image/${widget.user.id}.png",
              placeholder: (context, url) => const LinearProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(
                Icons.image_not_supported,
                size: 128,
              ),
            ),
          ),
          ListTile(
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => HomeScreen(user: widget.user)));
            },
          ),
          ListTile(
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => ProfileScreen(user: widget.user)));
            },
          ),
          ListTile(
            title: const Text("Catalogue"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) =>
                          CatalogueScreen(user: widget.user)));
            },
          ),
        ],
      ),
    );
  }
}
