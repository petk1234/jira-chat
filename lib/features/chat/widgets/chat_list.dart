import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jira_project/controllers/auth.dart';
import 'package:jira_project/controllers/jira.dart';
import 'package:jira_project/features/chat/widgets/comment.dart';
import 'package:provider/provider.dart';

class ChatList extends StatelessWidget {
  final Function(BuildContext) openKeyBoard;
  ChatList({Key? key, required this.openKeyBoard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<JiraState>(context).chatComments;
    return Flexible(
        child: ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      reverse: true,
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final isAuthorizedComment = comments[index].author.emailAddress ==
            Provider.of<AuthState>(context).user!.emailAddress;
        return Row(
            mainAxisAlignment: isAuthorizedComment
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              isAuthorizedComment
                  ? Comment(comment: comments[index])
                  : Dismissible(
                      key: ValueKey<int>(int.parse(comments[index].comment.id)),
                      child: Comment(comment: comments[index]),
                      onDismissed: null,
                      background: _buildResponseBg(),
                      direction: DismissDirection.startToEnd,
                      confirmDismiss: (direction) async {
                        Provider.of<JiraState>(context, listen: false)
                            .setSelectedComment(comments[index]);
                        openKeyBoard(context);
                        return false;
                      },
                    )
            ]);
      },
    ));
  }

  Widget _buildResponseBg() {
    return Container(
      color: Colors.blue,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.reply, color: Colors.white),
          SizedBox(width: 8),
          Text('Reply', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
