import 'package:finobird/screens/profile/faq/faq_widget.dart';
import 'package:flutter/material.dart';

import '../../../models/faq/faq.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int?> expandIndex = ValueNotifier(null);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4AB5E5),
        title: const Text("FAQ's"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: expandIndex,
              builder: (context, selectedIndex, child) => ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: faqList.length,
                itemBuilder: (context, i) => FaqWidget(
                  model: faqList[i],
                  expanded: selectedIndex == i,
                  onChange: () {
                    if (selectedIndex == i) {
                      expandIndex.value = null;
                    } else {
                      expandIndex.value = i;
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
