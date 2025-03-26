import 'package:petcare/models/post_model.dart';

abstract class PostEvent {}

/// Create Post Event
class PostEventCreate extends PostEvent {
  final PostModel model;

  PostEventCreate({required this.model});
}

/// Update Post Event
class PostEventUpdate extends PostEvent {
  final PostModel model;

  PostEventUpdate({required this.model});
}

/// Fetch Own Posts Event
class PostEventFetchOwn extends PostEvent {}

/// Fetch All Posts Event
class PostEventFetchAll extends PostEvent {
  final bool isFetchNew;

  PostEventFetchAll({required this.isFetchNew});
}

/// Delete Post Event
class PostEventDelete extends PostEvent {
  final String uuid;

  PostEventDelete({required this.uuid});
}
