import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:noreen/app_storage.dart';
import 'package:noreen/substring_highlight.dart';
import 'package:noreen/utils.dart';

import 'main.dart';

class RecordingHistory extends StatefulWidget {
  const RecordingHistory({Key? key}) : super(key: key);

  @override
  State<RecordingHistory> createState() => _RecordingHistoryState();
}

class _RecordingHistoryState extends State<RecordingHistory> {
  List<String>? previousRecognitions;

  @override
  void initState() {
    super.initState();
    previousRecognitions = AppStorage().allHistory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("History"),
        centerTitle: true,
      ),
      body: previousRecognitions!.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "No history found",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: previousRecognitions!.length,
              itemBuilder: (context, index) {
                return _listTile(previousRecognitions![index]);
              },
            ),
    );
  }

  Widget _listTile(String result) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16).copyWith(right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                decoration: ShapeDecoration(
                    color: Colors.lightBlueAccent.withOpacity(0.2),
                    shape: CircleBorder(
                        side: BorderSide(
                      color: Colors.lightBlueAccent.withOpacity(0.5),
                    ))),
                child: Icon(
                  Icons.mic,
                  color: Colors.grey.withOpacity(0.5),
                )),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: SubstringHighlight(
                terms: Command.commands,
                text: result,
                textStyle: TextStyle(
                  fontSize: 17,
                  color: Colors.black
                ),
                textStyleHighlight: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ),
            (Command.commands.any((element)=>((result.toLowerCase()).contains(element) ? true: false))) ? 
            IconButton(
              onPressed: () async {
                Utils.checkText(result);
              },
              tooltip: "Copy text",
              color: Colors.black,
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).primaryColor,
              ),
            )
            :IconButton(
              onPressed: () async {
                await FlutterClipboard.copy(result);
                showSnack(context, "Copied to clipboard");
              },
              tooltip: "Copy text",
              color: Colors.black,
              icon: Icon(
                Icons.copy,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
