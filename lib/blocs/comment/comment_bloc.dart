

import 'package:petcare/blocs/comment/comment_event.dart';
import 'package:petcare/blocs/comment/comment_state.dart';
import 'package:petcare/exceptions/app_exceptions.dart';
import 'package:petcare/models/comment_model.dart';
import 'package:petcare/repos/comment/comment_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentStateInitial()) {
    // OnAdd Comment Event
    on<CommentEventAdd>(
      (event, emit) async {
        try {
          emit(CommentStateAdding());
          final CommentModel comment = await CommentRepo.addComment(
              postId: event.postId,
              comment: event.comment,
              contentId: event.contentId);
          emit(CommentStateAdded(comment: comment));
        } on AppException catch (e) {
          emit(CommentStateAddFailure(exception: e));
        }
      },
    );

    /// OnFetch Comments for Post Event Trigger
    on<CommentEventFetchForPost>(
      (event, emit) async {
        try {
          emit(CommentStateFetchingForPost());
          final List<CommentModel> comments = await CommentRepo.fetchComments(
            forPost: event.postId,
            onGetLastDocSnap: (lasDoc) {
              emit(CommentStateLastSnapForPost(lastDocSnapshot: lasDoc));
            },
            lastDoc: event.lastDoc,
          );
          emit(CommentStateFetchedForPost(comments: comments));
        } on AppException catch (e) {
          emit(CommentStateFetchFailureForPost(exception: e));
        }
      },
    );

    /// OnFetch Comments for Comment Event Trigger
    on<CommentEventFetchForComments>(
      (event, emit) async {
        try {
          emit(CommentStateFetchingForComment());
          final List<CommentModel> comments =
              await CommentRepo.fetchCommentsFor(
            commentId: event.commentId,
            onGetLastDocSnap: (lasDoc) {
              emit(CommentStateLastSnapForComment(lastDocSnapshot: lasDoc));
            },
            lastDoc: event.lastDoc,
          );
          emit(CommentStateFetchedForComment(comments: comments));
        } on AppException catch (e) {
          emit(CommentStateFetchFailureForComment(exception: e));
        }
      },
    );
  }
}
