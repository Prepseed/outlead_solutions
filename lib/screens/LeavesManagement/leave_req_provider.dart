import 'package:flutter/material.dart';
import 'package:outlead_solutions/utils/exception/customException.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/sharedPref.dart';
import '../../constants/urls.dart';
import 'leaves_model.dart';

class LeaveReqProvider extends ChangeNotifier{

  final ApiBaseHelper _helper = ApiBaseHelper();
  String? userId;
  LeavesModel leavesModel = LeavesModel();
  LeavesModel leavesModelRequest = LeavesModel();

  getLeaves(bool hr) async{
    userId = await SharedPref().getSharedPref('userId');
    String url = hr ? ApiUrls.BASEURL + "/leaves/request" : ApiUrls.BASEURL + "/leaves/request?id=$userId";
    final response = await _helper.get(url);
    leavesModelRequest = LeavesModel.fromJson(response);
    leaves();

    notifyListeners();
  }

  leaves() async{
    userId = await SharedPref().getSharedPref('userId');
    String url = ApiUrls.BASEURL + "/leaves?format=user&startDate=11/21/2022&endDate=12/31/2022";
    final response = await _helper.get(url);
    leavesModel = LeavesModel.fromJson(response);
    leavesModelRequest.leaves!.forEach((elementReq) {
      leavesModel.leaves!.forEach((element) {
        if(elementReq.user!.sId == element.user!.sId){
          element.leavesStatus!.addAll(elementReq.leavesStatus!);
        }
      });
    });
    notifyListeners();
  }

  String? msg;
  leaveReq(body) async {
      final response = await _helper.post("https://napi.prepseed.com/leaves/request", body);
      msg = response["msg"];
      SharedPreferences pref = await SharedPreferences.getInstance();
      var role = pref.getString('Role');
      getLeaves(role == 'hr' ? true : false);
      notifyListeners();
  }

  leaveAction(String id, String date, String action) async {
   await _helper.put("https://napi.prepseed.com/leaves/request?leaveId=$id&date=$date&action=$action");
    getLeaves(true);
    notifyListeners();
  }
}