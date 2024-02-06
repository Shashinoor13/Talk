class AppRouteConstantsPublic {
  static String home = '/';
  static String login = '/login';
  static String signup = '/signup';

  //return a list of all the Strings
  static List<String> get all => [home, login, signup];
}

class AppRouteConstantsPrivate {
  static String profile = '/profile';
  static String settings = '/profile/settings';
  static String chat = '/chat';
  static String chatInbox = '/chat/inbox/:room_id';
  static String myPost = '/profile/myPost/:id';

  //return a list of all the Strings
  static List<String> get all => [profile, settings];
}
