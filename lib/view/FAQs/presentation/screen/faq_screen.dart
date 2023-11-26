import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus_driver/view/FAQs/presentation/cubit/faqs_cubit.dart';
import 'package:venus_driver/view/FAQs/presentation/widget/faqs_body.dart';

class FAQscreen extends StatelessWidget {
  const FAQscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaqsCubit()..getFAQs(),
      child: const Scaffold(body: FAQsBody()),
    );
  }
}
