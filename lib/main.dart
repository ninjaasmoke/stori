import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/components/SnackBarWidget.dart';
import 'package:stori/logic/RecomendedBooksBloc.dart';
import 'package:stori/logic/SearchBooksLogic.dart';
import 'package:stori/logic/UserLogic.dart';
import 'package:stori/pages/App.dart';
import 'package:stori/pages/Init.dart';
import 'package:stori/pages/Login.dart';
import 'package:stori/pages/NoConnectivity.dart';
import 'package:stori/theme.dart';

var res;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  res = await (Connectivity().checkConnectivity());
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
        BlocProvider<RecBooksBloc>(
          create: (context) => RecBooksBloc()..add(FetchRecBooksEvent()),
        ),
        BlocProvider<SearchBooksBloc>(
          create: (context) => SearchBooksBloc(),
        ),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: MaterialApp(
          title: 'Stori',
          theme: themeData,
          debugShowCheckedModeBanner: false,
          home: BlocConsumer<UserBloc, UserState>(
            builder: (context, state) {
              if (res == ConnectivityResult.none) {
                return NoConnectivityPage();
              }
              if (state is InitUserState || state is LoadingUserState) {
                return InitPage();
              }
              if (state is LoggedInUserState) {
                return AppPage();
              }
              if (state is LoggedOutUserState || state is LoggingInUserState) {
                return LoginPage();
              }
              return InitPage();
            },
            listener: (context, state) {
              if (res != ConnectivityResult.none) {
                if (state is LoadingUserState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(text: "Loading..."),
                  );
                } else if (state is ErrorUserState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(text: state.errorMessage, milli: 10000),
                  );
                } else if (state is LoggingInUserState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(text: 'Logging in...', milli: 10000),
                  );
                } else if (state is LoggedInUserState) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(
                      text: "Welcome ${state.user.username}",
                      milli: 2000,
                    ),
                  );
                }
                //  else if (state is LoggedOutUserState) {

                // }
              }
            },
          ),
        ),
      ),
    );
  }
}
