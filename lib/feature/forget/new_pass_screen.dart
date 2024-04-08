import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';


class NewPassScreen extends StatefulWidget {
  final String identity;
  final String identityType;
  final String otp;
  const NewPassScreen({super.key, required this.identity,required this.otp, required this.identityType});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final GlobalKey<FormState> newPassKey = GlobalKey<FormState>();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  String _identity='';

  @override
  void initState() {
    Get.find<AuthController>().newPasswordController.clear();
    Get.find<AuthController>().confirmNewPasswordController.clear();
    super.initState();
    _identity = widget.identity;
  }


  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(title:'change_password'.tr, onBackPressed: (){
        Get.find<AuthController>().updateVerificationCode('');
        Get.back();
      },),
      body: SafeArea(child: FooterBaseView(
        isCenter: true,
        child: WebShadowWrap(
          child: Center(child: Form(
            key: newPassKey,
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.isDesktop(context)?Dimensions.webMaxWidth/6:
                    ResponsiveHelper.isTab(context)? Dimensions.webMaxWidth/8:Dimensions.paddingSizeLarge
                ),
                child: Column(children: [
                  CustomTextField(
                    title: 'new_password'.tr,
                    hintText: '**************',
                    controller: controller.newPasswordController,
                    focusNode: _passwordFocus,
                    nextFocus: _confirmPasswordFocus,
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                    onValidate: (String? value) {
                      return FormValidation().isValidPassword(value!);
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

                  CustomTextField(
                    title: 'confirm_new_password'.tr,
                    hintText: '**************',
                    controller: controller.confirmNewPasswordController,
                    inputAction: TextInputAction.done,
                    focusNode: _confirmPasswordFocus,
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                    onValidate: (String? value) {
                      if(value == null || value.isEmpty){
                        return 'this_field_can_not_empty'.tr;
                      }else{
                        return FormValidation().isValidConfirmPassword(
                          controller.newPasswordController.text,
                          value,
                        );
                      }
                    },
                    onSubmit: (text) => GetPlatform.isWeb ? _resetPassword(controller.confirmNewPasswordController.text,controller.confirmNewPasswordController.text) : null,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

                  GetBuilder<UserController>(builder: (userController) {
                    return GetBuilder<AuthController>(builder: (authBuilder) {
                      return CustomButton(
                        buttonText: 'change_password'.tr,
                        isLoading: authBuilder.isLoading!,
                        onPressed: () {
                          if(isRedundentClick(DateTime.now())){
                            return;
                          }
                          else{
                            _resetPassword(controller.newPasswordController.value.text, controller.confirmNewPasswordController.value.text);
                          }
                        },
                      );

                    });
                  }),

                ]),
              ),

            ]),
          )),
        ),
      )),
    );
  }

  void _resetPassword(newPassword, confirmNewPassword) {
    if(newPassKey.currentState!.validate()){
      if(newPassword != confirmNewPassword){
        customSnackBar('confirm_password_not_matched'.tr);
      }else{
        Get.find<AuthController>().resetPassword(_identity,widget.identityType,widget.otp,newPassword,confirmNewPassword);
      }
    }
  }
}




