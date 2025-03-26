import 'package:petcare/exceptions/app_exceptions.dart';
import 'package:petcare/models/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CommentState {
  final bool isLoading;

  CommentState({this.isLoading = false});
}

/// initial State
class CommentStateInitial extends CommentState {}

// =========================== Add Comment States ================================
class CommentStateAdding extends CommentState {
  CommentStateAdding({super.isLoading = true});
}

class CommentStateAddFailure extends CommentState {
  final AppException exception;

  CommentStateAddFailure({required this.exception});
}

class CommentStateAdded extends CommentState {
  final CommentModel comment;

  CommentStateAdded({required this.comment});
}

// ===========================Fetch for Post================================
class CommentStateFetchingForPost extends CommentState {
  CommentStateFetchingForPost({super.isLoading = true});
}

class CommentStateFetchFailureForPost extends CommentState {
  final AppException exception;

  CommentStateFetchFailureForPost({required this.exception});
}

class CommentStateFetchedForPost extends CommentState {
  final List<CommentModel> comments;

  CommentStateFetchedForPost({required this.comments});
}

class CommentStateLastSnapForPost extends CommentState {
  final DocumentSnapshot? lastDocSnapshot;

  CommentStateLastSnapForPost({this.lastDocSnapshot});
}

// ===========================Fetch For Comments================================
class CommentStateFetchingForComment extends CommentState {
  CommentStateFetchingForComment({super.isLoading = true});
}

class CommentStateFetchFailureForComment extends CommentState {
  final AppException exception;

  CommentStateFetchFailureForComment({required this.exception});
}

class CommentStateFetchedForComment extends CommentState {
  final List<CommentModel> comments;

  CommentStateFetchedForComment({required this.comments});
}

class CommentStateLastSnapForComment extends CommentState {
  final DocumentSnapshot? lastDocSnapshot;

  CommentStateLastSnapForComment({this.lastDocSnapshot});
}
