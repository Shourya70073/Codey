// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:io';

import 'package:code_text_field/code_text_field.dart';
import 'package:codey/Controllers/compiler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:path_provider/path_provider.dart';

class codePage extends StatefulWidget {
  const codePage({super.key});

  @override
  State<codePage> createState() => _codePageState();
}

class _codePageState extends State<codePage> {
  String? _output;
  CodeController? _codeController;
  int run = 0;

  late Compiler c;

  @override
  void initState() {
    super.initState();
    final source = "print('Hello World!')";
    // Instantiate the CodeController
    _codeController = CodeController(
      text: source,
      language: dart,
      params: EditorParams(),
    );
    c = Get.put(Compiler());
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  // void _runCode() async {
  //   final code = _codeController?.text;
  //   if (code == null || code.isEmpty) {
  //     return;
  //   }
  //   setState(() {
  //     _output = null;
  //   });
  //   final result = await c.getData(code, "CPP");

  //   setState(() {
  //     _output = result ? c.res.toString() : "An error occurred";
  //     print(output)
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF0556f3),
        onPressed: () {},
        child: Icon(
          Icons.upload,
        ),
      ),
      appBar: AppBar(
        actions: [
          MaterialButton(
            onPressed: () {},
            child: Text("Login"),
          )
        ],
        elevation: 2,
        title: Text("Code Editor - Codey"),
        centerTitle: true,
        backgroundColor: Color(0xff252525),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xff2d2f34),
                      border: Border.all(color: Colors.grey)),
                  height: 46.5222,
                  width: double.infinity,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Main.py",
                          style: TextStyle(color: Colors.white),
                        ),
                        MaterialButton(
                          elevation: 3,
                          onPressed: () {
                            setState(() {
                              run = 1;
                            });
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  height: 32,
                                  width: 67,
                                  decoration: BoxDecoration(
                                      color: Color(0XFF0556f3),
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5, left: 15, right: 15),
                                    child: Center(
                                      child: Text(
                                        "Run",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: CodeField(
                    background: Color(0xff1c2130),
                    maxLines: 33,
                    controller: _codeController!,
                    textStyle: TextStyle(fontFamily: 'SourceCode'),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: double.infinity,
            width: 2,
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(width: 0.5, color: Colors.grey)),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xff2d2f34),
                      border: Border.all(color: Colors.grey)),
                  height: 46.5222,
                  width: double.infinity,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Output",
                          style: TextStyle(color: Colors.white),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Container(
                            height: 32,
                            width: 67,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border:
                                    Border.all(width: 2, color: Colors.grey)),
                            child: Center(
                              child: Text(
                                "Clear",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: run == 1
                          ? FutureBuilder(
                              future: c.getData(_codeController!.text, "PYTHON"),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(child: Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator()));
                                } else if (snapshot.hasData) {
                                  return Text(
                                    c.res.toString(),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              })
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                    ),
                    color: Color(0xff1c2130),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
