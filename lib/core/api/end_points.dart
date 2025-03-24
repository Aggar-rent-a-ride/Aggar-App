class EndPoint {
  static String baseUrl = "https://aggarapi.runasp.net/";

  static String login = "api/auth/login";
  static String register = "api/auth/register";
  static String sendActivationCode = "api/auth/send-activation-code";
  static String activate = "/api/auth/activate";
  //TODO: error will be updated in the future
  static String vehicle = "https://aggarapi.runasp.net/api/vehicle/";
  static String vehicleType = "https://aggarapi.runasp.net/api/vehicletype/";
  static String vehicleBrand = "https://aggarapi.runasp.net/api/vehiclebrand/";
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
  //////////////////////vehicle///////////////////////////////
  static String vehicleSeatsNo = "NumOfPassengers";
  static String vehicleYearOfManufacture = "Year";
  static String vehicleModel = "Model";
  static String vehicleColor = "Color";
  static String vehicleMainImage = "MainImage";
  static String vehicleImages = "Images";
  static String vehicleStatus = "Status";
  static String vehicleHealth = "PhysicalStatus";
  static String vehicleTransmissionMode = "Transmission";
  static String vehicleRentalPrice = "PricePerDay";
  static String vehicleProperitesOverview = "ExtraDetails";
  static String vehicleBrand = "VehicleBrandId";
  static String vehicleType = "VehicleTypeId";
  static String vehicleAddress = "Address";
  static String vehiclLocation = "Location";
  static String vehicleLocationLatitude = "Latitude";
  static String vehicleLocationLongitude = "Longitude";
  static String vehicleAddressCountry = "Country";
  static String vehicleAddressState = "State";
  static String vehicleAddressCity = "City";
  static String vehicleAddressStreet = "Street";
  ////////////////vehicletype//////////////////////
  static String vehicleTypeId = "id";
  static String vehicleTypeName = "name";
  static String vehicleTypeSlogen = "slogenPath";
  ////////////////vehiclebrand///////////////////////
  static String vehicleBrandId = "id";
  static String vehicleBrandName = "name";
  static String vehicleBrandCountry = "country";
  static String vehicleBrandLogo = "logoPath";
}
