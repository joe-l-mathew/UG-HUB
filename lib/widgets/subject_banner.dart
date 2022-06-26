import 'package:flutter/cupertino.dart';
import 'package:ug_hub/widgets/module_list_tile.dart';

class SubjectBanner extends StatelessWidget {
  const SubjectBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Subject Name"),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true, // 1st add
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int Index) {
                  return ModuleListTile(
                      "Module ${Index + 1}", "No of module : 5");
                  // return Text(Index.toString());
                }),
          )
        ],
      ),
    );
  }
}
