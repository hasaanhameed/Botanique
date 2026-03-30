import 'dart:typed_data';
import 'package:flutter/material.dart';

class PlantResultPage extends StatelessWidget {
  final Map<String, dynamic> plantData;
  final Uint8List? imageBytes;

  const PlantResultPage({super.key, required this.plantData, this.imageBytes});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Support both 'name' (from fresh identification) and 'plant_name' (from DB history)
    final plantName =
        plantData['name'] ?? plantData['plant_name'] ?? 'Unknown Plant';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Identification Result',
          style: TextStyle(
            fontFamily: 'Raleway',
            color: cs.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.5)),
                  image: imageBytes != null
                      ? DecorationImage(
                          image: MemoryImage(imageBytes!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imageBytes == null
                    ? Center(
                        child: Icon(
                          Icons.energy_savings_leaf,
                          size: 80,
                          color: cs.primary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 24),

              // Plant Name
              Text(
                'Common Name',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: cs.secondary,
                ),
              ),
              Text(
                plantName,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),

              if (plantData['scientific_name'] != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Scientific Name',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: cs.secondary,
                  ),
                ),
                Text(
                  plantData['scientific_name'],
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface.withValues(alpha: 0.9),
                  ),
                ),
              ],
              const SizedBox(height: 12),

              // Description
              Text(
                plantData['description'] ?? 'No description available.',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 16,
                  height: 1.5,
                  color: cs.secondary,
                ),
              ),
              const SizedBox(height: 24),

              // Growth Environment
              Text(
                'Best Growth Environment',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              _buildEnvDetail(context, Icons.water_drop, 'Water',
                  plantData['water'] ?? 'N/A'),
              const SizedBox(height: 12),
              _buildEnvDetail(context, Icons.wb_sunny, 'Light',
                  plantData['light'] ?? 'N/A'),
              const SizedBox(height: 12),
              _buildEnvDetail(context, Icons.thermostat, 'Temperature',
                  plantData['temperature'] ?? 'N/A'),
              const SizedBox(height: 12),
              _buildEnvDetail(context, Icons.calendar_month, 'Season',
                  plantData['season'] ?? 'N/A'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnvDetail(
      BuildContext context, IconData icon, String title, String value) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: cs.primary, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 14,
                  height: 1.4,
                  color: cs.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
