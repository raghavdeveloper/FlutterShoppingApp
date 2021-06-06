//@dart=2.9

import 'dart:ui';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/providers/order_provider.dart';
import 'package:flutter_shopping_app/services/order_services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  OrderServices _orderServices = OrderServices();
  User user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = [
    'All Orders',
    'Ordered',
    'Accepted',
    'Picked Up',
    'On The Way',
    'Delivered'
  ];

  @override
  Widget build(BuildContext context) {
    var _orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(
            'My Orders',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                CupertinoIcons.search,
                color: Colors.white,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: ChipsChoice<int>.single(
                choiceStyle: C2ChoiceStyle(
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                value: tag,
                onChanged: (val) {
                  if (val == 0) {
                    setState(() {
                      _orderProvider.status = null;
                    });
                  }
                  setState(() {
                    tag = val;
                    _orderProvider.status = options[val];
                  });
                },
                choiceItems: C2Choice.listFrom<int, String>(
                  source: options,
                  value: (i, v) => i,
                  label: (i, v) => v,
                ),
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _orderServices.orders
                    .where('userId', isEqualTo: user.uid)
                    .where('orderStatus',
                        isEqualTo: tag > 0 ? _orderProvider.status : null)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data.size == 0) {
                    //TODO:NO Order screen
                    return Center(
                      child: Text(tag > 0
                          ? 'No ${options[tag]} orders'
                          : 'No Orders. Continue Shopping'),
                    );
                  }

                  return Expanded(
                    child: new ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return new Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                horizontalTitleGap: 0,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 14,
                                  child: Icon(
                                    CupertinoIcons.square_list,
                                    size: 18,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                title: Text(
                                  document.data()['orderStatus'],
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orangeAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'On ${DateFormat.yMMMd().format(DateTime.parse(document.data()['timestamp']))}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Payment Type : ${document.data()['cod'] == true ? 'Cash on delivery' : 'Pay Online'}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Amount : \$${document.data()['total'].toStringAsFixed(0)}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              //TODO: Delivery boy contact, live location, and delivery boy name
                              ExpansionTile(
                                title: Text(
                                  'Order details',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                                subtitle: Text(
                                  'View order details',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Image.network(
                                              document.data()['products'][index]
                                                  ['productImage']),
                                        ),
                                        title: Text(
                                          document.data()['products'][index]
                                              ['productName'],
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        subtitle: Text(
                                          '${document.data()['products'][index]['qty']} x \$${document.data()['products'][index]['price'].toStringAsFixed(0)} = \$${document.data()['products'][index]['total'].toStringAsFixed(0)}',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      );
                                    },
                                    itemCount:
                                        document.data()['products'].length,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12, top: 8, bottom: 8),
                                    child: Card(
                                      elevation: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Seller : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  document.data()['seller']
                                                      ['shopName'],
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            if (int.parse(document
                                                    .data()['discount']) >
                                                0) //only if discount available
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Discount : ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          '${document.data()['discount']}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Discount Code: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          '${document.data()['discountCode']}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Delivery Fee: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  '\$${document.data()['deliveryFee'].toString()}',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                height: 3,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
