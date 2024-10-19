class LastCrDrResponse {
  String status = "";
  String? message, formID;
  List<dynamic>? dynamicList;

  LastCrDrResponse(
      {required this.status,
        this.message,
        this.formID,
        this.dynamicList});

  LastCrDrResponse.fromJson(Map<String, dynamic> json) {
    status = json["Status"];
    message = json["Message"];
    formID = json["FormID"];
    dynamicList = json["Data"];
  }
}