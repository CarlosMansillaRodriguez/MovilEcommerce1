import 'package:client/utils/app_textstyles.dart';
import 'package:client/features/product/widget/filter_botton_sheet.dart';
import 'package:flutter/material.dart';

// Asegúrate de tener importado tu AppTextStyle
// import 'package:tu_app/utils/app_text_style.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // vuelve atrás
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          'All Products',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          // search icon
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: isDark ? Colors.white : Colors.black,
            ),
            // Icon
          ),

          ///  filter icon
          ///
          IconButton(
            onPressed: () => FilterBottomSheet.show(context),
            icon: Icon(
              Icons.filter_list,
              color: isDark ? Colors.white : Colors.black,
            ),
            // Icon
          ),
          // IconButton

          // IconButton
        ],
      ),
      body: const Center(child: Text("Aquí irán los productos en un GridView")),
    );
  }
}
