import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/models.dart';
import '../providers/capture_providers.dart';
import 'add_student_page.dart';
import 'capture_photo_flow.dart';

class OrderStudentsPage extends ConsumerStatefulWidget {
  const OrderStudentsPage({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderStudentsPage> createState() => _OrderStudentsPageState();
}

class _OrderStudentsPageState extends ConsumerState<OrderStudentsPage> {
  late final ScrollController _scrollController;

  final List<CaptureStudent> _students = <CaptureStudent>[];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  int _pageSize = 50;
  int _total = 0;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFirstPage());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (!position.hasPixels || !position.hasContentDimensions) return;
    if (position.pixels >= position.maxScrollExtent - 400) {
      _loadMore();
    }
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      _loading = true;
      _error = null;
      _students.clear();
      _page = 1;
      _hasMore = true;
      _total = 0;
    });

    try {
      final repo = ref.read(captureOrdersRepositoryProvider);
      final response = await repo.fetchStudentsPage(
        orderId: widget.orderId,
        online: ref.read(isOnlineProvider),
        page: 1,
        pageSize: _pageSize,
      );

      setState(() {
        _students.addAll(response.students);
        _page = response.page;
        _pageSize = response.pageSize;
        _total = response.totalStudents;
        _hasMore = response.page * response.pageSize < response.totalStudents;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loading || _loadingMore || !_hasMore) return;

    setState(() {
      _loadingMore = true;
      _error = null;
    });

    try {
      final repo = ref.read(captureOrdersRepositoryProvider);
      final nextPage = _page + 1;
      final response = await repo.fetchStudentsPage(
        orderId: widget.orderId,
        online: ref.read(isOnlineProvider),
        page: nextPage,
        pageSize: _pageSize,
      );

      setState(() {
        _students.addAll(response.students);
        _page = response.page;
        _pageSize = response.pageSize;
        _total = response.totalStudents;
        _hasMore = response.page * response.pageSize < response.totalStudents;
        _loadingMore = false;
      });
    } catch (e) {
      setState(() {
        _error = e;
        _loadingMore = false;
      });
    }
  }

  Future<void> _captureSequence({
    required int startIndex,
    required Session session,
  }) async {
    final repo = ref.read(captureOrdersRepositoryProvider);

    var index = startIndex;
    while (mounted) {
      // Load more if we're at the end and there are more records.
      if (index >= _students.length) {
        if (_hasMore) {
          await _loadMore();
          continue;
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reached end of loaded students.')),
          );
        }
        return;
      }

      final s = _students[index];

      // Strict mode: always go to the next uncaptured student.
      final isAbsent = (s.details['absent'] == true);
      if (s.captureTimestamp != null || isAbsent) {
        index++;
        continue;
      }

      if (!mounted) return;

      final res = await Navigator.of(context).push<CapturePhotoResult>(
        MaterialPageRoute(
          builder: (_) => CapturePhotoFlowPage(
            orderId: widget.orderId,
            studentId: s.studentId,
            studentName: s.name,
            studentAdmNo: s.admNo,
          ),
        ),
      );

      // User backed out -> stop the sequence.
      if (res == null || !mounted) return;

      final CaptureStudent updated;
      if (res.absent) {
        updated = await repo.markAbsent(
          orderId: widget.orderId,
          studentId: s.studentId,
          editedBy: session.userId,
        );
      } else {
        updated = await repo.markCapturedWithLocalPhotos(
          orderId: widget.orderId,
          studentId: s.studentId,
          editedBy: session.userId,
          localHighResPath: res.highResPath,
          localThumbnailPath: res.thumbnailPath,
          crop: res.crop,
        );
      }

      if (!mounted) return;
      setState(() {
        _students[index] = updated;
      });

      // Keep the next student visible.
      await _scrollController.animateTo(
        (index + 1) * 72.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );

      index++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final online = ref.watch(isOnlineProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students (${widget.orderId})${_total > 0 ? ' • $_total' : ''}',
        ),
        actions: [
          IconButton(
            tooltip: 'Sync next 10',
            onPressed: (!online || session == null)
                ? null
                : () async {
                    final res = await ref
                        .read(captureSyncRepositoryProvider)
                        .syncNextChunk(
                          orderId: widget.orderId,
                          editedBy: session.userId,
                        );
                    if (!context.mounted) return;
                    if (res == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Nothing to sync (no ready pending records).',
                          ),
                        ),
                      );
                      return;
                    }
                    final failed = res.failedIds.length;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sync done. Failed: $failed')),
                    );
                    await _loadFirstPage();
                  },
            icon: const Icon(Icons.cloud_upload_outlined),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loadFirstPage,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddStudentPage(orderId: widget.orderId),
            ),
          );
          await _loadFirstPage();
        },
        child: const Icon(Icons.person_add_alt_1),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : RefreshIndicator(
              onRefresh: _loadFirstPage,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _students.length + 1,
                itemBuilder: (context, index) {
                  if (index == _students.length) {
                    if (!_hasMore) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: Text('No more students.')),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: _loadingMore
                            ? const CircularProgressIndicator.adaptive()
                            : const SizedBox.shrink(),
                      ),
                    );
                  }

                  final s = _students[index];
                  final sync = s.syncStatus.name;
                  final captured = s.captureTimestamp != null;
                  final absent = s.details['absent'] == true;

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: s.localThumbnailPath != null
                          ? FileImage(File(s.localThumbnailPath!))
                          : null,
                      child: s.localThumbnailPath == null
                          ? Icon(
                              absent
                                  ? Icons.person_off_outlined
                                  : Icons.person_outline,
                              color: Colors.grey.shade600,
                            )
                          : null,
                    ),
                    title: Text(s.name),
                    subtitle: Text(
                      'Adm: ${s.admNo} • $sync${captured ? (absent ? ' • absent' : ' • captured') : ''}',
                    ),
                    trailing: IconButton(
                      tooltip: 'Capture photo',
                      onPressed: session == null
                          ? null
                          : () async {
                              await _captureSequence(
                                startIndex: index,
                                session: session,
                              );
                            },
                      icon: const Icon(Icons.photo_camera_outlined),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
