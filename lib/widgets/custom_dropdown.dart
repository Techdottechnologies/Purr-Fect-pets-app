// Project: 	   listi_shop
// File:    	   custom_dropdown
// Path:    	   lib/screens/components/custom_dropdown.dart
// Author:       Ali Akbar
// Date:        23-04-24 16:54:23 -- Tuesday
// Description:

import 'package:petcare/config/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants/app_theme.dart';
import '../../utils/constants/constants.dart';

@Deprecated("User CustomDropdownTF instead")
class CustomTextFieldDropdown extends StatefulWidget {
  const CustomTextFieldDropdown({
    super.key,
    this.titleText,
    required this.hintText,
    required this.items,
    required this.onSelectedItem,
    this.selectedValue,
    this.isEnabled = true,
  });
  final String? titleText;
  final String hintText;
  final List<String> items;
  final Function(String) onSelectedItem;
  final String? selectedValue;
  final bool isEnabled;
  @override
  State<CustomTextFieldDropdown> createState() =>
      _CustomTextFieldDropdownState();
}

// ignore: deprecated_member_use_from_same_package
class _CustomTextFieldDropdownState extends State<CustomTextFieldDropdown> {
  bool isShowPassword = true;
  List<String> items = [];
  String? selectedItem;

  @override
  void initState() {
    setState(() {
      items = List.from(widget.items);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Visibility(
          visible: widget.titleText != null,
          child: Text(
            widget.titleText ?? "",
            style: const TextStyle(
              color: MyColors.txtclr1,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        gapH10,

        /// Dropdown Buttton
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 300,
              decoration: BoxDecoration(
                color: Color(0xFF303030),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(height: 50),
            items: widget.isEnabled
                ? items
                    .map(
                      (String item) => DropdownMenuItem<String>(
                        value: item,
                        child: SizedBox(
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: AppTheme.titleColor1,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    )
                    .toList()
                : [],
            value: widget.selectedValue ?? selectedItem,
            onChanged: (value) {
              setState(() {
                selectedItem = value as String? ?? "";
              });
              widget.onSelectedItem(value as String? ?? "");
            },
            hint: Text(
              widget.hintText,
              style: const TextStyle(
                color: MyColors.txtclr2,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(left: 5, right: 20),
              decoration: BoxDecoration(
                color: Color(0xFF303030),
                borderRadius: BorderRadius.all(
                  Radius.circular(124),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================Custom Button Dropdoown================================

class CustomMenuDropdown extends StatelessWidget {
  const CustomMenuDropdown(
      {required this.items,
      required this.onSelectedItem,
      super.key,
      this.icon,
      this.width});
  final List<DropdownMenuModel> items;
  final Function(String, int) onSelectedItem;
  final Widget? icon;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: icon ??
            const Icon(
              Icons.more_vert_outlined,
              color: Colors.black,
            ),
        items: items
            .map(
              (DropdownMenuModel item) => DropdownMenuItem<String>(
                value: item.title,
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      color: Colors.white,
                    ),
                    gapW10,
                    Text(
                      item.title,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          direction: DropdownDirection.left,
          width: width ?? SCREEN_WIDTH * 0.5,
        ),
        onChanged: (value) {
          if (value != null) {
            final int index = items.indexWhere(
                (e) => e.title.toLowerCase() == value.toLowerCase());
            onSelectedItem(value, index);
          }
        },
      ),
    );
  }
}

class DropdownMenuModel {
  final String title;
  final IconData icon;

  DropdownMenuModel({required this.title, required this.icon});
}

// ===========================Small Dropdown TF================================

class CustomDropdownTF extends StatefulWidget {
  const CustomDropdownTF({
    super.key,
    this.titleText,
    required this.hintText,
    required this.items,
    required this.onSelectedItem,
    this.selectedValue,
    this.isEnabled = true,
    this.isTransparent = false,
    this.textSize = 10,
    this.width,
    this.height,
  });
  final String? titleText;
  final String hintText;
  final List<String> items;
  final Function(String) onSelectedItem;
  final String? selectedValue;
  final bool isEnabled;
  final bool isTransparent;
  final double? width;
  final double? height;
  final double textSize;
  @override
  State<CustomDropdownTF> createState() => _CustomSmallTextFieldDropdownState();
}

class _CustomSmallTextFieldDropdownState extends State<CustomDropdownTF> {
  bool isShowPassword = true;
  List<String> items = [];
  String? selectedItem;

  @override
  void initState() {
    setState(() {
      items = List.from(widget.items);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Dropdown Buttton
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            dropdownStyleData: DropdownStyleData(
              width: widget.width != null ? (widget.width! + 50) : 150,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF303030),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(height: widget.textSize + 20),
            items: widget.isEnabled
                ? items
                    .map(
                      (String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            color: AppTheme.titleColor1,
                            fontSize: widget.textSize,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList()
                : [],
            value: widget.selectedValue ?? selectedItem,
            onChanged: (value) {
              setState(() {
                selectedItem = value as String? ?? "";
              });
              widget.onSelectedItem(value as String? ?? "");
            },
            hint: Text(
              widget.hintText,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: MyColors.txtclr2,
                fontWeight: FontWeight.w700,
                fontSize: widget.textSize,
              ),
            ),
            buttonStyleData: ButtonStyleData(
              width: widget.width ?? 100,
              height: widget.height,
              padding: widget.isTransparent
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: widget.isTransparent
                    ? Colors.transparent
                    : const Color(0xFF303030),
                borderRadius: const BorderRadius.all(
                  Radius.circular(124),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
