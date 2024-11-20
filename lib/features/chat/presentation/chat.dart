import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jira_project/features/auth/presentation/controllers/auth.dart';
import 'package:jira_project/features/chat/domain/entities/chat_comment.dart';
import 'package:jira_project/features/chat/presentation/controllers/jira.dart';
import 'package:jira_project/features/chat/presentation/widgets/chat_list.dart';
import 'package:jira_project/features/chat/presentation/widgets/keyboard.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController controller = TextEditingController();
  Future<List<ChatComment>?>? _future;
  Timer? _timer;

  setUpTimedFetch() {
    Timer.periodic(const Duration(seconds: 90), (timer) {
      _timer = _timer ?? timer;
      setState(() {
        _future = Provider.of<JiraState>(context, listen: false)
            .getChatComments(
                email: Provider.of<AuthState>(context, listen: false)
                    .user!
                    .emailAddress) as Future<List<ChatComment>?>?;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _future = Provider.of<JiraState>(context, listen: false)
            .getChatComments(
                email: Provider.of<AuthState>(context, listen: false)
                    .user!
                    .emailAddress);
      });
    });
    setUpTimedFetch();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Chat'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              return Column(children: [
                if (!snapshot.hasData)
                  const Expanded(child:
                    Column(children: [
                      Expanded(child:
                        Center(child: CircularProgressIndicator())
                      ),
                    ])
                  )

                else if ((snapshot.connectionState == ConnectionState.waiting &&
                        Provider.of<JiraState>(context, listen: true)
                            .chatComments
                            .isNotEmpty) ||
                    snapshot.connectionState == ConnectionState.done)
                  ...[const ChatList()],

                Keyboard(controller: controller),
              ]);
            },
          ),
        ));
  }
}
