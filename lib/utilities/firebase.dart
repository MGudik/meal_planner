import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/invitation.dart';
import 'package:meal_planner/models/week.dart';

Future<String> createEmptyMealPlan() async {
  final response =
      await FirebaseFirestore.instance.collection('mealplans').add({
    'monday': null,
    'tuesday': null,
    'wednesday': null,
    'thursday': null,
    'friday': null,
    'saturday': null,
    'sunday': null,
    'wishes': [],
  });

  return response.id;
}

void updateDay(WeekDay day, String? meal) async {
  final mealPlanId = await getMealPlanId();
  FirebaseFirestore.instance
      .collection('mealplans')
      .doc(mealPlanId)
      .update({day.toString(): meal == null ? null : meal});
}

void clearDay(WeekDay day) async {
  updateDay(day, null);
}

Future<void> addWish(String wish) async {
  final mealPlanId = await getMealPlanId();
  final username = await getUsername();
  final document = await FirebaseFirestore.instance
      .collection('mealplans')
      .doc(mealPlanId)
      .get();
  final currentWishes = document.get('wishes') as List;
  currentWishes.add({'title': wish, 'wishedBy': username});

  FirebaseFirestore.instance
      .collection('mealplans')
      .doc(mealPlanId)
      .update({'wishes': currentWishes});
}

void removeWish(Wish wish) async {
  final mealPlanId = await getMealPlanId();
  final document = await FirebaseFirestore.instance
      .collection('mealplans')
      .doc(mealPlanId)
      .get();
  final currentWishes = document.get('wishes') as List;
  currentWishes.removeAt(int.parse(wish.id));
  FirebaseFirestore.instance.collection('mealplans').doc(mealPlanId).update({
    'wishes': currentWishes,
  });
}

Future<String> getMealPlanId() async {
  final authenticatedUser = FirebaseAuth.instance.currentUser!;
  final userStore = await FirebaseFirestore.instance
      .collection('users')
      .doc(authenticatedUser.uid)
      .get();
  final mealPlanId = userStore.get('mealId');
  return mealPlanId;
}

Future<String> getUsername() async {
  final authenticatedUser = FirebaseAuth.instance.currentUser!;
  final userStore = await FirebaseFirestore.instance
      .collection('users')
      .doc(authenticatedUser.uid)
      .get();
  final username = userStore.get('username');
  return username;
}

Future<List<Wish>> getWishList() async {
  final mealPlanId = await getMealPlanId();
  final document = await FirebaseFirestore.instance
      .collection('mealplans')
      .doc(mealPlanId)
      .get();
  final currentWishes = document.get('wishes') as List;

  return currentWishes.asMap().entries.map((entry) {
    int idx = entry.key;
    Map<String, dynamic> val = entry.value;
    return Wish(
        id: idx.toString(), title: val['title'], wishedBy: val['wishedBy']);
  }).toList();
}

void deleteInvitation(Invitation invitation) async {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userData = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .get();

  final List invitations = userData.get('invitations');
  final new_invitations = invitations.where((element) {
    return !(element['invitedBy'] == invitation.invitedBy &&
        element['planID'] == invitation.planID);
  });
  FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .update({'invitations': new_invitations});
}

Future<void> acceptInvitation(Invitation invitation) async {
  final currentUser = FirebaseAuth.instance.currentUser!;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .update({'mealId': invitation.planID});
}

void inviteUser(String email) async {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userData = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .get();
  if (email.toLowerCase() == userData.get('email')) {
    return;
  }
  final username = userData.get('username');
  final mealPlan = userData.get('mealId');
  final documents = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email.toLowerCase())
      .get()
      .then((snapshot) => snapshot.docs);

  if (documents.length == 0) {
    return;
  }
  final targetDoc = documents[0];
  final List<dynamic> invitations = targetDoc.get('invitations');
  final planAlreadyExists = invitations.where((element) {
        if (element['planID'] == mealPlan) {
          return true;
        } else {
          return false;
        }
      }).length >
      0;
  if (planAlreadyExists) {
    return;
  }

  FirebaseFirestore.instance.collection('users').doc(targetDoc.id).update({
    'invitations': [
      ...invitations,
      {'invitedBy': username, 'planID': mealPlan}
    ]
  });
}
