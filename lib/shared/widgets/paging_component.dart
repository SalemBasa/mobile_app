import 'package:flutter/material.dart';

class PagingComponent extends StatelessWidget {
  final int itemsPerPage;
  final int totalRecords;
  final int currentPage;
  final Function(int) onPageChange;

  PagingComponent({
    required this.itemsPerPage,
    required this.totalRecords,
    required this.currentPage,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    final pageNumbers = List.generate(
      (totalRecords / itemsPerPage).ceil(),
      (index) => index + 1,
    );

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Page $currentPage of ${pageNumbers.length}'),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.navigate_before),
                onPressed: currentPage > 1 ? () => onPageChange(currentPage - 1) : null,
              ),
              for (int page in pageNumbers)
                TextButton(
                  onPressed: () => onPageChange(page),
                  child: Text(
                    page.toString(),
                    style: TextStyle(
                      color: currentPage == page ? Colors.blue : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: currentPage < pageNumbers.length ? () => onPageChange(currentPage + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
