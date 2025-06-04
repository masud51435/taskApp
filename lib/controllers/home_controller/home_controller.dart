import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/common/user_id.dart';
import '../../model/post_model.dart';

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> posts = <Map<String, dynamic>>[].obs;
  final RxMap<String, int> likesMap = <String, int>{}.obs;
  final RxSet<String> likedPosts = <String>{}.obs;
  final RxMap<String, List<Map<String, dynamic>>> commentsMap =
      <String, List<Map<String, dynamic>>>{}.obs;
  final Rxn<Map<String, dynamic>> editingComment = Rxn<Map<String, dynamic>>();

  final TextEditingController commentController = TextEditingController();
  final Rxn<Map<String, dynamic>> replyingTo = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    fetchPosts(); // Load posts when controller is initialized
  }

  Future<void> fetchPosts() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      final fetchedPosts = snapshot.docs.map((doc) {
        final data = doc.data();
        final post = PostModel.fromJson(data);
        return {
          'id': doc.id,
          'userName': 'Anonymous',
          'userAvatar': 'https://via.placeholder.com/150',
          'departureAirport': post.departureAirport,
          'arrivalAirport': post.arrivalAirport,
          'airline': post.airline,
          'class': post.travelClass,
          'message': post.message,
          'images': post.images,
          'travelDate': DateTime.tryParse(post.travelDate),
          'rating': post.rating,
          'timestamp': DateTime.tryParse(
            post.timestamp ?? DateTime.now().toString(),
          ),
        };
      }).toList();

      posts.assignAll(fetchedPosts);
    } catch (e) {
      print('Error fetching posts: $e');
      Get.snackbar('Error', 'Failed to load posts');
    }
  }

  // Like / Unlike functionality
  // Add these new methods for Firestore integration
  Future<void> likePost(String postId, String userId) async {
    try {
      final postRef = FirebaseFirestore.instance
          .collection('posts')
          .doc(postId);
      final likeRef = postRef.collection('likes').doc(userId);

      final likeDoc = await likeRef.get();
      if (likeDoc.exists) {
        await likeRef.delete(); // Unlike
        likedPosts.remove(postId);
      } else {
        await likeRef.set({
          'userId': userId,
          'timestamp': FieldValue.serverTimestamp(),
        }); // Like
        likedPosts.add(postId);
      }

      // Update local likes count
      final likesSnapshot = await postRef.collection('likes').count().get();
      likesMap[postId] = likesSnapshot.count!;
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update like');
    }
  }

  Future<void> fetchLikes(String postId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .count()
          .get();

      likesMap[postId] = snapshot.count!;
      update();
    } catch (e) {
      print('Error fetching likes: $e');
    }
  }

  Future<void> checkIfLiked(String postId, String userId) async {
    try {
      final likeDoc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userId)
          .get();

      if (likeDoc.exists) {
        likedPosts.add(postId);
      }
    } catch (e) {
      print('Error checking like: $e');
    }
  }

  Future<void> fetchComments(String postId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .get();

      final comments = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
          'replies': <Map<String, dynamic>>[],
        };
      }).toList();

      // Fetch replies for each comment
      for (var comment in comments) {
        final repliesSnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(comment['id'])
            .collection('replies')
            .orderBy('timestamp', descending: false)
            .get();

        comment['replies'] = repliesSnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'parentId': comment['id'], 
            ...doc.data(),
          };
        }).toList();
      }

      commentsMap[postId] = comments;
      update();
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<void> submitComment(String postId) async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    try {
      final commentData = {
        'userId': getCurrentUserId(),
        'userName': 'Current User', // Replace with actual user name
        'avatar': 'https://i.pravatar.cc/150', // Replace with actual avatar
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'edited': true, // Mark as edited when updating
      };

      // Check if we're editing an existing comment
      if (editingComment.value != null) {
        final isReply = replyingTo.value != null;
        final collection = isReply
            ? FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postId)
                  .collection('comments')
                  .doc(editingComment.value!['parentId'] ?? '')
                  .collection('replies')
            : FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postId)
                  .collection('comments');

        await collection.doc(editingComment.value!['id']).update(commentData);
        editingComment.value = null;
      }
      // Check if we're replying to a comment
      else if (replyingTo.value != null) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(replyingTo.value!['id'])
            .collection('replies')
            .add(commentData);
        replyingTo.value = null;
      }
      // Otherwise, it's a new comment
      else {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .add(commentData);
      }

      commentController.clear();
      await fetchComments(postId); // Refresh comments
    } catch (e) {
      Get.snackbar('Error', 'Failed to post comment');
    }
  }

  Future<void> editComment(String postId, Map<String, dynamic> comment) async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    try {
      final isReply = replyingTo.value != null;
      final collection = isReply
          ? FirebaseFirestore.instance
                .collection('posts')
                .doc(postId)
                .collection('comments')
                .doc(comment['parentId'] ?? '')
                .collection('replies')
          : FirebaseFirestore.instance
                .collection('posts')
                .doc(postId)
                .collection('comments');

      await collection.doc(comment['id']).update({
        'text': text,
        'edited': true,
      });

      commentController.clear();
      await fetchComments(postId);
      replyingTo.value = null;
    } catch (e) {
      Get.snackbar('Error', 'Failed to edit comment');
    }
  }

  void startEditingComment(Map<String, dynamic> comment) {
    commentController.text = comment['text'];
    editingComment.value = comment;
    replyingTo.value = null; // Clear any reply state when editing
  }

  void cancelEditing() {
    commentController.clear();
    editingComment.value = null;
    replyingTo.value = null;
  }

  Future<void> deleteComment(
    String postId,
    Map<String, dynamic> comment,
  ) async {
    try {
      final isReply =
          comment.containsKey('parentId') && comment['parentId'] != null;

      if (isReply) {
        // Delete a single reply
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(comment['parentId'])
            .collection('replies')
            .doc(comment['id'])
            .delete();
      } else {
        // Delete a parent comment and all its replies
        final WriteBatch batch = FirebaseFirestore.instance.batch();

        // Reference to the parent comment
        final commentRef = FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(comment['id']);

        // Get all replies
        final replies = await commentRef.collection('replies').get();

        // Add all replies to batch delete
        for (final reply in replies.docs) {
          batch.delete(reply.reference);
        }

        // Add parent comment to batch delete
        batch.delete(commentRef);

        // Commit the batch
        await batch.commit();
      }

      // Refresh comments
      await fetchComments(postId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete comment: ${e.toString()}');
      print('Error deleting comment: $e');
    }
  }

  void setReplyingTo(Map<String, dynamic> comment) {
    replyingTo.value = comment;
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
