class EndPoint {
  static String baseUrl = "https://aggarapi.runasp.net";

  // Auth endpoints
  static String login = "/api/auth/login";
  static String register = "/api/auth/register";
  static String sendActivationCode = "/api/auth/send-activation-code";
  static String activate = "/api/auth/activate";
  static String refreshToken = "/api/auth/refresh";
  static String logout = "/api/auth/logout";

  // Booking endpoints
  static const String cancelBooking = '/api/booking/cancel';
  static String createBooking = "/api/booking";
  static String getBookingById = "/api/booking";
  static String getBookingsByStatus = "/api/booking/bookings-by-status";
  static String getBookingsCount = "/api/booking/count-bookings-by-status";

  // Vehicle endpoints
  static String vehicle = "/api/vehicle/";
  static String vehicleType = "$baseUrl/api/vehicletype/";
  static String vehicleBrand = "$baseUrl/api/vehiclebrand/";
  static String addVehicle = "$baseUrl/api/vehicle/?id=";
  static String vehicleDiscount = "$baseUrl/api/vehicle/vehicle-discounts";
  static String getVehicles = "$baseUrl/api/vehicle/get-vehicles";
  static String getVehiclesByStatus = "$baseUrl/api/vehicle/vehicles-by-status";
  static String statusCount = "$baseUrl/api/vehicle/count-vehicles-by-status";
  static String getPopularVehicles = "$baseUrl/api/vehicle/popular-vehicles";
  static String mostRentedVehicles =
      "$baseUrl/api/vehicle/most-rented-vehicles";
  static String putFavourite = "$baseUrl/api/vehicle/favourite";
  static String getFavouriteVehicles = "$baseUrl/api/vehicle/get-favourites";
  static String getRenterVehicles = "$baseUrl/api/vehicle/renter";

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

  // Notification endpoint
  static String notificationHub = "/Notification";

  // Review endpoints
  static String createReview = "$baseUrl/api/review/";
  static String getUserReviews = "$baseUrl/api/review/user-reviews";
  static String getVehicleReviews = "$baseUrl/api/review/vehicle-reviews";
  static String getReview = "$baseUrl/api/review";

  //Rental Endpoint
  static String rentalHistory = "/api/rental/history";

  //Report Endpoint
  static String createReport = "$baseUrl/api/report/";
  static String getReportById = "$baseUrl/api/report/";
  static String updateReportStatus = "$baseUrl/api/report/status";
  static String filterReport = "$baseUrl/api/report/filter";

  //User Endpoint
  static String getTotalUser = "$baseUrl/api/user/all";
  static String getTotalUserCount = "$baseUrl/api/user/count-all";
  static String getSearchUsers = "$baseUrl/api/user/search";
  static String deleteUser = "$baseUrl/api/user/";
  static String getUser = "$baseUrl/api/user/";
  static String punishUser = "$baseUrl/api/user/punish";
  static String getUserInfo = "$baseUrl/api/user/profile";

  //Payment Endpoint
  static String connectedAccount = "$baseUrl/api/payment/connected-account";
  static String getPlatformBalance = "$baseUrl/api/payment/balance";
  static String renterpayoutDetails = "$baseUrl/api/payment/renter-payout";
  static String webHooks = "$baseUrl/api/payment/webhook";
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
  static String getVehicleTransmission = "transmission";

  ///////////////GetFilterReports////////////////////////
  static String getFilterReportId = "id";
  static String getFilterReportDescrption = "description";
  static String getFilterReportCreatedAt = "createdAt";
  static String getFilterReportStatus = "status";
  static String getFilterReportReporter = "reporter";
  static String getFilterReportReporterId = "id";
  static String getFilterReportReporterName = "name";
  static String getFilterReportReporterPfp = "imagePath";
  static String getFilterReportTargetType = "targetType";
  //////////////////////////////////////////////////////
  static String getFilterReportTargetAppUser = "targetAppUser";
  static String getFilterReportTargetAppUserId = "id";
  static String getFilterReportTargetAppUserName = "name";
  static String getFilterReportTargetAppUserPfp = "imagePath";
  //////////////////////////////////////////////////////
  static String getFilterReportTargetRenterReview = "targetRenterReview";
  static String getFilterReportTargetRenterReviewId = "id";
  static String getFilterReportTargetRenterReviewRentalId = "rentalId";
  static String getFilterReportTargetRenterReviewCreatedAt = "createdAt";
  static String getFilterReportTargetRenterReviewBehavior = "behavior";
  static String getFilterReportTargetRenterReviewPunctuality = "punctuality";
  static String getFilterReportTargetRenterReviewComments = "comments";
  static String getFilterReportTargetRenterReviewCare = "care";
  //////////////////////////////////////////////////////
  static String getFilterReportTargetCustomerReview = "targetCustomerReview";
  static String getFilterReportTargetCustomerReviewId = "id";
  static String getFilterReportTargetCustomerReviewRentalId = "rentalId";
  static String getFilterReportTargetCustomerReviewCreatedAt = "createdAt";
  static String getFilterReportTargetCustomerReviewBehavior = "behavior";
  static String getFilterReportTargetCustomerReviewPunctuality = "punctuality";
  static String getFilterReportTargetCustomerReviewComments = "comments";
  static String getFilterReportTargetCustomerReviewCare = "care";
  //////////////////////////////////////////////////////
  static String getFilterReportTargetMessageFile = "targetFileMessage";
  static String getFilterReportTargetMessagecontent = "targetContentMessage";
  static String getFilterReportTargetMessageFilePath = "filePath";
  static String getFilterReportTargetMessageContent = "content";
  static String getFilterReportTargetMessageId = "id";
  static String getFilterReportTargetMessageSenderId = "senderId";
  static String getFilterReportTargetMessageReceiverId = "receiverId";
  static String getFilterReportTargetMessageSentAt = "sentAt";
  static String getFilterReportTargetMessageIsSeen = "isSeen";
  //////////////////////////////////////////////////////
  static String getFilterReportTargetVehicle = "targetVehicle";
  static String getFilterReportTargetVehicleId = "id";
  static String getFilterReportTargetVehicleDistance = "distance";
  static String getFilterReportTargetVehicleModel = "model";
  static String getFilterReportTargetVehicleYear = "year";
  static String getFilterReportTargetVehiclePricePerDay = "pricePerDay";
  static String getFilterReportTargetVehicleIsFavourite = "isFavourite";
  static String getFilterReportTargetVehicleTransmission = "transmission";
  static String getFilterReportTargetVehicleRate = "rate";
  static String getFilterReportTargetVehicleMainImagePath = "mainImagePath";

  //////////////////////Users/////////////////////////////////
  static String getSearchUsersId = "id";
  static String getSearchUsersName = "name";
  static String getSearchUsersUsername = "username";
  static String getSearchUsersImage = "imagePath";
  static String getSearchUsersrate = "rate";

  //////////////////Payment////////////////////////////////
  static String paymentStripeAccountId = "stripeAccountId";
  static String paymentBankAccountId = "bankAccountId";
  static String paymentIsVerified = "isVerified";
  static String paymentAvailableBalance = "availableBalanc";
  static String paymentPendingBalance = "pendingBalance";
  static String paymentConnectReserved = "connectReserved";
  static String paymentTotalBalance = "totalBalance";
  static String paymentCurrency = "currency";
  static String paymentLast4 = "last4";
  static String paymentRoutingNumber = "routingNumber";
  static String paymentCurrentAmount = "currentAmount";
  static String paymentUpcomingAmount = "upcomingAmount";
}
