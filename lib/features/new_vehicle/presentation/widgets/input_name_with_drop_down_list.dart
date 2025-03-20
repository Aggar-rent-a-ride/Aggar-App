import 'package:aggar/features/new_vehicle/presentation/widgets/search_text_field.dart'
    show SearchTextField;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_light_colors.dart' show AppLightColors;
import '../../../../core/utils/app_styles.dart' show AppStyles;
import '../../data/model/dropbown_button.dart';

class InputNameWithDropDownList extends StatefulWidget {
  const InputNameWithDropDownList({
    super.key,
    required this.hintTextSearch,
    required this.lableText,
    required this.hintText,
    this.width,
    required this.items,
    this.flag = false,
    this.onSaved,
    this.validator,
    this.controller,
    this.initialValue,
  });
  final String hintTextSearch;
  final String lableText;
  final String hintText;
  final double? width;
  final List<String> items;
  final bool? flag;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? initialValue;

  @override
  State<InputNameWithDropDownList> createState() =>
      _InputNameWithDropDownListState();
}

class _InputNameWithDropDownListState extends State<InputNameWithDropDownList> {
  String? selectedValue;
  late final TextEditingController textEditingController;
  late final TextEditingController dropdownController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    dropdownController = widget.controller ?? TextEditingController();

    // Initialize selectedValue from the controller or initialValue
    if (widget.initialValue != null) {
      selectedValue = widget.initialValue;
      dropdownController.text = widget.initialValue!;
    } else if (widget.items == vehicleStatus) {
      selectedValue = widget.items.first;
      dropdownController.text = widget.items.first;
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    if (widget.controller == null) {
      dropdownController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      onSaved: widget.onSaved,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lableText,
              style: AppStyles.medium18(context).copyWith(
                color: AppLightColors.myBlue100_1,
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  widget.hintText,
                  style: AppStyles.medium15(context).copyWith(
                    color: AppLightColors.myBlack50,
                  ),
                ),
                items: widget.items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: item == selectedValue
                              ? (item == "active"
                                  ? AppStyles.medium15(context).copyWith(
                                      color: AppLightColors.myGreen100_1,
                                    )
                                  : item == "out of stock"
                                      ? AppStyles.medium15(context).copyWith(
                                          color: AppLightColors.myRed100_1,
                                        )
                                      : AppStyles.medium15(context).copyWith(
                                          color: AppLightColors.myBlack100,
                                        ))
                              : AppStyles.medium15(context).copyWith(
                                  color: AppLightColors.myBlack50,
                                ),
                        ),
                      ),
                    )
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                    dropdownController.text = value ?? '';
                    state.didChange(value);
                  });
                },
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(color: AppLightColors.myWhite100_1),
                  maxHeight: 200,
                ),
                buttonStyleData: ButtonStyleData(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width:
                      widget.width ?? MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: AppLightColors.myWhite100_1,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: state.hasError
                          ? AppLightColors.myRed100_1
                          : AppLightColors.myBlack50,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                dropdownSearchData: widget.flag == true
                    ? DropdownSearchData(
                        searchController: textEditingController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          color: AppLightColors.myWhite100_1,
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: SearchTextField(
                            hintText: widget.hintTextSearch,
                            textEditingController: textEditingController,
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.value.toString().contains(searchValue);
                        },
                      )
                    : const DropdownSearchData(),
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 12.0),
                child: Text(
                  state.errorText!,
                  style: AppStyles.regular14(context).copyWith(
                    color: AppLightColors.myRed100_1,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
