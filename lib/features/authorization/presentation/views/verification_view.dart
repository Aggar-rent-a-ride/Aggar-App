import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationView extends StatelessWidget {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Verification Screen', style: AppStyles.medium24(context)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
        child: Column(
          children: [
            Image.asset(
              AppAssets.assetsImagesVerificationIcon,
              height: 150,
            ),
            const Gap(25),
            Text(
              'please enter the verification code sent to:',
              style: AppStyles.regular20(context)
                  .copyWith(color: AppColors.myGray100_2),
            ),
            Text(
              'ali.dosoqi0190@gmail.com',
              style: AppStyles.semiBold20(context),
            ),
            const Gap(40),
            PinCodeTextField(
              appContext: context,
              length: 5,
              onChanged: (value) {},
              textStyle: GoogleFonts.poppins(fontSize: 18),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 50,
                activeColor: AppColors.myBlue100_1,
                inactiveColor: AppColors.myGray100_2,
                selectedColor: AppColors.myBlue100_2,
              ),
              keyboardType: TextInputType.number,
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Didn't receive the code?",
                    style: AppStyles.regular20(context)
                        .copyWith(color: AppColors.myGray100_2)),
                TextButton(
                  onPressed: () {},
                  child: Text('Resend it',
                      style: AppStyles.bold22(context)
                          .copyWith(color: AppColors.myBlue100_1)),
                )
              ],
            ),
            const Gap(30),
            CustomElevatedButton(onPressed: () {}, text: "Enter")
          ],
        ),
      ),
    );
  }
}
