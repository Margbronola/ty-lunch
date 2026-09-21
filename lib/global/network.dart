class Network {
  // static String url = "https://back.tylunch.studioseizh.com"; //TEST
  static String url = "https://admin.ty-lunch.fr"; //LIVE
  static String get api => "$url/api";

  // The Banque "Confirmer" flow uses the test payment endpoints while it is
  // being tested; everything else stays on the normal api.
  // static String get testApi => "$url/api/test";
}
