class Redirected {
  static String routeName = '/';

   void setRedirectedUrl(String url) {
    routeName = url;
  }

   String getRedirectedUrl() {
    return routeName;
  }
}

