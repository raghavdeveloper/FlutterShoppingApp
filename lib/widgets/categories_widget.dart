//@dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/providers/store_provider.dart';
import 'package:flutter_shopping_app/services/product_services.dart';
import 'package:provider/provider.dart';

class ShopCategories extends StatefulWidget {
  @override
  _ShopCategoriesState createState() => _ShopCategoriesState();
}

class _ShopCategoriesState extends State<ShopCategories> {
  ProductServices _services = ProductServices();

  List _catList = [];
  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: _store.storeDetails['uid'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //add all this in a list
        setState(() {
          _catList.add(doc['category']['mainCategory']);
        });
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _services.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong..'),
          );
        }
        if (_catList.length == 0) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData) {
          return Container();
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('images/city.png'))),
                    child: Center(
                      child: Text(
                        'Shop By Category',
                        style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 3.0,
                                  color: Colors.black)
                            ],
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                  ),
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return _catList.contains(document.data()['name'])
                      ? //only if catList contain the category name from selected vendor
                      Container(
                          width: 120,
                          height: 150,
                          child: Container(
                            //card
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.grey, width: .5)),
                            child: Column(
                              children: [
                                Center(
                                  child:
                                      Image.network(document.data()['image']),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    document.data()['name'],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Text('');
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
