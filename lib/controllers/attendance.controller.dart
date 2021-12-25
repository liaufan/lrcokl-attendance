import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';

class AttendanceController extends GetxController {
  final bool isPanDown = false;
  final List<String> types = [];
  String selectedType = "";
  RxList members = [].obs;

  bool isAscending = true;
  RxList<String> dates = <String>[].obs;

  final eventsRef = FirebaseFirestore.instance.collection("events");
  final membersRef = FirebaseFirestore.instance.collection("members");
  final typesRef = FirebaseFirestore.instance.collection("types");

  @override
  void onInit() {
    super.onInit();

    typesRef.get().then((value) {
      value.docs.forEach((doc) {
        types.add(doc.data()["name"]);
      });

      selectedType = types[0];
    });

    eventsRef.get().then((value) {
      value.docs.forEach((doc) {
        if (doc.data()["type"] ==
            selectedType.toLowerCase().replaceAll(" ", "_")) {
          dates.add(Jiffy(doc.data()["date"].toDate()).yMMMd);
        }
      });
    });

    membersRef.get().then((value) {
      value.docs.forEach((doc) {
        if (doc.data()["type"] ==
            selectedType.toLowerCase().replaceAll(" ", "_")) {
          List<String> attendance_date = [];
          doc.data()["attendance"].forEach((a) {
            attendance_date.add(Jiffy(a.toDate()).yMMMd);
          });

          List<String> attendance = [];

          dates.forEach((date) {
            if (attendance_date.contains(date)) {
              attendance.add("Present");
            } else {
              attendance.add("Absent");
            }
          });

          members.add(UserInfo(
              doc.data()["name_chi"],
              ((attendance_date.length / dates.length) * 100).toString() + "%",
              attendance));
        }
      });
    });
  }

  reloadMembers() {
    members.clear();
    dates.clear();
    eventsRef.get().then((value) {
      value.docs.forEach((doc) {
        if (doc.data()["type"] ==
            selectedType.toLowerCase().replaceAll(" ", "_")) {
          dates.add(Jiffy(doc.data()["date"].toDate()).yMMMd);
        }
      });
    });
    membersRef.get().then((value) {
      value.docs.forEach((doc) {
        if (doc.data()["type"] ==
            selectedType.toLowerCase().replaceAll(" ", "_")) {
          List<String> attendance_date = [];
          doc.data()["attendance"].forEach((a) {
            attendance_date.add(Jiffy(a.toDate()).yMMMd);
          });

          List<String> attendance = [];

          dates.forEach((date) {
            if (attendance_date.contains(date)) {
              attendance.add("Present");
            } else {
              attendance.add("Absent");
            }
          });

          members.add(UserInfo(
              doc.data()["name_chi"],
              ((attendance_date.length / dates.length) * 100).toString() + "%",
              attendance));
        }
      });
    });
  }
}

class UserInfo {
  String name;
  String percentage;
  List<String> attendances;

  UserInfo(this.name, this.percentage, this.attendances);
}
