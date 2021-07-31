import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stori/components/SnackBarWidget.dart';
import 'package:stori/constants.dart';
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
          create: (context) => UserBloc()..add(FetchUserEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Stori',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          accentColor: accentcolor,
          primaryColor: accentcolor,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<UserBloc, UserState>(
          builder: (context, state) {
            if (state is InitUserState || state is LoadingUserState) {
              return InitPage();
            }
            if (state is LoggedInUserState) {
              return AppPage();
            }
            if (state is LoggedOutUserState || state is ErrorUserState) {
              return LoginPage();
            }
            return LoginPage();
          },
          listener: (context, state) {
            if (state is LoadingUserState) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(text: "Loading..."),
              );
            }
            // else if (state is LoggedInUserState) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     customSnackBar(text: "Logged In!", milli: 2000),
            //   );
            // } else if (state is LoggedOutUserState) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     customSnackBar(text: "Logged Out!", milli: 2000),
            //   );
            // }
          },
        ),
      ),
    );
  }
}
