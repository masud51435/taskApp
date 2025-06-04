import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/common/common_button.dart';
import 'package:taskapp/pages/home/widgets/airline_review_appbar.dart';

import '../../controllers/home_controller/home_controller.dart';
import 'widgets/post_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: AirlineReviewAppBar(),
      body: Obx(() {
        if (controller.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: controller.fetchPosts,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CommonButton(
                              onTap: () => Get.toNamed('/share'),
                              text: 'Share Your Experience',
                              icon: Icons.share_outlined,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CommonButton(
                              onTap: () {},
                              text: 'Ask A Question',
                              icon: Icons.question_answer_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CommonButton(
                        onTap: () {},
                        text: 'Search',
                        icon: Icons.search,
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Image.asset('assets/images/image 8.png'),
                  ),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final post = controller.posts[index];
                    return PostCard(post: post);
                  }, childCount: controller.posts.length),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        );
      }),
    );
  }
}
