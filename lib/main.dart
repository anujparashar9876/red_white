import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redwhite/app_repository.dart';
import 'package:redwhite/firebase_options.dart';
import 'package:redwhite/provider/theme_provider.dart';
import 'package:redwhite/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeDataStyle,
      home: const MyHomePage(title: 'Red & white'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TextEditingController id = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController count = TextEditingController();
  void _incrementCounter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    controller: id,
                    decoration: InputDecoration(
                        hintText: 'Id',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black12))),
                  ),
                  TextFormField(
                    controller: title,
                    decoration: InputDecoration(
                        hintText: 'Title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black12))),
                  ),
                  TextFormField(
                    controller: description,
                    decoration: InputDecoration(
                        hintText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black12))),
                  ),
                  TextFormField(
                    controller: category,
                    decoration: InputDecoration(
                        hintText: 'Category',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black12))),
                  ),
                  TextFormField(
                    controller: price,
                    decoration: InputDecoration(
                        hintText: 'Price',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black12))),
                  ),
                  TextFormField(
                    controller: image,
                    decoration: InputDecoration(
                        hintText: 'Image',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black12))),
                  ),
                  TextFormField(
                    controller: rate,
                    decoration: InputDecoration(
                        hintText: 'Rate',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black12))),
                  ),
                  TextFormField(
                    controller: count,
                    decoration: InputDecoration(
                        hintText: 'Count',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black12))),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        AppRepository().storeData(
                            id: int.parse(id.text.toString()),
                            title: title.text,
                            price: double.parse(price.text),
                            description: description.text,
                            category: category.text,
                            image: image.text,
                            rate: double.parse(rate.text),
                            count: int.parse(count.text));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(milliseconds: 1000),
                          content: Text('Product Success'),
                          shape: const StadiumBorder(),
                          elevation: 5,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green,
                        ));
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      )),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
        actions: [
          Switch(
              trackOutlineColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.secondary),
              thumbColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.secondary),
              value: themeProvider.themeDataStyle == ThemeDataStyle.dark
                  ? true
                  : false,
              onChanged: (isOn) {
                themeProvider.changeTheme();
              })
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
                future: AppRepository().getProduct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.hasData) {
                      final queryData = snapshot.data;
                      log(queryData.toString());
                      return ListView.builder(
                          itemCount: queryData.length,
                          itemBuilder: (context, index) {
                            AppRepository().storeData(
                                id: queryData[index]['id'],
                                title: queryData[index]['title'],
                                price: queryData[index]['price'] is int
                                    ? 12.10
                                    : queryData[index]['price'],
                                description: queryData[index]['description'],
                                category: queryData[index]['category'],
                                image: queryData[index]['image'],
                                rate: queryData[index]['rating']['rate'] is int
                                    ? 3.6
                                    : queryData[index]['rating']['rate'],
                                count: queryData[index]['rating']['count']);
                            return StreamBuilder(
                                stream: AppRepository().getproduct(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    case ConnectionState.active:
                                    case ConnectionState.done:
                                      final data = snapshot.data!.docs;
                                      return Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            Colors.white,
                                            Colors.black12,
                                            Colors.black26
                                          ], stops: [
                                            0,
                                            0.5,
                                            0.7
                                          ]),
                                          border:
                                              Border.all(color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text('Delete Product'),
                                                    content: Text(
                                                        'Want to delete this product?'),
                                                    actions: [
                                                      CupertinoButton(
                                                          child: Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                          ),
                                                          onPressed: () {
                                                            AppRepository()
                                                                .deleteproduct(
                                                                    data[index]
                                                                        ['id']);
                                                            Navigator.pop(
                                                                context);
                                                          })
                                                    ],
                                                  );
                                                });
                                          },
                                          leading: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: Image.network(
                                                  data[index]['image'])),
                                          title: Text(
                                              data[index]['title'].toString()),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '\$ ${data[index]['price'].toString()}'),
                                                Text(
                                                    '⭐️ ${data[index]['rating']['rate'].toString()}'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                  }
                                });
                          });
                    } else {
                      return Text('No data');
                    }
                  }
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
