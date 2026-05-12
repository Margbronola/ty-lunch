import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomImageBuilder {
  Widget networkBuild(context, String url) => LayoutBuilder(
    builder: (context,c) {
      final double w = c.maxWidth;
      final double h = c.maxHeight;
      return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              url,
              width: w,
              height: h,
              fit: BoxFit.cover,
              errorBuilder: (context, _, e) => Container(),
              loadingBuilder: (context, child, progress) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: progress == null
                      ? child
                      : SizedBox(
                        width: w,
                        height: h,
                        child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.white,
                            child: Container(color: Colors.grey.shade300),
                          ),
                      ),
                );
              },
            ),
          );
    }
  );
}
