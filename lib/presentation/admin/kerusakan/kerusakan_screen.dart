import 'package:damagereports/data/model/response/kerusakan_admin_response_model.dart';
import 'package:damagereports/data/model/response/project_response_model.dart';
import 'package:damagereports/presentation/admin/kerusakan/bloc/kerusakan_admin_bloc.dart';
import 'package:damagereports/presentation/admin/project/bloc/project_bloc.dart';
import 'package:damagereports/presentation/admin/kerusakan/kerusakan_detail_screen.dart';
import 'package:damagereports/presentation/teknisi_pic/kerusakan/date_range.dart';
import 'package:damagereports/service/pdf/kerusakan_pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class KerusakanScreen extends StatefulWidget {
  const KerusakanScreen({super.key});

  @override
  State<KerusakanScreen> createState() => _KerusakanScreenState();
}

class _KerusakanScreenState extends State<KerusakanScreen> with RouteAware {
  String selectedStatus = 'Pending';
  DateTimeRange? selectedDateRange;
  String selectedProject = 'Semua';
  int? selectedProjectId;
  final dateFormat = DateFormat('dd-MM-yyyy');

  int currentPage = 1;
  int itemsPerPage = 5;

  String formatTanggal(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) return '-';
    try {
      final dt = DateTime.parse(tanggal);
      return dateFormat.format(dt);
    } catch (e) {
      return tanggal;
    }
  }

  final List<String> statusOptions = [
    'Semua',
    'Pending',
    'Diperbaiki',
    'Selesai',
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(ProjectRequested());
    _loadData();
  }

  void _loadData() {
    context.read<KerusakanAdminBloc>().add(
      KerusakanAdminRequested(
        idProject: selectedProjectId,
        status:
            selectedStatus.toLowerCase() == 'semua'
                ? null
                : selectedStatus.toLowerCase(),
        startDate: selectedDateRange?.start,
        endDate: selectedDateRange?.end,
      ),
    );
  }

  void _pickDateRange() async {
    final range = await showCustomCupertinoDateRangePicker(
      context: context,
      currentRange: selectedDateRange,
    );

    if (!mounted) return;
    setState(() {
      selectedDateRange = range;
    });

    _loadData();
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
                      "Daftar Kerusakan",
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
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              BlocBuilder<ProjectBloc, ProjectState>(
                                builder: (context, state) {
                                  if (state is ProjectLoaded) {
                                    final List<DataProject> projects =
                                        state.listProject;

                                    final List<DataProject?> projectOptions = [
                                      null, // untuk "Semua"
                                      ...projects,
                                    ];

                                    return Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFF003D7A),
                                            width: 1,
                                          ),
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children:
                                                projectOptions.asMap().entries.map((
                                                  entry,
                                                ) {
                                                  final index = entry.key;
                                                  final project = entry.value;

                                                  final title =
                                                      project == null
                                                          ? "Semua"
                                                          : project.namaProject;

                                                  final isSelected =
                                                      selectedProject == title;

                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedProject = title;
                                                        selectedProjectId =
                                                            project?.idProject;
                                                      });

                                                      _loadData();
                                                    },
                                                    child: Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                            minWidth: 90,
                                                          ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            isSelected
                                                                ? const Color(
                                                                  0xFF002F87,
                                                                )
                                                                : Colors
                                                                    .transparent,
                                                        borderRadius: BorderRadius.only(
                                                          topLeft:
                                                              index == 0
                                                                  ? const Radius.circular(
                                                                    12,
                                                                  )
                                                                  : Radius.zero,
                                                          bottomLeft:
                                                              index == 0
                                                                  ? const Radius.circular(
                                                                    12,
                                                                  )
                                                                  : Radius.zero,
                                                          topRight:
                                                              index ==
                                                                      projectOptions
                                                                              .length -
                                                                          1
                                                                  ? const Radius.circular(
                                                                    12,
                                                                  )
                                                                  : Radius.zero,
                                                          bottomRight:
                                                              index ==
                                                                      projectOptions
                                                                              .length -
                                                                          1
                                                                  ? const Radius.circular(
                                                                    12,
                                                                  )
                                                                  : Radius.zero,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          title,
                                                          style: TextStyle(
                                                            color:
                                                                isSelected
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  if (state is ProjectLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  return const SizedBox();
                                },
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Color(0xFF003D7A),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children:
                                            statusOptions.asMap().entries.map((
                                              entry,
                                            ) {
                                              final index = entry.key;
                                              final status = entry.value;
                                              final isSelected =
                                                  selectedStatus == status;
                                              return Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedStatus = status;
                                                    });

                                                    _loadData();
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 8,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          isSelected
                                                              ? Color(
                                                                0xFF002F87,
                                                              )
                                                              : Colors
                                                                  .transparent,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft:
                                                            index == 0
                                                                ? const Radius.circular(
                                                                  12,
                                                                )
                                                                : Radius.zero,
                                                        bottomLeft:
                                                            index == 0
                                                                ? const Radius.circular(
                                                                  12,
                                                                )
                                                                : Radius.zero,
                                                        topRight:
                                                            index ==
                                                                    statusOptions
                                                                            .length -
                                                                        1
                                                                ? const Radius.circular(
                                                                  12,
                                                                )
                                                                : Radius.zero,
                                                        bottomRight:
                                                            index ==
                                                                    statusOptions
                                                                            .length -
                                                                        1
                                                                ? const Radius.circular(
                                                                  12,
                                                                )
                                                                : Radius.zero,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        status,
                                                        style: TextStyle(
                                                          color:
                                                              isSelected
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: BlocBuilder<
                                  KerusakanAdminBloc,
                                  KerusakanAdminState
                                >(
                                  builder: (context, state) {
                                    if (state is KerusakanAdminLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF002F87),
                                        ),
                                      );
                                    } else if (state is KerusakanAdminFailure) {
                                      return Center(
                                        child: Text(
                                          'Gagal memuat data: ${state.error}',
                                        ),
                                      );
                                    } else if (state is KerusakanAdminLoaded) {
                                      final kerusakanList =
                                          state.listKerusakanAdmin;
                                      final totalKerusakan =
                                          state.totalKerusakan;
                                      final totalPerbaikan =
                                          state.totalPerbaikan;
                                      final totalSelesai = state.totalSelesai;

                                      List<KerusakanAdmin> filteredList =
                                          kerusakanList;
                                      if (selectedDateRange == null) {
                                        final now = DateTime.now();
                                        final weekAgo = now.subtract(const Duration(days: 7));

                                        filteredList = kerusakanList.where((k) {
                                          if (k.tanggal == null || k.tanggal!.isEmpty) {
                                            return false;
                                          }

                                          try {
                                            final tgl = DateTime.parse(k.tanggal!);

                                            return tgl.isAfter(
                                                  weekAgo.subtract(const Duration(seconds: 1)),
                                                ) &&
                                                tgl.isBefore(
                                                  now.add(const Duration(days: 1)),
                                                );
                                          } catch (_) {
                                            return false;
                                          }
                                        }).toList();
                                      }
                                      final totalPages =
                                          (filteredList.length / itemsPerPage)
                                              .ceil()
                                              .clamp(1, double.infinity)
                                              .toInt();
                                      currentPage = currentPage.clamp(
                                        1,
                                        totalPages,
                                      );

                                      final startIndex = ((currentPage - 1) *
                                              itemsPerPage)
                                          .clamp(0, filteredList.length);
                                      final endIndex = (startIndex +
                                              itemsPerPage)
                                          .clamp(0, filteredList.length);
                                      final pagedList = filteredList.sublist(
                                        startIndex,
                                        endIndex,
                                      );

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFFA64D),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                        "Total Kerusakan",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        "$totalKerusakan",
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF5C9DFF),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                        "Proses Perbaikan",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        "$totalPerbaikan",
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF1A6FE8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                        "Total Selesai",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        "$totalSelesai",
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),

                                          Row(
                                            children: [
                                              Text(
                                                "Jumlah: ${filteredList.length}",
                                                style: const TextStyle(
                                                  color: Color(0xFF002F87),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Spacer(),
                                              InkWell(
                                                onTap: _pickDateRange,
                                                child: Container(
                                                  width: 180,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 6,
                                                        horizontal: 12,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF002F87),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    border: Border.all(
                                                      color: Color(0xFF002F87),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    selectedDateRange != null
                                                        ? "${dateFormat.format(selectedDateRange!.start)} s/d ${dateFormat.format(selectedDateRange!.end)}"
                                                        : "Pilih Tanggal",
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFF002F87),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              minimumSize: Size(70, 35)
                                            ),
                                            onPressed: () {
                                              KerusakanPdfService.export(
                                                data: filteredList,
                                                project: selectedProject,
                                                status: selectedStatus,
                                                dateRange: selectedDateRange,
                                              );
                                            },
                                            child: const Text(
                                              "PDF",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Expanded(
                                            child:
                                                filteredList.isEmpty
                                                    ? const Center(
                                                      child: Text(
                                                        'Tidak ada kerusakan dalam seminggu',
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF002F87,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    : ListView.separated(
                                                      itemCount:
                                                          pagedList.length,
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const SizedBox(
                                                                height: 16,
                                                              ),
                                                      itemBuilder: (
                                                        context,
                                                        index,
                                                      ) {
                                                        final kerusakan =
                                                            pagedList[index];
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) => KerusakanDetailScreen(
                                                                      kerusakan:
                                                                          kerusakan,
                                                                    ),
                                                              ),
                                                            );
                                                          },

                                                          child: Stack(
                                                            clipBehavior:
                                                                Clip.none,
                                                            children: [
                                                              Positioned(
                                                                bottom: 1,
                                                                left: 0,
                                                                right: 0,
                                                                child: Container(
                                                                  height: 70,
                                                                  decoration: BoxDecoration(
                                                                    color: Color(
                                                                      0xFF002F87,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          14,
                                                                        ),
                                                                  ),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(
                                                                        bottom:
                                                                            4,
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          const SizedBox(
                                                                            width:
                                                                                16,
                                                                          ),
                                                                          Text(
                                                                            kerusakan.status,
                                                                            style: TextStyle(
                                                                              fontSize:
                                                                                  12,
                                                                              color:
                                                                                  kerusakan.status.toLowerCase() ==
                                                                                          'pending'
                                                                                      ? const Color.fromARGB(
                                                                                        255,
                                                                                        247,
                                                                                        165,
                                                                                        165,
                                                                                      )
                                                                                      : kerusakan.status.toLowerCase() ==
                                                                                          'diperbaiki'
                                                                                      ? const Color.fromARGB(
                                                                                        255,
                                                                                        123,
                                                                                        209,
                                                                                        249,
                                                                                      )
                                                                                      : const Color.fromARGB(
                                                                                        255,
                                                                                        114,
                                                                                        245,
                                                                                        118,
                                                                                      ),
                                                                              fontWeight:
                                                                                  FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          const Spacer(),
                                                                          const Icon(
                                                                            Icons.arrow_forward,
                                                                            size:
                                                                                24,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                16,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets.only(
                                                                      bottom:
                                                                          32,
                                                                    ),
                                                                padding:
                                                                    const EdgeInsets.all(
                                                                      3,
                                                                    ),
                                                                decoration: const BoxDecoration(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  borderRadius: BorderRadius.only(
                                                                    topLeft:
                                                                        Radius.circular(
                                                                          14,
                                                                        ),
                                                                    topRight:
                                                                        Radius.circular(
                                                                          14,
                                                                        ),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width: 12,
                                                                    ),
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(
                                                                          top:
                                                                              7,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              kerusakan.fasilitas ??
                                                                                  '',
                                                                              style: const TextStyle(
                                                                                fontSize:
                                                                                    12,
                                                                                fontWeight:
                                                                                    FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height:
                                                                                  2,
                                                                            ),
                                                                            Text(
                                                                              kerusakan.lokasi ??
                                                                                  '-',
                                                                              style: const TextStyle(
                                                                                fontSize:
                                                                                    12,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(
                                                                        right:
                                                                            10,
                                                                      ),
                                                                      child: Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.date_range_rounded,
                                                                                size:
                                                                                    18,
                                                                              ),
                                                                              SizedBox(
                                                                                width:
                                                                                    5,
                                                                              ),
                                                                              Text(
                                                                                formatTanggal(
                                                                                  kerusakan.tanggal,
                                                                                ),
                                                                                style: const TextStyle(
                                                                                  fontSize:
                                                                                      12,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                          ),
                                          const SizedBox(height: 10),
                                          if (totalPages > 1)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed:
                                                      currentPage > 1
                                                          ? () => setState(
                                                            () => currentPage--,
                                                          )
                                                          : null,
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor: Color(
                                                      0xFF003C97,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Text("Prev"),
                                                ),
                                                const SizedBox(width: 70),
                                                Text(
                                                  "$currentPage / $totalPages",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 70),
                                                ElevatedButton(
                                                  onPressed:
                                                      currentPage < totalPages
                                                          ? () => setState(
                                                            () => currentPage++,
                                                          )
                                                          : null,
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor: Color(
                                                      0xFF003C97,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Text("Next"),
                                                ),
                                              ],
                                            ),
                                          const SizedBox(height: 30),
                                        ],
                                      );
                                    }
                                    return const Center(
                                      child: Text(
                                        "Halaman Kerusakan",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
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
