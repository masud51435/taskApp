import 'package:flutter/material.dart';

class PostImageGrid extends StatelessWidget {
  final List<String> imageUrls;
  final double gridHeight;

  const PostImageGrid({
    super.key,
    required this.imageUrls,
    this.gridHeight = 300,
  });

  @override
  Widget build(BuildContext context) {
    final int count = imageUrls.length;
    if (count == 0) return const SizedBox.shrink();

    const double spacing = 10.0;

    Widget buildImage(String url, [BoxFit fit = BoxFit.cover]) {
      return Image.network(url, fit: fit);
    }

    switch (count) {
      case 1:
        return SizedBox(
          height: gridHeight,
          width: double.infinity,
          child: buildImage(imageUrls[0]),
        );

      case 2:
        return SizedBox(
          height: gridHeight,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: spacing / 2),
                  child: buildImage(imageUrls[0]),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: spacing / 2),
                  child: buildImage(imageUrls[1]),
                ),
              ),
            ],
          ),
        );

      case 3:
        return SizedBox(
          height: gridHeight,
          child: Row(
            children: [
              Expanded(child: buildImage(imageUrls[0])),
              SizedBox(width: spacing),
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: spacing / 2),
                      child: buildImage(imageUrls[1]),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: spacing / 2),
                      child: buildImage(imageUrls[2]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case 4:
        return SizedBox(
          height: gridHeight,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: 1,
            ),
            itemCount: 4,
            itemBuilder: (_, index) => buildImage(imageUrls[index]),
          ),
        );

      case 5:
        return SizedBox(
          height: gridHeight,
          child: Column(
            children: [
              Expanded(
                flex: 2, // Top row takes 2/3 of height
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: spacing / 2,
                          bottom: spacing / 2,
                        ),
                        child: buildImage(imageUrls[0]),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: spacing / 2,
                          right: spacing / 2,
                          bottom: spacing / 2,
                        ),
                        child: buildImage(imageUrls[1]),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: spacing / 2,
                          bottom: spacing / 2,
                        ),
                        child: buildImage(imageUrls[2]),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1, // Bottom row takes 1/3 of height
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: spacing / 2,
                          top: spacing / 2,
                        ),
                        child: buildImage(imageUrls[3]),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: spacing / 2,
                          top: spacing / 2,
                        ),
                        child: buildImage(imageUrls[4]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      default: // 6+ images
        return SizedBox(
          height: gridHeight,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: i < 2 ? spacing / 2 : 0,
                            bottom: spacing / 2,
                          ),
                          child: buildImage(imageUrls[i]),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 1, // Bottom row takes 1/3 of height
                child: Row(
                  children: [
                    for (int i = 3; i < 5; i++)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: i == 3 ? spacing / 2 : 0,
                            top: spacing / 2,
                          ),
                          child: i == 4 && count > 5
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    buildImage(imageUrls[i]),
                                    Container(
                                      color: Colors.black54,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '+${count - 5}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : buildImage(imageUrls[i]),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
    }
  }
}
