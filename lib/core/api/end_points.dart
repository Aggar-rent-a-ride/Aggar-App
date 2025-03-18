class EndPoint {
  static String baseUrl = "https://aggarapi.runasp.net/";

  static String login = "api/auth/login";
  static String register = "api/auth/register";
  static String sendActivationCode = "api/auth/send-activation-code";
  static String activate = "/api/auth/activate";
}

class ApiKey {
  static String status = "statusCode";
  static String errorMessage = "ErrorMessage";
  static String message = "message";
  static String userId = "userId";
  static String username = "username";
  static String email = "email";
  static String accountStatus = "accountStatus";
  static String isAuthenticated = "isAuthenticated";
  static String roles = "roles";
  static String accessToken = "accessToken";
  static String refreshToken = "refreshToken";
  static String refreshTokenExpiration = "refreshTokenExpiration";
}
