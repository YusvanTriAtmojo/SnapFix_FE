import 'package:damagereports/data/model/request/roleakses/roleakses_request_model.dart';
import 'package:damagereports/data/model/response/akses_response_model.dart';
import 'package:damagereports/data/model/response/roleakses_response_model.dart';
import 'package:damagereports/presentation/admin/akses/bloc/akses_bloc.dart';
import 'package:damagereports/presentation/admin/roleakses/bloc/roleakses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleaksesEditScreen extends StatefulWidget {
  final DataRoleAkses roleakses;

  const RoleaksesEditScreen({super.key, required this.roleakses});

  @override
  State<RoleaksesEditScreen> createState() => _RoleaksesEditScreenState();
}

class _RoleaksesEditScreenState extends State<RoleaksesEditScreen> {
  final _formKey = GlobalKey<FormState>();
  List<DataAkses> semuaAkses = [];
  Set<int> selectedAksesIds = {};

  @override
  void initState() {
    super.initState();
    context.read<AksesBloc>().add(AksesRequested());

    selectedAksesIds =
        widget.roleakses.akses.map((e) => e.idAkses).toSet();
  }

  @override
  Widget build(BuildContext context) {
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
                      decoration: const BoxDecoration(
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
                      "Edit Akses Role",
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
            
            // --- BODY ---
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
                  child: BlocConsumer<RoleaksesBloc, RoleaksesState>(
                    listener: (context, state) async {
                      if (state is RoleaksesOperationSuccess) {
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
                                    state.message,
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(context),
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
                        Navigator.pop(context, true);
                      } else if (state is RoleaksesFailure) {
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
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              const Text(
                                "Nama Role",
                                style: TextStyle(
                                    color: Color(0xFF002F87),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              
                              TextFormField(
                                initialValue: widget.roleakses.namaRole,
                                readOnly: true, 
                                enabled: false, 
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: const TextStyle(color: Colors.black54),
                              ),
                              
                              const SizedBox(height: 10),
                              BlocBuilder<AksesBloc, AksesState>(
                                builder: (context, aksesState) {
                                  if (aksesState is AksesLoaded) {
                                    semuaAkses = aksesState.listAkses;

                                    return Column(
                                      children: semuaAkses.map((akses) {

                                        final checked =
                                            selectedAksesIds.contains(akses.idAkses);

                                        return CheckboxListTile(
                                          value: checked,
                                          title: Text(akses.namaAkses),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == true) {
                                                selectedAksesIds.add(akses.idAkses);
                                              } else {
                                                selectedAksesIds.remove(akses.idAkses);
                                              }
                                            });
                                          },
                                        );

                                      }).toList(),
                                    );
                                  }

                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                              const SizedBox(height: 30),
                              
                              // --- BUTTON SIMPAN ---
                              ElevatedButton(
                                onPressed: state is RoleaksesLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                        

                                          final requestModel = RoleAksesRequestModel(
                                            idAkses: selectedAksesIds.toList(),
                                          );
                                          
                                          context.read<RoleaksesBloc>().add(
                                                RoleaksesUpdateRequested(
                                                  id: widget.roleakses.idRole,
                                                  requestModel: requestModel,
                                                ),
                                              );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF003C97),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                child: state is RoleaksesLoading
                                    ? const CircularProgressIndicator(
                                        color: Color(0xFF002F87))
                                    : const Text(
                                        "Simpan Perubahan Akses",
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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