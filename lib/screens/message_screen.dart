import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:flutter/material.dart';

import 'contact_screen.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticatedScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            SearchField(),
          ]),
        ),
      ),
      active: 1,
    );
  }
}
