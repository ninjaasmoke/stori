import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:stori/components/CustomCachedImage.dart';
import 'package:stori/components/SnackBarWidget.dart';
import 'package:stori/constants.dart';
import 'package:stori/helper/utils.dart';
import 'package:stori/logic/UserBloc.dart';
import 'package:stori/models/UserModel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(),
          body: state is LoggedInUserState
              ? _body(context, state.user)
              : Center(),
        );
      },
      listener: (context, state) {
        if (state is LoggingOutUserState) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(text: state.loggingOutMessage, milli: 2000),
          );
        }
        if (state is LoggedOutUserState) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(text: "Logged Out!", milli: 2000),
          );
          Navigator.pop(context);
        }
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

  Widget _body(BuildContext context, AppUser user) {
    return Column(
      children: [
        _profileBanner(user.photoURL, user.username),
        _tellFriendsBanner(context),
        // Create a logout button
        ListTile(
          onTap: () {
            context.read<UserBloc>().add(LogoutUserEvent());
          },
          title: Text(
            'Sign Out',
            style: TextStyle(
              color: tertiaryTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileBanner(String? userPhoto, String? userName) {
    return Container(
      color: scaffoldBGColor,
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: 12.0,
          ),
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
            height: 20.0,
          ),
          Text(
            userName!,
            style: TextStyle(
              color: secondaryTextColor,
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.edit,
              color: tertiaryTextColor,
              size: 16,
            ),
            label: Text(
              "Manage Profile",
              style: TextStyle(
                color: tertiaryTextColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _copyLink() {
    return Container(
      decoration: BoxDecoration(
        color: scaffoldBGColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.only(right: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                COPY_LINK_URL,
                style: TextStyle(color: secondaryTextColor),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: primaryTextColor,
            ),
            onPressed: () async {
              await onCopyData(copyLink: COPY_LINK_URL);
            },
            child: Text("Copy Link", style: TextStyle(color: darkTextColor)),
          )
        ],
      ),
    );
  }

  Widget _tellFriendsBanner(BuildContext context) {
    return Container(
      color: tileColor,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.message_rounded,
                color: secondaryTextColor,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                "Tell friends about Stori.",
                style: TextStyle(
                  color: secondaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              )
            ],
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            "Share so friends can hear about the books you have and can tell you about the books they have.",
            style: TextStyle(
              color: secondaryTextColor,
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          _copyLink(),
          TextButton.icon(
            onPressed: () {
              onShareData(context, "Stori", SHARE_LINK);
            },
            icon: Icon(
              Icons.share,
              color: secondaryTextColor,
              size: 16,
            ),
            label: Text(
              "Share",
              style: TextStyle(
                color: secondaryTextColor,
              ),
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
        ],
      ),
    );
  }
}
