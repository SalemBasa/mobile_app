import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_mobile/features/quiz/models/quiz.dart';
import 'package:trash_track_mobile/features/quiz/screens/quiz_details_screen.dart';
import 'package:trash_track_mobile/features/quiz/services/quiz_service.dart';
import 'package:trash_track_mobile/shared/widgets/paging_component.dart';
import 'package:trash_track_mobile/shared/widgets/table_cell.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({Key? key, this.quiz}) : super(key: key);
  final Quiz? quiz;

  @override
  _QuizzesScreenState createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  late QuizService _quizService;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<Quiz> _quizzes = [];

  String _searchQuery = '';

  int _currentPage = 1;
  int _itemsPerPage = 3;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _quizService = context.read<QuizService>();
    _initialValue = {
      'id': widget.quiz?.id.toString(),
      'title': widget.quiz?.title,
      'description': widget.quiz?.description,
    };

    _loadPagedQuizzes();
  }

  Future<void> _loadPagedQuizzes() async {
    try {
      final models = await _quizService.getPaged(
        filter: {
          'title': _searchQuery,
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _quizzes = models.items;
        _totalRecords = models.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadPagedQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quizzes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Quizzes.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF49464E),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                          _loadPagedQuizzes();
                        },
                        decoration: InputDecoration(
                          labelText: 'Search',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Color(0xFF49464E),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFE0D8E0),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Table(
                border: TableBorder.all(
                  color: Colors.transparent,
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F1FB),
                    ),
                    children: [
                      TableCellWidget(text: 'Title'),
                      TableCellWidget(text: 'Description'),
                    ],
                  ),
                  if (_isLoading)
                    TableRow(
                      children: [
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                      ],
                    )
                  else
                    ..._quizzes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final quiz = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(
                            text: quiz.title ?? '',
                            onTap: () {
                              // Navigate to the QuizDetailsScreen when a quiz is tapped.
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    QuizDetailsScreen(quiz: quiz),
                              ));
                            },
                          ),
                          TableCellWidget(text: quiz.description ?? '')
                        ],
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PagingComponent(
        currentPage: _currentPage,
        itemsPerPage: _itemsPerPage,
        totalRecords: _totalRecords,
        onPageChange: _handlePageChange,
      ),
    );
  }
}
