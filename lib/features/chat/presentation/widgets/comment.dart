import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jira_project/features/auth/presentation/controllers/auth.dart';
import 'package:jira_project/features/chat/domain/entities/chat_comment.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Comment extends StatelessWidget {
  final ChatComment comment;
  const Comment({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final commentOfCurrentUser = comment.author.emailAddress ==
        Provider.of<AuthState>(context, listen: false).user!.emailAddress;

    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.systemGrey),
          borderRadius: BorderRadius.circular(16),
          color: commentOfCurrentUser
              ? CupertinoColors.activeGreen.withOpacity(0.2)
              : CupertinoColors.systemGrey6,
        ),
        width: MediaQuery.of(context).size.width * 0.7,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              _buildContent(commentOfCurrentUser),
              const SizedBox(height: 8),
              _buildTimeStamp()
            ])
        )
    );
  }

  Widget _buildContent(bool commentOfCurrentUser){
    final commentURL = comment.comment.link.split('/rest')[0] +
        '/browse/' +
        comment.issue.key +
        '?focusedCommentId=' +
        comment.comment.id;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('IN PROJECT ${comment.project.name}'),
          if (!commentOfCurrentUser)
            Text('BY ${comment.author.displayName}'),
          Text('IN CARD ${comment.issue.key}'),
          if (!commentOfCurrentUser)
            Flexible(
                child: Text(
                    'WITH DESCRIPTION ${comment.issue.description?.trim()}')),
          Flexible(
              child: Text(
                  'ADDED COMMENT ${comment.comment.body.trim()}')),
          const Text('Jira link: '),
          Flexible(
              child: InkWell(
                onTap: () async {
                  await launchUrl(Uri.parse(commentURL));
                },
                child: Text(commentURL,
                    style: const TextStyle(color: Colors.blue)),
              ))
        ]);
  }

  _buildTimeStamp(){
    final dateFormatter = DateFormat('HH:mm');
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            dateFormatter.format(comment.comment.createdAt),
            style: const TextStyle(fontSize: 12),
          ),
        ]);
  }
}
