import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_mobile/models/models.dart';
import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_contact_screen.dart';

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
                  stream: DotModel().contactDbRef.snapshots(),
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
                          onTap: () {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor:
                                  Get.theme.scaffoldBackgroundColor,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 72,
                                        height: 72,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            e.data().avatar,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16.0,
                                        ),
                                        child: Text(
                                          e.data().fullName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              context: context,
                            );
                          },
                        );
                      }).toList();

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
