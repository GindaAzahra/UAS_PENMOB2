import 'package:flutter/material.dart';
import '../models/comment_model.dart';
import '../utils/constants.dart';
import '../widgets/comment_section.dart';
import '../services/comment_service.dart';

class TestimonialDetailPage extends StatefulWidget {
  final String name;
  final double rating;
  final String image;
  final String comment;
  final String date;

  const TestimonialDetailPage({
    super.key,
    required this.name,
    required this.rating,
    required this.image,
    required this.comment,
    required this.date,
  });

  @override
  State<TestimonialDetailPage> createState() => _TestimonialDetailPageState();
}

class _TestimonialDetailPageState extends State<TestimonialDetailPage> {
  late List<Comment> comments;
  late CommentService _commentService;
  late String _itemId;

  @override
  void initState() {
    super.initState();
    _commentService = CommentService();
    _itemId = 'testimonial_${widget.name}';
    // Get comments from service
    comments = _commentService.getComments(_itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Review',
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Review Card Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author Info
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withValues(alpha: 0.1),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.image,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.date,
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
                    const SizedBox(height: 16),

                    // Rating
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(
                            5,
                            (index) => Icon(
                              index < widget.rating.floor()
                                  ? Icons.star
                                  : (index < widget.rating
                                      ? Icons.star_half
                                      : Icons.star_border),
                              color: accentColor,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.rating} / 5',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Review Content
                    Text(
                      widget.comment,
                      style: const TextStyle(
                        fontSize: 14,
                        color: textColor,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Comments Section Title
              const Text(
                '💬 Komentar & Tanggapan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),

              // Comments Section
              CommentSection(
                itemId: 'testimonial_${widget.name}',
                initialComments: comments,
                onCommentAdded: (comment) {
                  setState(() {
                    _commentService.addComment(_itemId, comment);
                    comments = _commentService.getComments(_itemId);
                  });
                },
              ),

              const SizedBox(height: 24),

              // Tips Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue[200]!,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tips Memberikan Komentar',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '✓ Berikan komentar yang sopan dan membangun\n'
                      '✓ Hindari penggunaan HURUF BESAR berlebihan\n'
                      '✓ Jangan bagikan informasi pribadi\n'
                      '✓ Hormati pendapat pengguna lain',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue[700],
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

