part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatInilError extends ChatState {}

class ChatInilLoading extends ChatState {}

class ChatSuccessState extends ChatState {
  final List<MessageModel> messages;
  ChatSuccessState({required this.messages});
}

class SendMessageLoading extends ChatState {}

class SendMessageLoaded extends ChatState {}

class SendMessageError extends ChatState {}

class ListenMessageRequest extends ChatState {}

class ListenMessageLoading extends ChatState {}

class ListenMessageLoaded extends ChatState {}

class ResetMessageList extends ChatState {}
