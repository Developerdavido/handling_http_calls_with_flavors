

enum Flavor {prod, dev}
class AppEnv {

  String appName = "";

  String baseUrl = "";

  Flavor flavor = Flavor.dev;


  /// this code will initialize the the app config and make it static so it can
  /// be accessed from anywhere in the app.
  static AppEnv config = AppEnv.create();

  ///create a factory method that will have the @params [appName, baseUrl, flavor]
  ///this will return a new config that will determine which app flavor is being used.
  factory AppEnv.create({String appName = "",
  String baseUrl = "",
  Flavor flavor = Flavor.dev}) {
    return config = AppEnv(appName, baseUrl, flavor);
  }

  AppEnv(this.appName, this.baseUrl, this.flavor);


}