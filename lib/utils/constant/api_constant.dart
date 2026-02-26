class ApiConstant {
  static const String baseUrl = "http://tradetrace.runasp.net/api/";
  //auth
  static const String register = "Auth/register-salesrep";
  static const String loginEndpoint = "Auth/login";
  static const String changepassword = "Auth/change-password";
  static const String registerEndpoint = "auth/register";
  static const String userProfileEndpoint = "user/profile";
  static const String itemsEndpoint = "items";

  //Attendence
  static const String checkin = "Attendance/checkin";
  static const String checkout = "Attendance/{id}/checkout";
  static const String getattendancebydate = "Attendance/bydate";
  static const String attendancerepo = "Attendance/{salesRepId}/summary";
  static const String attendancebyrep = "Attendance/byrep/{salesRepId}";

  //outlet
  static const String outlet = "Outlets";
  // add outlate
  static const String addoutlate = "Outlets";
  //get order by outlet
  static const String orderByOutlet = "Orders/byoutlet/{outletId}";
  //order
  static const String orderlis = "Orders";
  //take order

  //prodct
  static const String productlist = "Products";
  //add product
  static const String addproduct = "Products";
}
