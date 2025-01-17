import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jira_project/features/chat/presentation/controllers/jira.dart';
import 'package:provider/provider.dart';

class Keyboard extends StatelessWidget {
  final TextEditingController controller;
  const Keyboard({super.key, required this.controller});

  _handleSend(BuildContext context, bool isCommentSelected) => () async {
        try {
          if (!isCommentSelected) {
            return;
          }
          await Provider.of<JiraState>(context, listen: false)
              .postComment(controller.text);
          controller.clear();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.55),
              content: Text(e.toString())
          )
          );
        }
      };

  @override
  Widget build(BuildContext context) {
    final isCommentSelected =
        Provider.of<JiraState>(context, listen: false).selectedComment != null;
    return Container(
      height: 85,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type Your Message',
                ),
                focusNode: Provider.of<JiraState>(context, listen: false).inputNode,
                controller: controller,
              ),
            ),
            CupertinoButton(
              child: Provider.of<JiraState>(context, listen: true).loadingType == LoadingType.loading
                      ? CircularProgressIndicator()
                      : Icon(CupertinoIcons.paperplane),
              onPressed: _handleSend(context, isCommentSelected),
              disabledColor: isCommentSelected ? Colors.white : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
