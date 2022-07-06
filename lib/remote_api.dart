import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jsons/model/user_model.dart';

class RemoteApi extends StatefulWidget {
  const RemoteApi({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RemoteApiState createState() => _RemoteApiState();
}

Future<List<UserModel>> _getUserList() async {
  try {
    var response =
        await Dio().get('https://jsonplaceholder.typicode.com/users');

    List<UserModel> _userList = [];

    if (response.statusCode == 200) {
      _userList =
          (response.data as List).map((e) => UserModel.fromMap(e)).toList();
      return _userList;
    }
    return _userList;
  } on DioError catch (e) {
    return Future.error(e.message);
  }
}

class _RemoteApiState extends State<RemoteApi> {
  late final Future<List<UserModel>> _userList;

  @override
  void initState() {
    super.initState();
    _userList = _getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Api With Dio'),
      ),
      body: Center(
        child: FutureBuilder<List<UserModel>>(
            future: _userList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var userList = snapshot.data!;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    var user = userList[index];
                    return ListTile(
                      title: Text(user.email),
                      subtitle: Text(user.address.toString()),
                      leading: Text(user.id.toString()),
                    );
                  },
                  itemCount: userList.length,
                );
                return Text(snapshot.data.toString());
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else
                return CircularProgressIndicator();
            }),
      ),
    );
  }
}
