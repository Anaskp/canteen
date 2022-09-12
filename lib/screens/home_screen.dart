import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('menu')
              .where('quantity', isGreaterThan: 0)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (!streamSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (streamSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No food available'),
              );
            } else {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    child: ListTile(
                      title: Text(documentSnapshot['name']),
                      subtitle: Row(
                        children: [
                          Text('Price: ${documentSnapshot['cost'].toString()}'),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              'Quantity: ${documentSnapshot['quantity'].toString()}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          addCart(documentSnapshot['name']);
                        },
                      ),
                    ),
                  );
                },
                itemCount: streamSnapshot.data!.docs.length,
              );
            }
          },
        ),
      ),
    );
  }

  addCart(name) async {
    final user = FirebaseAuth.instance.currentUser;

    var data = await FirebaseFirestore.instance
        .collection('usersData')
        .doc(user!.uid)
        .get();

    var cart = data['cart'];

    if (cart.containsKey(name)) {
      int n = cart[name];

      await FirebaseFirestore.instance
          .collection('usersData')
          .doc(user.uid)
          .update({'cart.$name': n + 1});
    } else {
      await FirebaseFirestore.instance
          .collection('usersData')
          .doc(user.uid)
          .update({'cart.$name': 1});
    }
  }
}
