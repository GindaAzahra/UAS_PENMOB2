import 'package:flutter/material.dart';
import '../models/comment_model.dart';
import '../utils/constants.dart';
import '../services/comment_service.dart';

class CommentSection extends StatefulWidget {
  final String itemId;
  final List<Comment> initialComments;
  final Function(Comment) onCommentAdded;

  const CommentSection({
    super.key,
    required this.itemId,
    required this.initialComments,
    required this.onCommentAdded,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late List<Comment> comments;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();
  bool _isSubmitting = false;
  late CommentService _commentService;

  @override
  void initState() {
    super.initState();
    comments = List.from(widget.initialComments);
    _commentService = CommentService();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tulis komentar terlebih dahulu'),
          duration: Duration(milliseconds: 1500),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user',
        userName: 'Anda',
        userImage: '👤',
        content: _commentController.text.trim(),
        createdAt: DateTime.now(),
      );

      setState(() {
        comments.insert(0, newComment);
        _commentController.clear();
        _isSubmitting = false;
      });

      widget.onCommentAdded(newComment);
      _commentService.addComment(widget.itemId, newComment);
      _commentFocus.unfocus();
    });
  }

  void _likeComment(int index) {
    setState(() {
      final comment = comments[index];
      comment.isLikedByUser = !comment.isLikedByUser;
      comment.likeCount += comment.isLikedByUser ? 1 : -1;
    });
    _commentService.likeComment(widget.itemId, comments[index].id);
  }

  void _deleteComment(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Komentar'),
        content: const Text('Anda yakin ingin menghapus komentar ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              final commentId = comments[index].id;
              setState(() {
                comments.removeAt(index);
              });
              _commentService.deleteComment(widget.itemId, commentId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Komentar dihapus'),
                  duration: Duration(milliseconds: 1500),
                ),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment Input Section
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: lightGrayColor),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withOpacity(0.12),
                      ),
                      alignment: Alignment.center,
                      child: const Text('👤', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        focusNode: _commentFocus,
                        maxLines: 4,
                        maxLength: 500,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Tulis komentar Anda...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          suffixIcon: _isSubmitting
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : IconButton(
                                  onPressed: _addComment,
                                  icon: const Icon(Icons.send, size: 20, color: primaryColor),
                                ),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Comments List Section
          if (comments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      size: 48,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada komentar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Jadilah yang pertama memberikan komentar',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[200],
                height: 16,
              ),
              itemBuilder: (context, index) {
                final comment = comments[index];
                return CommentCard(
                  comment: comment,
                  onLike: () => _likeComment(index),
                  onDelete: () => _deleteComment(index),
                );
              },
            ),
        ],
      ),
    );
  }
}

class CommentCard extends StatefulWidget {
  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback onDelete;

  const CommentCard({
    super.key,
    required this.comment,
    required this.onLike,
    required this.onDelete,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> with SingleTickerProviderStateMixin {
  late AnimationController _likeController;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  void _handleLike() {
    if (widget.comment.isLikedByUser) {
      _likeController.reverse();
    } else {
      _likeController.forward();
    }
    widget.onLike();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.1),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.comment.userImage,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.comment.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                        if (widget.comment.userId == 'current_user')
                          GestureDetector(
                            onTap: widget.onDelete,
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.grey[400],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.comment.timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Comment Content
          Padding(
            padding: const EdgeInsets.only(left: 48),
            child: Text(
              widget.comment.content,
              style: const TextStyle(
                fontSize: 13,
                color: textColor,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Actions: Like, Reply
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _handleLike,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 1, end: 1.15).animate(
                      CurvedAnimation(parent: _likeController, curve: Curves.elasticOut),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: widget.comment.isLikedByUser
                            ? primaryColor.withOpacity(0.1)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            widget.comment.isLikedByUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 14,
                            color: widget.comment.isLikedByUser
                                ? primaryColor
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.comment.likeCount.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: widget.comment.isLikedByUser
                                  ? primaryColor
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.reply,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Balas',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Replies Section (if any)
          if (widget.comment.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 52, top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey[300], height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.comment.replies.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final reply = widget.comment.replies[index];
                      return _ReplyCard(reply: reply);
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ReplyCard extends StatelessWidget {
  final Comment reply;

  const _ReplyCard({required this.reply});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accentColor.withOpacity(0.08),
            border: Border.all(
              color: accentColor.withOpacity(0.25),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(reply.userImage, style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    reply.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: textColor,
                    ),
                  ),
                  Text(
                    reply.timeAgo,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                reply.content,
                style: const TextStyle(
                  fontSize: 12,
                  color: textColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
