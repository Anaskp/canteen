import 'package:canteen_app/screens/auth_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? number;
  Map order = {};
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    fetchData();

    fetchCart();
    super.initState();
  }

  fetchCart() async {
    var data =
        await FirebaseFirestore.instance.collection('orders').doc(number).get();
    setState(() {
      order = data['order'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(name ?? ''),
              const SizedBox(
                height: 10,
              ),
              Text(number ?? ''),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen()),
                      (route) => false);
                },
                child: const Text('Log Out'),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: fetchCart(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: order.length,
                    itemBuilder: (BuildContext context, int index) {
                      fetchCart();
                      String key = order.keys.elementAt(index);

                      return Card(
                        child: ListTile(
                          title: Text(key),
                          subtitle: Text('Quantity: ${order[key].toString()}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  fetchData() async {
    var data = await FirebaseFirestore.instance
        .collection('usersData')
        .doc(user!.uid)
        .get();
    setState(() {
      name = data['name'];
      number = data['mobile'];
    });
  }
}
