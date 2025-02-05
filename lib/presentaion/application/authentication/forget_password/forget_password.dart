import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/application/bloc/authentication/forgot_password/forget_password_bloc.dart';
import 'package:task_manager/application/routes/app_routes_config.dart';
import 'package:task_manager/application/services/operations/after_operations.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/extensions/loading.dart';
import 'package:task_manager/core/shared/enums/processing_status.dart';
import 'package:task_manager/core/shared/enums/status.dart';
import 'package:task_manager/core/theme/styles_manager.dart';
import 'package:task_manager/gen/assets.gen.dart';
import 'package:task_manager/presentaion/application/authentication/enum/input_enum.dart';
import 'package:task_manager/presentaion/application/authentication/widget/auth_button.dart';
import 'package:task_manager/presentaion/application/authentication/widget/auth_textfield.dart';
import 'package:task_manager/presentaion/core/toast_info.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void forgotPassword() {
    if (formKey.currentState!.validate()) {
      context.read<ForgotPasswordBloc>().add(
            ForgotPassword(
              emailAddress: emailController.text,
            ),
          );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.processingStatus == ProcessingStatus.waiting) {
          context.showLoader();
        } else if (state.processingStatus == ProcessingStatus.error) {
          context.hideLoader();
          toastInfo(
            msg: 'Ops! ${state.error.errorMsg}',
            status: Status.error,
          );
        } else if (state.processingStatus == ProcessingStatus.success) {
          context.hideLoader();
          AfterOperationNavigation.navigateToLogin(context: context);
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              Assets.images.bgImage.path,
              fit: BoxFit.cover,
            ),
            Center(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(40),
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Form(
                            key: formKey,
                            child: Container(
                              width: 464,
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppColors.vistaWhite,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.authenticationShadowColor,
                                    spreadRadius: -4,
                                    blurRadius: 16,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.cashAtmBorderColor,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.arrow_back_ios,
                                            size: 15,
                                            color: AppColors
                                                .homeFirstAidSubTitleColor,
                                          ),
                                          Text(
                                            "Back",
                                            style: getRegularStyle(
                                              color: AppColors
                                                  .homeFirstAidSubTitleColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Forgot Password?",
                                    style: getRegularStyle(
                                      color:
                                          AppColors.homeFirstAidSubTitleColor,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  Text(
                                    "No worries!\nenter the email address associated with your account. We will send you reset instructions.",
                                    textAlign: TextAlign.center,
                                    style: getRegularStyle(
                                      color:
                                          AppColors.homeFirstAidSubTitleColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 48,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: AuthTextField(
                                      isAutofocused: true,
                                      textInputType: TextInputType.emailAddress,
                                      hintText: 'Email Address',
                                      controller: emailController,
                                      inputEnum: InputEnum.email,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 48,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: AuthButton(
                                      title: 'Reset Password',
                                      onTap: () {
                                        forgotPassword();
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 48,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
