import '/exceptions/auth_exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../manager/app_manager.dart';
import '../../models/user_model.dart';
import '../../repos/user_repo.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserStateInitial()) {
    /// OnUpdateProfile Event
    on<UserEventUpdateProfile>(
      (event, emit) async {
        try {
          if (AppManager.currentUser == null) {
            emit(UserStateProfileUpdatingFailure(
                exception: AuthExceptionUserNotFound()));
            return;
          }
          UserModel user = AppManager.currentUser!;
          String? avatarUrl = user.avatar;

          if (event.avatar != null) {
            emit(UserStateAvatarUploading());
            avatarUrl =
                await UserRepo().uploadProfile(path: event.avatar ?? "");
            emit(UserStateAvatarUploaded());
            user = user.copyWith(avatar: avatarUrl);
          }
          if (event.phone != null || event.phone != "") {
            user = user.copyWith(phone: event.phone);
          }

          if (event.location != null) {
            user = user.copyWith(location: event.location);
          }

          if (event.name != null) {
            user = user.copyWith(name: event.name);
          }

          if (event.email != null) {
            user = user.copyWith(email: event.email);
          }

          emit(UserStateProfileUpdating());
          final UserModel updatedModel = await UserRepo().update(user: user);
          emit(UserStateProfileUpdated(user: updatedModel));
        } on AppException catch (e) {
          emit(UserStateProfileUpdatingFailure(exception: e));
        }
      },
    );

    /// OnFindUser
    on<UserEventFindBy>(
      (event, emit) async {
        try {
          emit(UserStateFinding());
          final List<UserModel> users = await UserRepo()
              .fetchUsersBy(searchText: event.searchText, bounds: event.bounds);
          emit(UserStateFinded(users: users));
        } on AppException catch (e) {
          emit(UserStateFindFailure(exception: e));
        }
      },
    );

    /// FetchSingleUser
    on<UserEventFetchDetail>(
      (event, emit) async {
        try {
          emit(UserStateFetchingSingle());
          final UserModel? user =
              await UserRepo().fetchUser(profileId: event.uid);
          if (user != null) {
            emit(UserStateFetchedSingle(user: user));
          } else {
            emit(UserStateFetchedSingleEmpty());
          }
        } on AppException catch (e) {
          emit(UserStateFetchSingleFailure(exception: e));
        }
      },
    );

    // OnFindUser
    on<UserEventSearchUsers>(
      (event, emit) async {
        try {
          emit(UserStateSearchFetching());
          final List<UserModel> users = await UserRepo().fetchUsersWith(
            searchName: event.search,
            ignoreIds: event.ignoreIds,
          );
          emit(UserStateSearchFetched(users: users));
        } on AppException catch (e) {
          emit(UserStateSearchFetchFailure(exception: e));
        }
      },
    );

    // On Fetch All Doc Snap shot
    on<UserEventFetchAll>(
      (event, emit) async {
        try {
          emit(UserStateFetchingAll());
          final users = await UserRepo().fetchAllUsers(
            onLastDocReceived: (lastSnap) {
              if (lastSnap != null) {
                emit(UserStateLastSnapDocRecieved(
                    lastDocumentSnapshot: lastSnap));
              }
            },
            igonreIds: event.ignoreIds,
            lastDocSnap: event.lastDocSnap,
          );
          emit(UserStateFetchedAll(users: users));
        } on AppException catch (e) {
          emit(UserStateFetchAllFailure(exception: e));
        }
      },
    );
  }
}
