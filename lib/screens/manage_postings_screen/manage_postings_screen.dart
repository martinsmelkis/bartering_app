import 'package:flutter/material.dart';
import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../models/postings/posting_data_response.dart';
import '../../services/api_client.dart';
import '../../services/secure_storage_service.dart';
import '../../theme/app_colors.dart';
import '../user_profile_screen/create_posting_screen.dart';
import 'package:intl/intl.dart';

class ManagePostingsScreen extends StatefulWidget {
  final String userId;

  const ManagePostingsScreen({super.key, required this.userId});

  @override
  State<ManagePostingsScreen> createState() => _ManagePostingsScreenState();
}

class _ManagePostingsScreenState extends State<ManagePostingsScreen> {
  final _apiClient = getIt<ApiClient>();
  List<UserPostingData> _postings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPostings();
  }

  Future<void> _loadPostings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get user's active posting IDs from profile
      final secureStorage = SecureStorageService();
      final userId = await secureStorage.getOwnUserId();
      
      if (userId == null) {
        setState(() {
          _error = "User ID not found";
          _isLoading = false;
        });
        return;
      }

      // Fetch profile to get posting IDs
      final profile = await _apiClient.getProfileInfo(userId);
      final postingIds = profile.activePostingIds ?? [];

      // Fetch each posting
      final postings = <UserPostingData>[];
      for (final id in postingIds) {
        try {
          final posting = await _apiClient.getPostingById(id);
          if (posting != null) {
            postings.add(posting);
          }
        } catch (e) {
          print('Error loading posting $id: $e');
        }
      }

      setState(() {
        _postings = postings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePosting(UserPostingData posting) async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deletePosting),
        content: Text(l10n.deletePostingConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      if (posting.id != null) {
        await _apiClient.deletePosting(posting.id!);
      }
      
      setState(() {
        _postings.remove(posting);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.postingDeleted),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorWithMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _editPosting(UserPostingData posting) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreatePostingScreen(
          existingPosting: posting,
        ),
      ),
    );

    if (result == true) {
      _loadPostings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.managePostings),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPostings,
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                )
              : _postings.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.post_add,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noActivePostings,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadPostings,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _postings.length,
                        itemBuilder: (context, index) {
                          final posting = _postings[index];
                          return _buildPostingCard(posting, l10n);
                        },
                      ),
                    ),
    );
  }

  Widget _buildPostingCard(UserPostingData posting, AppLocalizations l10n) {
    final dateFormat = DateFormat.yMMMd();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with type badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: posting.isOffer ? Colors.green[50] : Colors.blue[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  posting.isOffer ? Icons.sell : Icons.shopping_bag,
                  color: posting.isOffer ? Colors.green : Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  posting.isOffer ? l10n.offer : l10n.need,
                  style: TextStyle(
                    color: posting.isOffer ? Colors.green[700] : Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  dateFormat.format(posting.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  posting.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  posting.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (posting.value != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                      Text(
                        '${posting.value}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                if (posting.expiresAt != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.event, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${l10n.expires}: ${dateFormat.format(posting.expiresAt!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          // Actions
          const Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _editPosting(posting),
                  icon: const Icon(Icons.edit),
                  label: Text(l10n.edit),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _deletePosting(posting),
                  icon: const Icon(Icons.delete),
                  label: Text(l10n.delete),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
