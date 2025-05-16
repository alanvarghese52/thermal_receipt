import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/dummy models.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SettingsView'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Company Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.companyNameController,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: 'company name',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 2),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Connect',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField<DropdownModel>(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Select Item',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                          ),
                          value: controller.selectedConnectivity.value,
                          items:
                              controller.connectivityItems.map((
                                DropdownModel item,
                              ) {
                                return DropdownMenuItem<DropdownModel>(
                                  value: item,
                                  child: Text(item.name),
                                );
                              }).toList(),
                          onChanged: (DropdownModel? newValue) {
                            if (newValue != null) {
                              controller.onConnectivityChanged(newValue);
                            }
                          },
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Please select a value'
                                      : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 2),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Weighing scale',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [Text('HC-05'), Text('00:22:01:00:0A')],
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Printer',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text('Bluetooth Printer'),
                        Text('5A:3R:01:00:34'),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Set Weighing Scale Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Default Unit',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField<DropdownModel>(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Select Uom',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                          ),
                          value: controller.selectedUom.value,
                          items:
                              controller.uomItems.map((DropdownModel item) {
                                return DropdownMenuItem<DropdownModel>(
                                  value: item,
                                  child: Text(item.name),
                                );
                              }).toList(),
                          onChanged: (DropdownModel? newValue) {
                            if (newValue != null) {
                              controller.onUomChanged(newValue);
                            }
                          },
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Please select a value'
                                      : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Set Header, Sub Header & Footer',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Default Print Count',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.printCountController,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: 'print count',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Divider in Print',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.dividerTextController,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: 'divider text',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Report File type',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField<DropdownModel>(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Select Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                          ),
                          value: controller.selectedReport.value,
                          items:
                              controller.reportItems.map((DropdownModel item) {
                                return DropdownMenuItem<DropdownModel>(
                                  value: item,
                                  child: Text(item.name),
                                );
                              }).toList(),
                          onChanged: (DropdownModel? newValue) {
                            if (newValue != null) {
                              controller.onReportChanged(newValue);
                            }
                          },
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Please select a value'
                                      : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 2),
            ],
          ),
        ),
      ),
    );
  }
}
