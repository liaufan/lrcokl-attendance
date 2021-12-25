import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lrcokl/controllers/attendance.controller.dart';
import 'package:lrcokl/controllers/update.comtroller.dart';
import 'package:lrcokl/helpers/dropdown.helper.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:flutter_switch/flutter_switch.dart';

class UpdateComponent extends StatefulWidget {
  UpdateComponent({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _UpdateComponentState createState() => _UpdateComponentState();
}

class _UpdateComponentState extends State<UpdateComponent> {
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
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: DropdownSearch<String>(
          mode: Mode.DIALOG,
          showSearchBox: true,
          items: updateController.names,
          label: "Name",
          hint: "country in menu mode",
          onChanged: (value) {
            print(value);
            updateController.selectedName.value = value ?? "";
            updateController.selectName(value ?? "");
          },
        ),
      ),
      Obx(() => updateController.attendances.isNotEmpty
          ? _getAttendanceSwitchers()
          : Container())
    ]);
  }

  Widget _getAttendanceSwitchers() {
    List<Widget> switches = [];
    for (int i = 0; i < updateController.attendances.length; i++) {
      switches.add(Obx(() => Row(
            children: [
              Text(Jiffy(updateController.attendances[i].date).yMMMd),
              FlutterSwitch(
                width: 60.0,
                height: 30.0,
                valueFontSize: 12.0,
                toggleSize: 22.0,
                value: updateController.attendances[i].present.value,
                borderRadius: 30.0,
                padding: 4.0,
                showOnOff: true,
                onToggle: (val) {
                  updateController.toggleAttendance(
                      updateController.attendances[i].date, val);
                  updateController.attendances[i].present.value = val;
                },
              ),
            ],
          )));
    }
    return Column(
      children: switches,
    );
  }
}
