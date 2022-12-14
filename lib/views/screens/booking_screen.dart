import 'package:flutter/material.dart';
import '../../models/user.dart';
import '/views/screens/registration_screen.dart';
import '/views/shared/main_menu_widget.dart';
import 'login_screen.dart';

class BookingScreen extends StatefulWidget {
  final User user;
  const BookingScreen({super.key, required this.user});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking'),
          actions: [
            IconButton(
                onPressed: _registrationForm,
                icon: const Icon(Icons.app_registration)),
            IconButton(onPressed: _loginForm, icon: const Icon(Icons.login)),
          ],
        ),
        body: const Center(
          child: Text('Booking'),
        ),
        drawer: MainMenuWidget(user: widget.user),
      ),
    );
  }

  void _registrationForm() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegistrationScreen()));
  }

  void _loginForm() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
