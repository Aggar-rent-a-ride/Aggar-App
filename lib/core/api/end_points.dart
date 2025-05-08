class EndPoint {
  static String baseUrl = "https://aggarapi.runasp.net";

  // Auth endpoints
  static String login = "/api/auth/login";
  static String register = "/api/auth/register";
  static String sendActivationCode = "/api/auth/send-activation-code";
  static String activate = "/api/auth/activate";
  static String refreshToken = "/api/auth/refresh";
  static String logout = "/api/auth/logout";

  // Vehicle endpoints
  static String vehicle = "/api/vehicle/";
  static String vehicleType = "$baseUrl/api/vehicletype/";
  static String vehicleBrand = "$baseUrl/api/vehiclebrand/";
  static String addVehicle = "$baseUrl/api/vehicle/?id=";
  static String vehicleDiscount = "$baseUrl/api/vehicle/vehicle-discounts";
  static String getVehicles =
      "$baseUrl/api/vehicle/get-vehicles?pageNo=1&pageSize=8&byNearest=true";

  // Chat endpoints
  static String chatHub = "/Chat";
  static String getMessageBetween = "$baseUrl/api/chat/messages";
  static String filterMessages = "$baseUrl/api/chat/filter";
  static String getMyChat = "$baseUrl/api/chat/chat?pageNo=1&pageSize=30";
  static String markAsSeen = "$baseUrl/api/chat/ack";

  // Chat SignalR methods
  static String sendMessageMethod = "SendMessageAsync";
  static String initiateUploadMethod = "InitiateUploadingAsync";
  static String uploadMethod = "UploadAsync";
  static String finishUploadMethod = "FinishUploadingAsync";

  // Review endpoints
  static String createReview = "$baseUrl/api/review/";
  static String getUserReviews = "$baseUrl/api/review/user-reviews";
  static String getVehicleReviews = "$baseUrl/api/review/vehicle-reviews";
  static String getReview = "$baseUrl/api/review";
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
  static String vehicleLocationLatitude = "Location.Latitude";
  static String vehicleLocationLongitude = "Location.Longitude";
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

  ///////////////vehicleDiscount//////////////////////
  static String vehicleDiscountDaysRequired = "daysRequired";
  static String vehicleDiscountPercentage = "discountPercentage";
  static String vehicleDiscountVehicleId = "vehicleId";
  static String vehicleDiscountDiscounts = "discounts";

  //////////////GetMessageBetween/////////////////
  static String msgContent = "content";
  static String msgFilePath = "filePath";
  static String msgId = "id";
  static String msgSenderId = "senderId";
  static String msgReceiverId = "receiverId";
  static String msgDate = "sentAt";
  static String msgStatus = "isSeen";

  /////////////FilterMessages//////////////////////
  static String filterMessagesSenderId = "userId";
  static String filterMsgSearchContent = "searchQuery";
  static String filterMsgDateTime = "date";
  static String filterMsgPageSize = "pageSize";
  static String filterMsgPageNo = "pageNo";

  ///////////////GetMyChat////////////////////////////
  static String getMyChatUnSeenMsg = "unseenMessageIds";
  static String getMyChatUser = "user";
  static String getMyChatUserId = "id";
  static String getMyChatUserName = "name";
  static String getMyChatUserPfp = "imagePath";
  static String getMyChatLastMsg = "lastMessage";
  static String getMyChatLastMsgFilePath = "filePath";
  static String getMyChatLastMsgContent = "content";
  static String getMyChatLastMsgId = "id";
  static String getMyChatLastMsgSentAt = "sentAt";
  static String getMtChatLastMsgSeen = "seen";

  //////////////MarkAsSeen/////////////////////////////
  static String markAsSeenMsgId = "messageIds";

  //////////////SignalR Chat Keys//////////////////////
  static String clientMessageId = "clientMessageId";
  static String receiverId = "receiverId";
  static String content = "content";
  static String fileName = "Name";
  static String fileExtension = "Extension";
  static String filePath = "FilePath";
  static String bytesBase64 = "BytesBase64";
  static String checksum = "checksum";
  static String progress = "Progress";

  //////////////Reviews//////////////////////////////
  static String rentalId = "rentalId";
  static String behaviorOfThePerson = "behavior";
  static String punctualityOfThePerson = "punctuality";
  static String comments = "comments";
  static String care = "care";
  static String truthfulness = "truthfulness";

  /////////////GetVehicleReviews///////////////////////
  static String getVehicleReviewId = "reviewId";
  static String getVehicleReviewer = "reviewer";
  static String getVehicleCreatedAt = "createdAt";
  static String getVehicleRate = "rate";
  static String getVehicleComments = "comments";

  //////////////GetVehicle///////////////////////////
  static String getVehicleId = "id";
  static String getVehicleDistance = "distance";
  static String getVehicleBrand = "brand";
  static String getVehicleType = "type";
  static String getVehicleModel = "model";
  static String getVehicleYear = "year";
  static String getVehiclePricePerDay = "pricePerDay";
  static String getVehicleIsFavourite = "isFavourite";
  static String getVehicleMainImagePath = "mainImagePath";
}
