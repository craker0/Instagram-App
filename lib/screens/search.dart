



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/screens/profile.dart';
import 'package:insta/shared/colors.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchController.addListener(showUsre);
  }

  showUsre() {
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(labelText: "Search User ..."),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Users')
            .where('username', isEqualTo: searchController.text)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(9, 15, 9, 5),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(
                                      uid: snapshot.data!.docs[index]['uid'],
                                    )));
                      },
                      title: Text(snapshot.data!.docs[index]['username']),
                      leading: CircleAvatar(
                        radius: 33,
                        backgroundImage: NetworkImage(
                            snapshot.data!.docs[index]['profileImg']),
                      ),
                    ),
                  );
                });
          }

          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        },
      ),
    );
  }
}
