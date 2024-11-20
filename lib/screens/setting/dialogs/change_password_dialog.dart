import 'package:daelim/extensions/context_extension.dart';
import 'package:daelim/helpers/api_helper.dart';
import 'package:daelim/helpers/storage_helper.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _confirmPwController = TextEditingController();

  final _currentPwFormKey = GlobalKey<FormState>();
  final _newPwFormKey = GlobalKey<FormState>();
  final _confirmPwFormKey = GlobalKey<FormState>();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final bgColor = const Color(0xFFF3F4F6);

  String currentPasswordValidateMessage = "";

  @override
  void dispose() {
    // TODO: implement dispose
    _currentPwController.dispose();
    _newPwController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String hintText,
    required GlobalKey<FormState> key,
    required TextEditingController controller,
    bool obscureText = true,
    String? Function(String? value)? validator,
    VoidCallback? onObscurePressed,
  }) {
    return ListTile(
      dense: true,
      title: Form(
        key: key,
        child: TextFormField(
          validator: validator,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            filled: false,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            suffixIcon: InkWell(
                onTap: onObscurePressed,
                child: Icon(obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined)),
          ),
        ),
      ),
    );
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return "이 입력란을 작성하세요.";
    }
    return null;
  }

  //비밀번호 변경 버튼
  void _onChangedPassword() async {
    final currentValidate = _currentPwFormKey.currentState?.validate() ?? false;
    final newValidate = _newPwFormKey.currentState?.validate() ?? false;
    final confirmValidate = _confirmPwFormKey.currentState?.validate() ?? false;

    if (!currentValidate || !newValidate || !confirmValidate) {
      return;
    }

    final currentPassword = _currentPwController.text;
    final newPassword = _newPwController.text;

    //현재 비밀번호 검사 -> 실패 시 에러 표시
    final authData = await ApiHelper.signIn(
        email: StorageHelper.authData!.email, pw: currentPassword);
    if (authData == null) {
      return setState(() {
        currentPasswordValidateMessage = "현재 비밀번호가 틀렸습니다.";
      });
    }
    //새로운 비밀번호로 변경 -> 성공 후 로그아웃 및 로그인 화면으로 이동
    // final (success, error) = await ApiHelper.changePassword(newPassword);
    final (success, error) = await ApiHelper.changePassword(newPassword);

    //변경 실패
    if (!success) {
      Log.red("비밀번호 변경 에러: $error");
      if (mounted) {
        context.showSnackBar(message: "비밀번호를 변경할 수 없습니다.");
      }
      return;
    }

    //변경 성공
    if (!mounted) {
      return;
    }

    ApiHelper.signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: bgColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "비밀번호 변경",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            30.heightBox,
            Card(
              elevation: 0.0,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: context.theme.dividerColor,
                ),
              ),
              child: Column(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    _buildTextField(
                        key: _currentPwFormKey,
                        controller: _currentPwController,
                        hintText: "현재 비밀번호",
                        obscureText: _obscureCurrent,
                        validator: (value) => _validator(value),
                        onObscurePressed: () {
                          setState(() {
                            _obscureCurrent = !_obscureCurrent;
                          });
                        }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 20,
                        color: bgColor,
                        child: Text(
                          currentPasswordValidateMessage,
                          textAlign: TextAlign.left,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    _buildTextField(
                        key: _newPwFormKey,
                        controller: _newPwController,
                        hintText: "새 비밀번호",
                        obscureText: _obscureNew,
                        validator: (value) => _validator(value),
                        onObscurePressed: () {
                          setState(() {
                            _obscureNew = !_obscureNew;
                          });
                        }),
                    _buildTextField(
                        key: _confirmPwFormKey,
                        controller: _confirmPwController,
                        hintText: "새 비밀번호 확인",
                        obscureText: _obscureConfirm,
                        validator: (value) {
                          final isEmptyValidate = _validator(value);

                          if (isEmptyValidate != null) {
                            return isEmptyValidate;
                          }

                          final newPassword = _newPwController.text;

                          if (value != newPassword) {
                            return "새 비밀번호가 일치하지 않습니다.";
                          }
                          return null;
                        },
                        onObscurePressed: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        }),
                  ],
                ).toList(),
              ),
            ),
            20.heightBox,
            ElevatedButton(
              onPressed: _onChangedPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4E46DC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "변경하기",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
