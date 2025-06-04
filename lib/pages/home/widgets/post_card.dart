import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../common/user_id.dart';
import '../../../controllers/home_controller/home_controller.dart';
import 'post_image_grid.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final userId = getCurrentUserId();
    final postId = post['id'] ?? '';

    // Initialize likes and comments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchLikes(postId);
      controller.fetchComments(postId);
      controller.checkIfLiked(postId, userId);
    });

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(post),
            const SizedBox(height: 10),
            _buildFlightInfo(post),
            const SizedBox(height: 10),
            Text(post['message'] ?? '', style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 10),
            if (post['images'] != null && (post['images'] as List).isNotEmpty)
              PostImageGrid(imageUrls: List<String>.from(post['images'])),
            const SizedBox(height: 15),
            _buildActionsRow(postId, controller, userId, context),
            const Divider(),
            _buildCommentsSection(postId, controller),
            const SizedBox(height: 8),
            _buildCommentField(postId, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(Map<String, dynamic> post) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage('https://placehold.co/600x400/png'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['userName'] ?? 'User',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                timeAgo(getPostDateTime(post['timestamp'])),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
        Row(
          children: [
            RatingBarIndicator(
              rating: (post['rating'] ?? 0).toDouble(),
              itemBuilder: (context, index) =>
                  const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 18.0,
              direction: Axis.horizontal,
            ),
            const SizedBox(width: 4),
            Text('${post['rating']?.toStringAsFixed(1) ?? "0.0"}'),
          ],
        ),
      ],
    );
  }

  String timeAgo(DateTime date) {
    final Duration diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    } else {
      return '${(diff.inDays / 7).floor()} week${(diff.inDays / 7).floor() == 1 ? '' : 's'} ago';
    }
  }

  DateTime getPostDateTime(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is DateTime) {
      return timestamp;
    } else {
      return DateTime.now(); // fallback
    }
  }

  Widget _buildFlightInfo(Map<String, dynamic> post) {
    return Wrap(
      spacing: 8, // Adjust space between chips
      runSpacing: 4, // Adjust space between lines if chips wrap
      children: [
        commonChip(post['departureAirport']),
        commonChip(post['arrivalAirport']),
        commonChip(post['airline'] ?? ''),
        commonChip(post['class'] ?? ''),
        commonChip(
          DateFormat(
            'MMMM yyyy',
          ).format(post['travelDate'] ?? DateTime.now()).toString(),
        ),
      ],
    );
  }

  Chip commonChip(String post) {
    return Chip(
      label: Text(post, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Color.fromARGB(255, 233, 233, 255),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildActionsRow(
    String postId,
    HomeController controller,
    String userId,
    BuildContext context,
  ) {
    return Obx(() {
      final isLiked = controller.likedPosts.contains(postId);
      final likes = controller.likesMap[postId] ?? 0;
      final comments = controller.commentsMap[postId]?.length ?? 0;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => controller.likePost(postId, userId),
            child: Row(
              children: [
                Icon(
                  isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                  size: 20,
                  color: isLiked ? Colors.blue : Colors.grey[700],
                ),
                const SizedBox(width: 6),
                Text('$likes Like'),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // Focus on comment field when comment button is pressed
              FocusScope.of(context).requestFocus(FocusNode()..requestFocus());
            },
            child: Row(
              children: [
                Icon(Icons.comment_outlined, size: 20, color: Colors.grey[700]),
                const SizedBox(width: 6),
                Text('$comments Comment'),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.share_outlined, size: 20, color: Colors.grey[700]),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      );
    });
  }

  Widget _buildCommentsSection(String postId, HomeController controller) {
    return Obx(() {
      final comments = controller.commentsMap[postId];
      if (comments == null || comments.isEmpty) return const SizedBox();

      return Column(
        children: [
          for (final comment in comments.take(2)) ...[
            _buildCommentItem(comment, postId, controller, false),
            if (comment['replies'] != null && comment['replies'].isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Column(
                  children: [
                    for (final reply in comment['replies'])
                      _buildCommentItem(reply, postId, controller, true),
                  ],
                ),
              ),
          ],
          if (comments.length > 2)
            TextButton(
              onPressed: () {
                // Show all comments dialog
                _showAllCommentsDialog(postId, controller);
              },
              child: Text('View all ${comments.length} comments'),
            ),
        ],
      );
    });
  }

  Widget _buildCommentItem(
    Map<String, dynamic> comment,
    String postId,
    HomeController controller,
    bool isReply,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(
          comment['avatar'] ?? 'https://i.pravatar.cc/150',
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment['userName'] ?? 'User',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                _formatTime(comment['timestamp']),
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              if (comment['edited'] == true)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    '(edited)',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment['text'], style: const TextStyle(fontSize: 13)),
          Row(
            children: [
              TextButton(
                onPressed: () => controller.setReplyingTo(comment),
                child: const Text('Reply', style: TextStyle(fontSize: 12)),
              ),
              if (comment['userId'] == getCurrentUserId())
                TextButton(
                  onPressed: () {
                    controller.commentController.text = comment['text'];
                    controller.startEditingComment(comment);
                  },
                  child: const Text('Edit', style: TextStyle(fontSize: 12)),
                ),
              if (comment['userId'] == getCurrentUserId())
                TextButton(
                  onPressed: () => controller.deleteComment(postId, comment),
                  child: const Text('Delete', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return 'Just now';
    final DateTime time = timestamp is Timestamp
        ? timestamp.toDate()
        : timestamp;
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showAllCommentsDialog(String postId, HomeController controller) {
    Get.dialog(
      Dialog(
        child: Column(
          children: [
            AppBar(
              title: const Text('Comments'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                final comments = controller.commentsMap[postId] ?? [];
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return _buildCommentItem(
                      comment,
                      postId,
                      controller,
                      false,
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildCommentField(postId, controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentField(String postId, HomeController controller) {
    return Obx(() {
      final isEditing = controller.editingComment.value != null;
      final isReplying = controller.replyingTo.value != null;

      return Column(
        children: [
          if (isEditing || isReplying)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    isEditing ? 'Editing comment' : 'Replying to comment',
                    style: TextStyle(color: Colors.blue),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: controller.cancelEditing,
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller.commentController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    hintText: isEditing
                        ? 'Edit your comment'
                        : 'Write your comment...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => controller.submitComment(postId),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
