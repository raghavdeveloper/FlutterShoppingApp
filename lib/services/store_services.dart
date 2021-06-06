//@dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  CollectionReference shopBanner =
      FirebaseFirestore.instance.collection('shopBanner');
  CollectionReference shops = FirebaseFirestore.instance.collection('shops');

  getTopPickedStore() {
    return shops
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .where('shopOpen', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }

  getNearbyStore() {
    return shops
        .where('accVerified', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }

  getNearByStorePagination() {
    return shops.where('accVerified', isEqualTo: true).orderBy('shopName');
  }

  Future<DocumentSnapshot> getShopDetails(sellerUid) async {
    DocumentSnapshot snapshot = await shops.doc(sellerUid).get();
    return snapshot;
  }
}

//this will show only verified sellers
//this will show only top picked vendor by admin
//this will sort the stores in alphabetic order
