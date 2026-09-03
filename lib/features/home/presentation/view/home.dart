import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_app_foundation/core/widget/dropdown/custom_search_dropdown.dart';
import 'package:flutter_app_foundation/core/widget/navbar/navbar.dart';
import 'package:flutter_app_foundation/core/widget/textfield/app_textfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  late final TextEditingController _dropdownController = TextEditingController();

  List<Widget> get pages => [
    Column(
      spacing: AppConstants.isMobileAndTabletLandscapeDimensions(10.h, 5.h, 5.h),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: CustomSearchDropdown(
            labelText: 'Select an item',
            items: const ['Item 1', 'Item 2', 'Item 3'],
            displayText: (item) => item,
            onChanged: (value) {
              _dropdownController.text = value ?? '';
            },
            controller: _dropdownController,
          ),
        ),
        Center(
          child: CustomSearchDropdown(
            labelText: 'Select an item',
            items: const ['مرحبا', 'مرحبا', 'مرحبا'],
            displayText: (item) => item,
            onChanged: (value) {
              _dropdownController.text = value ?? '';
            },
            controller: _dropdownController,
          ),
        ),
        AppTextField(
          labelText: "auth.login.fields.usernameOrEmailLabel".tr(),
          hintText: "auth.login.fields.usernameOrEmailHint".tr(),
          controller: TextEditingController(),
          textInputAction: TextInputAction.next,
          //color: AppColors.WHITE,
        ),
      ],
    ),

    const Center(child: Text('Search')),
    const Center(child: Text('Profile')),
    const Center(child: Text('Test')),
  ];

  @override
  void dispose() {
    _dropdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      bottomNavigationBar: NavbarBottom(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: pages[_currentIndex],
    );
  }
}
