import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/component/app_loader_widget.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/moodlelogin_model.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/auth/component/signin_bottom_widget.dart';
import 'package:granth_flutter/screen/auth/component/signin_top_component.dart';
import 'package:granth_flutter/screen/auth/forgot_password_screen.dart';
import 'package:granth_flutter/screen/dashboard/dashboard_screen.dart';
import 'package:granth_flutter/screen/auth/sign_up_screen.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/login_model.dart';

class MobileLoginComponent extends StatefulWidget {
  @override
  _MobileLoginComponentState createState() => _MobileLoginComponentState();
}

class _MobileLoginComponentState extends State<MobileLoginComponent> {
  final formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode? emailFocusNode = FocusNode();
  FocusNode? passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  ///login api call
  Future<void> loginApi(BuildContext context) async {
    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      appStore.setLoading(true);

      await moodleLogin(
              usernameController.text.trim(), passwordController.text.trim())
          .then((res) async {
        if (res.error != null) {
          toast(res.error);
        } else if (res.token != null) {
          MoodleBasicUserData userBasicData =
              await getBasicUserData(res.token!);
          if (userBasicData.userid != null) {
            MoodleUserData userData =
                await getUserData(res.token!, userBasicData.userid!);
            UserData user =
                UserData.fromMoodleData(userBasicData, userData, res.token!);
            await saveUserData(user);
            DashboardScreen().launch(context,
                isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
            toast(language!.loginSuccessfully);
          }
        }
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('',
          elevation: 0, color: context.scaffoldBackgroundColor),
      body: Stack(
        children: [
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SignInTopComponent(),
                  Column(
                    children: [
                      Text(language!.login, style: boldTextStyle(size: 28))
                          .center(),
                      8.height,
                      Text(language!.signInToContinue,
                          style: secondaryTextStyle()),
                      32.height,
                      AppTextField(
                        controller: usernameController,
                        autoFocus: false,
                        textFieldType: TextFieldType.USERNAME,
                        focus: emailFocusNode,
                        nextFocus: passwordFocusNode,
                        decoration: inputDecoration(context,
                            hintText: language!.userName),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return language!.thisFieldIsRequired;
                          }
                          return null;
                        },
                      ),
                      16.height,
                      AppTextField(
                        controller: passwordController,
                        autoFocus: false,
                        textFieldType: TextFieldType.PASSWORD,
                        focus: passwordFocusNode,
                        decoration: inputDecoration(context,
                            hintText: language!.password),
                        onFieldSubmitted: (value) {
                          loginApi(context);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return language!.thisFieldIsRequired;
                          } else if (value.length < 6) {
                            return language!.passwordMustBeSame;
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            ForgotPasswordScreen().launch(context,
                                pageRouteAnimation: PageRouteAnimation.Slide);
                          },
                          child: Text(language!.lblForgotPassword,
                              style: boldTextStyle(
                                  color: defaultPrimaryColor, size: 14)),
                        ),
                      ),
                      24.height,
                      AppButton(
                        width: context.width(),
                        text: language!.login,
                        textStyle: boldTextStyle(color: Colors.white),
                        color: defaultPrimaryColor,
                        enableScaleAnimation: false,
                        onTap: () async {
                          loginApi(context);
                        },
                      ),
                      32.height,
                      SignInBottomWidget(
                        title: language!.donTHaveAnAccount,
                        subTitle: language!.register,
                        onTap: () {
                          SignupScreen().launch(context,
                              pageRouteAnimation: PageRouteAnimation.Slide);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Observer(
            builder: (context) {
              return AppLoaderWidget().visible(appStore.isLoading).center();
            },
          )
        ],
      ),
    );
  }
}
