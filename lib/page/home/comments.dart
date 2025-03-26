import 'package:petcare/blocs/comment/comment_bloc.dart';
import 'package:petcare/blocs/comment/comment_event.dart';
import 'package:petcare/blocs/comment/comment_state.dart';
import 'package:petcare/blocs/post/post_bloc.dart';
import 'package:petcare/blocs/post/post_status.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/notification_model.dart';
import 'package:petcare/models/post_model.dart';
import 'package:petcare/models/user_model.dart';
import 'package:petcare/repos/comment/comment_repo.dart';
import 'package:petcare/repos/like_repo.dart';
import 'package:petcare/repos/notification_repo.dart';
import 'package:petcare/repos/user_repo.dart';
import 'package:petcare/services/notifications/fire_notification.dart';
import 'package:petcare/utils/constants/constants.dart';
import 'package:petcare/utils/dialogs/dialogs.dart';
import 'package:petcare/utils/extensions/date_extension.dart';
import 'package:petcare/widgets/avatar_widget.dart';
import 'package:petcare/widgets/pet_post.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/comment_model.dart';
import '../../models/like_model.dart';
import '../../models/user_profile_model.dart';
import '../../utils/constants/enum.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage(
      {super.key, required this.post, required this.totalComments});
  final PostModel post;
  final int totalComments;
  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late PostModel post = widget.post;
  bool isAddingComment = false;
  final TextEditingController controller = TextEditingController();
  late int totalComments = widget.totalComments;
  CommentModel? replier;
  void triggerAddCommentForPostEvent() {
    context.read<CommentBloc>().add(
          CommentEventAdd(
            contentId: replier?.uuid ?? widget.post.uuid,
            comment: controller.text,
            postId: widget.post.uuid,
          ),
        );
  }

  int current = 0;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// CommentBloc
        BlocListener<CommentBloc, CommentState>(
          listener: (ctx, state) {
            if (state is CommentStateAddFailure ||
                state is CommentStateAdded ||
                state is CommentStateAdding) {
              setState(() {
                isAddingComment = state.isLoading;
              });

              if (state is CommentStateAddFailure) {
                CustomDialogs().errorBox(message: state.exception.message);
              }

              if (state is CommentStateAdded) {
                controller.clear();
                replier = null;
                setState(() {
                  totalComments += 1;
                });
              }
            }
          },
        ),

        /// PostBloc
        BlocListener<PostBloc, PostState>(
          listener: (_, state) {
            if (state is PostStateUpdated) {
              if (post.uuid == state.model?.uuid) {
                setState(() {
                  post = state.model!;
                });
              }
            }

            if (state is PostStateDeleted) {
              if (post.uuid == state.uuid) {
                Get.back();
              }
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  SizedBox(height: 1.h),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: CircleAvatar(
                        radius: 2.3.h,
                        backgroundColor: MyColors.primary,
                        child: Icon(
                          Remix.arrow_left_s_line,
                          color: Colors.white,
                          size: 3.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    textWidget(
                      "Comments",
                      fontWeight: FontWeight.w500,
                      fontSize: 19.sp,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PetPost(
                          post: post,
                          key: GlobalKey(),
                        ),
                        SizedBox(height: 2.h),
                        textWidget(
                          "${totalComments} ${totalComments > 1 ? "Comments" : "Comment"}",
                        ),
                        SizedBox(height: 2.h),

                        /// Comment Sections
                        _CommentWidget(
                          post: post,
                          totalComments: totalComments,
                          onReplierPressed: (comment) {
                            controller.text = "${comment.commentBy.name}: ";
                            replier = comment;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0, bottom: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: TextField(
                      controller: controller,
                      onChanged: (va) {
                        if (va.isEmpty) {
                          replier = null;
                        }
                      },
                      style: GoogleFonts.roboto(
                          fontSize: 16.sp, color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xffF9F9F9),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        suffixIconConstraints: BoxConstraints(minWidth: 10.w),
                        suffixIcon: isAddingComment
                            ? Lottie.asset(
                                "assets/icons/sender-icon.json",
                                height: 50,
                              )
                            : InkWell(
                                onTap: () async {
                                  triggerAddCommentForPostEvent();
                                  UserModel currentUser =
                                      AppManager.currentUser!;
                                  UserModel? receiver = await UserRepo()
                                      .fetchUser(profileId: post.userInfo.uid);
                                  NotificationRepo().save(
                                    recieverId: receiver!.uid,
                                    title: currentUser.name,
                                    message:
                                        "${currentUser.name} commented on your post.",
                                    avatar: currentUser.avatar ?? "",
                                    type: NotificationType.post,
                                    data: {
                                      'type': 'post',
                                      'post': post.toMap()
                                    },
                                  );

                                  FireNotification.fire(
                                      title: currentUser.name,
                                      description:
                                          "${currentUser.name} commented on your post ${post.status}.",
                                      topic:
                                          "$PUSH_NOTIFICATION_USER${receiver.uid}",
                                      type: NotificationType.post.toString(),
                                      additionalData: {
                                        'type': 'post',
                                        'post': post.toMap(),
                                      });
                                },
                                child: Image.asset(
                                  "assets/icons/send.png",
                                  color: MyColors.primary,
                                  height: 2.4.h,
                                ),
                              ),
                        hintText: "Write Here",
                        hintStyle: GoogleFonts.poppins(
                            color: Colors.black54, fontSize: 15.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================Comment Section================================
class _CommentWidget extends StatefulWidget {
  const _CommentWidget(
      {required this.onReplierPressed,
      required this.post,
      required this.totalComments});
  final Function(CommentModel) onReplierPressed;
  final PostModel post;
  final int totalComments;

  @override
  State<_CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<_CommentWidget> {
  final List<String> showReplierSectionIds = [];

  final List<CommentModel> comments = [];
  bool isLoading = false;
  DocumentSnapshot? lastSnap;
  Map<String, int> totalReplies = {};
  void triggerFetchCommentsEvent() {
    context.read<CommentBloc>().add(
        CommentEventFetchForPost(postId: widget.post.uuid, lastDoc: lastSnap));
  }

  @override
  void initState() {
    triggerFetchCommentsEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is CommentStateFetchFailureForPost ||
            state is CommentStateFetchedForPost ||
            state is CommentStateFetchingForPost ||
            state is CommentStateAdded ||
            state is CommentStateLastSnapForPost) {
          setState(() {
            isLoading = isLoading;
          });

          if (state is CommentStateFetchedForPost) {
            for (final c in state.comments) {
              if (c.contentId == widget.post.uuid) {
                if (!comments.contains(c)) {
                  comments.add(c);
                }
              }
            }
            setState(() {});
          }

          if (state is CommentStateLastSnapForPost) {
            lastSnap = state.lastDocSnapshot;
          }

          if (state is CommentStateAdded) {
            if (state.comment.contentId == widget.post.uuid) {
              setState(() {
                comments.add(state.comment);
                totalReplies[state.comment.uuid] =
                    (totalReplies[state.comment.uuid] ?? 0) + 1;
              });
            }
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < comments.length; i++)
            Builder(
              builder: (context) {
                final CommentModel comment = comments[i];

                return Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AvatarWidget(
                            width: 40,
                            height: 40,
                            placeholderChar:
                                comment.commentBy.name.characters.first,
                            avatarUrl: comment.commentBy.avatarUrl,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        textWidget(
                                          comment.commentBy.name,
                                          fontSize: 15.5.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        Spacer(),
                                        textWidget(
                                          comment.createdAt.convertToPostTime(),
                                          fontSize: 13.4.sp,
                                          color: Color(0xffBFBFBF),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 0.6.h),
                                    textWidget(
                                      comment.comment,
                                      fontSize: 12.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          /// Like
                          FutureBuilder<Set<dynamic>>(
                            future:
                                LikeRepo().getLikeData(contentId: comment.uuid),
                            builder: (context, snap) {
                              final int count = snap.data?.first ?? 0;
                              LikeModel? like;
                              if (snap.data?.last is LikeModel) {
                                like = snap.data?.last as LikeModel;
                              }
                              return InkWell(
                                onTap: () async {
                                  final UserModel? user =
                                      AppManager.currentUser;
                                  if (like == null) {
                                    final LikeModel likeModel =
                                        await LikeRepo().addLike(
                                      model: LikeModel(
                                        uuid: "",
                                        likedAt: DateTime.now(),
                                        likedBy: UserProfileModel(
                                          name: user?.name ?? "",
                                          uid: user?.uid ?? "",
                                          avatarUrl: user?.avatar ?? "",
                                        ),
                                        contentId: comment.uuid,
                                        type: LikeType.comment,
                                      ),
                                    );
                                    UserModel currentUser =
                                        AppManager.currentUser!;
                                    UserModel? receiver = await UserRepo()
                                        .fetchUser(
                                            profileId:
                                                widget.post.userInfo.uid);
                                    NotificationRepo().save(
                                      recieverId: receiver!.uid,
                                      title: currentUser.name,
                                      message:
                                          "${currentUser.name} liked your post.",
                                      avatar: currentUser.avatar ?? "",
                                      type: NotificationType.post,
                                      data: {
                                        'type': 'post',
                                        'post': widget.post.toMap()
                                      },
                                    );

                                    FireNotification.fire(
                                        title: currentUser.name,
                                        description:
                                            "${currentUser.name} liked your post.",
                                        topic:
                                            "$PUSH_NOTIFICATION_USER${receiver.uid}",
                                        type: NotificationType.post.toString(),
                                        additionalData: {
                                          'type': 'post',
                                          'post': widget.post.toMap(),
                                        });
                                    setState(() {
                                      like = likeModel;
                                    });
                                  } else {
                                    LikeRepo().removeLike(uuid: like!.uuid);
                                    setState(() {
                                      like = null;
                                    });
                                  }
                                },
                                child: textWidget(
                                  "${like == null ? "Like" : "Liked"} ($count)",
                                  fontSize: 13.sp,
                                  color: like == null
                                      ? Colors.black
                                      : MyColors.primary3,
                                  fontWeight: like == null
                                      ? FontWeight.w400
                                      : FontWeight.w500,
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 2.w),
                          FutureBuilder<int>(
                            future: CommentRepo.countCommentsFor(
                                commentId: comment.uuid),
                            builder: (context, snap) {
                              totalReplies[comment.uuid] = snap.data ?? 0;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (showReplierSectionIds
                                        .contains(comment.uuid)) {
                                      showReplierSectionIds.removeWhere(
                                          (e) => e == comment.uuid);
                                    } else {
                                      showReplierSectionIds.add(comment.uuid);
                                    }
                                  });
                                  widget.onReplierPressed(comment);
                                },
                                child: textWidget(
                                  "Reply (${totalReplies[comment.uuid]})",
                                  fontSize: 13.sp,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      if (showReplierSectionIds.contains(comment.uuid))
                        _ReplyWidget(
                          totalComments: totalReplies[comment.uuid] ?? 0,
                          parentComment: comment,
                          onReplierPressed: (com) {
                            com = com.copyWith(uuid: comment.uuid);
                            widget.onReplierPressed(com);
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          if (isLoading) CircularProgressIndicator(),

          /// More Text Widget
          if ((comments.length % 10) == 0)
            InkWell(
              onTap: () {
                triggerFetchCommentsEvent();
              },
              child: textWidget(
                "Load more comments",
                fontSize: 12.9,
              ),
            ),
        ],
      ),
    );
  }
}

// ===========================Reply Section================================
class _ReplyWidget extends StatefulWidget {
  const _ReplyWidget({
    required this.onReplierPressed,
    required this.parentComment,
    required this.totalComments,
  });
  final Function(CommentModel) onReplierPressed;
  final CommentModel parentComment;
  final int totalComments;

  @override
  State<_ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<_ReplyWidget> {
  // bool isShowTF = false;
  final List<CommentModel> comments = [];
  bool isLoading = false;
  DocumentSnapshot? lastSnap;
  late int remainingComments = widget.totalComments;

  void triggerFetchCommentsEvent() {
    context.read<CommentBloc>().add(CommentEventFetchForComments(
          commentId: widget.parentComment.uuid,
          lastDoc: lastSnap,
        ));
  }

  @override
  void initState() {
    triggerFetchCommentsEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is CommentStateFetchFailureForComment ||
            state is CommentStateFetchedForComment ||
            state is CommentStateFetchingForComment ||
            state is CommentStateLastSnapForComment ||
            state is CommentStateAdded) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is CommentStateFetchedForComment) {
            for (final c in state.comments) {
              if (c.contentId == widget.parentComment.uuid) {
                if (!comments.contains(c)) {
                  comments.add(c);
                }
              }
            }
            setState(() {
              remainingComments -= comments.length;
            });
          }

          if (state is CommentStateAdded) {
            if (state.comment.contentId == widget.parentComment.uuid) {
              setState(() {
                comments.add(state.comment);
              });
            }
          }

          if (state is CommentStateLastSnapForComment) {
            lastSnap = state.lastDocSnapshot;
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < comments.length; i++)
            Builder(
              builder: (context) {
                final CommentModel comment = comments[i];
                return Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 6, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AvatarWidget(
                            width: 40,
                            height: 40,
                            placeholderChar:
                                comment.commentBy.name.characters.first,
                            avatarUrl: comment.commentBy.avatarUrl,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        textWidget(
                                          comment.commentBy.name,
                                          fontSize: 15.5.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        Spacer(),
                                        textWidget(
                                          comment.createdAt.convertToPostTime(),
                                          fontSize: 13.4.sp,
                                          color: Color(0xffBFBFBF),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 0.6.h),
                                    textWidget(
                                      comment.comment,
                                      fontSize: 12.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          FutureBuilder<Set<dynamic>>(
                            future:
                                LikeRepo().getLikeData(contentId: comment.uuid),
                            builder: (context, snap) {
                              final int count = snap.data?.first ?? 0;
                              LikeModel? like;
                              if (snap.data?.last is LikeModel) {
                                like = snap.data?.last as LikeModel;
                              }
                              return InkWell(
                                onTap: () async {
                                  final UserModel user =
                                      AppManager.currentUser!;
                                  if (like == null) {
                                    final LikeModel likeModel =
                                        await LikeRepo().addLike(
                                      model: LikeModel(
                                        uuid: "",
                                        likedAt: DateTime.now(),
                                        likedBy: UserProfileModel(
                                          name: user.name,
                                          uid: user.uid,
                                          avatarUrl: user.avatar ?? "",
                                        ),
                                        contentId: comment.uuid,
                                        type: LikeType.comment,
                                      ),
                                    );

                                    // UserModel currentUser =
                                    //     AppManager.currentUser!;
                                    // UserModel? receiver = await UserRepo()
                                    //     .fetchUser(
                                    //         profileId:
                                    //             comment.uuid);
                                    // NotificationRepo().save(
                                    //   recieverId: receiver!.uid,
                                    //   title: currentUser.name,
                                    //   message:
                                    //       "${currentUser.name} liked your comment.",
                                    //   avatar: currentUser.avatar ?? "",
                                    //   type: NotificationType.post,
                                    //   data: {'type': 'post', 'post': {}},
                                    // );

                                    // FireNotification.fire(
                                    //     title: currentUser.name,
                                    //     description:
                                    //         "${currentUser.name} liked your comment.",
                                    //     topic: "$PUSH_NOTIFICATION_USER${receiver.uid}",
                                    //     type: NotificationType.post.toString(),
                                    //     additionalData: {
                                    //       'type': 'post',
                                    //       ' post': {}
                                    //     });

                                    setState(() {
                                      like = likeModel;
                                    });
                                  } else {
                                    LikeRepo().removeLike(uuid: like!.uuid);
                                    setState(() {
                                      like = null;
                                    });
                                  }
                                },
                                child: textWidget(
                                  "${like == null ? "Like" : "Liked"} ($count)",
                                  fontSize: 13.sp,
                                  color: like == null
                                      ? Colors.black
                                      : MyColors.primary3,
                                  fontWeight: like == null
                                      ? FontWeight.w400
                                      : FontWeight.w500,
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 2.w),
                          InkWell(
                            onTap: () {
                              widget.onReplierPressed(comment);
                            },
                            child: textWidget(
                              "Reply",
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

          /// Bottom Content
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading) CircularProgressIndicator(),

                /// More Text Widget
                if (remainingComments > 0)
                  InkWell(
                    onTap: () {
                      triggerFetchCommentsEvent();
                    },
                    child: textWidget(
                      "Load more $remainingComments replies",
                      fontSize: 12.9,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
