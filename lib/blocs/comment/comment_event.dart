
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CommentEvent {}

/// Add Comment
class CommentEventAdd extends CommentEvent {
  final String contentId;
  final String postId;
  final String comment;

  CommentEventAdd(
      {required this.contentId, required this.comment, required this.postId});
}

/// Fetch Comments For Post
class CommentEventFetchForPost extends CommentEvent {
  final String postId;
  final DocumentSnapshot? lastDoc;
  CommentEventFetchForPost({required this.postId, this.lastDoc});
}

/// Fetch Comments For Comment
class CommentEventFetchForComments extends CommentEvent {
  final String commentId;
  final DocumentSnapshot? lastDoc;
  CommentEventFetchForComments({required this.commentId, this.lastDoc});
}
