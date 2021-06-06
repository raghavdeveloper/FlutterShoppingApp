//@dart=2.9
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/providers/store_provider.dart';
import 'package:flutter_shopping_app/services/store_services.dart';
import 'package:provider/provider.dart';

class ShopBanner extends StatefulWidget {
  @override
  _ShopBannerState createState() => _ShopBannerState();
}

class _ShopBannerState extends State<ShopBanner> {
  int _index = 0;
  int _dataLength = 1;

  @override
  void didChangeDependencies() {
    //here we can use context
    var _storeProvider = Provider.of<StoreProvider>(context);
    getBannerImageFromDb(_storeProvider);

    super.didChangeDependencies();
  }

  Future getBannerImageFromDb(StoreProvider storeProvider) async {
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _fireStore
        .collection('shopBanner')
        .where('sellerUid', isEqualTo: storeProvider.storeDetails['uid'])
        .get();
    if (mounted) {
      setState(() {
        _dataLength = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    //we need to get banner only from selected shop
    var _storeProvider = Provider.of<StoreProvider>(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (_dataLength != 0)
            FutureBuilder(
              future: getBannerImageFromDb(_storeProvider),
              builder: (_, snapShot) {
                return snapShot.data == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: CarouselSlider.builder(
                            itemCount: snapShot.data.length,
                            itemBuilder: (context, int index, _) {
                              DocumentSnapshot sliderImage =
                                  snapShot.data[index];
                              Map getImage = sliderImage.data();
                              return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.network(
                                    getImage['bannerUrl'],
                                    fit: BoxFit.fill,
                                  ));
                            },
                            options: CarouselOptions(
                                viewportFraction: 1,
                                initialPage: 0,
                                autoPlay: true,
                                height: 180,
                                onPageChanged:
                                    (int i, carouselPageChangedReason) {
                                  setState(() {
                                    _index = i;
                                  });
                                })),
                      );
              },
            ),
          if (_dataLength != 0)
            DotsIndicator(
              dotsCount: _dataLength,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                  size: const Size.square(5.0),
                  activeSize: const Size(18.0, 5.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  activeColor: Theme.of(context).primaryColor),
            )
        ],
      ),
    );
  }
}
