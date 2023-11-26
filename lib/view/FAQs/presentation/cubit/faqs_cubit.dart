import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:venus_driver/view/FAQs/data/model/faqs_model.dart';
import 'package:venus_driver/view/FAQs/data/repo/faqs_repo.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';

part 'faqs_state.dart';

class FaqsCubit extends Cubit<FaqsState> {
  FaqsCubit() : super(FaqsInitial());
  final faqsRepo = FaqsRepo();

  static FaqsCubit of(context) => BlocProvider.of(context);

  List<FaqsData> listOfFAQsData = [];

  Future getFAQs() async {
    emit(FaqsLoading());
    final res = await faqsRepo.getFaqs();
    res.fold(
      (err) {
        showSnackBar(err);
        emit(FaqsInitial());
      },
      (res) async {
        listOfFAQsData = res.data;
        emit(FaqsInitial());
      },
    );
  }
}
