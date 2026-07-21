import 'dart:async';
import 'dart:io';

import 'package:damagereports/data/model/response/kerusakan_response_model.dart';
import 'package:damagereports/data/repository/kerusakan_repository.dart';
import 'package:damagereports/presentation/teknisi_pic/bloc/kerusakan/kerusakan_bloc.dart';
import 'package:damagereports/presentation/teknisi_pic/home/teknisi_pic_screen.dart';
import 'package:damagereports/presentation/teknisi_pic/kerusakan/lapor_perbaikan_screen.dart';
import 'package:damagereports/service/service_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class KerusakanDetailScreen extends StatefulWidget {
  final Kerusakan kerusakan;

  const KerusakanDetailScreen({super.key, required this.kerusakan});

  @override
  State<KerusakanDetailScreen> createState() => _KerusakanDetailScreenState();
}

class _KerusakanDetailScreenState extends State<KerusakanDetailScreen> {
  final GlobalKey _cardKey = GlobalKey();
  double _cardHeight = 160;

  final dateFormat = DateFormat('dd-MM-yyyy');
  late String currentStatus;
  final KerusakanRepository repository = KerusakanRepository(
    ServiceHttpClient(),
  );

  @override
  void initState() {
    super.initState();

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
        child: Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF003C97), Color(0xFF0056D6)],
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
                    colors: [Color(0xFF7A8FB1), Color(0xFFE7EBFF)],
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
                                      if (widget.kerusakan.fotoKerusakan !=
                                              null &&
                                          widget
                                              .kerusakan
                                              .fotoKerusakan!
                                              .isNotEmpty) {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (_) => Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                insetPadding: EdgeInsets.zero,
                                                child: GestureDetector(
                                                  onTap:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  child: InteractiveViewer(
                                                    child: Image.network(
                                                      widget
                                                          .kerusakan
                                                          .fotoKerusakan!,
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
                                Text(
                                  "Foto Kerusakan",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF002C5A),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (widget.kerusakan.fotoPerbaikan !=
                                              null &&
                                          widget
                                              .kerusakan
                                              .fotoPerbaikan!
                                              .isNotEmpty) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Foto perbaikan sudah diunggah. Tidak bisa mengambil ulang foto.',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              backgroundColor: Colors.white,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          );
                                        }
                                        return;
                                      }

                                      showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                        ),
                                        builder:
                                            (context) => Wrap(
                                              children: [
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.camera_alt,
                                                  ),
                                                  title: Text('Camera'),
                                                  onTap: () async {
                                                    final picker =
                                                        ImagePicker();
                                                    final pickedFile =
                                                        await picker.pickImage(
                                                          source:
                                                              ImageSource
                                                                  .camera,
                                                        );

                                                    if (!mounted) return;

                                                    if (pickedFile != null) {
                                                      final file = File(
                                                        pickedFile.path,
                                                      );
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (
                                                                _,
                                                              ) => LaporPerbaikanScreen(
                                                                foto: file,
                                                                kerusakanId:
                                                                    widget
                                                                        .kerusakan
                                                                        .idKerusakan,
                                                              ),
                                                        ),
                                                      );
                                                    } else {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                ),
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.photo_library,
                                                  ),
                                                  title: Text('Gallery'),
                                                  onTap: () async {
                                                    final picker =
                                                        ImagePicker();
                                                    final pickedFile =
                                                        await picker.pickImage(
                                                          source:
                                                              ImageSource
                                                                  .gallery,
                                                        );

                                                    if (!mounted) return;

                                                    if (pickedFile != null) {
                                                      final file = File(
                                                        pickedFile.path,
                                                      );
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (
                                                                _,
                                                              ) => LaporPerbaikanScreen(
                                                                foto: file,
                                                                kerusakanId:
                                                                    widget
                                                                        .kerusakan
                                                                        .idKerusakan,
                                                              ),
                                                        ),
                                                      );
                                                    } else {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        color: Colors.grey[200],
                                        child:
                                            widget.kerusakan.fotoPerbaikan !=
                                                        null &&
                                                    widget
                                                        .kerusakan
                                                        .fotoPerbaikan!
                                                        .isNotEmpty
                                                ? Image.network(
                                                  widget
                                                      .kerusakan
                                                      .fotoPerbaikan!,
                                                  fit: BoxFit.cover,
                                                )
                                                : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(
                                                      Icons.camera_alt,
                                                      size: 32,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      "Add Photo",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
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
                                    color: Color(0xFF002C5A),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.kerusakan.fasilitas} - ${widget.kerusakan.lokasi ?? '-'}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF002F87),
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
                                          SizedBox(width: 10),
                                          Text(
                                            formatTanggal(
                                              widget.kerusakan.tanggal,
                                            ),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
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
                                          SizedBox(width: 10),
                                          Text(
                                            "${widget.kerusakan.user ?? '-'} - ${widget.kerusakan.role ?? '-'}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
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
                                          color: _warnaStatus(
                                            widget.kerusakan.status,
                                          ).withAlpha(51),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          widget.kerusakan.status,
                                          style: TextStyle(
                                            color: _warnaStatus(
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
                                            interactionOptions:
                                                const InteractionOptions(
                                                  flags: InteractiveFlag.none,
                                                ),
                                          ),
                                          children: [
                                            TileLayer(
                                              urlTemplate:
                                                  "https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}{r}.png",
                                              userAgentPackageName:
                                                  'yusvan.damagereports',
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF002F87),
                              ),
                            ),
                            Text(
                              widget.kerusakan.deskripsi,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (currentStatus.toLowerCase() == 'pending') ...[
                            SizedBox(
                              width: 140,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4FC85C),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  final result = await repository.updateStatus(
                                    widget.kerusakan.idKerusakan,
                                    "diperbaiki",
                                  );
                                  result.fold(
                                    (error) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(24),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Color(
                                                          0xFFFFEBEE,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                  child: const Icon(
                                                    Icons.close_rounded,
                                                    color: Colors.red,
                                                    size: 50,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                const Text(
                                                  "Terjadi Kesalahan",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  "Gagal update status: $error",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 24),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.red,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: const Text(
                                                      "OK",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    (success) {
                                      setState(() {
                                        currentStatus = "diperbaiki";
                                      });
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(24),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                  child: const Icon(
                                                    Icons.check_circle,
                                                    color: Color(0xFF4CD991),
                                                    size: 50,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                const Text(
                                                  "Berhasil",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  success,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 24),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Color(
                                                        0xFF4CD991,
                                                      ),
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                   onPressed: () {
                                                      Navigator.pop(context); // tutup dialog

                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => const TeknisiPicScreen(),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                      "OK",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  "Update Status",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),
                            SizedBox(
                              width: 140,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFAF3536),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<KerusakanBloc>().add(
                                    HapusPesananEvent(
                                      widget.kerusakan.idKerusakan,
                                    ),
                                  );

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const TeknisiPicScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Batalkan",
                                  textAlign: TextAlign.center,
                                ),
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
          ],
        ),
      ),
    );
  }
}

Color _warnaStatus(String status) {
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
