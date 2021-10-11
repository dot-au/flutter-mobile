import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_mobile/models/models.dart';
import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../themes.dart';
import 'add_contact_screen.dart';
import 'contact_details_screen.dart';

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticatedScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => AddContactScreen());
        },
        label: Text(
          "Add Contact",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFF9AA33),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SearchField(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: StreamBuilder(
                  stream: DotModel().allContactsQuery.snapshots(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Contact>> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      final tiles = snapshot.data!.docs.map((e) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              e.data().avatar,
                            ),
                          ),
                          title: Text(
                            e.data().fullName,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: e.data().email.isNotEmpty
                              ? Builder(
                                  builder: (context) {
                                    final email = e.data().email;
                                    return FutureBuilder<QuerySnapshot>(
                                      future:
                                          DotModel().isUserOnDot(email).get(),
                                      builder: (context, snapshot) {
                                        return IconButton(
                                          icon: Icon(Icons.message),
                                          onPressed: () {
                                            if (snapshot.data!.docs.isEmpty) {
                                              showModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                backgroundColor: Get.theme
                                                    .scaffoldBackgroundColor,
                                                builder:
                                                    (BuildContext context) {
                                                  return SafeArea(
                                                    child: Wrap(children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Center(
                                                          child: Text(
                                                            "The user is not yet on Dot.",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 8.0,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Would you want to invite the user?",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child: Text(
                                                                "No",
                                                              ),
                                                              style: ButtonThemes
                                                                  .elevatedButtonThemeLight(),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                final Uri
                                                                    emailLaunchUri =
                                                                    Uri(
                                                                  scheme:
                                                                      'mailto',
                                                                  path: email,
                                                                  query: encodeQueryParameters(<
                                                                      String,
                                                                      String>{
                                                                    'subject':
                                                                        'I am on DOT. Join me!'
                                                                  }),
                                                                );

                                                                launch(emailLaunchUri
                                                                    .toString());
                                                                Get.back();
                                                              },
                                                              child: Text(
                                                                "Yes",
                                                              ),
                                                              style: ButtonThemes
                                                                  .elevatedButtonThemeLight(),
                                                            ),
                                                          ])
                                                    ]),
                                                  );
                                                },
                                                context: context,
                                              );
                                            } else {
                                              throw UnimplementedError();
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                )
                              : null,
                          onTap: () {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor:
                                  Get.theme.scaffoldBackgroundColor,
                              builder: (BuildContext context) {
                                return ContactDetailsScreen(contact: e.data());
                              },
                              context: context,
                            );
                          },
                        );
                      }).toList();

                      if (tiles.isEmpty) {
                        return Container(
                          margin: EdgeInsets.only(top: 64),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(1000)),
                            color: Colors.white,
                          ),
                          width: 240,
                          height: 240,
                          child: EmptyWidget(
                            hideBackgroundAnimation: true,
                            image: null,
                            packageImage: PackageImage.Image_2,
                            title: 'No contacts',
                            titleTextStyle: TextStyle(
                              fontSize: 22,
                              color: Color(0xff9da9c7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: tiles,
                        ).toList(),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      active: 3,
    );
  }
}

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(100000)),
      borderSide: BorderSide(
        width: 2,
        color: Colors.white,
      ),
    );
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          Icons.search_outlined,
          color: Colors.black,
        ),
        hintStyle: TextStyle(
          color: Colors.black,
        ),
        hintText: "Search a contact....",
        focusColor: Colors.black,
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}
