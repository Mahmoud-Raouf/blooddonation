/*
  هذا الكود يقوم بتعريف مجموعة من الوظائف التي تقوم بجلب معلومات حول المستخدم الحالي من خدمة Firebase Authentication و Cloud Firestore.

  - getCurrentUserData(): تستخدم لجلب اسم المستخدم الحالي.
  - getNumberofvisitsUser(): تستخدم لجلب عدد زيارات المستخدم الحالي.
  - getCurrentUserNumberPhone(): تستخدم لجلب رقم الهاتف للمستخدم الحالي.
  - getCurrentUserNumberofvisits(): تستخدم لجلب عدد زيارات المستخدم الحالي.
  - getCurrentUserUid(): تستخدم لجلب معرف المستخدم الحالي.
  - getCurrentEmail(): تستخدم لجلب البريد الإلكتروني للمستخدم الحالي.

  يتم استخدام Firestore لجلب المعلومات المخزنة عن المستخدمين، وهنا يتم تحديد المجموعة باستخدام مجموعة مختارة بواسطة "uid" للمستخدم الحالي.

  يجب التأكد من أنه تم تكوين Firebase وتكوين Firestore في تطبيقك لضمان عمل هذه الوظائف بشكل صحيح.

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final currentUser = FirebaseAuth.instance.currentUser!;
final FirebaseAuth _auth = FirebaseAuth.instance;

// جلب اسم المستخدم الحالي
getCurrentUseData() async {
  final User user = _auth.currentUser!;
  final uid = user.uid;
  final CollectionReference documentReference = FirebaseFirestore.instance.collection("customUsers");

  final QuerySnapshot querySnapshot = await documentReference.where("uid", isEqualTo: uid).get();

  // الحصول على أول وثيقة من نتائج الاستعلام
  final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

  final String name = documentSnapshot['name'];
  return name;
}

Future<String> getclinicAppointmentsDocument() async {
  final User user = _auth.currentUser!;
  final uid = user.uid;
  final CollectionReference documentReference = FirebaseFirestore.instance.collection("hospitals");

  final QuerySnapshot querySnapshot = await documentReference.where("uid", isEqualTo: uid).get();

  if (querySnapshot.docs.isEmpty) {
    throw Exception("No documents found for user $uid");
  }

  final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
  final String documentId = documentSnapshot.id;
  return documentId;
}

// جلب رقم الهاتف للمستخدم الحالي
Future<String> getCurrentUserNumberPhone() async {
  final User user = _auth.currentUser!;
  final uid = user.uid;
  final CollectionReference documentReference = FirebaseFirestore.instance.collection("customUsers");

  final QuerySnapshot querySnapshot = await documentReference.where("uid", isEqualTo: uid).get();

  final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

  final String number = documentSnapshot['number'];

  return number;
}

Future<String> getCurrentUserAge() async {
  final User user = _auth.currentUser!;
  final uid = user.uid;
  final CollectionReference documentReference = FirebaseFirestore.instance.collection("customUsers");

  final QuerySnapshot querySnapshot = await documentReference.where("uid", isEqualTo: uid).get();

  final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

  final String age = documentSnapshot['age'];

  return age;
}

Future<String> getCurrentUserWeight() async {
  final User user = _auth.currentUser!;
  final uid = user.uid;
  final CollectionReference documentReference = FirebaseFirestore.instance.collection("customUsers");

  final QuerySnapshot querySnapshot = await documentReference.where("uid", isEqualTo: uid).get();

  final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

  final String weight = documentSnapshot['weight'];

  return weight;
}

Future<String> getCurrentUserChronicDiseases() async {
  final User user = _auth.currentUser!;
  final uid = user.uid;
  final CollectionReference documentReference = FirebaseFirestore.instance.collection("customUsers");

  final QuerySnapshot querySnapshot = await documentReference.where("uid", isEqualTo: uid).get();

  final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

  final String chronicDiseases = documentSnapshot['chronicDiseases'];

  return chronicDiseases;
}

// جلب عدد زيارات المستخدم الحالي
Future<String> getCurrentUserLocation() async {
  final User user = _auth.currentUser!;
  final uid = user.uid;
  final CollectionReference documentReference = FirebaseFirestore.instance.collection("customUsers");

  final QuerySnapshot querySnapshot = await documentReference.where("uid", isEqualTo: uid).get();

  final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

  final String location = documentSnapshot['location'];

  return location;
}

Future<String> getCurrentUserbloodType() async {
  final User user = _auth.currentUser!;
  final uid = user.uid;
  final CollectionReference documentReference = FirebaseFirestore.instance.collection("customUsers");

  final QuerySnapshot querySnapshot = await documentReference.where("uid", isEqualTo: uid).get();

  final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

  final String bloodType = documentSnapshot['bloodType'];

  return bloodType;
}

// جلب معرف المستخدم الحالي
getCurrentUserUid() async {
  final User user = _auth.currentUser!;
  final uid = user.uid;

  return uid;
}

// جلب البريد الإلكتروني للمستخدم الحالي
getCurrentEmail() async {
  final User user = _auth.currentUser!;
  final uemail = user.email;
  return uemail;
}
