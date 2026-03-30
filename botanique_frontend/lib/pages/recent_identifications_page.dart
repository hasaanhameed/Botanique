import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/identification_service.dart';
import '../notifiers/auth_notifier.dart';
import 'plant_result_page.dart';

class RecentIdentificationsPage extends StatefulWidget {
  final AuthNotifier? authNotifier;
  const RecentIdentificationsPage({super.key, this.authNotifier});

  @override
  State<RecentIdentificationsPage> createState() =>
      _RecentIdentificationsPageState();
}

class _RecentIdentificationsPageState
    extends State<RecentIdentificationsPage> {
  List<dynamic> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final token = widget.authNotifier?.token;
    if (token == null) {
      setState(() => _isLoading = false);
      return;
    }

    final history = await IdentificationService.getHistory(token);
    if (mounted) {
      setState(() {
        _history = history;
        _isLoading = false;
      });
    }
  }

  Uint8List? _decodeImage(String? base64Str) {
    if (base64Str == null || base64Str.isEmpty) return null;
    try {
      return base64Decode(base64Str);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Recent Identifications',
          style: TextStyle(
            fontFamily: 'Raleway',
            color: cs.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: cs.primary))
          : _history.isEmpty
              ? Center(
                  child: Text(
                    'No identifications yet.',
                    style: TextStyle(
                      color: cs.secondary,
                      fontFamily: 'Raleway',
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final plant = _history[index];
                    final dateStr = plant['created_at'] != null
                        ? plant['created_at'].toString().split('T')[0]
                        : 'Unknown Date';

                    final imageBytes = _decodeImage(plant['image_base64']);

                    return Card(
                      color: cs.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: cs.primary.withValues(alpha: 0.3)),
                      ),
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlantResultPage(
                                plantData: plant,
                                imageBytes: imageBytes,
                              ),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.all(16.0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imageBytes != null
                              ? Image.memory(
                                  imageBytes,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.local_florist,
                                  color: cs.primary,
                                  size: 40,
                                ),
                        ),
                        title: Text(
                          plant['plant_name'] ?? 'Unknown Plant',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              dateStr,
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 13,
                                color: cs.secondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              plant['description'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 14,
                                color: cs.secondary,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.chevron_right, color: cs.primary),
                      ),
                    );
                  },
                ),
    );
  }
}
