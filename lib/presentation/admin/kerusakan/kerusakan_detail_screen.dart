import 'dart:async';

import 'package:damagereports/data/model/response/kerusakan_admin_response_model.dart';
import 'package:damagereports/data/repository/kerusakan_repository.dart';
import 'package:damagereports/presentation/admin/admin_screen.dart';
import 'package:damagereports/presentation/admin/kerusakan/bloc/kerusakan_admin_bloc.dart';
import 'package:damagereports/service/service_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class KerusakanDetailScreen extends StatefulWidget {
  final KerusakanAdmin kerusakan;

  const KerusakanDetailScreen({super.key, required this.kerusakan});

  @override
  State<KerusakanDetailScreen> createState() => _KerusakanDetailScreenState();
}

class _KerusakanDetailScreenState extends State<KerusakanDetailScreen> {
  final GlobalKey _cardKey = GlobalKey();
  double _cardHeight = 160;
  Marker? _marker;
  final dateFormat = DateFormat('dd-MM-yyyy');
  late String currentStatus;
  final KerusakanRepository repository = KerusakanRepository(
    ServiceHttpClient(),
  );

  @override
  void initState() {
    super.initState();
    _marker = Marker(
      point: LatLng(
        widget.kerusakan.latPosisi,
        widget.kerusakan.lngPosisi,
      ),
      width: 40,
      height: 40,
      child: const Icon(
        Icons.location_on,
        color: Colors.red,
        size: 40,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateCardHeight());
    currentStatus = widget.kerusakan.status;
  }

    String formatTanggal(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) return '-';
    try {
      final dt = DateTime.parse(tanggal);
      return dateFormat.format(dt); 
    } catch (e) {
      return tanggal;
    }
  }

  void _updateCardHeight() {
    final context = _cardKey.currentContext;
    if (context != null) {
      final newHeight = context.size?.height ?? 160;
      if (newHeight != _cardHeight) {
        setState(() {
          _cardHeight = newHeight;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lat = widget.kerusakan.latPosisi;
    final lng = widget.kerusakan.lngPosisi;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey,
      body: SafeArea(
      child: Column( children: [
      Container(
        height: 60,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF003C97),
              Color(0xFF0056D6),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -30,
              child: Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              right: -60,
              bottom: -60,
              child: Container(
                width: 150,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF7A00),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_circle_left_outlined,
                  color: Colors.white,
                  size: 35,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const Center(
                child: Text(
                  "Detail Kerusakan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7A8FB1), 
                Color(0xFFE7EBFF)
              ],
            ),
          ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (widget.kerusakan.fotoKerusakan != null &&
                                widget.kerusakan.fotoKerusakan!.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder:
                                    (_) => Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: EdgeInsets.zero,
                                      child: GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: InteractiveViewer(
                                          child: Image.network(
                                            widget.kerusakan.fotoKerusakan!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                              );
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.kerusakan.fotoKerusakan ?? "",
                              fit: BoxFit.cover,
                              height: 150,
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    color: Colors.grey,
                                    child: const Icon(Icons.image),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Foto Kerusakan",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF002F87)
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.kerusakan.status == 'selesai')
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (widget.kerusakan.fotoPerbaikan != null &&
                                  widget.kerusakan.fotoPerbaikan!.isNotEmpty) {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: EdgeInsets.zero,
                                        child: GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: InteractiveViewer(
                                            child: Image.network(
                                              widget.kerusakan.fotoPerbaikan!,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                );
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.kerusakan.fotoPerbaikan ?? "",
                                fit: BoxFit.cover,
                                height: 150,
                                errorBuilder:
                                    (_, __, ___) => Container(
                                      color: Colors.grey,
                                      child: const Icon(Icons.image),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Foto Perbaikan",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF002F87)
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.kerusakan.fasilitas} - ${widget.kerusakan.lokasi ?? '-'}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF002F87)
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Divider(
                              color: Color(0xFFFF7A00),
                              thickness: 2,
                            ),
                             Row(
                               children: [
                                const Icon(
                                                                Icons.date_range_rounded,
                                                                size: 17,
                                                                color: Color(0xFFFF7A00),
                                                              ),
                               SizedBox(width: 10,),
                                 Text(
                                  formatTanggal(widget.kerusakan.tanggal),
                                  style: const TextStyle(fontSize: 14),
                                                             ),
                               ],
                             ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                                                Icons.person,
                                                                size: 19,
                                                                color: Color(0xFFFF7A00),
                                                              ),
                               SizedBox(width: 10,),
                                Text(
                                  "${widget.kerusakan.user ?? '-'} - ${widget.kerusakan.role ?? '-'}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  widget.kerusakan.status,
                                ).withAlpha(51),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.kerusakan.status,
                                style: TextStyle(
                                  color: _getStatusColor(
                                    widget.kerusakan.status,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: Stack(
                            children: [
                              FlutterMap(
                                options: MapOptions(
                                  initialCenter: LatLng(lat, lng),
                                  initialZoom: 16,
                                  interactionOptions: const InteractionOptions(
                                    flags: InteractiveFlag.none, 
                                  ),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: "https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}{r}.png",
                                    userAgentPackageName: 'yusvan.damagereports',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(lat, lng),
                                        width: 40,
                                        height: 40,
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Color(0xFFFF7A00),
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      await _bukaGoogleMaps(lat, lng); 
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  const Divider(
                    color: Color(0xFF002F87),
                    thickness: 2,
                  ),
                  Text(
                    "Deskripsi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF002F87)),
                  ),
                  Text(
                    widget.kerusakan.deskripsi,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentStatus.toLowerCase() == 'pending' ||
                  currentStatus.toLowerCase() == 'diperbaiki') ...[
                  const SizedBox(width: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      label: const Text("Hapus"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFAF3536),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<KerusakanAdminBloc>().add(
                          KerusakanAdminDeleted(widget.kerusakan.idKerusakan),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => AdminScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
        ),
      ),
      ]
      ),
      ),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case "pending":
      return Colors.redAccent;
    case "diperbaiki":
      return Colors.blue;
    case "selesai":
      return Colors.green;
    default:
      return Colors.grey;
  }
}

Future<void> _bukaGoogleMaps(double lat, double lng) async {
  final Uri url = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Tidak bisa membuka Google Maps';
  }
}
