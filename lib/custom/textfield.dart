import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required TextEditingController? controller,
    required this.text,
    this.hintText,
    required this.type,
    this.onSubmit,
    this.suffix,
    this.prefix,
    this.validator,
    this.maxLength,
    this.inputFormatters,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController? _controller;
  final String text;
  final String? hintText;
  final TextInputType type;
  final Function(String)? onSubmit;
  final Widget? suffix;
  final Widget? prefix;
  final String? Function(String?)? validator;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    RxBool obscureText = false.obs;
    if (type == TextInputType.visiblePassword) {
      obscureText.value = true;
    }

    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        // height: 50,
        child: Obx(
          () => TextFormField(
            controller: _controller,
            keyboardType: type,
            obscureText: obscureText.value,
            maxLength: maxLength ?? 45,
            validator: validator,
            style: GoogleFonts.chivo().copyWith(
              fontSize: 14,
            ),
            onFieldSubmitted: onSubmit,
            inputFormatters: inputFormatters,

            decoration: InputDecoration(
              errorMaxLines: 2,
              hintText: hintText,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              label: Text(
                text,
                textScaleFactor: 1,
              ),
              counterText: "",
              floatingLabelStyle: const TextStyle(
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0xFF4AB5E5).withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              prefix: prefix,
              suffix: type == TextInputType.visiblePassword
                  ? InkWell(
                      onTap: () {
                        obscureText.value = !obscureText.value;
                      },
                      child:  Icon(obscureText.value?Icons.visibility:Icons.visibility_off),
                    )
                  : suffix,
            ),
          ),
        ),
      ),
    );
  }
}
