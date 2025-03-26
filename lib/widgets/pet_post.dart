import 'package:petcare/blocs/post/post_bloc.dart';
import 'package:petcare/blocs/post/post_event.dart';
import 'package:petcare/blocs/post/post_status.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/main.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/like_model.dart';
import 'package:petcare/models/notification_model.dart';
import 'package:petcare/models/post_model.dart';
import 'package:petcare/models/user_model.dart';
import 'package:petcare/page/home/comments.dart';
import 'package:petcare/page/home/post/create_post.dart';
import 'package:petcare/page/home/report_page.dart';
import 'package:petcare/page/home/spam_page.dart';
import 'package:petcare/repos/comment/comment_repo.dart';
import 'package:petcare/repos/like_repo.dart';
import 'package:petcare/repos/notification_repo.dart';
import 'package:petcare/repos/user_repo.dart';
import 'package:petcare/services/notifications/fire_notification.dart';
import 'package:petcare/utils/constants/constants.dart';
import 'package:petcare/utils/constants/enum.dart';
import 'package:petcare/utils/dialogs/dialogs.dart';
import 'package:petcare/utils/extensions/date_extension.dart';
import 'package:petcare/utils/extensions/string_extension.dart';
import 'package:petcare/widgets/avatar_widget.dart';
import 'package:petcare/widgets/custom_network_image.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/user_profile_model.dart';
// import 'package:share_plus/share_plus.dart';

class PetPost extends StatefulWidget {
  const PetPost({required this.post, required this.key});
  final PostModel post;

  @override
  final Key key;
  @override
  State<PetPost> createState() => _PetPostState();
}

class _PetPostState extends State<PetPost> {
  late PostModel post = widget.post;
  late bool isEdit = AppManager.currentUser?.uid == widget.post.userInfo.uid;
  final UserModel user = AppManager.currentUser!;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PostBloc, PostState>(
          listener: (_, state) {
            if (state is PostStateUpdated) {
              post = state.model!;
            }
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          onTap: () {
            // Get.to(CommentsPage(post: post));
          },
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(21),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            AvatarWidget(
                              width: 35,
                              height: 35,
                              placeholderChar: "",
                              avatarUrl: post.userInfo.avatarUrl,
                            ),
                            gapW10,
                            textWidget(post.userInfo.name),
                          ],
                        ),
                        gapW10,
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: textWidget(
                              timeago
                                  .format(post.createdAt, locale: 'en_short')
                                  .replaceAll('~', ''),
                              color: Color(0xffBFBFBF),
                              textAlign: TextAlign.right,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                        isEdit
                            ? selectPopup1(
                                navKey.currentContext!,
                                post,
                                () {
                                  navKey.currentContext!
                                      .read<PostBloc>()
                                      .add(PostEventDelete(uuid: post.uuid));
                                },
                              )
                            : Container()
                      ],
                    ),
                    if (post.media.content != "") SizedBox(height: 1.5.h),
                    if (post.media.content != "")
                      text_w(
                        post.media.content ?? "",
                        fontSize: 14.sp,
                      ),
                    SizedBox(height: 2.h),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: (post.media.mediaUrl != null)
                              ? CustomNetworkImage(
                                  imageUrl: post.media.mediaUrl ?? "",
                                )
                              : Container(
                                  height: 50,
                                  width: SCREEN_WIDTH,
                                  color: Colors.black,
                                ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8),
                              child: Row(
                                children: [
                                  /// Like
                                  FutureBuilder<Set<dynamic>>(
                                    future: LikeRepo()
                                        .getLikeData(contentId: post.uuid),
                                    builder: (context, snap) {
                                      final int count = snap.data?.first ?? 0;
                                      LikeModel? like;

                                      if (snap.data?.last is LikeModel) {
                                        like = snap.data?.last as LikeModel;
                                      }

                                      return Theme(
                                        data: Theme.of(navKey.currentContext!)
                                            .copyWith(
                                                canvasColor: Colors.white
                                                    .withOpacity(0.46)),
                                        child: InkWell(
                                          onTap: () async {
                                            if (like == null) {
                                              final LikeModel likeModel =
                                                  await LikeRepo().addLike(
                                                model: LikeModel(
                                                    uuid: "",
                                                    likedAt: DateTime.now(),
                                                    likedBy: UserProfileModel(
                                                      name: user.name,
                                                      uid: user.uid,
                                                      avatarUrl:
                                                          user.avatar ?? "",
                                                    ),
                                                    contentId: post.uuid,
                                                    type: LikeType.post),
                                              );

                                              UserModel currentUser =
                                                  AppManager.currentUser!;
                                              UserModel? receiver =
                                                  await UserRepo().fetchUser(
                                                      profileId: widget
                                                          .post.userInfo.uid);
                                              NotificationRepo().save(
                                                recieverId: receiver!.uid,
                                                title: currentUser.name,
                                                message:
                                                    "${currentUser.name} liked your post.",
                                                avatar:
                                                    currentUser.avatar ?? "",
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
                                                  type: NotificationType.post
                                                      .toString(),
                                                  additionalData: {
                                                    'type': 'post',
                                                    'post': widget.post.toMap(),
                                                  });
                                              setState(() {
                                                like = likeModel;
                                              });
                                            } else {
                                              LikeRepo()
                                                  .removeLike(uuid: like!.uuid);
                                              setState(() {
                                                like = null;
                                              });
                                            }
                                          },
                                          child: Chip(
                                            label: textWidget(
                                              "${count}",
                                              fontSize: 13.sp,
                                              color: Colors.white,
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            avatar: Image.asset(
                                              "assets/icons/heart.png",
                                              color: like != null
                                                  ? Colors.red
                                                  : Colors.white,
                                            ),
                                            backgroundColor:
                                                Color.fromARGB(255, 0, 0, 0)
                                                    .withOpacity(0.3),
                                            shadowColor:
                                                Colors.white.withOpacity(0.36),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 1.w),

                                  /// Comment Section
                                  Theme(
                                    data: Theme.of(navKey.currentContext!)
                                        .copyWith(
                                            canvasColor:
                                                Colors.white.withOpacity(0.46)),
                                    child: FutureBuilder<int>(
                                        future: CommentRepo.countComments(
                                            postId: post.uuid),
                                        builder: (context, snap) {
                                          int count = snap.data ?? 0;

                                          return InkWell(
                                            onTap: () {
                                              Get.to(CommentsPage(
                                                post: post,
                                                totalComments: count,
                                              ));
                                            },
                                            child: Chip(
                                              label: textWidget(
                                                count.toString(),
                                                fontSize: 13.sp,
                                                color: Colors.white,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              avatar: Image.asset(
                                                "assets/icons/cmt.png",
                                              ),
                                              backgroundColor:
                                                  Color.fromARGB(255, 0, 0, 0)
                                                      .withOpacity(0.3),
                                              shadowColor: Colors.white
                                                  .withOpacity(0.36),
                                            ),
                                          );
                                        }),
                                  ),
                                  // SizedBox(width: 1.w),
                                  // Theme(
                                  //   data: Theme.of(navKey.currentContext!)
                                  //       .copyWith(
                                  //           canvasColor:
                                  //               Colors.white.withOpacity(0.46)),
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       //  Share.share('Visit FlutterCampus at https://www.fluttercampus.com');
                                  //     },
                                  //     child: Chip(
                                  //       label: text_w(
                                  //         "0",
                                  //         fontSize: 13.sp,
                                  //         color: Colors.white,
                                  //       ),
                                  //       // padding: EdgeInsets.zero,
                                  //       shape: RoundedRectangleBorder(
                                  //           borderRadius:
                                  //               BorderRadius.circular(100)),
                                  //       avatar: Image.asset(
                                  //           "assets/icons/share.png"),
                                  //       backgroundColor:
                                  //           Color.fromARGB(255, 0, 0, 0)
                                  //               .withOpacity(0.3),
                                  //       shadowColor:
                                  //           Colors.white.withOpacity(0.36),
                                  //     ),
                                  //   ),
                                  // ),
                                  Spacer(),
                                  if (post.status != null)
                                    Theme(
                                      data: Theme.of(navKey.currentContext!)
                                          .copyWith(
                                              canvasColor: MyColors.primary),
                                      child: Chip(
                                        label: textWidget(
                                          post.status?.name
                                                  .capitalizeFirstCharacter() ??
                                              "",
                                          fontSize: 13.sp,
                                          color: Colors.white,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectPopup({required PostModel post}) => PopupMenuButton<int>(
        color: Color(0xffF9F8F8),
        constraints: BoxConstraints.expand(width: 35.w, height: 15.h),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/icons/report.png",
                  height: 2.h,
                ),
                SizedBox(width: 3.w),
                textWidget(
                  "Report",
                  fontWeight: FontWeight.w300,
                  fontSize: 16.sp,
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/spam.png",
                  height: 2.h,
                ),
                SizedBox(width: 3.w),
                textWidget(
                  "Spam",
                  fontWeight: FontWeight.w300,
                  fontSize: 16.sp,
                ),
              ],
            ),
          ),
        ],
        // initialValue: 0,
        onCanceled: () {},
        onSelected: (value) {
          // print(value);
          value == 1 ? Get.to(ReportPage()) : Get.to(SpamPage());
        },
        icon: const Icon(
          Icons.more_vert_outlined,
          color: Colors.black,
        ),
        offset: const Offset(0, 50),
      );

  Widget selectPopup1(context, PostModel post, VoidCallback onDeletePressed) =>
      PopupMenuButton<int>(
        color: Colors.white,
        shadowColor: Colors.white,
        constraints: BoxConstraints.expand(width: 35.w, height: 15.h),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Container(
              height: 4.h,
              width: 25.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: MyColors.primary),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.s,
                children: [
                  Spacer(),
                  Icon(
                    Icons.edit_note_sharp,
                    size: 2.5.h,
                    color: Colors.white,
                  ),
                  SizedBox(width: 2.w),
                  textWidget('Edit',
                      color: Colors.white,
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w500),
                  Spacer(),
                  Spacer(),
                ],
              ),
            ),

            // Image.asset(
            //   "assets/nav/edit.png",
            //   height: 4.h,
            //   fit: BoxFit.fill,
            // ),
          ),
          PopupMenuItem(
            value: 2,
            child: Image.asset(
              "assets/nav/del.png",
              height: 4.h,
              fit: BoxFit.fill,
            ),
          ),
        ],
        // initialValue: 0,
        onCanceled: () {},
        onSelected: (value) {
          if (value == 1) {
            Get.to(CreatePost(model: post));
          }

          if (value == 2) {
            CustomDialogs().deleteBox(
              title: "Delete Post",
              message: "Are you sure to delete the post?",
              onPositivePressed: () {
                onDeletePressed();
              },
            );
          }
        },
        icon: const Icon(
          Icons.more_vert_outlined,
          color: Colors.black,
        ),
        offset: const Offset(0, 50),
      );
}
