import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/components/CustomCachedImage.dart';
import 'package:stori/constants.dart';
import 'package:stori/logic/UserBloc.dart';
import 'package:stori/models/UserModel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(),
          body: state is LoggedInUserState ? _body(state.user) : Center(),
        );
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: appBarBGColor,
      automaticallyImplyLeading: true,
      title: Text('Profile & More'),
    );
  }

  Widget _body(AppUser user) {
    return Column(
      children: [_profileBanner(user.photoURL, user.username)],
    );
  }

  Widget _profileBanner(String? userPhoto, String? userName) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      color: scaffoldBGColor,
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: customCachedNetworkImage(url: userPhoto!),
              ),
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            userName!,
            style: TextStyle(
              color: tertiaryTextColor,
            ),
          )
        ],
      ),
    );
  }
}
