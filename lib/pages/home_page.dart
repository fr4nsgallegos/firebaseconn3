import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseconn3/apiservices/api_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  CollectionReference userReference =
      FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ApiServices().getPokemonInfo();
        },
      ),
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder(
            future: userReference.get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                QuerySnapshot userCollection = snapshot.data;
                List<QueryDocumentSnapshot> docs = userCollection.docs;
                return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          docs[index]["name"],
                        ),
                      );
                    });
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
