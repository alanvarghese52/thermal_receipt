import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/dummy models.dart';

class SettingsController extends GetxController {
  final companyNameController = TextEditingController();
  final printCountController = TextEditingController();
  final dividerTextController = TextEditingController();
  final Rx<DropdownModel?> selectedConnectivity = Rx<DropdownModel?>(null);
  final Rx<DropdownModel?> selectedUom = Rx<DropdownModel?>(null);
  final Rx<DropdownModel?> selectedReport = Rx<DropdownModel?>(null);

  final List<DropdownModel> connectivityItems = [
    DropdownModel(id: '0', name: 'Both'),
    DropdownModel(id: '1', name: 'Scale'),
    DropdownModel(id: '2', name: 'Printer'),
  ];

  final List<DropdownModel> uomItems = [
    DropdownModel(id: '0', name: 'KG'),
    DropdownModel(id: '1', name: 'Grams'),
  ];

  final List<DropdownModel> reportItems = [
    DropdownModel(id: '0', name: 'PDF'),
    DropdownModel(id: '1', name: 'CSV'),
  ];

  @override
  void onInit() {
    super.onInit();
    companyNameController.text = 'Coinone Global Solutions';
    printCountController.text = '1';
    dividerTextController.text = '____________';
  }

  void onConnectivityChanged(DropdownModel value) {
    selectedConnectivity.value = value;
  }

  void onUomChanged(DropdownModel value) {
    selectedUom.value = value;
  }

  void onReportChanged(DropdownModel value) {
    selectedReport.value = value;
  }

  @override
  void onClose() {
    companyNameController.dispose();
    printCountController.dispose();
    dividerTextController.dispose();
    super.onClose();
  }
}
