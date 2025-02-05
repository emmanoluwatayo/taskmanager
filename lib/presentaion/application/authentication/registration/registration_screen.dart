import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/application/bloc/authentication/registration/registration_bloc.dart';
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

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();

  bool isObscured = true;
  bool isObscured2 = true;
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

  void toggleObscure() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  void toggleObscure2() {
    setState(() {
      isObscured2 = !isObscured2;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void registration() {
    if (formKey.currentState!.validate()) {
      context.read<RegistrationBloc>().add(
            RegistrationEvent.registerWithEmailAndPassword(
              emailAddress: emailController.text,
              password: passwordController.text,
              phoneNumber: phoneNumberController.text,
              fullName: fullNameController.text,
            ),
          );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
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
          showSuccessDialog(context);
          AfterOperationNavigation.afterSignup(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                Assets.images.bgImage.path,
                fit: BoxFit.cover,
              ),
              Center(
                child: SingleChildScrollView(
                    child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
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
                                      color:
                                          AppColors.authenticationShadowColor,
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
                                      "Registration",
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
                                      "Kindly fill in your details to get started.",
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
                                        textInputType: TextInputType.text,
                                        hintText: 'Full Name',
                                        controller: fullNameController,
                                        inputEnum: InputEnum.others,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: AuthTextField(
                                        isAutofocused: true,
                                        textInputType:
                                            TextInputType.emailAddress,
                                        hintText: 'Email Address',
                                        controller: emailController,
                                        inputEnum: InputEnum.email,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: AuthTextField(
                                        textInputType: TextInputType.phone,
                                        hintText: 'Phone Number',
                                        controller: phoneNumberController,
                                        inputEnum: InputEnum.phone,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: AuthPasswordTextField(
                                        hintText: 'Choose a strong password',
                                        controller: passwordController,
                                        isObscured: isObscured,
                                        toggleObscure: toggleObscure,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: AuthPasswordTextField(
                                        hintText: 'Confirm Password',
                                        controller: passwordController2,
                                        passwordText: passwordController.text,
                                        isConfirmPassword: true,
                                        isObscured: isObscured2,
                                        toggleObscure: toggleObscure2,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 48,
                                    ),
                                    SizedBox(
                                      width: 230,
                                      child: AuthButton2(
                                        title: 'Got an account? Log in instead',
                                        onTap: () {
                                          context
                                              .pushNamed(AppRoutes.loginScreen);
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: AuthButton(
                                        title: 'Register',
                                        onTap: () {
                                          registration();
                                        },
                                      ),
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
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.images.taskLogo.image(
                scale: 3,
                height: 40,
                width: 40,
              ),
              const Gap(10),
              Text(
                "All done!",
                style: getRegularStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Your account has been created successfully.",
                style: getRegularStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Press enter to complete your registration.",
                style: getRegularStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const Gap(15),
              SizedBox(
                width: double.infinity,
                child: AuthButton(
                  title: 'Enter',
                  onTap: () {
                    context.pushNamed(
                      AppRoutes.completeRegistrationScreen,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
