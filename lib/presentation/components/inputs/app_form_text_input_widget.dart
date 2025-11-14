import 'package:igmp/domain/models/shared/text_input_types.dart';
import 'package:igmp/presentation/components/utils/app_text_input_types.dart';
import 'package:igmp/presentation/components/utils/app_text_input_validators.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormTextInput extends StatefulWidget {
  const FormTextInput({
    super.key,
    required this.label,
    required this.controller,
    this.onSaved,
    this.clear,
    this.isVisible,
    this.isDisabled,
    this.onChanged,
    this.isRequired,
    this.inputFormatters,
    this.validator,
    this.keyboardType,
    this.type,
  });

  final String label;
  final TextEditingController controller;
  final Function(String value)? onChanged;
  final Function(String? value)? onSaved;
  final bool? clear;
  final bool? isVisible;
  final bool? isDisabled;
  final bool? isRequired;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String val)? validator;
  final TextInputType? keyboardType;
  final TextInputTypes? type;

  @override
  State<FormTextInput> createState() => _FormTextInputState();
}

class _FormTextInputState extends State<FormTextInput> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible ?? true,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 4.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: RichText(
                text: TextSpan(
                  text: widget.label,
                  style: TextStyle(
                    color: AppColors.cardColor,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: widget.isRequired == true ? ' *' : '',
                      style: TextStyle(
                        color: AppColors.delete,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 55,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: widget.keyboardType ?? TextInputType.text,
                enabled: widget.isDisabled != null ? !widget.isDisabled! : true,
                onChanged: (value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                },
                onSaved: widget.onSaved != null
                    ? (value) => widget.onSaved!(value)
                    : (value) => widget.controller.text = value ?? '',
                controller: widget.controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  suffixIconConstraints: BoxConstraints(maxHeight: 30),
                  suffixIcon: widget.clear == true
                      ? IconButton(
                          iconSize: 15,
                          onPressed: () {
                            setState(() {
                              widget.controller.text = '';
                            });
                          },
                          icon: Icon(Icons.close),
                        )
                      : null,
                ),
                inputFormatters: widget.inputFormatters != null
                    ? widget.inputFormatters!
                    : filterTextInputFormatterByType(widget.type),
                validator: (value) {
                  if (widget.validator != null) {
                    return widget.validator!(value ?? '');
                  }
                  if (widget.isRequired != null && widget.isRequired!) {
                    String? validator =
                        textInputTypesValidator(value ?? '', widget.type);
                    return validator;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
