import 'package:copter/view/company/c_home.dart';
import 'package:copter/view/root.dart';
import 'package:copter/view/chat/chat_head.dart';
import 'package:copter/view/chat/chat_screen.dart';
import 'package:copter/view/company/get_employee_account.dart';
import 'package:copter/view/company/subscriptions/payment.dart';
import 'package:copter/view/company/subscriptions/subscription.dart';
import 'package:copter/view/company/task_dash_board/task_dash_board.dart';
import 'package:copter/view/company/tasks/add_task.dart';
import 'package:copter/view/company/tasks/cancel_tasks.dart';
import 'package:copter/view/company/tasks/completed_tasks.dart';
import 'package:copter/view/company/tasks/running_tasks.dart';
import 'package:copter/view/company/tasks/starting_tasks.dart';
import 'package:copter/view/company/tasks/tasks.dart';
import 'package:copter/view/employee/e_home.dart';
import 'package:copter/view/employee/e_report.dart';
import 'package:copter/view/launch/get_started.dart';
import 'package:copter/view/launch/splash_screen.dart';
import 'package:copter/view/notifications/e_notifications.dart';
import 'package:copter/view/profile/c_profile.dart';
import 'package:copter/view/profile/e_profile.dart';
import 'package:copter/view/profile/c_profile_edit.dart';
import 'package:copter/view/profile/e_profile_edit.dart';
import 'package:copter/view/public_profile/public_profile.dart';
import 'package:copter/view/public_profile/public_profile_detail.dart';
import 'package:copter/view/user/login.dart';
import 'package:copter/view/user/sign_up.dart';
import 'package:get/get.dart';

import 'bindings.dart';

class AppRoutes {
  static final pages = [
    GetPage(
      name: AppLinks.splashScreen,
      page: () => const SplashScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppLinks.getStarted,
      page: () => const GetStarted(),
    ),
    GetPage(
      name: AppLinks.login,
      page: () => Login(),
      binding: LoginBinding(),
    ),
    /*  GetPage(
      name: AppLinks.login,
      page: () => const Login(),
    ),*/
    GetPage(
      name: AppLinks.signup,
      page: () => const SignUp(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppLinks.root,
      page: () => Root(),
      binding: UserBindings(),
    ),
    GetPage(
      name: AppLinks.chatHead,
      page: () => const ChatHead(),
    ),
    GetPage(
      name: AppLinks.chatScreen,
      page: () => ChatScreen(),
    ),

    //  Employee Screens
    GetPage(
      name: AppLinks.eHome,
      page: () => EHome(),
    ),
    GetPage(
      name: AppLinks.eNotifications,
      page: () => const ENotifications(),
    ),
    GetPage(
      name: AppLinks.eProfile,
      page: () => const EProfile(),
    ),
    GetPage(
      name: AppLinks.eProfileEdit,
      page: () => const EProfileEdit(),
    ),
    GetPage(
      name: AppLinks.report,
      page: () => const Report(),
    ),
    //  Employee Screens

    // Tasks
    GetPage(
      name: AppLinks.tasks,
      page: () => const Tasks(),
    ),
    // GetPage(
    //   name: AppLinks.taskDashBoard,
    //   page: () => TaskDashBoard(),
    // ),
    GetPage(
      name: AppLinks.addTask,
      page: () => AddTask(),
    ),
    GetPage(
      name: AppLinks.startingTasks,
      page: () => const StartingTasks(),
    ),
    GetPage(
      name: AppLinks.runningTasks,
      page: () => const RunningTasks(),
    ),
    GetPage(
      name: AppLinks.completedTasks,
      page: () => const CompletedTasks(),
    ),
    GetPage(
      name: AppLinks.cancelTasks,
      page: () => const CancelTasks(),
    ),
    // Tasks

    //Company Screens
    GetPage(
      name: AppLinks.cHome,
      page: () => const CHome(),
    ),
    GetPage(
      name: AppLinks.cProfile,
      page: () => CProfile(),
    ),
    GetPage(
      name: AppLinks.cProfileEdit,
      page: () => const CProfileEdit(),
    ),
    GetPage(
      name: AppLinks.getEmployeeAccount,
      page: () => const GetEmployeeAccount(),
    ),
    GetPage(
      name: AppLinks.publicProfile,
      page: () => const PublicProfile(),
    ),
    GetPage(
      name: AppLinks.publicProfileDetail,
      page: () => const PublicProfileDetail(),
    ),
    GetPage(
      name: AppLinks.subscription,
      page: () => const Subscription(),
    ),
    GetPage(
      name: AppLinks.payment,
      page: () => const Payment(),
    ),
  ];
}

class AppLinks {
  static const splashScreen = '/splash_screen';
  static const getStarted = '/get_started';
  static const login = '/login';
  static const signup = '/sign_up';
  static const root = '/root';
  static const chatHead = '/chat_head';
  static const chatScreen = '/chat_screen';

//  Tasks
  static const tasks = '/tasks';
  static const taskDashBoard = '/task_dash_board';
  static const addTask = '/add_task';
  static const startingTasks = '/starting_tasks';
  static const runningTasks = '/running_tasks';
  static const completedTasks = '/completed_tasks';
  static const cancelTasks = '/cancel_tasks';

//  Employee Screens
  static const eHome = '/e_home';
  static const eProfile = '/e_profile';
  static const eProfileEdit = '/e_profile_edit';
  static const eNotifications = '/e_notifications';
  static const report = '/report';

//Company Screens
  static const cHome = '/c_home';
  static const cProfile = '/c_profile';
  static const cProfileEdit = '/c_profile_edit';
  static const getEmployeeAccount = '/get_employee_account';
  static const publicProfile = '/public_profile';
  static const publicProfileDetail = '/public_profile_detail';
  static const subscription = '/subscription';
  static const payment = '/payment';
}
