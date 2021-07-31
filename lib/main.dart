import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/logic/UserBloc.dart';
import 'package:stori/pages/App.dart';
import 'package:stori/pages/Init.dart';
import 'package:stori/pages/Login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Stori',
        home: BlocConsumer<UserBloc, UserState>(
          builder: (context, state) {
            if (state is InitUserState || state is LoadingUserState) {
              return InitPage();
            }
            if (state is LoggedInUserState) {
              return AppPage();
            }
            if (state is LoggedOutUserState) {
              return LoginPage();
            }
            return InitPage();
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
