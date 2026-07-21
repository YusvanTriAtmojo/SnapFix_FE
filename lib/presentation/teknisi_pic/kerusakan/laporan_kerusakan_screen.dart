import 'dart:io';
import 'package:damagereports/data/model/request/kerusakan/kerusakan_request_model.dart';
import 'package:damagereports/data/model/response/fasilitas_response_model.dart';
import 'package:damagereports/data/model/response/lokasi_response_model.dart';
import 'package:damagereports/presentation/admin/fasilitas/bloc/fasilitas_bloc.dart';
import 'package:damagereports/presentation/admin/lokasi/bloc/lokasi_bloc.dart';
import 'package:damagereports/presentation/teknisi_pic/bloc/kerusakan/kerusakan_bloc.dart';
import 'package:damagereports/presentation/teknisi_pic/home/teknisi_pic_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class LaporKerusakanScreen extends StatefulWidget {
  final File foto;

  const LaporKerusakanScreen({super.key, required this.foto});

  @override
  State<LaporKerusakanScreen> createState() => _LaporKerusakanScreenState();
}

class _LaporKerusakanScreenState extends State<LaporKerusakanScreen> {
  final _formKey = GlobalKey<FormState>();
  final fasilitasController = TextEditingController();
  final lokasiController = TextEditingController();
  final deskripsiController = TextEditingController();

  double? latKerusakan;
  double? lngKerusakan;
  int? userId;
  List<DataLokasi> hasilLokasi = [];

  DataLokasi? selectedLokasi;

  List<DataFasilitas> hasilFasilitas = [];

  DataFasilitas? selectedFasilitas;

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _loadUserIdDanFetchLokasi();
    _loadUserIdDanFetchFasilitas();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  "Izin lokasi ditolak. Tidak bisa mengambil posisi.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "OK",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> _loadUserIdDanFetchLokasi() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('userId');
    if (storedUserId != null) {
      setState(() => userId = storedUserId);
      context.read<LokasiBloc>().add(LoadLokasiByUserId(userId: storedUserId));
    }
  }

  Future<void> _loadUserIdDanFetchFasilitas() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('userId');
    if (storedUserId != null) {
      setState(() => userId = storedUserId);
      context.read<FasilitasBloc>().add(
        LoadFasilitasByUserId(userId: storedUserId),
      );
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  InputDecoration _fieldDecoration({String? hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xFF003C97), width: 2),
      ),
    );
  }

  void _submit() async {
    if (isSubmitting) return;
    setState(() => isSubmitting = true);

    final position = await _getCurrentLocation();

    if (!mounted) return;

    if (position != null) {
      latKerusakan = position.latitude;
      lngKerusakan = position.longitude;
    }

    if (_formKey.currentState!.validate() &&
        latKerusakan != null &&
        lngKerusakan != null &&
        userId != null &&
        selectedLokasi != null &&
        selectedFasilitas != null) {
      final requestModel = KerusakanRequestModel(
        userId: userId,
        lokasiId: selectedLokasi?.id,
        fasilitasId: selectedFasilitas?.idFasilitas,
        tanggal: DateTime.now().toIso8601String().split('T').first,
        latPosisi: latKerusakan!,
        lngPosisi: lngKerusakan!,
        deskripsi: deskripsiController.text,
        fotoKerusakan: widget.foto.path,
        status: 'pending',
      );

      context.read<KerusakanBloc>().add(
        KerusakanCreateRequested(requestModel: requestModel),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  "Lengkapi semua data terlebih dahulu",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "OK",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
      setState(() => isSubmitting = false);
    }
  }

  @override
  void dispose() {
    fasilitasController.dispose();
    lokasiController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "Lapor Kerusakan",
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
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              widget.foto,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Lokasi",
                            style: TextStyle(color: Color(0xFF003D7A)),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: lokasiController,
                            onChanged: (value) {
                              final state = context.read<LokasiBloc>().state;

                              if (state is LokasiLoadedState) {
                                hasilLokasi =
                                    state.lokasiList.where((lokasi) {
                                      return lokasi.namaLokasi
                                          .toLowerCase()
                                          .contains(value.toLowerCase());
                                    }).toList();
                              }

                              setState(() {});
                            },
                            decoration: _fieldDecoration(
                              hint: "Cari lokasi...",
                              suffix: const Icon(
                                Icons.search,
                                color: Color(0xFF002F87),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Lokasi wajib diisi';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),

                          if (hasilLokasi.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: hasilLokasi.length,
                                itemBuilder: (context, index) {
                                  final lokasi = hasilLokasi[index];

                                  return ListTile(
                                    title: Text(
                                      lokasi.namaLokasi,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedLokasi = lokasi;
                                        lokasiController.text =
                                            lokasi.namaLokasi;
                                        hasilLokasi.clear();
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 16),
                          const Text(
                            "Fasilitas",
                            style: TextStyle(color: Color(0xFF003D7A)),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: fasilitasController,
                            onChanged: (value) {
                              final state = context.read<FasilitasBloc>().state;

                              if (state is FasilitasLoadedState) {
                                hasilFasilitas =
                                    state.fasilitasList.where((fasilitas) {
                                      return fasilitas.namaFasilitas
                                          .toLowerCase()
                                          .contains(value.toLowerCase());
                                    }).toList();
                              }

                              setState(() {});
                            },
                            decoration: _fieldDecoration(
                              hint: "Cari fasilitas...",
                              suffix: const Icon(
                                Icons.search,
                                color: Color(0xFF002F87),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Fasilitas wajib diisi';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),

                          if (hasilFasilitas.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: hasilFasilitas.length,
                                itemBuilder: (context, index) {
                                  final fasilitas = hasilFasilitas[index];

                                  return ListTile(
                                    title: Text(
                                      fasilitas.namaFasilitas,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedFasilitas = fasilitas;
                                        fasilitasController.text =
                                            fasilitas.namaFasilitas;
                                        hasilFasilitas.clear();
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 16),
                          const Text(
                            "Deskripsi",
                            style: TextStyle(color: Color(0xFF003D7A)),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: deskripsiController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: "Deskripsi Kerusakan",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFF003D7A),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFF003D7A),
                                  width: 5,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Deskripsi wajib diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          BlocListener<KerusakanBloc, KerusakanState>(
                            listener: (context, state) async {
                              if (state is KerusakanOperationSuccess) {
                                setState(() => isSubmitting = false);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TeknisiPicScreen(),
                                  ),
                                );
                                await showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      contentPadding: const EdgeInsets.all(24),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: const BoxDecoration(
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
                                            "Laporan Berhasil dikirim",
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
                                                backgroundColor: Color(0xFF4CD991),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: const Text(
                                                "OK",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else if (state is KerusakanFailure) {
                                setState(() => isSubmitting = false);
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      contentPadding: const EdgeInsets.all(24),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFFEBEE),
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
                                            state.error,
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
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: const Text(
                                                "OK",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            child: BlocBuilder<KerusakanBloc, KerusakanState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed:
                                      (state is KerusakanLoading ||
                                              isSubmitting)
                                          ? null
                                          : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF003D7A),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                  ),
                                  child:
                                      (state is KerusakanLoading ||
                                              isSubmitting)
                                          ? const CircularProgressIndicator(
                                            color: Color(0xFF003D7A),
                                          )
                                          : const Text(
                                            "Kirim Laporan",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
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
