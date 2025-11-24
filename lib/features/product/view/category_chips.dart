import 'package:client/features/product/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/utils/app_textstyles.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProductController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final cats = c.categories;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _ChipItem(
              label: 'Todos',
              selected: c.selectedCategoryId.value == null,
              onTap: () => c.selectCategory(null),
              isDark: isDark,
            ),
            ...cats.map((cat) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _ChipItem(
                    label: cat.name,
                    selected: c.selectedCategoryId.value == cat.id,
                    onTap: () => c.selectCategory(cat.id),
                    isDark: isDark,
                  ),
                )),
          ],
        ),
      );
    });
  }
}

class _ChipItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;
  const _ChipItem({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: AppTextStyle.withColor(
          AppTextStyle.bodySmall,
          selected ? Colors.white : (isDark ? Colors.grey[300]! : Colors.grey[700]!),
        ),
      ),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).primaryColor,
      backgroundColor: isDark ? Colors.grey[850] : Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
