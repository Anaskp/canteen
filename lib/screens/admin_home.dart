import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  AdminHome({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('menu').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (!streamSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (streamSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No food added'),
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _update(context, documentSnapshot);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('menu')
                                  .doc(documentSnapshot.id)
                                  .delete();
                            },
                          ),
                        ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _add(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _add(context) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _costController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: (() async {
                    await FirebaseFirestore.instance
                        .collection('menu')
                        .doc()
                        .set({
                      'name': _nameController.text,
                      'cost': double.parse(_costController.text),
                      'quantity': double.parse(_quantityController.text),
                    });
                    _nameController.text = '';
                    _costController.text = '';
                    _quantityController.text = '';
                    Navigator.of(context).pop();
                    //}
                  }),
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _update(context, DocumentSnapshot documentSnapshot) async {
    _nameController.text = documentSnapshot['name'];
    _costController.text = documentSnapshot['cost'].toString();
    _quantityController.text = documentSnapshot['quantity'].toString();

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _costController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: (() async {
                    await FirebaseFirestore.instance
                        .collection('menu')
                        .doc(documentSnapshot.id)
                        .update({
                      'name': _nameController.text,
                      'cost': double.parse(_costController.text),
                      'quantity': double.parse(_quantityController.text),
                    });
                    _nameController.text = '';
                    _costController.text = '';
                    _quantityController.text = '';
                    Navigator.of(context).pop();
                    //}
                  }),
                  child: const Text('Update'),
                ),
              ],
            ),
          );
        });
  }
}
