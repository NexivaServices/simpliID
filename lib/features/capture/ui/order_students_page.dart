import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/models.dart';
import '../providers/capture_providers.dart';
import 'capture_photo_flow.dart';

class OrderStudentsPage extends HookConsumerWidget {
  const OrderStudentsPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final students = useState<List<CaptureStudent>>([]);
    final loading = useState(true);
    final loadingMore = useState(false);
    final hasMore = useState(true);
    final page = useState(1);
    final pageSize = useState(50);
    final total = useState(0);
    final error = useState<Object?>(null);

    Future<void> loadFirstPage() async {
      loading.value = true;
      error.value = null;
      students.value = [];
      page.value = 1;
      hasMore.value = true;
      total.value = 0;

      try {
        final repo = ref.read(captureOrdersRepositoryProvider);
        final response = await repo.fetchStudentsPage(
          orderId: orderId,
          online: ref.read(isOnlineProvider),
          page: 1,
          pageSize: pageSize.value,
        );

        students.value = response.students;
        page.value = response.page;
        pageSize.value = response.pageSize;
        total.value = response.totalStudents;
        hasMore.value = response.page * response.pageSize < response.totalStudents;
        loading.value = false;
      } catch (e) {
        error.value = e;
        loading.value = false;
      }
    }

    Future<void> loadMore() async {
      if (loading.value || loadingMore.value || !hasMore.value) return;

      loadingMore.value = true;
      error.value = null;

      try {
        final repo = ref.read(captureOrdersRepositoryProvider);
        final nextPage = page.value + 1;
        final response = await repo.fetchStudentsPage(
          orderId: orderId,
          online: ref.read(isOnlineProvider),
          page: nextPage,
          pageSize: pageSize.value,
        );

        students.value = [...students.value, ...response.students];
        page.value = response.page;
        pageSize.value = response.pageSize;
        total.value = response.totalStudents;
        hasMore.value = response.page * response.pageSize < response.totalStudents;
        loadingMore.value = false;
      } catch (e) {
        error.value = e;
        loadingMore.value = false;
      }
    }

    void onScroll() {
      final position = scrollController.position;
      if (!position.hasPixels || !position.hasContentDimensions) return;
      if (position.pixels >= position.maxScrollExtent - 400) {
        loadMore();
      }
    }

    useEffect(() {
      scrollController.addListener(onScroll);
      loadFirstPage();
      return () => scrollController.removeListener(onScroll);
    }, []);

    Future<void> captureSequence({
      required int startIndex,
      required Session session,
    }) async {
      final repo = ref.read(captureOrdersRepositoryProvider);

      var index = startIndex;
      while (true) {
        if (index >= students.value.length) {
          if (hasMore.value) {
            await loadMore();
            continue;
          }
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reached end of loaded students.')),
            );
          }
          return;
        }

        final s = students.value[index];

        final isAbsent = (s.details['absent'] == true);
        if (s.captureTimestamp != null || isAbsent) {
          index++;
          continue;
        }

        if (!context.mounted) return;

        final res = await context.push(
          '/order/$orderId/student/${s.studentId}/capture',
          extra: {
            'studentName': s.name,
            'studentAdmNo': s.admNo,
          },
        );

        if (res == null || !context.mounted) return;
        
        final result = res is CapturePhotoResult ? res : null;
        if (result == null) return;

        final CaptureStudent updated;
        if (result.absent) {
          updated = await repo.markAbsent(
            orderId: orderId,
            studentId: s.studentId,
            editedBy: session.userId,
          );
        } else {
          updated = await repo.markCapturedWithLocalPhotos(
            orderId: orderId,
            studentId: s.studentId,
            editedBy: session.userId,
            localHighResPath: result.highResPath,
            localThumbnailPath: result.thumbnailPath,
            crop: result.crop,
          );
        }

        if (!context.mounted) return;
        final updatedList = [...students.value];
        updatedList[index] = updated;
        students.value = updatedList;

        await scrollController.animateTo(
          (index + 1) * 72.0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );

        index++;
      }
    }

    final sessionData = ref.watch(sessionProvider);
    final onlineStatus = ref.watch(isOnlineProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students ($orderId)${total.value > 0 ? ' • ${total.value}' : ''}',
        ),
        actions: [
          IconButton(
            tooltip: 'Sync next 10',
            onPressed: (!onlineStatus || sessionData == null)
                ? null
                : () async {
                    final res = await ref
                        .read(captureSyncRepositoryProvider)
                        .syncNextChunk(
                          orderId: orderId,
                          editedBy: sessionData.userId,
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
                    await loadFirstPage();
                  },
            icon: const Icon(Icons.cloud_upload_outlined),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: loadFirstPage,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/order/$orderId/add-student');
          await loadFirstPage();
        },
        child: const Icon(Icons.person_add_alt_1),
      ),
      body: loading.value
          ? const Center(child: CircularProgressIndicator())
          : error.value != null
              ? Center(child: Text('Error: ${error.value}'))
              : RefreshIndicator(
                  onRefresh: loadFirstPage,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: students.value.length + 1,
                    itemBuilder: (context, index) {
                      if (index == students.value.length) {
                        if (!hasMore.value) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: Text('No more students.')),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: loadingMore.value
                                ? const CircularProgressIndicator.adaptive()
                                : const SizedBox.shrink(),
                          ),
                        );
                      }

                      final s = students.value[index];
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
                          onPressed: sessionData == null
                              ? null
                              : () async {
                                  await captureSequence(
                                    startIndex: index,
                                    session: sessionData,
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
