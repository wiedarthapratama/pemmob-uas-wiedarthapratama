import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uas_pemmob_wap/models/posts.dart';
import 'package:http/http.dart' as http;
import 'package:uas_pemmob_wap/pages/comments_page.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  bool isLoading = true;

  List<Posts> posts = [];

  TextEditingController judulCtrl = TextEditingController();
  TextEditingController deskripsiCtrl = TextEditingController();

  getDataPosts() async {
    http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/posts"))
        .then((value) {
      print(value.body);
      setState(() {
        posts = postsFromJson(value.body);
        isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      print(error);
    });
  }

  deletePosts(Posts post) {
    setState(() {
      isLoading = true;
    });
    http
        .delete(
            Uri.parse("https://jsonplaceholder.typicode.com/posts/${post.id}"))
        .then((value) {
      print(value.body);
      setState(() {
        posts.remove(post);
        isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      print(error);
    });
  }

  ubahPosts(Posts post) {
    http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/posts/${post.id}"))
        .then((value) {
      setState(() {
        judulCtrl.text = post.title;
        deskripsiCtrl.text = post.body;
      });
      print(value.body);
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  perbaruiPosts(Posts post, String judul, String deskripsi) {
    setState(() {
      isLoading = true;
    });
    http.patch(
        Uri.parse("https://jsonplaceholder.typicode.com/posts/${post.id}"),
        body: {
          'id': post.id.toString(),
          'title': judul,
          'body': deskripsi,
          'userId': "1"
        }).then((value) {
      int indexMauDiUpdate =
          posts.indexWhere((element) => element.id == post.id);
      setState(() {
        isLoading = false;
        posts[indexMauDiUpdate].title = judul;
        posts[indexMauDiUpdate].body = deskripsi;
        posts[indexMauDiUpdate].userId = 1;
      });
      print(value.body);
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
    getDataPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Wied Artha Pratama - 20180801316')),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      title: Text(posts[i].title),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(posts[i].body),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                  onPressed: () {
                                    Get.to(() => CommentsPage(
                                        key: widget.key, post: posts[i]));
                                  },
                                  icon: Icon(Icons.comment),
                                  label: Text('Komentar')),
                              TextButton.icon(
                                  onPressed: () {
                                    ubahPosts(posts[i]);
                                    Get.bottomSheet(
                                        SafeArea(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 50,
                                                    ),
                                                    Text(
                                                      "Ubah Data",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Divider(),
                                                    TextFormField(
                                                      maxLines: 3,
                                                      controller: judulCtrl,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Judul",
                                                        fillColor: Colors.white,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          borderSide:
                                                              BorderSide(
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
                                                      controller: deskripsiCtrl,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Deskripsi",
                                                        fillColor: Colors.white,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          borderSide:
                                                              BorderSide(
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
                                                          perbaruiPosts(
                                                              posts[i],
                                                              judulCtrl.text,
                                                              deskripsiCtrl
                                                                  .text);
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
                                  icon: Icon(Icons.edit),
                                  label: Text('Ubah')),
                              TextButton.icon(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        title: 'Pemberitahuan',
                                        content: Text(
                                            'Anda yakin ingin menghapus data ini?'),
                                        onConfirm: () {
                                          deletePosts(posts[i]);
                                          Get.back();
                                        },
                                        onCancel: () {
                                          Get.back();
                                        });
                                  },
                                  icon: Icon(Icons.delete),
                                  label: Text('Hapus')),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: posts.length,
              ));
  }
}
