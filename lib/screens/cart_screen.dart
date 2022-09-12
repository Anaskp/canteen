import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map cart = {};

  final user = FirebaseAuth.instance.currentUser;

  fetchCart() async {
    var data = await FirebaseFirestore.instance
        .collection('usersData')
        .doc(user!.uid)
        .get();
    setState(() {
      cart = data['cart'];
    });
  }

  @override
  void initState() {
    fetchCart();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cart',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              FutureBuilder(
                future: fetchCart(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cart.length,
                    itemBuilder: (BuildContext context, int index) {
                      fetchCart();
                      String key = cart.keys.elementAt(index);

                      return Card(
                        child: ListTile(
                          title: Text(key),
                          subtitle: Text('Quantity: ${cart[key].toString()}'),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove,
                            ),
                            onPressed: () {
                              removeQuantity(key, cart[key]);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      checkout(cart);
                    },
                    child: const Text('Check Out'),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  removeQuantity(key, qty) async {
    if (cart[key] == 1) {
      await FirebaseFirestore.instance
          .collection('usersData')
          .doc(user!.uid)
          .update({
        'cart.$key': FieldValue.delete(),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('usersData')
          .doc(user!.uid)
          .update({
        'cart.$key': qty - 1,
      });
    }
  }

  checkout(cart) async {
    if (cart == {}) null;

    var data = await FirebaseFirestore.instance
        .collection('usersData')
        .doc(user!.uid)
        .get();

    var number = data['mobile'];

    await FirebaseFirestore.instance.collection('orders').doc(number).set({
      'order': cart,
    });

    await FirebaseFirestore.instance
        .collection('usersData')
        .doc(user!.uid)
        .update({'cart': {}});

    cart = {};
  }
}
