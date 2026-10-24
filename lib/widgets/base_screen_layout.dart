// File: lib/widgets/base_screen_layout.dart
import 'package:flutter/material.dart';

abstract class BaseScreenLayout<T> extends StatelessWidget {
  const BaseScreenLayout({super.key});

  String get screenTitle;
  IconData get screenIcon;
  T get screenData;

  // Nhãn gợi ý thao tác trên khối chữ nhật đầu trang
  String get headerActionLabel => 'Chạm để tùy chỉnh';

  List<Widget>? buildAppBarActions(BuildContext context) => null;

  Widget buildHeaderContent(BuildContext context, T data);

  // Hàm xử lý khi người dùng bấm vào khối hình chữ nhật ở đầu mỗi trang
  void onHeaderTap(BuildContext context, T data);

  Widget buildMainContent(BuildContext context, T data);

  Widget buildGenericItemCard<E>({
    required E item,
    required IconData leadingIcon,
    required String title,
    required String subtitle,
    required String trailingText,
    VoidCallback? onTap,
    Widget? trailingWidget,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.teal.withValues(alpha: 0.12),
          child: Icon(leadingIcon, color: Colors.teal),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(subtitle, style: const TextStyle(fontSize: 13)),
        ),
        trailing: trailingWidget ??
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                trailingText,
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final T data = screenData;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(screenIcon, color: Colors.white),
        title: Text(
          screenTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: buildAppBarActions(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Khối chữ nhật đầu trang (Header Banner) có InkWell bắt sự kiện onTap
            Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () => onHeaderTap(context, data),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal.shade800, Colors.teal.shade500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildHeaderContent(context, data),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.touch_app,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      headerActionLabel,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: -15,
                      top: -15,
                      child: Icon(
                        screenIcon,
                        size: 100,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            buildMainContent(context, data),
          ],
        ),
      ),
    );
  }
}