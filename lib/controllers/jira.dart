import 'package:flutter/material.dart';
import 'package:jira_project/data/models/user.dart';
import 'package:jira_project/domain/entities/chat_comment.dart';
import 'package:jira_project/domain/repository/jira_repository.dart';
import 'package:collection/collection.dart';

class JiraState extends ChangeNotifier {
  final JiraRepository jiraRepository;
  JiraState({required this.jiraRepository});

  List<ChatComment> chatComments = [];
  LoadingType loadingType = LoadingType.initial;
  ChatComment? selectedComment;
  List<User> users = [];

  Future<List<ChatComment>?> getChatComments({String? email}) async {
    try {
      loadingType = LoadingType.loading;
      users = await jiraRepository.getAllUsers() ?? [];
      notifyListeners();
      chatComments = await jiraRepository.prepareChatComments(
              email: email, users: users) ??
          [];
      loadingType = LoadingType.loaded;
      notifyListeners();
      return chatComments;
    } catch (e) {
      print(e);
      loadingType = LoadingType.error;
      notifyListeners();
    }
  }

  setSelectedComment(ChatComment comment) {
    selectedComment = comment;
    notifyListeners();
  }

  postComment(String text) async {
    loadingType = LoadingType.loading;
    notifyListeners();
    final names = _splitOnNamedTags(text);
    final updText = enableCommentTags(names, text);
    final newComment =
        await jiraRepository.postComment(selectedComment!, updText ?? text);
    if (newComment != null) {
      final refreshedComments = await getChatComments();
      chatComments = refreshedComments ?? chatComments;
      loadingType = LoadingType.loaded;
      selectedComment = null;
      notifyListeners();
    }
  }

  List<String> _splitOnNamedTags(String text) {
    final isSomeoneMentioned = text.contains('@');
    if (isSomeoneMentioned) {
      final mentionedUser = text.split('@{')[1].split('}')[0];
      final restText = text
          .split('}')
          .indexed
          .fold<List<String>>([], (acc, entries) {
            final (index, element) = entries;
            if (index > 0) {
              return [...acc, element];
            }
            return acc;
          })
          .toList()
          .join('}');
      return [mentionedUser, ..._splitOnNamedTags(restText)];
    }
    return [];
  }

  enableCommentTags(List<String> names, String text) {
    String? updText;
    if (names.isNotEmpty) {
      final List<User?> taggedUsers = names.map((name) {
        final user = users.firstWhereOrNull((user) {
          return user.displayName.trim() == name.trim();
        });
        return user;
      }).toList();
      if (taggedUsers.any((el) => el == null)) {
        loadingType = LoadingType.loaded;
        notifyListeners();
        throw ('Tagged user(s) not found');
      }
      updText = names.indexed.fold<String>(text, (acc, userEntry) {
        final (index, name) = userEntry;
        String newText = text.replaceAll(
            '@{$name}', '[~accountId:${taggedUsers[index]!.userId}]');
        return newText;
      });
    };
    return updText;
  }
}

enum LoadingType { initial, loading, loaded, error }
