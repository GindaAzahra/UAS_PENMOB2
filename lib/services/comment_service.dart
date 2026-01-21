import 'package:flutter/foundation.dart';
import '../models/comment_model.dart';

class CommentService extends ChangeNotifier {
  static final CommentService _instance = CommentService._internal();
  
  // Store comments per item (testimonials and products)
  static final Map<String, List<Comment>> _commentsStorage = {
    'testimonial_Siti Nurhaliza': [
      Comment(
        id: '1',
        userId: 'user1',
        userName: 'Admin Aliya Divani',
        userImage: '👨‍💼',
        content: 'Terima kasih Siti! Kami sangat menghargai kepercayaan Anda terhadap layanan kami. Testimoni Anda motivasi untuk terus meningkatkan kualitas.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        likeCount: 12,
      ),
      Comment(
        id: '2',
        userId: 'user2',
        userName: 'Budi Santoso',
        userImage: '👨',
        content: 'Setuju! Saya juga sudah pesan berkali-kali, selalu memuaskan. Deliverynya cepat dan makanannya masih hangat.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likeCount: 8,
      ),
    ],
    'testimonial_Budi Santoso': [
      Comment(
        id: '3',
        userId: 'user1',
        userName: 'Admin Aliya Divani',
        userImage: '👨‍💼',
        content: 'Terimakasih atas review bintang 4! Kami akan terus meningkatkan kualitas untuk memberikan yang terbaik.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        likeCount: 5,
      ),
    ],
    'product_Nasi Goreng Spesial': [
      Comment(
        id: '4',
        userId: 'user3',
        userName: 'Sinta Wijaya',
        userImage: '👩',
        content: 'Nasi gorengnya enak banget! Porsi besar, harganya worth it. Paling suka sama sambal yang pedasnya pas.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likeCount: 15,
      ),
      Comment(
        id: '5',
        userId: 'user1',
        userName: 'Admin Aliya Divani',
        userImage: '👨‍💼',
        content: 'Terima kasih feedback positifnya! Kami menggunakan bumbu pilihan untuk rasa yang maksimal.',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        likeCount: 8,
      ),
      Comment(
        id: '6',
        userId: 'user4',
        userName: 'Roni Hartono',
        userImage: '👨',
        content: 'Sangat recommended! Saya pesan 3 porsi untuk keluarga, semuanya habis. Next order untuk teman-teman.',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        likeCount: 10,
      ),
    ],
    'product_Mie Ayam Pangsit': [
      Comment(
        id: '7',
        userId: 'user5',
        userName: 'Eka Putri',
        userImage: '👩',
        content: 'Mie ayamnya lembut dan pangsitnya crispy! Kuahnya gurih, pas untuk sarapan atau makan siang.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        likeCount: 12,
      ),
      Comment(
        id: '8',
        userId: 'user2',
        userName: 'Budi Santoso',
        userImage: '👨',
        content: 'Sudah 5x pesan ini, consistent enak. Porsi banyak untuk harganya.',
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        likeCount: 7,
      ),
    ],
    'product_Soto Ayam': [
      Comment(
        id: '9',
        userId: 'user6',
        userName: 'Ibu Sari',
        userImage: '👩‍🦱',
        content: 'Soto ayamnya masih hangat sampai tiba, aromanya harum banget. Bumbu tradisional yang pas!',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        likeCount: 18,
      ),
      Comment(
        id: '10',
        userId: 'user1',
        userName: 'Admin Aliya Divani',
        userImage: '👨‍💼',
        content: 'Soto Ayam kami dibuat dengan resep tradisional dan bahan-bahan pilihan. Senang Anda menyukainya!',
        createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
        likeCount: 9,
      ),
    ],
  };

  factory CommentService() {
    return _instance;
  }

  CommentService._internal();

  // Get comments for a specific item
  List<Comment> getComments(String itemId) {
    return _commentsStorage[itemId] ?? [];
  }

  // Add a new comment
  void addComment(String itemId, Comment comment) {
    if (!_commentsStorage.containsKey(itemId)) {
      _commentsStorage[itemId] = [];
    }
    _commentsStorage[itemId]!.insert(0, comment);
    notifyListeners();
  }

  // Get all product comments that should appear in testimonials
  List<Comment> getAllProductComments() {
    List<Comment> allComments = [];
    
    // Collect comments from all product items
    _commentsStorage.forEach((key, comments) {
      if (key.startsWith('product_')) {
        allComments.addAll(comments);
      }
    });
    
    // Sort by date (newest first)
    allComments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return allComments;
  }

  // Delete a comment
  void deleteComment(String itemId, String commentId) {
    if (_commentsStorage.containsKey(itemId)) {
      _commentsStorage[itemId]!
          .removeWhere((comment) => comment.id == commentId);
      notifyListeners();
    }
  }

  // Like a comment
  void likeComment(String itemId, String commentId) {
    if (_commentsStorage.containsKey(itemId)) {
      final comments = _commentsStorage[itemId];
      final index = comments!.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        final comment = comments[index];
        if (!comment.isLikedByUser) {
          comment.likeCount++;
          comment.isLikedByUser = true;
        } else {
          comment.likeCount--;
          comment.isLikedByUser = false;
        }
        notifyListeners();
      }
    }
  }

  // Add reply to a comment
  void addReply(String itemId, String commentId, Comment reply) {
    if (_commentsStorage.containsKey(itemId)) {
      final comments = _commentsStorage[itemId];
      final index = comments!.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        comments[index].replies.insert(0, reply);
        notifyListeners();
      }
    }
  }

  // Get comments count
  int getCommentCount(String itemId) {
    return _commentsStorage[itemId]?.length ?? 0;
  }
}
