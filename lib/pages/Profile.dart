import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/components/CustomCachedImage.dart';
import 'package:stori/components/CustomPopUp.dart';
import 'package:stori/components/SnackBarWidget.dart';
import 'package:stori/constants.dart';
import 'package:stori/helper/utils.dart';
import 'package:stori/logic/UserLogic.dart';
import 'package:stori/models/UserModel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
            appBar: _appBar(),
            body: _body(
              context,
              state,
            ));
      },
      listener: (context, state) {
        if (state is LoggingOutUserState) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(text: state.loggingOutMessage, milli: 200),
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

  Widget _body(BuildContext context, UserState state) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          state is LoggedInUserState
              ? _profileBanner(state.user, context)
              : Container(
                  height: 204,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(accentcolor),
                  ),
                ),
          _tellFriendsBanner(context),
          _signoutButton(context),
        ],
      ),
    );
  }

  Widget _profileBanner(AppUser user, BuildContext context) {
    return Container(
      height: 204,
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
                child: customCachedNetworkImage(url: user.photoURL!),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            user.username!,
            style: TextStyle(
              color: secondaryTextColor,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              TextEditingController _usernameController =
                  new TextEditingController(
                text: user.username,
              );
              showOverlay(
                context: context,
                widgets: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextField(
                      controller: _usernameController,
                      autofocus: true,
                      style: TextStyle(
                        color: primaryTextColor,
                      ),
                      cursorColor: primaryTextColor,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: searchBarColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_usernameController.text.length > 0 &&
                          _usernameController.text != user.username) {
                        AppUser _updatedUser = AppUser(
                          displayName: user.displayName,
                          username: _usernameController.text,
                          uid: user.uid,
                          photoURL: user.photoURL,
                          email: user.email,
                          hasBooks: user.hasBooks,
                          wantBooks: user.wantBooks,
                          location: user.location,
                        );
                        Navigator.pop(context);
                        context
                            .read<UserBloc>()
                            .add(UpdateUserEvent(appUser: _updatedUser));
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                      child: Text(
                        "Update",
                        style: TextStyle(color: accentcolor),
                      ),
                    ),
                  ),
                ],
                barrierDismiss: false,
              );
            },
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
                size: 18.0,
                color: secondaryTextColor,
              ),
              SizedBox(
                width: 12.0,
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
            height: 16.0,
          ),
          Text(
            "Share so friends can hear about the books you have and can tell you about the books they have.",
            style: TextStyle(
              color: secondaryTextColor,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          _copyLink(),
          TextButton.icon(
            onPressed: () {
              onShareData(context, "Stori", SHARE_LINK);
            },
            icon: Icon(
              CupertinoIcons.share,
              color: secondaryTextColor,
              size: 17,
            ),
            label: Text(
              "Share Link",
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

  Widget _signoutButton(BuildContext context) {
    return ListTile(
      onTap: () {
        // context.read<UserBloc>().add(LogoutUserEvent());
        showOverlay(
          context: context,
          widgets: [
            Text(
              "Are you sure you want to sign out?",
              style: TextStyle(
                color: secondaryTextColor,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: secondaryTextColor),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.read<UserBloc>().add(LogoutUserEvent());
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                    child: Text(
                      "Sign Out",
                      style: TextStyle(color: accentcolor),
                    ),
                  ),
                ),
              ],
            )
          ],
          barrierDismiss: false,
        );
      },
      title: Text(
        'Sign Out',
        style: TextStyle(
          color: tertiaryTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
