import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uas_pemmob_wap/models/posts.dart';
import 'package:uas_pemmob_wap/models/comments.dart';
import 'package:http/http.dart' as http;

class CommentsPage extends StatefulWidget {
  final Posts post;
  const CommentsPage({Key? key, required this.post}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  bool isLoading = true;

  List<Comments> comments = [];

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController bodyCtrl = TextEditingController();

  getDataComments() async {
    http
        .get(Uri.parse(
            "https://jsonplaceholder.typicode.com/comments/${widget.post.id}/comments"))
        .then((value) {
      print(value.body);
      setState(() {
        comments = commentsFromJson(value.body);
        isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      print(error);
    });
  }

  addComments(String name, String email, String body) {
    setState(() {
      isLoading = true;
    });
    http.post(Uri.parse("https://jsonplaceholder.typicode.com/comments"),
        body: {
          'name': name,
          'email': email,
          'body': body,
          'postId': widget.post.id.toString()
        }).then((value) {
      print(value.body);
      setState(() {
        isLoading = false;
        // Comments commentNew = commentFromJson(value.body);
        var bodyNya = json.decode(value.body);
        comments.insert(
            0,
            Comments(
                id: bodyNya['id'],
                name: name,
                email: email,
                body: body,
                postId: widget.post.id));
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    getDataComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Komentar')),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.bottomSheet(
                  SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            // mainAxisAlignment:
                            //     MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                "Tambah Komentar",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Divider(),
                              TextFormField(
                                controller: nameCtrl,
                                decoration: InputDecoration(
                                  labelText: "Nama",
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: emailCtrl,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                maxLines: 5,
                                controller: bodyCtrl,
                                decoration: InputDecoration(
                                  labelText: "Deskripsi",
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextButton.icon(
                                  onPressed: () {
                                    addComments(nameCtrl.text, emailCtrl.text,
                                        bodyCtrl.text);
                                    Get.back();
                                  },
                                  icon: Icon(Icons.save),
                                  label: Text('Simpan')),
                            ]),
                      ),
                    ),
                  ),
                  isScrollControlled: true);
            },
            child: Icon(Icons.add_comment)),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text(widget.post.title),
                      subtitle: Text(widget.post.body),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.comment),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'List Komentar',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return ListTile(
                            title: Row(
                              children: [
                                Text(comments[i].email),
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comments[i].name),
                                Text(comments[i].body),
                              ],
                            ));
                      },
                      itemCount: comments.length,
                    ),
                  ),
                ],
              ));
  }
}
