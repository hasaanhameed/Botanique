import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import '../services/plant_service.dart';
import 'plant_result_page.dart';
import '../notifiers/auth_notifier.dart';
import 'recent_identifications_page.dart';

class DashboardPage extends StatefulWidget {
  final AuthNotifier? authNotifier;
  const DashboardPage({super.key, this.authNotifier});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndIdentify(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return;

    if (!mounted) return;

    final cs = Theme.of(context).colorScheme;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: cs.primary),
              const SizedBox(height: 15),
              Text(
                'Identifying plant...',
                style: TextStyle(
                  color: cs.primary,
                  fontFamily: 'Raleway',
                  decoration: TextDecoration.none,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final result = await PlantService.identifyPlant(
      image,
      authToken: widget.authNotifier?.token,
    );

    if (!mounted) return;
    Navigator.pop(context); // Dismiss loading dialog

    if (result != null && result['error'] == null) {
      final bytes = await image.readAsBytes();
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PlantResultPage(plantData: result, imageBytes: bytes),
        ),
      );
    } else {
      String message = 'Failed to identify plant. Please try again.';
      if (result != null && result['error'] == 'rate_limit') {
        message = 'Rate limit reached: 5 identifications per hour allowed.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  void _showAddPhotoOptions() {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final innerCs = Theme.of(context).colorScheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library, color: innerCs.primary),
                  title: Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: innerCs.onSurface,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndIdentify(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: innerCs.primary),
                  title: Text(
                    'Take a Picture',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: innerCs.onSurface,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndIdentify(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _showAddPhotoOptions,
                  child: DottedBorder(
                    strokeWidth: 2,
                    dashPattern: const [8, 4],
                    borderType: BorderType.RRect,
                    color: cs.primary,
                    radius: const Radius.circular(10),
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 40, color: cs.primary),
                          const SizedBox(height: 10),
                          Text(
                            'Upload Plant Image',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Snap a photo to learn about any plant species",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14,
                    color: cs.secondary,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecentIdentificationsPage(
                          authNotifier: widget.authNotifier,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Recent Identifications',
                    style: TextStyle(fontFamily: 'Raleway', fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
