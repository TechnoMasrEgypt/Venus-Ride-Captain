import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:venus_driver/view/review/data/model/review_model.dart';
import 'package:venus_driver/view/review/data/repo/review_repo.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit() : super(ReviewsInitial());
  final reviewRepo = ReviewRepo();

  static ReviewsCubit of(context) => BlocProvider.of(context);

  List<ReviewData> listOfReviews = [];

  Future getReviewsHistory() async {
    emit(ReviewsLoading());
    final res = await reviewRepo.getReviews();
    res.fold(
      (err) {
        showSnackBar(err);
        emit(ReviewsInitial());
      },
      (res) async {
        listOfReviews = res.data;
        emit(ReviewsInitial());
      },
    );
  }
}
