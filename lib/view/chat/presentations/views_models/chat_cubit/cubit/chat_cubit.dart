import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../global_variables.dart';
import '../../../../../../widgets/custom_snackbar.dart';
import '../../../../data/models/message_model.dart';
import '../../../../data/repos/chat_repo.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  static ChatCubit get(context) => BlocProvider.of(context);

  final TextEditingController controller = TextEditingController();
  final ScrollController listViewController = ScrollController();
  // CollectionReference messagesFirBase =
  //     FirebaseFirestore.instance.collection(kMessagesCollection);
  List<MessageModel> messagesList = [];
  final chatRepo = ChatRepo();
  List<MessageModel> messages = [];

//send message firebase
  // void sendMessageFirebase({
  //   required String message,
  //   required int id,
  // }) {
  //   try {
  //     messagesFirBase.add({
  //       kMessage: message,
  //       kCreatedAt: DateTime.now(),
  //       'id': id,
  //     });
  //   } on Exception {}
  // }

  // void getMessage({required int rideId}) {
  //   messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
  //     controller.clear();
  //     for (var doc in event.docs) {
  //       print('doc--${doc}');
  //       messagesList.add(MessageModel.fromJson(doc));
  //     }
  //     print('sucess--------------------------------------------');
  //     emit(ChatSuccessState(messages: messagesList));
  //   });
  // }
  // Future<List<MessageModel>> getMessages() async {
  //   List<MessageModel> messages = [];
  //   emit(ChatInilLoading());
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
  //         .collection(kMessagesCollection)
  //         .orderBy(kCreatedAt, descending: true)
  //         .get();
  //     for (QueryDocumentSnapshot<Map<String, dynamic>> doc
  //         in querySnapshot.docs) {
  //       var message = MessageModel.fromSnapshot(doc);
  //       messages.add(message);
  //     }
  //     print('Success--------------------------------------------');
  //     emit(ChatSuccessState(messages: messages));
  //     return messages;
  //   } catch (e) {
  //     print('Error getting messages: $e');
  //     throw Exception('Error getting messages: $e');
  //   }
  // }

  ////////
  // void getChat({required int rideId}) async {
  //   listenChat2(rideId: rideId).onValue.listen((DatabaseEvent event) async {
  //     emit(ListenMessageLoading());
  //     if (event.snapshot.value == null) {
  //       emit(ListenMessageRequest());
  //       print('Error');
  //       return;
  //     } else {
  //       final data = event.snapshot.value as Map;
  //       data.forEach((key, value) {
  //         messages.add(MessageModel(
  //           id: key,
  //           message: value['message'],
  //           userId: value['userId'],
  //         ));
  //       });
  //       // if (data.containsKey('1647')) {
  //       //   List<dynamic> replies = data['1586'][0]['replies'];
  //       //   print('Replies:');
  //       //   for (var reply in replies) {
  //       //     print(reply);
  //       //     // messagesList.add(MessageModel.fromJson(reply));
  //       //   }
  //       // }
  //       print('000000000000000');
  //       print(data);
  //       print('000000000000000');

  //       emit(ListenMessageLoaded());
  //     }
  //   });
  // }

  Future sendMessage({required int rideId}) async {
    emit(SendMessageLoading());
    final res =
        await chatRepo.sendMessage(msg: controller.text, rideId: rideId);
    res.fold(
      (err) {
        showSnackBar(err);
        emit(SendMessageError());
      },
      (res) async {
        controller.clear();
        showSnackBar(res.message);
        emit(SendMessageLoaded());
      },
    );
  }

  void getAllMessages({required int rideId}) {
    listenChat2(rideId: rideId)
        .orderByChild('created_at')
        .onValue
        .listen((event) {
      emit(ListenMessageLoading());
      if (event.snapshot.value == null) {
        emit(ListenMessageRequest());
        print('Error');
        return;
      } else {
        messages.clear();
        Map<dynamic, dynamic> messagesData = event.snapshot.value as Map;
        messagesData.forEach((key, value) {
          String id = value['id'].toString();
          String message = value['message'].toString();
          String userId = value['user_id'].toString();
          String createdAt = value['created_at'].toString();
          MessageModel newMessage = MessageModel(
              id: id,
              message: message,
              userId: userId,
              createdAt: createdAt.toString());
          messages.add(newMessage);
          print('000000000000000');
          print(id);
          print(message);
          print(userId);
          print(createdAt);
          print('000000000000000');
        });
        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        emit(ListenMessageLoaded());
      }
    });
  }
}
