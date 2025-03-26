import 'package:petcare/blocs/post/post_event.dart';
import 'package:petcare/blocs/post/post_status.dart';
import 'package:petcare/exceptions/app_exceptions.dart';
import 'package:petcare/repos/post/post_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostStateInitial()) {
    /// on Create Post Event trigger
    on<PostEventCreate>(
      (event, emit) async {
        try {
          emit(PostStateCreating());
          await PostRepo.create(model: event.model);
          emit(PostStateCreated());
        } on AppException catch (e) {
          emit(PostStateCreateFailure(exception: e));
        }
      },
    );

    /// on Update Post Event trigger
    on<PostEventUpdate>(
      (event, emit) async {
        try {
          emit(PostStateUpdating());
          final post = await PostRepo.update(model: event.model);
          emit(PostStateUpdated(model: post));
        } on AppException catch (e) {
          emit(PostStateUpdateFailure(exception: e));
        }
      },
    );

    /// on Fetch Own Posts Event trigger
    on<PostEventFetchOwn>(
      (event, emit) async {
        try {
          emit(PostStateFetchingOwn());
          await PostRepo.fetchOwn();
          emit(PostStateFetchedOwn());
        } on AppException catch (e) {
          emit(PostStateFetchOwnFailure(exception: e));
        }
      },
    );

    /// on Fetch All Posts Event trigger
    on<PostEventFetchAll>(
      (event, emit) async {
        try {
          emit(PostStateFetchingAll());
          await PostRepo.fetchAll(event.isFetchNew);
          emit(PostStateFetchedAll());
        } on AppException catch (e) {
          emit(PostStateFetchAllFailure(exception: e));
        }
      },
    );

    /// on Delete Post Event Trigger
    on<PostEventDelete>(
      (event, emit) async {
        PostRepo.delete(uuid: event.uuid);
        emit(PostStateDeleted(uuid: event.uuid));
      },
    );
  }
}
