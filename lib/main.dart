import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatflow/src/core/services/error_handler_service.dart';
import 'package:chatflow/src/features/auth/bloc/auth_bloc.dart';
import 'package:chatflow/src/features/auth/bloc/auth_event.dart';
import 'package:chatflow/src/features/auth/bloc/auth_state.dart';
import 'package:chatflow/src/features/auth/repository/auth_repository.dart';
import 'package:chatflow/src/features/auth/ui/login_screen.dart';
import 'package:chatflow/src/features/chat/bloc/chat_bloc.dart';
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
    return RepositoryProvider(
      create: (context) => AuthRepository(preferences),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
        )..add(AuthCheckStatusEvent()),
        child: MaterialApp(
          title: 'Chatflow',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return RepositoryProvider(
                  create: (context) => ChatRepository(
                    authRepository: context.read<AuthRepository>(),
                  ),
                  child: BlocProvider(
                    create: (context) => ChatBloc(
                      chatRepository: context.read<ChatRepository>(),
                    ),
                    child: const ChatScreen(),
                  ),
                );
              } else if (state is AuthUnauthenticated) {
                return const LoginScreen();
              } else {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
