import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Search',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
      ),
      home: const Search(),
    );
  }
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isVisible = false;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();

    // listen to focus changes
    focusNode.addListener(() => setState(() {
          deleteSearch();
          isVisible = !isVisible;
          print(isVisible);
        }));
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> results = [];
  final List<Map<String, dynamic>> adminList = [
    {"isRed": false, "id": 0, "name": "Liam", "age": 32},
    {"isRed": false, "id": 1, "name": "Oliver", "age": 29},
    {"isRed": false, "id": 2, "name": "Elijah", "age": 40},
    {"isRed": false, "id": 3, "name": "James", "age": 25},
    {"isRed": true, "id": 4, "name": "William", "age": 35},
    {"isRed": true, "id": 5, "name": "Benjamin", "age": 21},
    {"isRed": false, "id": 6, "name": "Colin", "age": 55},
    {"isRed": false, "id": 7, "name": "Lucas", "age": 30},
  ];
  final TextEditingController searchController = TextEditingController();
  void search(String value) {
    if (value.isEmpty) {
      results.clear();
    } else {
      results = adminList.where((element) => element['name'].toLowerCase().contains(value.toLowerCase())).toList();
    }
  }

  void deleteSearch() {
    results.clear();
    searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("User Search"),
        leading: const Icon(Icons.chevron_left),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.heart_broken),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: TextField(
                        focusNode: focusNode,
                        controller: searchController,
                        onChanged: (value) {
                          search(value);
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            prefixIconConstraints: const BoxConstraints(minWidth: 50),
                            hintText: "Search User...",
                            iconColor: Colors.grey,
                            icon: const Icon(Icons.search),
                            border: InputBorder.none,
                            suffixIcon: isVisible
                                ? IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: (() => deleteSearch()),
                                  )
                                : const SizedBox(
                                    width: 0,
                                  ),
                            suffixIconColor: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              isVisible
                  ? TextButton(onPressed: (() => deleteSearch()), child: const Text("Cancel"))
                  : const SizedBox(
                      width: 0,
                    )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                int imgIdx = results[index]["id"];
                bool isRed = results[index]["isRed"];
                // created my own ListTile, because the CircleAvatar looked too small

                // return Card(
                // child: ListTile(
                //   leading: CircleAvatar(
                //   radius: 43,
                //   backgroundColor: isRed ? Colors.red : Colors.green[400],
                //   child: CircleAvatar(
                //     radius: 40,
                //     backgroundImage: AssetImage("assets/lego$imgIdx.jpg"),
                //   ),
                // ),
                //   title: Text(results[index]['name']),
                //   subtitle: Text('${results[index]["age"].toString()} years old'),
                //   trailing: const Icon(Icons.more_horiz),
                // ),
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 43,
                            backgroundColor: isRed ? Colors.red : Colors.green[400],
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage("assets/lego$imgIdx.jpg"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                child: Text(results[index]['name']),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text('${results[index]["age"].toString()} years old'),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.more_horiz,
                          size: 40,
                        ),
                      ],
                      // ),
                    ));
              },
            ),
          ),
        ]),
      ),
    );
  }
}
