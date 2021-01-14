import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/call.dart';

const String CALL_COLLECTION = 'call';

class CallMethods {
  final CollectionReference callCollection =
      Firestore.instance.collection(CALL_COLLECTION);

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialed = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);
      call.hasDialed = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      callCollection.doc(call.callerId).set(hasDialledMap);
      callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<bool> endCall({Call call}) async{
   try {
     await callCollection.doc(call.callerId).delete();
     await callCollection.doc(call.receiverId).delete();
     return true;
   } catch(e){
     print(e);
     return false;
   }
  }
}
