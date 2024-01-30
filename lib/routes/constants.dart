class AppRouteConstantsPublic{
  static String home = '/';
  static String login = '/login';
  static String signup = '/signup';

  //return a list of all the Strings
  static List<String> get all => [home,login,signup];
}

class AppRouteConstantsPrivate{
  static String profile = '/profile';

  //return a list of all the Strings
  static List<String> get all => [profile];
}