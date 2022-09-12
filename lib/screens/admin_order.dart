import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrder extends StatelessWidget {
  const AdminOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (!streamSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (streamSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No orders'),
            );
          } else {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderDetails(
                          documentId: documentSnapshot.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(documentSnapshot.id),
                      trailing: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          orderComplete(documentSnapshot.id);
                        },
                      ),
                    ),
                  ),
                );
              },
              itemCount: streamSnapshot.data!.docs.length,
            );
          }
        },
      ),
    );
  }

  orderComplete(documentId) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(documentId)
        .delete();
  }
}

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key, required this.documentId}) : super(key: key);

  final documentId;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Map order = {};

  @override
  void initState() {
    fetchCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
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
      ),
    );
  }

  fetchCart() async {
    var data = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.documentId)
        .get();
    setState(() {
      order = data['order'];
    });
  }
}
