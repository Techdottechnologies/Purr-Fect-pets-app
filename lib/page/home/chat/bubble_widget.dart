import 'package:petcare/config/colors.dart';
import 'package:petcare/utils/extensions/date_extension.dart';
import 'package:petcare/widgets/avatar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../blocs/message/mesaage_bloc.dart';
import '../../../../blocs/message/message_event.dart';
import '../../../../blocs/message/message_state.dart';
import '../../../../models/message_model.dart';
import '../../../../utils/constants/constants.dart';
import '../../../manager/app_manager.dart';
import '../../../repos/message_repo.dart';
import '../../../services/local_storage/local_storage_services.dart';
import '../../../utils/constants/app_theme.dart';
import '../../../widgets/custom_network_image.dart';

class BubbleWidget extends StatefulWidget {
  const BubbleWidget({super.key, required this.conversationId});
  final String conversationId;
  @override
  State<BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget> {
  bool isLoading = false;
  List<GroupedMessageModel> messages = MessageRepo().messages;
  DocumentSnapshot? lastDocSnap;
  final ScrollController scrollController = ScrollController();
  bool isEnd = false;

  Widget getMessageCell(MessageModel message) {
    final String userId = AppManager.currentUser!.uid;
    Widget currentWidget = const SizedBox();

    if (message.senderId == userId) {
      switch (message.type) {
        case MessageType.text:
          currentWidget = _getBubble(BubbleMessageType.textSender, message);
          break;
        case MessageType.photo:
          currentWidget = _getBubble(BubbleMessageType.imageSender, message);
          break;
        case MessageType.video:
          currentWidget = _getBubble(BubbleMessageType.videoSender, message);
          break;
        case MessageType.addMember:
          currentWidget = _getBubble(BubbleMessageType.addMember, message);
        case MessageType.removeMember:
          currentWidget = _getBubble(BubbleMessageType.removeMember, message);
        case MessageType.madeAdmin:
          currentWidget = _getBubble(BubbleMessageType.madeAdmin, message);
        case MessageType.removeAdmin:
          currentWidget = _getBubble(BubbleMessageType.removeAdmin, message);
        case MessageType.joinedChat:
          currentWidget = _getBubble(BubbleMessageType.joinedChat, message);
        case MessageType.exitChat:
          currentWidget = _getBubble(BubbleMessageType.exitChat, message);
        default:
          SizedBox();
      }
    } else {
      switch (message.type) {
        case MessageType.text:
          currentWidget = _getBubble(BubbleMessageType.textReciever, message);
          break;
        case MessageType.photo:
          currentWidget = _getBubble(BubbleMessageType.imageReciever, message);
          break;
        case MessageType.video:
          currentWidget = _getBubble(BubbleMessageType.videoReciever, message);
          break;
        case MessageType.addMember:
          currentWidget = _getBubble(BubbleMessageType.addMember, message);
        case MessageType.removeMember:
          currentWidget = _getBubble(BubbleMessageType.removeMember, message);
        case MessageType.madeAdmin:
          currentWidget = _getBubble(BubbleMessageType.madeAdmin, message);
        case MessageType.removeAdmin:
          currentWidget = _getBubble(BubbleMessageType.removeAdmin, message);
        case MessageType.joinedChat:
          currentWidget = _getBubble(BubbleMessageType.joinedChat, message);
        case MessageType.exitChat:
          currentWidget = _getBubble(BubbleMessageType.exitChat, message);
        default:
          SizedBox();
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: currentWidget,
    );
  }

  void addScrollListener() {
    scrollController.addListener(
      () {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          triggerConversationFetchEvent();
        }
      },
    );
  }

  void removeListener() {
    scrollController.removeListener(() {});
    scrollController.dispose();
  }

  void triggerConversationFetchEvent() {
    if (isEnd) return;
    context.read<MessageBloc>().add(
          MessageEventFetch(
            conversationId: widget.conversationId,
            lastDocSnap: lastDocSnap,
          ),
        );
  }

  void triggerReadMessagesEvent() async {
    final readMessages = await LocalStorageServices().getMessageIds();

    final List<String> readableMessageIds = [];
    final e = messages.expand((e) => e.messages
        .where((element) => element.senderId != AppManager.currentUser!.uid));

    for (final message in e) {
      if (!readMessages.contains(message.messageId)) {
        readableMessageIds.add(message.messageId);
        readMessages.add(message.messageId);
      }
    }
    context
        .read<MessageBloc>()
        .add(MessageEventOnRead(newMessages: readableMessageIds));
  }

  @override
  void initState() {
    triggerConversationFetchEvent();
    addScrollListener();
    super.initState();
  }

  @override
  void dispose() {
    MessageRepo().onDisposed();
    removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageBloc, MessageState>(
      listener: (context, state) {
        if (state is MessageStateOnLastSnapReceived) {
          lastDocSnap = state.lastDocSnapshot;
        }

        if (state is MessageStateFetchFailure ||
            state is MessageStateFetching ||
            state is MessageStateFetched ||
            state is MessageStatePrepareToSend) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is MessageStateFetchFailure) {
            debugPrint(state.exception.message);
          }

          if (state is MessageStateFetched ||
              state is MessageStatePrepareToSend) {
            setState(() {
              messages = MessageRepo().messages;
            });
            triggerReadMessagesEvent();
          }
        }
      },
      child: ListView.builder(
        controller: scrollController,
        itemCount: messages.length,
        reverse: true,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                messages[index].date.formatChatDateToString(),
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF7C7C7C),
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
              for (final message in messages[index].messages)
                getMessageCell(message),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _getBubble(BubbleMessageType messageType, MessageModel message) {
  switch (messageType) {
    // ===========================Product Cell================================
    case BubbleMessageType.product:
      return Container(
        width: SCREEN_WIDTH,
        height: SCREEN_HEIGHT * 0.21,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6FB),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  "assets/images/boy.png",
                  height: constraints.maxHeight * 0.74,
                  width: constraints.maxWidth,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 8, right: 8, bottom: 3),
                  child: Text(
                    "Bentley luxury Car",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.titleColor1,
                      fontSize: 14.45,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

    // ===========================Text Reciever Cell================================
    case BubbleMessageType.textReciever:
      return Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: SCREEN_WIDTH * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapW10,
              AvatarWidget(
                width: 30,
                height: 30,
                avatarUrl: message.senderAvatar,
                placeholderChar:
                    message.senderName.characters.firstOrNull?.toUpperCase() ??
                        "-",
              ),
              gapW10,
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 8,
                    top: 8,
                    bottom: 8,
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 204, 204, 204),
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // ignore: sdk_version_since
                        message.senderName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      gapH6,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.content,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          gapH6,
                          Text(
                            message.messageTime.dateToString("hh:mm a"),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 47, 47, 47),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

    // ===========================Text Sender Cell================================
    case BubbleMessageType.textSender:
      return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: SCREEN_WIDTH * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: MyColors.primary,
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                ),
                child: Text(
                  message.content,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              gapH6,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    message.messageTime.dateToString("hh:mm a"),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  gapW10,
                  message.conversationId != ""
                      ? SvgPicture.asset(
                          "assets/icons/double-check-ic.svg",
                          colorFilter: const ColorFilter.mode(
                            AppTheme.primaryColor1,
                            BlendMode.srcIn,
                          ),
                        )
                      : const SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor1,
                            strokeWidth: 1,
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      );

    // ===========================Image Sender Cell================================
    case BubbleMessageType.imageSender:
      return Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              width: SCREEN_WIDTH * 0.6,
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor1,
                borderRadius: BorderRadius.all(
                  Radius.circular(11),
                ),
              ),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(11),
                  ),
                ),
                child: CustomNetworkImage(imageUrl: message.content),
              ),
            ),
            gapH6,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  message.messageTime.dateToString("hh:mm a"),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primaryColor1,
                  ),
                ),
                gapW6,
                message.conversationId != ""
                    ? SvgPicture.asset(
                        "assets/icons/double-check-ic.svg",
                        colorFilter: const ColorFilter.mode(
                            AppTheme.primaryColor1, BlendMode.srcIn),
                      )
                    : const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor1,
                          strokeWidth: 1,
                        ),
                      ),
              ],
            )
          ],
        ),
      );
    // ===========================Image Reciever Cell================================
    case BubbleMessageType.imageReciever:
      return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AvatarWidget(
              width: 30,
              height: 30,
              avatarUrl: message.senderAvatar,
              placeholderChar:
                  message.senderName.characters.firstOrNull?.toUpperCase() ??
                      "-",
            ),
            gapW6,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: SCREEN_WIDTH * 0.6,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(11),
                    ),
                  ),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(11),
                      ),
                    ),
                    child: CustomNetworkImage(imageUrl: message.content),
                  ),
                ),
                gapH6,
                Row(
                  children: [
                    Text(
                      message.senderName.characters.take(40).join(),
                      maxLines: 1,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 120, 119, 119),
                      ),
                    ),
                    gapW10,
                    Text(
                      message.messageTime.dateToString("hh:mm a"),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 120, 119, 119),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    // ===========================Log Cell================================
    case BubbleMessageType.addMember ||
          BubbleMessageType.exitChat ||
          BubbleMessageType.removeMember ||
          BubbleMessageType.joinedChat ||
          BubbleMessageType.madeAdmin ||
          BubbleMessageType.removeMember ||
          BubbleMessageType.removeAdmin:
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 228, 228, 228),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Text(
          message.content,
          maxLines: 2,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    // ===========================Other Cell================================
    default:
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Text(
          "Your app doesn't support this message. Please update the app to see the message.",
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1E1E1E),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      );
  }
}

enum BubbleMessageType {
  product,
  textSender,
  textReciever,
  imageSender,
  imageReciever,
  videoSender,
  videoReciever,
  addMember,
  removeMember,
  joinedChat,
  exitChat,
  madeAdmin,
  removeAdmin,
}
