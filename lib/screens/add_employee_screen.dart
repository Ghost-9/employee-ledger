import 'package:employee_ledger/common/widgets/date_picker.dart';
import 'package:employee_ledger/utils/colors.dart';
import 'package:employee_ledger/utils/constants.dart';
import 'package:employee_ledger/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/employee_bloc.dart';
import '../blocs/employee_event.dart';
import '../models/employee.dart';

class AddEmployeeScreen extends StatefulWidget {
  final bool isEdit;
  final Employee? employee;

  AddEmployeeScreen({super.key, this.isEdit = false, this.employee}) {
    if (isEdit && employee == null) {
      throw ArgumentError("Employee must be provided when isEdit is true");
    }
  }

  @override
  AddEmployeeScreenState createState() => AddEmployeeScreenState();
}

class AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedRole;
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate;
  int? id;

  @override
  void initState() {
    if (widget.isEdit && widget.employee != null) {
      id = widget.employee!.id;
      _nameController.text = widget.employee!.name;
      _selectedRole = widget.employee!.role;
      _startDate = widget.employee!.startDate;
      _endDate = widget.employee?.endDate;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate() && _selectedRole != null) {
      final newEmployee = Employee(
        name: _nameController.text.trim(),
        role: _selectedRole!,
        startDate: _startDate!,
        endDate: _endDate,
      );
      context.read<EmployeeBloc>().add(AddEmployee(newEmployee));
      Navigator.pop(context);
    }
  }

  void _updateEmployee() {
    if (_formKey.currentState!.validate() && _selectedRole != null) {
      final updatedEmployee = Employee(
        id: id,
        name: _nameController.text.trim(),
        role: _selectedRole!,
        startDate: _startDate!,
        endDate: _endDate,
      );
      context.read<EmployeeBloc>().add(UpdateEmployee(updatedEmployee));
      Navigator.pop(context);
    }
  }

  void _showCustomRoleSelector() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Team Role",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.separated(
                  itemCount: Constants.roles.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 20),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final role = Constants.roles[index];
                    final isSelected = _selectedRole == role;
                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      title: Text(
                        role,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded,
                              color: AppColors.primary, size: 20)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedRole = role;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.isEdit ? "Edit Employee Record" : "Add Employee Record",
        ),
        actions: widget.isEdit
            ? [
                IconButton(
                  tooltip: 'Delete Record',
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: Color(0xFFEF4444)),
                  onPressed: () {
                    context.read<EmployeeBloc>().add(
                          DeleteEmployee(widget.employee!.id!),
                        );
                    Navigator.pop(context);
                    EmployeeUtils.showDeleteSnackbar(
                      id: widget.employee!.id!,
                      context: context,
                    );
                  },
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee Name Field
              TextFormField(
                controller: _nameController,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172A),
                ),
                decoration: const InputDecoration(
                  labelText: "Employee Name",
                  hintText: "e.g. Alexandra Chen",
                  prefixIcon: Icon(Icons.person_outline_rounded,
                      color: AppColors.primary),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? "Please enter employee name"
                        : null,
              ),
              const SizedBox(height: 18),

              // Role Selector Field
              GestureDetector(
                onTap: _showCustomRoleSelector,
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: _selectedRole != null
                        ? TextEditingController(text: _selectedRole)
                        : null,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F172A),
                    ),
                    decoration: const InputDecoration(
                      labelText: "Select Department Role",
                      hintText: "Select role...",
                      prefixIcon: Icon(Icons.work_outline_rounded,
                          color: AppColors.primary),
                      suffixIcon: Icon(Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF64748B)),
                    ),
                    validator: (value) =>
                        _selectedRole == null ? "Please select a role" : null,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Date Timeline Pickers
              const Text(
                "Employment Timeline",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final selectedDate = await showDialog<DateTime>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            insetPadding: const EdgeInsets.all(10),
                            contentPadding: EdgeInsets.zero,
                            titlePadding: EdgeInsets.zero,
                            actionsPadding: EdgeInsets.zero,
                            content: EmployeeDatePicker(
                              mode: DatePickerModeType.startDate,
                              initialDate: _startDate ?? DateTime.now(),
                            ),
                          ),
                        );
                        if (selectedDate != null) {
                          if (_endDate != null && selectedDate.isAfter(_endDate!)) {
                            if (context.mounted) {
                              EmployeeUtils.showSnackbar(
                                context: context,
                                message: "Start date cannot be after end date",
                              );
                            }
                          } else {
                            setState(() => _startDate = selectedDate);
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                size: 18, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Start Date",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF64748B),
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                    _startDate != null
                                        ? DateFormat('d MMM yyyy')
                                            .format(_startDate!)
                                        : "Select Date",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward_rounded,
                      size: 16, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final selectedDate = await showDialog<DateTime>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            insetPadding: const EdgeInsets.all(10),
                            contentPadding: EdgeInsets.zero,
                            titlePadding: EdgeInsets.zero,
                            actionsPadding: EdgeInsets.zero,
                            content: EmployeeDatePicker(
                              mode: DatePickerModeType.endDate,
                              initialDate: _endDate ?? DateTime.now(),
                              startDateConstraint: _startDate,
                            ),
                          ),
                        );
                        setState(() => _endDate = selectedDate);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.event_available_rounded,
                                size: 18, color: Color(0xFF64748B)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("End Date (Optional)",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF64748B),
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                    _endDate != null
                                        ? DateFormat('d MMM yyyy')
                                            .format(_endDate!)
                                        : "Present / Ongoing",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _endDate != null
                                          ? const Color(0xFF0F172A)
                                          : const Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Cancel",
                    style: TextStyle(color: Color(0xFF475569))),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: widget.isEdit ? _updateEmployee : _saveEmployee,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  widget.isEdit ? "Save Changes" : "Create Record",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
