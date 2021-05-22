//@dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  CollectionReference shopBanner =
      FirebaseFirestore.instance.collection('shopBanner');

  getTopPickedStore() {
    return FirebaseFirestore.instance
        .collection('shops')
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .where('shopOpen', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }

  getNearbyStore() {
    return FirebaseFirestore.instance
        .collection('shops')
        .where('accVerified', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }

  getNearByStorePagination() {
    return FirebaseFirestore.instance
        .collection('shops')
        .where('accVerified', isEqualTo: true)
        .orderBy('shopName');
  }
}

//this will show only verified sellers
//this will show only top picked vendor by admin
//this will sort the stores in alphabetic order
