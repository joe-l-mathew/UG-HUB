import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/utils/color.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/select_semester.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? _userModel = Provider.of<UserProvider>(context).userModel;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: primaryColor,
            bottom: const PreferredSize(
                child: SizedBox(), preferredSize: Size.fromHeight(100)),
            title: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome back,",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  Text(_userModel!.name!,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                  // Text('ME ' + ' KTU',
                  //     style: TextStyle(color: Colors.grey, fontSize: 16)),
                  // Text("KTU")
                ],
              ),
            ),
            flexibleSpace: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Container()),
                    Text(
                      _userModel.branchName!,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Text(
                      _userModel.universityName!,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Center(
                      child: TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Semester',
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              _userModel.profileUrl == null
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(_userModel.profileUrl!),
                      ),
                    )
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              color: primaryColor,
              height: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => Text(index.toString())))
        ],
      ),
    );
  }
}
