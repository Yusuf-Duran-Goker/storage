import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerSlider extends StatefulWidget {
  final List<String> imageUrls;
  const BannerSlider({Key? key, required this.imageUrls}) : super(key: key);

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();
  final RxInt _currentPage = 0.obs;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = (_pageController.page ?? 0).round();
      if (_currentPage.value != page) {
        _currentPage.value = page;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.imageUrls[i],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (c, child, progress) =>
                    progress == null ? child : Center(child: CircularProgressIndicator()),
                    errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.imageUrls.length, (i) {
              final isActive = _currentPage.value == i;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 12 : 8,
                height: isActive ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade400,
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}
