

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:petcare/blocs/post/post_bloc.dart';
import 'package:petcare/blocs/post/post_event.dart';
import 'package:petcare/blocs/post/post_status.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/page/home/post/create_post.dart';
import 'package:petcare/utils/constants/constants.dart';
import 'package:petcare/utils/dialogs/dialogs.dart';
import 'package:petcare/widgets/pet_post.dart';
import 'package:petcare/widgets/txt_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../models/post_model.dart';

class AllPosts extends StatefulWidget {
  const AllPosts({super.key});

  @override
  State<AllPosts> createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  List<PostModel> posts = AppManager.ownPosts;
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();

  void triggerOwnPostsEvent() {
    context.read<PostBloc>().add(PostEventFetchOwn());
  }

  @override
  void initState() {
    scrollController.addListener(
      () {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          triggerOwnPostsEvent();
        }
      },
    );

    triggerOwnPostsEvent();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(
      () {},
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostStateFetchOwnFailure ||
            state is PostStateFetchedOwn ||
            state is PostStateFetchingOwn ||
            state is PostStateCreated ||
            state is PostStateUpdated ||
            state is PostStateDeleted) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is PostStateFetchOwnFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is PostStateFetchedOwn ||
              state is PostStateCreated ||
              state is PostStateUpdated ||
              state is PostStateDeleted) {
            setState(() {
              posts = AppManager.ownPosts;
            });
          }
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: InkWell(
                onTap: () {
                  Get.to(CreatePost());
                },
                child: Image.asset(
                  "assets/nav/add.png",
                  height: 6.h,
                ),
              ),
              body: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                            "My Posts",
                            fontWeight: FontWeight.w500,
                            fontSize: 19.sp,
                          ),
                        ],
                      ),
                      gapH6,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: PaginateFirestore(
                              key: Key(''),
                              onEmpty: Padding(
                                padding: EdgeInsets.only(bottom: 40.h),
                                child: Text(
                                  "Nothing Found",
                                  style: GoogleFonts.abel(
                                    color: Colors.black,
                                    fontSize: 18,
                                    wordSpacing: 1.5,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                              initialLoader: Padding(
                                padding: EdgeInsets.only(bottom: 45.h),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.black, strokeWidth: 2),
                                ),
                              ),
                              itemBuilder: (context, documentSnapshots, index) {
                                if (documentSnapshots[index].exists) {
                                  PostModel model = PostModel.fromMap(
                                      documentSnapshots[index].data()
                                          as Map<String, dynamic>);
                                  return Column(
                                    children: [
                                      PetPost(
                                        post: model,
                                        key: GlobalKey(),
                                      ),
                                      if (index == documentSnapshots.length - 1)
                                        SizedBox(
                                            height: 20
                                                .h), // Extra space after last post
                                    ],
                                  );
                                }
                                return SizedBox.shrink();
                              },
                              query: FirebaseFirestore.instance
                                  .collection('Dev-Posts')
                                  .orderBy('createdAt', descending: true)
                                  .where('userInfo.uid',isEqual),
                              itemBuilderType: PaginateBuilderType.listView,
                              isLive: true,
                            )),
                            if (isLoading) CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
