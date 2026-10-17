import 'package:flutter/material.dart';

abstract class BaseScreenLayout<T> extends StatelessWidget {
  const BaseScreenLayout({super.key});

  // Các thuộc tính và phương thức bắt buộc lớp con (Screen) phải định nghĩa khi kế thừa
  String get screenTitle;
  IconData get screenIcon;
  T get screenData;

  // Xây dựng phần tóm tắt đầu trang dựa trên kiểu dữ liệu Generic T
  Widget buildHeaderContent(BuildContext context, T data);

  // Xây dựng nội dung chính của trang dựa trên kiểu dữ liệu Generic T
  Widget buildMainContent(BuildContext context, T data);

  // Generic method hỗ trợ tạo nhanh thẻ thông tin (Card + ListTile) dùng chung cho các màn hình
  Widget buildGenericItemCard<E>({
    required E item,
    required IconData leadingIcon,
    required String title,
    required String subtitle,
    required String trailingText,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade50,
          child: Icon(leadingIcon, color: Colors.teal),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Text(
          trailingText,
          style: const TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final T data = screenData;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: Icon(screenIcon, color: Colors.white),
        title: Text(
          screenTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Khối Header chung cho mọi màn hình
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: buildHeaderContent(context, data),
            ),
            const SizedBox(height: 16),
            // Khối Nội dung chính của từng màn hình
            buildMainContent(context, data),
          ],
        ),
      ),
    );
  }
}