import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/application/bloc/authentication/login/login_bloc.dart';
import 'package:task_manager/application/routes/app_routes_config.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscured = true;
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void login() {
    if (formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
            LoginEvent.loginWithEmailAndPassword(
              emailAddress: emailController.text,
              password: passwordController.text,
              context: context,
            ),
          );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
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
          AppRouteConfig.clearAndNavigate(
            AppRoutes.mainNavigationScreen,
          );
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
                      const SizedBox(height: 40),
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
                                  Text(
                                    "Sign Up",
                                    style: getRegularStyle(
                                      color:
                                          AppColors.homeFirstAidSubTitleColor,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    "Kindly enter your details below to log in to the admin portal.",
                                    textAlign: TextAlign.center,
                                    style: getRegularStyle(
                                      color:
                                          AppColors.homeFirstAidSubTitleColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const SizedBox(height: 48),
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
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: AuthPasswordTextField(
                                      isObscured: isObscured,
                                      toggleObscure: toggleObscure,
                                      hintText: 'Password',
                                      controller: passwordController,
                                      isLoginField: true,
                                    ),
                                  ),
                                  const SizedBox(height: 48),
                                  SizedBox(
                                    width: double.infinity,
                                    child: AuthButton(
                                      title: 'Log in',
                                      onTap: () {
                                        login();
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 48),
                                  Row(
                                    children: [
                                      AuthButton2(
                                        title: 'Forgot Password?',
                                        onTap: () {
                                          context.pushNamed(
                                            AppRoutes.forgetPasswordScreen,
                                          );
                                        },
                                      ),
                                      const Spacer(),
                                      AuthButton2(
                                        title: 'Create New Account',
                                        onTap: () {
                                          context.pushNamed(
                                            AppRoutes.registrationScreen,
                                          );
                                        },
                                      ),
                                    ],
                                  )
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
