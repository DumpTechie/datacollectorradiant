import 'package:sql_conn/sql_conn.dart';

class DaoClass {
  Future<void> connection() async {
    try {
      await SqlConn.connect(
          ip: '<ip-address>',
          port: "1433",
          databaseName: "NewTestDB20190906_Test_Raytech",
          username: "<usrname>",
          password: "<pass>");
      print("Connected!");
    } catch (e) {
      print(e.toString());
    } finally {
      print("connect finally");
    }
  }
}
