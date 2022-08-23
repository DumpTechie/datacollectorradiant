import 'package:datacollector/Dao/conection.dart';
import 'package:sql_conn/sql_conn.dart';

class otp {
  Future<Map> sendOtp(String phone) async {
    DaoClass newDao = new DaoClass();
    await newDao.connection();
    var res = await SqlConn.readData("SELECT * FROM IP_List");
    SqlConn.disconnect();
    return new Map();
  }
}
