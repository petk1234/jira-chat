import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jira_project/controllers/auth.dart';
import 'package:jira_project/domain/entities/chat_comment.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Comment extends StatelessWidget {
  final ChatComment comment;
  Comment({required this.comment});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('HH:mm');
    final commentURL = comment.comment.link.split('/rest')[0] +
        '/browse/' +
        comment.issue.key +
        '?focusedCommentId=' +
        comment.comment.id;
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
              Column(
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
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jira link: '),
                          Flexible(
                              child: InkWell(
                            onTap: () async {
                              await launchUrl(Uri.parse(commentURL));
                            },
                            child: Text(commentURL,
                                style: TextStyle(color: Colors.blue)),
                          ))
                        ])
                  ]),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    dateFormatter.format(comment.comment.createdAt),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              )
            ])));
  }
}
