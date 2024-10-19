class DPResponse {
  String status = "", data = "";
  String? message, formID;

  DPResponse(
      {required this.data,
      required this.status,
        this.message,
        this.formID});

  DPResponse.fromJson(Map<String, dynamic> json) {
    status = json["Status"];
    message = json["Message"];
    formID = json['FormID'];
    data = json["Data"];
  }
}