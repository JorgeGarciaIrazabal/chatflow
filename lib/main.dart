import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatflow/src/core/services/error_handler_service.dart';
import 'package:chatflow/src/features/auth/controllers/auth_controller.dart';
import 'package:chatflow/src/features/auth/repository/auth_repository.dart';
import 'package:chatflow/src/features/auth/ui/login_screen.dart';
import 'package:chatflow/src/features/chat/controllers/chat_controller.dart';
import 'package:chatflow/src/features/chat/repository/chat_repository.dart';
import 'package:chatflow/src/features/chat/ui/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up global error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    ErrorHandlerService.handleError(details.exception, details.stack!);
  };
  
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  runApp(MyApp(preferences: preferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;

  const MyApp({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(preferences),
        ),
        ChangeNotifierProvider<AuthController>(
          create: (context) => AuthController(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Chatflow',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Consumer<AuthController>(
          builder: (context, authController, child) {
            if (authController.isAuthenticated) {
              return ChangeNotifierProvider<ChatController>(
                create: (context) => ChatController(
                  chatRepository: ChatRepository(
                    authRepository: context.read<AuthRepository>(),
                  ),
                ),
                child: const ChatScreen(),
              );
            } else if (!authController.isAuthenticated) {
              return const LoginScreen();
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
