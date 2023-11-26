// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus_driver/view/review/presentation/cubit/reviews_cubit.dart';
import 'package:venus_driver/view/review/presentation/widget/review_body.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewsCubit()..getReviewsHistory(),
      child: const Scaffold(backgroundColor: Colors.white, body: ReviewBody()),
    );
  }
}
