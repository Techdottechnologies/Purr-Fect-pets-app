

import 'package:petcare/exceptions/app_exceptions.dart';
import 'package:petcare/models/post_model.dart';

abstract class PostState {
  final bool isLoading;

  PostState({this.isLoading = false});
}

/// initial State
class PostStateInitial extends PostState {}

// ===========================Create Post States================================

class PostStateCreating extends PostState {
  PostStateCreating({super.isLoading = true});
}

class PostStateCreateFailure extends PostState {
  final AppException exception;

  PostStateCreateFailure({required this.exception});
}

class PostStateCreated extends PostState {}

// ===========================Update Post States================================

class PostStateUpdating extends PostState {
  PostStateUpdating({super.isLoading = true});
}

class PostStateUpdateFailure extends PostState {
  final AppException exception;

  PostStateUpdateFailure({required this.exception});
}

class PostStateUpdated extends PostState {
  final PostModel? model;

  PostStateUpdated({this.model});
}

// ===========================Fetch Own Posts================================

class PostStateFetchingOwn extends PostState {
  PostStateFetchingOwn({super.isLoading = true});
}

class PostStateFetchOwnFailure extends PostState {
  final AppException exception;

  PostStateFetchOwnFailure({required this.exception});
}

class PostStateFetchedOwn extends PostState {}

// ===========================Fetch Posts================================

class PostStateFetchingAll extends PostState {
  PostStateFetchingAll({super.isLoading = true});
}

class PostStateFetchAllFailure extends PostState {
  final AppException exception;

  PostStateFetchAllFailure({required this.exception});
}

class PostStateFetchedAll extends PostState {}

// ===========================Delete Post================================

class PostStateDeleted extends PostState {
  final String uuid;

  PostStateDeleted({required this.uuid});
}
