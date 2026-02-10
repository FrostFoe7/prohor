import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client()
      .setEndpoint("https://sgp.cloud.appwrite.io/v1")
      .setProject("695103540022da68cbb9");
  Account account = Account(client);

  runApp(MaterialApp(
    title: 'Prohor App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ),
    home: MyApp(account: account),
  ));
}

class MyApp extends StatefulWidget {
  final Account account;
  const MyApp({super.key, required this.account});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  models.User? loggedInUser;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool isLogin = true;
  bool isLoading = false;

  Future<void> handleAuth() async {
    setState(() => isLoading = true);
    try {
      if (isLogin) {
        await widget.account.createEmailPasswordSession(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        await widget.account.create(
          userId: ID.unique(),
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
        );
        await widget.account.createEmailPasswordSession(
          email: emailController.text,
          password: passwordController.text,
        );
      }
      final user = await widget.account.get();
      setState(() => loggedInUser = user);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> logout() async {
    setState(() => isLoading = true);
    try {
      await widget.account.deleteSession(sessionId: 'current');
      setState(() => loggedInUser = null);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: WContainer(
              className: 'max-w-md w-full',
              child: loggedInUser != null ? _buildDashboard() : _buildAuthForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return WCard(
      className: 'shadow-2xl rounded-3xl p-10 bg-white',
      child: WFlex(
        className: 'flex-col items-center gap-6',
        children: [
          WContainer(
            className: 'p-4 bg-indigo-50 rounded-full',
            child: const Icon(Icons.person_rounded, size: 48, color: Color(0xFF6366F1)),
          ),
          WFlex(
            className: 'flex-col items-center gap-1',
            children: [
              WText('Welcome back,', className: 'text-gray-500 text-lg'),
              WText(loggedInUser!.name, className: 'text-3xl font-extrabold text-gray-900'),
              WText(loggedInUser!.email, className: 'text-gray-400 text-sm'),
            ],
          ),
          const Divider(height: 40),
          ElevatedButton.icon(
            onPressed: isLoading ? null : logout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[50],
              foregroundColor: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthForm() {
    return WFlex(
      className: 'flex-col items-stretch gap-8',
      children: [
        const Center(
          child: Icon(Icons.bolt_rounded, size: 64, color: Color(0xFF6366F1)),
        ),
        WFlex(
          className: 'flex-col gap-2',
          children: [
            WText(
              isLogin ? 'Welcome Back' : 'Get Started',
              className: 'text-4xl font-black text-gray-900',
            ),
            WText(
              isLogin ? 'Login to your account' : 'Create a new account',
              className: 'text-gray-500 text-lg',
            ),
          ],
        ),
        WFlex(
          className: 'flex-col gap-4',
          children: [
            if (!isLogin)
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email Address',
                prefixIcon: Icon(Icons.mail_outline),
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: isLoading ? null : handleAuth,
          child: isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(isLogin ? 'Sign In' : 'Sign Up'),
        ),
        Center(
          child: TextButton(
            onPressed: () => setState(() => isLogin = !isLogin),
            child: WFlex(
              className: 'flex-row gap-1',
              children: [
                WText(isLogin ? "New here?" : "Joined already?", className: 'text-gray-500'),
                WText(
                  isLogin ? "Create account" : "Sign in",
                  className: 'text-indigo-600 font-bold',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
