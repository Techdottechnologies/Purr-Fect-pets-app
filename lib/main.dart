import 'package:petcare/blocs/chat/%20chat_bloc.dart';
import 'package:petcare/blocs/comment/comment_bloc.dart';
import 'package:petcare/blocs/message/mesaage_bloc.dart';
import 'package:petcare/blocs/pet/pet_bloc.dart';
import 'package:petcare/blocs/post/post_bloc.dart';
import 'package:petcare/blocs/contact_us/contact_us_bloc.dart';
import 'package:petcare/page/auth/splash_Screen.dart';
import 'package:petcare/page/home/home_drawer.dart';
import 'package:petcare/blocs/privacy/privacy_bloc.dart';
import 'package:petcare/services/local_storage/local_storage_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/notification/notification_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'firebase_options.dart';
import 'manager/app_bloc_observer.dart';
import 'page/controller/nav_Controller.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
// Replace with actual imports

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  // Request necessary permissions before initialization
  await _requestPermissions();

  // Ensure Firebase app is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalStorageServices().initial();
  // await PushNotificationServices().initialize();

  Get.put(MyDrawerController());
  Get.put(NavControllerD());

  Get.find<MyDrawerController>().closeDrawer();
  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  // Define the required permissions
  List<Permission> permissions = [
    Permission.camera,
    Permission.photos,
    Permission.notification,
    Permission.location,
  ];

  // Request permissions
  for (Permission permission in permissions) {
    PermissionStatus status = await permission.status;

    if (status.isDenied || status.isRestricted || status.isLimited) {
      await permission.request();
    }

    if (status.isPermanentlyDenied) {
      bool openSettings = await _showSettingsDialog();
      if (openSettings) {
        await openAppSettings();
      }
    }
  }
}

// Function to show a dialog prompting the user to open settings
Future<bool> _showSettingsDialog() async {
  return await showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text("Permission Required"),
          content: Text(
              "Some permissions are permanently denied. Please enable them in settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Open Settings"),
            ),
          ],
        ),
      ) ??
      false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthBloc()),
            BlocProvider(create: (context) => UserBloc()),
            BlocProvider(create: (context) => PetBloc()),
            BlocProvider(create: (context) => PostBloc()),
            BlocProvider(create: (context) => CommentBloc()),
            BlocProvider(create: (context) => ChatBloc()),
            BlocProvider(create: (context) => MessageBloc()),
            BlocProvider(create: (context) => NotificationBloc()),
            BlocProvider(create: (context) => ContactUsBloc()),
            BlocProvider(create: (context) => PrivacyBloc()),
          ],
          child: GetMaterialApp(
            navigatorKey: navKey,
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}

GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
