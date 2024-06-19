import 'dart:convert';

import 'package:pc_part/CategoryPage/CategoryPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SectionPage extends StatefulWidget {
  final String userID;

  const SectionPage({required this.userID});

  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  late Future<List?> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = readData();
  }

  Future<List<Map<String, dynamic>>?> fetchDataForCategory(String category) async {
    var url = "http://192.168.68.111/server/Category.php?category=$category";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      List<dynamic> decodedData = jsonDecode(res.body);
      List<Map<String, dynamic>> mappedData = decodedData.map<Map<String, dynamic>>((item) => item.cast<String, dynamic>()).toList();
      return mappedData;
    } else {
      throw Exception("Failed to load data for category $category");
    }
  }



  Future<List?> readData() async {
    var url = "http://192.168.68.111/server/Category.php";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text('Sections',

            ),
            SizedBox(width: 8),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_image.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              _dataFuture = readData();
            });
            return _dataFuture;
          },
          child: FutureBuilder<List?>(
            future: _dataFuture,
            builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else {
                List<dynamic>? dataList = snapshot.data;
                List<Map<String, dynamic>> list =
                    dataList?.cast<Map<String, dynamic>>() ?? [];

                Set<String> uniqueCategories = Set();
                List<Map<String, dynamic>> uniqueList = [];

                for (var item in list) {
                  String category = item['Category']?.toString() ?? 'N/A';
                  if (!uniqueCategories.contains(category)) {
                    uniqueCategories.add(category);
                    uniqueList.add(item);
                  }
                }

                return ListView.builder(
                  itemCount: uniqueList.length,
                  itemBuilder: (BuildContext ctx, int i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(
                              category: uniqueList[i]['Category'],
                              fetchData: fetchDataForCategory,
                              userID: widget.userID, // Pass the userID to CategoryPage
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ListTile(
                            title: Text(
                              uniqueList[i]['Category']?.toString() ?? 'N/A',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              uniqueList[i]["Name"]?.toString() ?? 'N/A',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white, Colors.indigo],
                                ),
                              ),
                              child: Image.asset('lib/assets/pc.png')
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
