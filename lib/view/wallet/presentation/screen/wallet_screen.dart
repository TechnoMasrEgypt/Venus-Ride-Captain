import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/view/profile/presentation/cubit/profile_cubit.dart';
import 'package:venus_driver/view/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:venus_driver/widgets/circlular_percent_indicator.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';
import 'package:venus_driver/widgets/custom_wallet_card.dart';
import 'package:venus_driver/widgets/loading_indicator.dart';

class WalletHistoryScreen extends StatefulWidget {
  const WalletHistoryScreen({super.key});

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProfileCubit()..getProfileDetails(),
          ),
          BlocProvider(
            create: (context) => WalletCubit()..getWalletHistory(),
          ),
        ],
        child: Scaffold(
            backgroundColor: Colors.white,
            body: BlocBuilder<WalletCubit, WalletState>(
                builder: (context, state) {
              final cubit = WalletCubit.of(context);
              return state is WalletLoading
                  ? const LoadingIndicator()
                  : SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    customIconBack(
                                      icon: Localizations.localeOf(context)
                                                  .languageCode ==
                                              'en'
                                          ? Icons.keyboard_arrow_right
                                          : Icons.keyboard_arrow_left,
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              BlocBuilder<ProfileCubit, ProfileState>(
                                builder: (context, state) {
                                  final cubitDetails = ProfileCubit.of(context);
                                  return state is GetProfileDetailsLoading
                                      ? const LoadingIndicator()
                                      : circlularPercentIndicator(
                                          percent: .6,
                                          wallets: (cubitDetails
                                                      .driverData!.wallets /
                                                  100)
                                              .toStringAsFixed(2)
                                              .toString());
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    LocaleKeys.walletHistory.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0.sp,
                                        color: BrandColors.deepBlue),
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              Expanded(
                                  child: cubit.listOfWalletHistory.isEmpty
                                      ? SizedBox(
                                          height: 200.h,
                                          width: 200.w,
                                          child: Lottie.asset(
                                              'assets/json/money.json'))
                                      : SizedBox(
                                          height: 430.h,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView.separated(
                                            padding: const EdgeInsets.all(8),
                                            itemCount: cubit
                                                .listOfWalletHistory.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return walletCard(
                                                  date: cubit
                                                      .listOfWalletHistory[
                                                          index]
                                                      .date,
                                                  wallet: (cubit
                                                              .listOfWalletHistory[
                                                                  index]
                                                              .balance /
                                                          100)
                                                      .toString());
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                        int index) =>
                                                    const Divider(),
                                          ),
                                        )),
                            ],
                          ),
                        ),
                      ),
                    );
            })));
  }
}
