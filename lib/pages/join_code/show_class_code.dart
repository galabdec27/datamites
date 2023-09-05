import 'package:datamites/helper/hex_color.dart';
import 'package:datamites/model/class_code.dart';
import 'package:datamites/model/class_code_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowCLassCode extends StatelessWidget {
  final ClassCodeV2Model classCodeModel;

  const ShowCLassCode({required this.classCodeModel, Key? key}) : super(key: key);

  _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: height - 180,
        child: SingleChildScrollView(
            child: (classCodeModel.status == 1)
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 64,
                ),
                Text(
                  classCodeModel.course_name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(classCodeModel.batch_name),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: HexColor.fromHex(
                          classCodeModel.background_color)),
                  child: MaterialButton(
                    minWidth: 0,
                    height: 0,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: classCodeModel.class_code));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Class code copied to clipboard.",
                            textAlign: TextAlign.center),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "CLASSCODE",
                            style: TextStyle(
                                color: HexColor.fromHex(
                                    classCodeModel.front_color)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            classCodeModel.class_code,
                            style: TextStyle(
                                color: HexColor.fromHex(
                                    classCodeModel.front_color),
                                fontSize: 24),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "click to copy the class code",
                            style: TextStyle(
                                color: HexColor.fromHex(
                                    classCodeModel.front_color)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(classCodeModel.msg),
                if (classCodeModel.payment_amount.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MaterialButton(
                      onPressed: () {
                        _launchURL(classCodeModel.payment_url);
                      },
                      color: Colors.red,
                      height: 48,
                      minWidth: width,
                      child: Text(
                        "Pay ${classCodeModel.payment_amount}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                if (classCodeModel.zoom_link.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MaterialButton(
                      onPressed: () {
                        _launchURL(classCodeModel.zoom_link);
                      },
                      color: Colors.green,
                      height: 48,
                      minWidth: width,
                      child: const Text(
                        "Open zoom",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 64,
                ),
                Icon(Icons.error, color: HexColor.fromHex(classCodeModel.front_color), size: 64,),
                if (classCodeModel.course_name.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(
                      classCodeModel.course_name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                if (classCodeModel.batch_name.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Text(classCodeModel.batch_name),
                  ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: HexColor.fromHex(
                          classCodeModel.background_color)),
                  child: MaterialButton(
                    minWidth: 0,
                    height: 0,
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            classCodeModel.msg,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: HexColor.fromHex(
                                    classCodeModel.front_color),
                                fontSize: 16),
                          ),
                          const SizedBox(
                            height: 8,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                if (classCodeModel.payment_amount.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MaterialButton(
                      onPressed: () {
                        _launchURL(classCodeModel.payment_url);
                      },
                      color: Colors.red,
                      height: 48,
                      minWidth: width,
                      child: Text(
                        "Pay ${classCodeModel.payment_amount}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                if (classCodeModel.zoom_link.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MaterialButton(
                      onPressed: () {
                        _launchURL(classCodeModel.zoom_link);
                      },
                      color: Colors.green,
                      height: 48,
                      minWidth: width,
                      child: const Text(
                        "Open zoom",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            )),
      ),
    );
  }
}
