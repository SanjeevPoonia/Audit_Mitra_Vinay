
class AppModel{


  static bool isLogin=false;
  static String token='';
  static String userID='';
  static bool loginStatus=false;
  static bool cartLogin=false;
  static List<dynamic> rebuttalData=[];


  static bool setLoginToken(bool value)
  {
    isLogin=value;
    return isLogin;
  }


  static List<dynamic> setRebuttalData(Map mapData)
  {
    rebuttalData.add(mapData);
    return rebuttalData;
  }


  static String setTokenValue(String value)
  {
    token=value;
    return token;
  }

  static String setUserID(String id)
  {
    userID=id;
    return userID;
  }
  static bool setCartLogin(bool value)
  {
    cartLogin=value;
    return cartLogin;
  }
  static bool setLoginStatus(bool value)
  {
    loginStatus=value;
    return loginStatus;
  }

}
class TimePeriodData {
  final String timePeriod;
  final int value;

  TimePeriodData(this.timePeriod, this.value);
}