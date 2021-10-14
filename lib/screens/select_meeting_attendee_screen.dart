import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_mobile/models/models.dart';
import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef OnSelectAttendee = Future Function(Contact contact);

class SelectMeetingAttendeeScreen extends StatelessWidget {
  final OnSelectAttendee onSelectAttendee;
  final List<Contact> addedContacts;

  const SelectMeetingAttendeeScreen({
    Key? key,
    required this.onSelectAttendee,
    required this.addedContacts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthenticatedScaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text("Select an attendee"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // SearchField(),
              StreamBuilder(
                stream: DotModel().allContactsQuery.snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Contact>> snapshot,
                ) {
                  final addedAttendeeIds = addedContacts.map((e) => e.uid);
                  if (snapshot.hasData) {
                    final tiles = snapshot.data!.docs
                        .where(
                      (e) => !addedAttendeeIds.contains(e.id),
                    )
                        .map((e) {
                      return ListTile(
                        onTap: () {
                          onSelectAttendee(e.data());
                          Get.back();
                        },
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
                      );
                    }).toList();

                    if (tiles.isEmpty) {
                      return Align(
                        alignment: Alignment.center,
                        child: Container(
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
            ],
          ),
        ),
      ),
      active: 3,
    );
  }
}
