import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lrcokl/controllers/attendance.controller.dart';
import 'package:lrcokl/controllers/update.comtroller.dart';
import 'package:lrcokl/helpers/dropdown.helper.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class AttendanceComponent extends StatefulWidget {
  AttendanceComponent({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _AttendanceComponentState createState() => _AttendanceComponentState();
}

class _AttendanceComponentState extends State<AttendanceComponent> {
  final AttendanceController attendanceController = Get.find();
  final UpdateController updateController = Get.find();
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        SizedBox(
          width: 200,
          child: Obx(() => AwesomeDropDown(
                isPanDown: attendanceController.isPanDown,
                dropDownList: attendanceController.types,
                dropDownIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                  size: 23,
                ),
                selectedItem: attendanceController.selectedType.value,
                onDropDownItemClick: (selectedType) {
                  attendanceController.selectedType.value = selectedType;
                  attendanceController.reloadMembers();
                },
                dropStateChanged: (isOpened) {
                  // _isDropDownOpened = isOpened;
                  // if (!isOpened) {
                  //   _isBackPressedOrTouchedOutSide = false;
                  // }
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 10),
          child: SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  updateController.onInit();
                  Get.toNamed('/update')!.then((value) {
                    attendanceController.onInit();
                  });
                },
                child: Text("Update My Attendance"),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.0),
                )))),
          ),
        )
      ]),
      Spacer(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: size.height * 0.72,
          child: Obx(() => HorizontalDataTable(
                leftHandSideColumnWidth: 120,
                rightHandSideColumnWidth:
                    100.0 * (attendanceController.dates.length + 1),
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder: _generateRightHandSideColumnRow,
                itemCount: attendanceController.members.length,
                rowSeparatorWidget: const Divider(
                  color: Colors.black54,
                  height: 1.0,
                  thickness: 0.0,
                ),
                leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                verticalScrollbarStyle: const ScrollbarStyle(
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: Radius.circular(5.0),
                ),
                horizontalScrollbarStyle: const ScrollbarStyle(
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: Radius.circular(5.0),
                ),
                enablePullToRefresh: true,
                refreshIndicator: const WaterDropHeader(),
                refreshIndicatorHeight: 60,
                onRefresh: () async {
                  //Do sth
                  await Future.delayed(const Duration(milliseconds: 500));
                  _hdtRefreshController.refreshCompleted();
                },
                htdRefreshController: _hdtRefreshController,
              )),
        ),
      ),
    ]);
  }

  List<Widget> _getTitleWidget() {
    List<Widget> titles = [];
    titles.add(_getTitleItemWidget("Name", 100));
    titles.add(_getTitleItemWidget("Percentage", 100));
    for (int i = 0; i < attendanceController.dates.length; i++) {
      titles.add(_getTitleItemWidget(attendanceController.dates[i], 100));
    }

    return titles;
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(attendanceController.members[index].name),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    List<Widget> contents = [];
    contents.add(Container(
      child: Text(attendanceController.members[index].percentage,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: int.parse(attendanceController.members[index].percentage
                        .substring(
                            0,
                            attendanceController
                                    .members[index].percentage.length -
                                1)) >=
                    80
                ? Colors.green
                : Colors.red,
          )),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    ));

    for (var i = 0;
        i < attendanceController.members[index].attendances.length;
        i++) {
      contents.add(Container(
        child: Text(
          attendanceController.members[index].attendances[i],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:
                attendanceController.members[index].attendances[i] == "Present"
                    ? Colors.green
                    : Colors.red,
          ),
        ),
        width: 100,
        height: 52,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ));
    }
    return Row(children: contents);
  }
}
