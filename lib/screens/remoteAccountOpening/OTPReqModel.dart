class OTPResponse {
  String status = "";
  String? message, formID;
  List<dynamic>? dynamicList;

  OTPResponse(
      {required this.status,
        this.message,
        this.formID,
        this.dynamicList});

  OTPResponse.fromJson(Map<String, dynamic> json) {
    status = json["Status"];
    message = json["Message"];
    formID = json['FormID'];
    dynamicList = json["Data"];
  }
}