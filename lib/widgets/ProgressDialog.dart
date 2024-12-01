// ignore_for_file: must_be_immutable, library_prefixes, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:venus_driver/widgets/preparing.dart'as GradientWidgets;
//import 'package:gradient_widgets_plus/gradient_widgets_plus.dart';
//import 'package:gradient_ui/progress_indicator/gradient_progress_indicator.dart'
   // as GradientWidgets;

import '../utils/brand_colors.dart';

class ProgressDialog extends StatelessWidget {
  final String status;

  ProgressDialog({required this.status});

  Gradient g1 =  LinearGradient(
    colors: [
      BrandColors.colorPrimary,
      Colors.white,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              GradientWidgets.GradientCircularProgressIndicator(
                valueGradient: g1,
                backgroundColor: Colors.grey[200],
              ),
//GradientCircularProgressIndicator(),
            
              const SizedBox(
                width: 25,
              ),
              Text(
                
                status,
                style: const TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      ),
    );
  }
}
