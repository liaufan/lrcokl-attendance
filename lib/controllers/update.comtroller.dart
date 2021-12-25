import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';

class UpdateController extends GetxController {
  final bool isPanDown = false;
  final List<String> types = [];
  String selectedType = "";
  RxList members = [].obs;
  RxList<String> names = <String>[].obs;
  RxString selectedName = "".obs;
  RxList<Attendance> attendances = <Attendance>[].obs;

  bool isAscending = true;
  RxList<DateTime> dates = <DateTime>[].obs;

  final eventsRef = FirebaseFirestore.instance.collection("events");
  final membersRef = FirebaseFirestore.instance.collection("members");
  final typesRef = FirebaseFirestore.instance.collection("types");

  @override
  void onInit() {
    super.onInit();
    names.clear();
    attendances.clear();
    members.clear();
    dates.clear();
    selectedName.value = "";

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
          dates.add(doc.data()["date"].toDate());
        }
      });
    });

    membersRef.get().then((value) {
      value.docs.forEach((doc) {
        names.add(doc.data()["name_chi"]);
      });
    });
  }

  toggleAttendance(DateTime date, bool present) {
    if (present) {
      membersRef
          .where("name_chi", isEqualTo: selectedName.value)
          .get()
          .then((value) {
        membersRef.doc(value.docs[0].id).update({
          "attendance": FieldValue.arrayUnion([Timestamp.fromDate(date)])
        });
      });
    } else {
      membersRef
          .where("name_chi", isEqualTo: selectedName.value)
          .get()
          .then((value) {
        membersRef.doc(value.docs[0].id).update({
          "attendance": FieldValue.arrayRemove([Timestamp.fromDate(date)])
        });
      });
    }
  }

  selectName(String name) {
    dates.clear();
    attendances.clear();
    membersRef.get().then((value) {
      value.docs.forEach((doc) {
        if (doc.data()["name_chi"] == name) {
          List<DateTime> attendance_date = [];
          doc.data()["attendance"].forEach((a) {
            attendance_date.add(a.toDate());
          });

          selectedType = doc.data()["type"];
          eventsRef.get().then((value) {
            value.docs.forEach((doc) {
              if (doc.data()["type"] ==
                  selectedType.toLowerCase().replaceAll(" ", "_")) {
                dates.add(doc.data()["date"].toDate());
              }
            });

            dates.forEach((date) {
              attendances
                  .add(Attendance(date, attendance_date.contains(date).obs));
            });
          });
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

class Attendance {
  DateTime date;
  RxBool present;

  Attendance(this.date, this.present);
}
