import 'dart:convert';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'LastCrDrModel.dart';
import 'local_logger.dart';


final _sharedPref = CommonSharedPref();
//TODO: Update in live
String validate = "https://uat.craftsilicon.com/ElmaV4WebValidate/api/elma/v4/validate";
String purchase = "https://uat.craftsilicon.com/ElmaV4WebPurchase/api/elma/v4/purchase";

extension RAOOTP on APIService{

  Future<DynamicResponse> reqOTP(String mobileNumber) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["MOBILENUMBER"] = mobileNumber;
    innerMap["HEADER"] = "CREATEOTP";
    innerMap["SERVICENAME"] = "RAO";
    innerMap["MERCHANTID"] = "RAO";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("OTP Response : $res");
    } catch (e) {
      CommonUtils.showToast("Otp request failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension LastCrDr on APIService{

  Future<LastCrDrResponse?> checkRecentCrDr({formId = "DBCALL"}) async {
    var decrypted;
    LastCrDrResponse? lastCrDrResponse;
    Map<String, dynamic> innerMap = {};
    Map<String, dynamic> requestObj = {};
    innerMap["HEADER"] = "GETRECENTCREDITDEBIT";
    requestObj["DynamicForm"] = innerMap;

    final route = await _sharedPref.getRoute("other".toLowerCase());
    var res = await performDioRequest(
        await dioRequestBodySetUp(formId, objectMap: requestObj),
        route: route);

    try {
      decrypted = jsonDecode(res ?? "{}") ?? "{}";
      logger.d("\n\nLAST-CRDR RESPONSE: $decrypted");
      lastCrDrResponse = LastCrDrResponse.fromJson(decrypted);
    } catch (e) {
      // AppLogger.appLogE(tag: "DECODE:ERROR", message: e.toString());
    }
    return lastCrDrResponse ?? LastCrDrResponse(status: "XXX");
  }
}


extension RAOPARAMS on APIService{

  Future<DynamicResponse> reqRAOParams() async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "GetBranchHFStaticData";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("RAOPARAMS response : $res");
    } catch (e) {
      CommonUtils.showToast("RAOPARAMS request failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension RAOPRODUCTS on APIService{

  Future<DynamicResponse> reqRAOProducts() async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "GetBankHFStaticData";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("RAOPRODUCTS response : $res");
    } catch (e) {
      CommonUtils.showToast("RAOPRODUCTS request failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension ministatement on APIService{
  Future<DynamicResponse?> checkMiniStmnt(
      {required bankAccountID,
        formId = "PAYBILL"}) async {
    var decrypted;
    DynamicResponse? dynamicResponse;
    Map<String, dynamic> innerMap = {};
    Map<String, dynamic> requestObj = {};
    innerMap["BANKACCOUNTID"] = bankAccountID;
    innerMap["MerchantID"] = "STATEMENT";
    requestObj["ModuleID"] = "STATEMENT";
    requestObj["PayBill"] = innerMap;
    requestObj["MerchantID"] = "STATEMENT";

    final route = await _sharedPref.getRoute("account".toLowerCase());
    var res = await performDioRequest(
        await dioRequestBodySetUp(formId, objectMap: requestObj),
        route: route);

    try {
      decrypted = jsonDecode(res ?? "{}") ?? "{}";
      logger.d("\n\nMINI-STATEMENT RESPONSE: $decrypted");

      dynamicResponse = DynamicResponse.fromJson(decrypted);
    } catch (e) {
      // AppLogger.appLogE(tag: "DECODE:ERROR", message: e.toString());
    }
    return dynamicResponse ?? DynamicResponse(status: "XXX");
  }
}

extension myTrx on APIService{

  Future<DynamicResponse> checkMyTrx() async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    requestObj["ModuleID"] = "TRANSACTIONSCENTER";
    requestObj["MerchantID"] = "FULLSTATEMENT";
    innerMap["HEADER"] = "GETTRXLIST";
    innerMap["MerchantID"] = "FULLSTATEMENT";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETTrx response : $res");
    } catch (e) {
      CommonUtils.showToast("Trx fetch failed");
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension BillerTypes on APIService{

  Future<DynamicResponse> getBillerTypes() async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "GETBILLERS";
    innerMap["INFOFIELD1"] = "BILLERTYPE";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETBillers response : $res");
    } catch (e) {
      CommonUtils.showToast("Biller names fetch failed");
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension BillerNames on APIService{

  Future<DynamicResponse> getBillerNames(String utility,) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "GETBILLERSNAMES";
    innerMap["INFOFIELD1"] = "BILLERNAME";
    innerMap["INFOFIELD2"] = utility;
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETBillers response : $res");
    } catch (e) {
      CommonUtils.showToast("Biller names fetch failed");
      // AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension SaveBeneficiary on APIService{

  Future<DynamicResponse> saveBen(String billerType,
      String billerName,
      String alias,
      String account) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    requestObj["ModuleID"] = "ADDBENEFICIARY";
    requestObj["MerchantID"] = "BENEFICIARY";
    innerMap["HEADER"] = "BENEFICIARY";
    innerMap["INFOFIELD1"] = billerType;
    innerMap["INFOFIELD2"] = billerName;
    innerMap["INFOFIELD3"] = alias;
    innerMap["INFOFIELD4"] = account;
    innerMap["MerchantID"] = "BENEFICIARY";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("AddBens response : $res");
    } catch (e) {
      CommonUtils.showToast("Add Beneficiary failed");
      // AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension GetBeneficiary on APIService{

  Future<DynamicResponse> getBeneficiaries() async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    requestObj["ModuleID"] = "VIEWBENEFICIARY";
    requestObj["MerchantID"] = "BENEFICIARY";
    innerMap["HEADER"] = "GETBENEFICIARY";
    innerMap["INFOFIELD1"] = "TRANSFER";
    innerMap["MerchantID"] = "BENEFICIARY";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("Get Beneficiaries response : $res");
    } catch (e) {
      CommonUtils.showToast("Get Beneficiaries failed");
      // AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension DeleteBeneficiary on APIService{

  Future<DynamicResponse> deleteBen(String billerID,
      String billerName,
      String alias,
      String account) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    requestObj["ModuleID"] = "VIEWBENEFICIARY";
    requestObj["MerchantID"] = "BENEFICIARY";
    innerMap["HEADER"] = "DELETEBENEFICIARY";
    innerMap["INFOFIELD1"] = alias;
    innerMap["INFOFIELD2"] = billerName;
    innerMap["INFOFIELD3"] = billerID;
    innerMap["INFOFIELD4"] = account;
    innerMap["MerchantID"] = "BENEFICIARY";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("Delete Bens response : $res");
    } catch (e) {
      CommonUtils.showToast("Delete Beneficiary failed");
      // AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension setDP on APIService{

  Future<DynamicResponse> setDp(String image) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "CREATEPROFILEIMGURL";
    innerMap["infofield1"] = image;
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("SETDP response : $res");
    } catch (e) {
      CommonUtils.showToast("SETDP request failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension getDP on APIService{

  Future<DynamicResponse> getDp() async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "GETPROFILEIMGURL";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETDP response : $res");
    } catch (e) {
      CommonUtils.showToast("Profile picture fetch failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension updateDP on APIService{

  Future<DynamicResponse> updateDp(String image) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["infofield1"] = image;
    innerMap["HEADER"] = "UPDATEPROFILEIMGURL";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("UPDATEDP response : $res");
    } catch (e) {
      CommonUtils.showToast("UPDATEDP request failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension updateSO on APIService{

  Future<DynamicResponse> updateStandingOrder(String siid,
      String noOfEx,
      String firstEx,
      String trFrqID,
      String lastEx,
      String nextEx,
      String regEx,
      String drAcc,
      String crAcc,
      String amount,
      String encryptedPin,) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["MerchantID"] = "UPDATESTANDING";
    innerMap["BANKACCOUNTID"] = drAcc;
    innerMap["ACCOUNTID"] = crAcc;
    innerMap["AMOUNT"] = amount;
    innerMap["InfoField4"] = noOfEx;
    innerMap["InfoField5"] = siid;
    innerMap["InfoField6"] = regEx;
    innerMap["InfoField7"] = trFrqID;
    innerMap["InfoField8"] = lastEx;
    innerMap["InfoField9"] = nextEx;
    innerMap["InfoField10"] = firstEx;
    requestObj["PayBill"] = innerMap;
    requestObj["EncryptedFields"] = {"PIN": "$encryptedPin"};
    // requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("UpdateSO response : $res");
    } catch (e) {
      CommonUtils.showToast("UpdateSO fetch failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension deleteSO on APIService{

  Future<DynamicResponse> deleteStandingOrder(String account,
      String noOfEx,
      String siid,
      String ref,
      String reason,
      String encryptedPin,) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["MerchantID"] = "STOPSTANDINGINSTRUCTIONS";
    innerMap["ACCOUNTID"] = account;
    innerMap["InfoField4"] = noOfEx;
    innerMap["InfoField5"] = siid;
    innerMap["InfoField8"] = ref;
    innerMap["InfoField9"] = reason;
    requestObj["PayBill"] = innerMap;
    requestObj["EncryptedFields"] = {"PIN": "$encryptedPin"};
    // requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("DeleteSO response : $res");
    } catch (e) {
      CommonUtils.showToast("DeleteSO fetch failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension StandingOrder on APIService{

  Future<DynamicResponse> getSO(String account) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["MerchantID"] = "GETSILIST";
    innerMap["BANKACCOUNTID"] = account;
    requestObj["PayBill"] = innerMap;
    // requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETSO response : $res");
    } catch (e) {
      CommonUtils.showToast("Standing Order fetch failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension AgentLocations on APIService{

  Future<DynamicResponse> getAgentLocations() async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "GETAGENTS";
    innerMap["CATEGORY"] = "AGENT";
    innerMap["BANKID"] = "23";
    innerMap["COUNTRY"] = "UGANDATEST";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETAgentLocations response : $res");
    } catch (e) {
      CommonUtils.showToast("Agent locations fetch failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension ATMLocations on APIService{

  Future<DynamicResponse> getATMLocations() async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "GetNearestATM";
    innerMap["CATEGORY"] = "ATM";
    innerMap["BANKID"] = "23";
    innerMap["COUNTRY"] = "UGANDATEST";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETATMLocations response : $res");
    } catch (e) {
      CommonUtils.showToast("ATM locations fetch failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension BranchLocations on APIService{

  Future<DynamicResponse> getBranchLocations() async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "GetNearestBranch";
    innerMap["CATEGORY"] = "BRANCH";
    innerMap["BANKID"] = "23";
    innerMap["COUNTRY"] = "UGANDATEST";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETBranchLocations response : $res");
    } catch (e) {
      CommonUtils.showToast("Branch locations fetch failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension MMValidation on APIService{

  Future<DynamicResponse> mmValidate(String moduleID,
      String merchantID,
      String account) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    requestObj["ModuleID"] = moduleID;
    requestObj["MerchantID"] = merchantID;
    innerMap["NEXTFORM"] = "YES";
    innerMap["ACCOUNTID"] = account;
    requestObj["Validate"] = innerMap;

    final route = validate;
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("VALIDATE",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("MM Val response : $res");
    } catch (e) {
      CommonUtils.showToast("MM Val failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension Rao on APIService{

  Future<DynamicResponse> rao(
      String infofield1,
      String infofield2,
      String infofield3,
      String infofield4,
      String infofield5,
      String idFront,
      String idBack,
      String selfie,
      String signature) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    requestObj["ModuleID"] = "RAO";
    requestObj["MerchantID"] = "SELFRAO";
    innerMap["InfoField1"] = infofield1;
    innerMap["InfoField2"] = infofield2;
    innerMap["InfoField3"] = infofield3;
    innerMap["InfoField4"] = infofield4;
    innerMap["InfoField5"] = infofield5;
    innerMap["InfoField6"] =  idFront;
    innerMap["InfoField7"] =  selfie;
    innerMap["InfoField8"] =  signature;
    innerMap["InfoField9"] =  idBack;
    innerMap["BANKACCOUNTID"] = "";
    innerMap["MerchantID"] = "SELFRAO";
    requestObj["Validate"] = innerMap;

    logLargeString(requestObj.toString());

    final route = validate;
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("VALIDATE",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("RAO response : $res");
    } catch (e) {
      CommonUtils.showToast("RAO failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension GetDataFrequency on APIService{

  Future<DynamicResponse> getDataFreqs() async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "DataBundleCategories";
    innerMap["INFOFIELD1"] = "MTN";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETDataFreq response : $res");
    } catch (e) {
      CommonUtils.showToast("Data Freq fetch failed");
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension GetDataBundles on APIService{

  Future<DynamicResponse> getDataBundles(
      String category) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "DataBundle";
    innerMap["INFOFIELD1"] = "MTN";
    innerMap["INFOFIELD2"] = category;
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETBundles response : $res");
    } catch (e) {
      CommonUtils.showToast("Bundles fetch failed");
      // AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension validateData on APIService{

  Future<DynamicResponse> dataValidation(
      String category,
      String ID,
      String mobile,) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    requestObj["ModuleID"] = "MTNDATA";
    requestObj["MerchantID"] = "MTNDB";
    innerMap["InfoField1"] = ID;
    innerMap["InfoField2"] = category;
    innerMap["ACCOUNTID"] = mobile;
    innerMap["MerchantID"] = "MTNDB";
    requestObj["Validate"] = innerMap;
    // requestObj["EncryptedFields"] = {"PIN": "$encryptedPin"};
    // requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = validate;
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("VALIDATE",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("Validate Data response : $res");
    } catch (e) {
      CommonUtils.showToast("Data Number Validation failed");
      // AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension payData on APIService{

  Future<DynamicResponse> dataPayment(
      String category,
      String ID,
      String mobile,
      String account,
      String amount,
      String encryptedPin,) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    requestObj["ModuleID"] = "MTNDATA";
    requestObj["MerchantID"] = "MTNDB";
    innerMap["InfoField1"] = ID;
    innerMap["InfoField2"] = category;
    innerMap["ACCOUNTID"] = mobile;
    innerMap["AMOUNT"] = amount;
    innerMap["BANKACCOUNTID"] = account;
    innerMap["MerchantID"] = "MTNDB";
    requestObj["PayBill"] = innerMap;
    requestObj["EncryptedFields"] = {"PIN": "$encryptedPin"};
    // requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = purchase;
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("Pay Data response : $res");
    } catch (e) {
      CommonUtils.showToast("Pay Data fetch failed");
      // AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension QuickPayTrx on APIService{

  Future<DynamicResponse> getQuickPayTrx() async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "GetQuickPayTransactions";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETQuickPayTrx response : $res");
    } catch (e) {
      CommonUtils.showToast("Quick Pay trx fetch failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension QuickPayPayments on APIService{

  Future<DynamicResponse> quickPay(String moduleID,
      String merchantID,
      String accountID,
      String amount,
      String bankAccountID,
      String INFOFIELD1,
      String INFOFIELD2,
      String INFOFIELD3,
      String INFOFIELD4,
      String INFOFIELD6,
      String INFOFIELD7,
      String INFOFIELD9,
      String encryptedPin) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    requestObj["ModuleID"] = moduleID;
    requestObj["MerchantID"] = merchantID;
    innerMap["ACCOUNTID"] = accountID;
    innerMap["AMOUNT"] = amount;
    innerMap["INFOFIELD1"] = INFOFIELD1;
    innerMap["INFOFIELD2"] = INFOFIELD2;

    if (merchantID == "007001017" || merchantID == "007001016"){
      innerMap["NEXTFORM"] = "YES";
      innerMap["INFOFIELD3"] = INFOFIELD3;
    }

    if (merchantID == "007001003"){
      innerMap["INFOFIELD3"] = INFOFIELD3;
      innerMap["INFOFIELD9"] = INFOFIELD9;
    }

    if (merchantID == "TRANSFER"){
      innerMap["INFOFIELD3"] = INFOFIELD3;
      innerMap["NEXTFORM"] = "YES";
    }

    if (merchantID == "EFT"){
      innerMap["INFOFIELD3"] = INFOFIELD3;
      innerMap["INFOFIELD7"] = INFOFIELD7;
    }

    if (merchantID == "RTGS"){
      innerMap["INFOFIELD3"] = INFOFIELD3;
      innerMap["INFOFIELD4"] = INFOFIELD4;
      innerMap["INFOFIELD6"] = INFOFIELD6;
      innerMap["INFOFIELD7"] = INFOFIELD7;
    }

    innerMap["INFOFIELD10"] = "false";
    innerMap["BANKACCOUNTID"] = bankAccountID;
    innerMap["MerchantID"] = merchantID;
    requestObj["PayBill"] = innerMap;
    requestObj["EncryptedFields"] = {"PIN": "$encryptedPin"};

    final route = await _sharedPref.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("Quick Pay response : $res");
    } catch (e) {
      CommonUtils.showToast("Quick Pay failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}