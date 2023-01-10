import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'leave_list.dart';
import 'leave_req_provider.dart';

class AddNewLeaveReq extends StatefulWidget {
  const AddNewLeaveReq({Key? key}) : super(key: key);

  @override
  State<AddNewLeaveReq> createState() => _LeaveAndReportState();
}

class _LeaveAndReportState extends State<AddNewLeaveReq> {

  String? dropdownValue;
  TextEditingController reasonController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  bool isMultipleDay = false;
  bool isFullDay = false;

  DateTime? fromDate;
  DateTime? toDate;
  var differ;
  List days = [];
  List fullDays = [];
  List type = [];
  List leavesData = [];
  List<Map> leavesReq = [];
  Map leavesMap = {};
  bool fromEmpty = false;
  bool toEmpty = false;
  bool sameDate = false;
  bool types = false;

  static const IconData calendar_view_month_outlined = IconData(0xe122, fontFamily: 'MaterialIcons');
  static const IconData descriprion_icon =IconData(0xf5d6, fontFamily: 'MaterialIcons');
  static const IconData type_icon =IconData(0xf02c3, fontFamily: 'MaterialIcons');



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: backgroundColor,
        child: SafeArea(
          child:  Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: const BorderRadius.all(Radius.circular(10.0))
                          ),
                          child: const Icon(Icons.arrow_back_ios_new,size: 15.0,color: Colors.black,),
                        ),
                        onTap: (){
                          Navigator.pop(context, "");
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Text('New Leave',
                          style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0,top: 10,bottom: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 10.0),
                                        child: Row(
                                          children: [
                                            Text("Single Day",style: textStyle,),
                                            Switch(value: isMultipleDay, onChanged: toggleSwitch),
                                            Text("Multiple Day",style: textStyle,),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(indent: 20,),
                                  isMultipleDay != true
                                   ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text('Leave Duration',style: textStyle,),
                                      Container(
                                        margin: const EdgeInsets.only(right: 10.0),
                                        child: Row(
                                          children: [
                                            Text("Half Day",style: textStyle,),
                                            Switch(value: isFullDay, onChanged: fullDay),
                                            Text("Full Day",style: textStyle,),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                      : Container(),
                                  isMultipleDay!= true ?  const Divider(indent: 20,) : Container(),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          gradient: gradient
                                        ),
                                        child: Icon(calendar_view_month_outlined,size: 21.0,color: Colors.blue,)
                                      ),
                                      Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 45.0,
                                                margin: const EdgeInsets.all( 10.0),
                                                child: TextField(
                                                  readOnly: true,
                                                  controller: fromController, //editing controller of this TextField
                                                  decoration:  InputDecoration(
                                                      contentPadding: const EdgeInsets.all(10.0),
                                                      border: const OutlineInputBorder(
                                                        borderRadius:  BorderRadius.all(Radius.circular(10.0)),
                                                      ),
                                                      // icon: Icon(Icons.calendar_today), //icon of text field
                                                      labelText: isMultipleDay ? "From Date" : "Date",
                                                      labelStyle: textStyle//label text of field
                                                  ),
                                                  onTap: () async {
                                                    DateTime? pickedDate = await showDatePicker(
                                                        context: context,
                                                        initialDate: DateTime.now(), //get today's date
                                                        firstDate: DateTime.now(), //DateTime.now() - not to allow to choose before today.
                                                        lastDate: DateTime(2101)
                                                    );

                                                    if(pickedDate != null ){
                                                      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                      setState(() {
                                                        fromDate = pickedDate;
                                                        fromController.text = formattedDate;
                                                        fromEmpty = false;
                                                      });
                                                    }else{
                                                      setState(() {
                                                        fromEmpty = false;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                              fromEmpty == true
                                              ? Container(
                                                margin: const EdgeInsets.only(left: 15.0),
                                                child:  Text(isMultipleDay ? 'Select From Date' : 'Select Date',
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.red
                                                  ),
                                                ),
                                              )
                                                  : Container(),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                  const Divider(indent: 20,),
                                  isMultipleDay ? Row(
                                    children: [
                                      Image.asset("assets/images/Seelect Date Icon.png"),
                                      Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 45.0,
                                                margin: const EdgeInsets.all( 10.0),
                                                child: TextField(
                                                  readOnly: true,
                                                  controller: toController, //editing controller of this TextField
                                                  decoration:  InputDecoration(
                                                      contentPadding: const EdgeInsets.all(10.0),
                                                      border: const OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                      ),
                                                      labelText: "To Date",
                                                      labelStyle: textStyle  //label text of field
                                                  ),
                                                  onTap: () async {
                                                    DateTime? pickedDate = await showDatePicker(
                                                        context: context,
                                                        initialDate: fromDate!,
                                                        firstDate: fromDate!,
                                                        lastDate: DateTime(2101)
                                                    );
                                                    if(pickedDate != null ){
                                                      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                                      setState(() {
                                                        toEmpty = false;
                                                        toDate = pickedDate;
                                                        differ = (toDate!.difference(fromDate!).inDays + 1);
                                                        toController.text = formattedDate;
                                                        days = List.generate(differ, (i) => DateTime(fromDate!.year, fromDate!.month, fromDate!.day + (i)));
                                                        for (var element in days) {
                                                          leavesMap["date"] = DateFormat('MM-dd-yyyy').format(element);
                                                          leavesMap["type"] = "Casual";
                                                          leavesMap['fullDay'] = true;
                                                          leavesReq.add(leavesMap);
                                                          leavesMap = {};
                                                        }
                                                      });
                                                      if(toDate == fromDate){
                                                        setState(() {
                                                          sameDate = true;
                                                        });
                                                      }
                                                      else{
                                                        setState(() {
                                                          sameDate = false;
                                                        });
                                                      }
                                                    }
                                                  },
                                                ),
                                              ),
                                              sameDate ? Text('To date is same of From date', style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.red
                                              ),  textAlign: TextAlign.start,) : Container(),
                                              toEmpty == true
                                             ? Container(
                                                margin: const EdgeInsets.only(left: 15.0),
                                                child: const Text('Select To Date',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.red
                                                  ),
                                                ),
                                              )
                                                  : Container(),
                                            ],
                                          )
                                      ),
                                    ],
                                  ) : Container(),
                                  isMultipleDay ?  const Divider(indent: 20,) : Container(),

                                  isMultipleDay ? Container() : Row(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            gradient: gradient
                                          ),
                                          child: Icon(type_icon,size: 21.0,color: Colors.blue,)
                                      ),
                                      // SizedBox(width: 20,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.all(10.0),
                                                height: 40.0,
                                                // width: 150.0,
                                                margin: const EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                  border: Border.all(color: Colors.black45),
                                                ),
                                                child: DropdownButton<String>(
                                                  hint: Text("Select Leave Type",
                                                      style:textStyle),
                                                  // borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                  value: dropdownValue,
                                                  isExpanded: true,
                                                  icon: const Icon(Icons.keyboard_arrow_down),
                                                  iconSize: 20.0,
                                                  underline: Container(),
                                                  items: <String>['Casual', 'Medical', 'Unpaid'].map((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value.toString(),
                                                      child: Text(value.toString(),
                                                        style:const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15.0
                                                        ),),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? newValue) {
                                                    setState(() {
                                                      dropdownValue = newValue.toString();
                                                      types = false;
                                                    });
                                                  },
                                                )
                                            ),
                                            types ? Container(
                                              margin: const EdgeInsets.only(left: 15.0),
                                              child: Text('Select Leave Types', style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.red
                                              ),  textAlign: TextAlign.start,),
                                            ) : Container(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  isMultipleDay ?  Container() : const Divider(indent: 20,),
                                  sameDate == false ? days.length >= 1
                                   ? ListView.builder(
                                      padding: const EdgeInsets.all(10.0),
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: days.length,
                                      itemBuilder: (context,index){
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(DateFormat('dd-MM-yyyy').format(days[index]).toString()),
                                            Expanded(
                                              child: Container(
                                                  padding: const EdgeInsets.all(10.0),
                                                  height: 40.0,
                                                  margin: const EdgeInsets.all(10.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                    border: Border.all(color: Colors.black45),
                                                  ),
                                                  child: DropdownButton<String>(
                                                    hint: Text("Select Leave Type",
                                                        style:textStyle),
                                                    // borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                    value: leavesReq[index]["type"],
                                                    isExpanded: true,
                                                    icon: const Icon(Icons.keyboard_arrow_down),
                                                    iconSize: 20.0,
                                                    underline: Container(),
                                                    items: <String>['Casual', 'Medical', 'Unpaid'].map((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value.toString(),
                                                        child: Text(value.toString(),
                                                          style:const TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 15.0
                                                          ),),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? newValue) {
                                                      setState(() {
                                                        dropdownValue = newValue.toString();
                                                        leavesReq[index]["type"] = dropdownValue;
                                                      });
                                                    },
                                                  )
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Text("Half Day",style: textStyle,),
                                                  const SizedBox(width: 10.0,),
                                                  Expanded(
                                                    child: Switch(value: leavesReq[index]["fullDay"],
                                                        onChanged: (bool value){
                                                          if(leavesReq[index]["fullDay"] == false)
                                                          {
                                                            setState(() {
                                                              leavesReq[index]["fullDay"] = true;
                                                            });
                                                          }
                                                          else
                                                          {
                                                            setState(() {
                                                              leavesReq[index]["fullDay"] = false;
                                                            });
                                                          }
                                                        }
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10.0,),
                                                  Text("Full Day",style: textStyle,),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                  )
                                      : Container(): Container(),
                                  Row(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            gradient: gradient
                                          ),
                                          child: Icon(descriprion_icon,size: 21.0,color: Colors.blue,)
                                      ),
                                      Expanded(
                                          child:   Container(
                                            margin: const EdgeInsets.all( 10.0),
                                            child:  TextField(
                                              maxLines: 3,
                                              controller: reasonController,
                                              style: const TextStyle(color: Colors.black,fontSize: 14.0),
                                              decoration:  InputDecoration(
                                                  hintText: "Describe here (Optional)",
                                                  hintStyle: textStyle,
                                                  contentPadding: const EdgeInsets.all(10.0),
                                                  border: const OutlineInputBorder(
                                                    borderRadius:  BorderRadius.all(Radius.circular(10.0)),
                                                  )),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),

                                ],),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Consumer<LeaveReqProvider>(
                      builder: (context,data, _) {
                        return InkWell(
                          onTap: () async {

                            if(days.length >= 1){
                              // onTap("SuccessDully Added");
                            }
                            else{
                              setState(() {
                                if(fromController.text.isEmpty){
                                  fromEmpty = true;
                                }
                                if(toController.text.isEmpty){
                                  toEmpty = true;
                                }
                                if(dropdownValue == null){
                                  types = true;
                                }
                              });
                            }
                            if(!(types == true &&  toEmpty == true && fromEmpty == true)){
                              Map data = isMultipleDay ? {
                                "fromDate": DateFormat('MM-dd-yyyy').format(fromDate!),
                                "toDate": DateFormat('MM-dd-yyyy').format(toDate!),
                                'leaves': leavesReq, // this is a List
                              } :
                              {
                                "fromDate": DateFormat('MM-dd-yyyy').format(fromDate!),
                                "toDate": DateFormat('MM-dd-yyyy').format(fromDate!),
                                'leaves':  [
                                  {
                                    "date": DateFormat('MM-dd-yyyy').format(fromDate!),
                                    "fullDay" : isFullDay,
                                    "type" : dropdownValue
                                  }
                                ], // this is a List
                              };
                              await Provider.of<LeaveReqProvider>(context,listen: false).leaveReq(json.encode(data));
                              String? msg;
                              msg =  Provider.of<LeaveReqProvider>(context,listen: false).msg.toString();
                              msg.isNotEmpty ? onTaps(msg) : null;
                            }

                            fromController.clear();
                            toController.clear();
                            reasonController.clear();
                            setState(() {
                              dropdownValue == null;
                              days = [];
                              type = [];
                              fullDays = [];
                              leavesReq = [];
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(15.0),
                            height: 50,
                            padding: const EdgeInsets.all(10.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.blue
                            ),
                            child:  Center(child: days.length >= 1 ? Text("Apply For ${days.length} Days Leave",style: textStyle,) :  Text("Apply For Leave",style: textStyle,))
                          ),
                        );
                      }
                    ),
                  ),
                ],
              )

        ),
      ),
    );
  }

  onTaps(String msg){
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius:  BorderRadius.all(Radius.circular(10.0))
          ),
          content: Container(
            padding: const EdgeInsets.all(10.0),
            height: 100.0,
            child: Text(msg),
          ),
          actions: [
            ElevatedButton(
                onPressed: (){
                  Navigator.pop(ctx);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  const LeaveLists()));
                },
                child: const Text('Ok')
            )
          ],
        )
    );
  }

  void toggleSwitch(bool value) {

    if(isMultipleDay == false)
    {
      setState(() {
        isMultipleDay = true;
        fromEmpty = false;
        toEmpty = false;
        sameDate = false;
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isMultipleDay = false;
        days = [];
        fromController.clear();
        toController.clear();
        fromEmpty = false;
        toEmpty = false;
        sameDate = false;
      });
      print('Switch Button is OFF');
    }
  }

   fullDay(bool value) {

    if(isFullDay == false)
    {
      setState(() {
        isFullDay = true;
      });
      print('Full Day');
    }
    else
    {
      setState(() {
        isFullDay = false;
      });
      print('Half Day');
    }
  }

  TextStyle textStyle = const TextStyle(
  color: Colors.black54,fontSize: 14,fontWeight: FontWeight.w500,
  );

  LinearGradient gradient = LinearGradient(
    colors: <Color>[
      Colors.blue.shade200,
      Colors.white,
      Colors.blue.shade200,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomRight,
  );
}