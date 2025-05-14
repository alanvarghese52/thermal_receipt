import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final flutterThermalPrinterPlugin = FlutterThermalPrinter.instance;

  RxList<Printer> printers = <Printer>[].obs;
  RxBool isScanning = false.obs;
  StreamSubscription<List<Printer>>? devicesStreamSubscription;

  // Selected printer
  Rx<Printer?> selectedPrinter = Rx<Printer?>(null);

  @override
  void onInit() {
    super.onInit();
    startScan();
  }

  @override
  void onClose() {
    devicesStreamSubscription?.cancel();
    super.onClose();
  }

  // Start scanning for printers
  void startScan() async {
    isScanning.value = true;
    printers.clear();
    devicesStreamSubscription?.cancel();

    try {
      await flutterThermalPrinterPlugin.getPrinters(
        connectionTypes: [ConnectionType.BLE],
      );

      devicesStreamSubscription = flutterThermalPrinterPlugin.devicesStream
          .listen((List<Printer> event) {
            log(
              "Found printers: ${event.map((e) => e.name).toList().toString()}",
            );
            printers.value =
                event
                    .where(
                      (element) =>
                          element.name != null && element.name!.isNotEmpty,
                    )
                    .toList();
            isScanning.value = false;
          });
    } catch (e) {
      log("Error scanning for printers: $e");
      isScanning.value = false;
    }
  }

  // Stop scanning
  void stopScan() {
    isScanning.value = false;
    flutterThermalPrinterPlugin.stopScan();
  }

  // Connect to a printer
  Future<bool> connectPrinter(Printer printer) async {
    try {
      // First disconnect to ensure clean state
      try {
        await flutterThermalPrinterPlugin.disconnect(printer);
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        // Ignore errors on disconnect attempt
      }

      // Connect to printer
      await flutterThermalPrinterPlugin.connect(printer);
      await Future.delayed(const Duration(seconds: 1));
      selectedPrinter.value = printer;

      Get.snackbar('Success', 'Connected to ${printer.name ?? "printer"}');
      return true;
    } catch (e) {
      log("Error connecting to printer: $e");
      Get.snackbar('Error', 'Failed to connect: $e');
      return false;
    }
  }

  // Disconnect from printer
  Future<bool> disconnectPrinter(Printer printer) async {
    try {
      await flutterThermalPrinterPlugin.disconnect(printer);
      if (selectedPrinter.value?.address == printer.address) {
        selectedPrinter.value = null;
      }
      return true;
    } catch (e) {
      log("Error disconnecting from printer: $e");
      return false;
    }
  }

  // Print a receipt
  Future<void> printReceipt(BuildContext context) async {
    if (selectedPrinter.value == null) {
      Get.snackbar('Error', 'Please select a printer first');
      return;
    }

    // Show loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final printer = selectedPrinter.value!;
      log(
        "Printing receipt to ${printer.name} (${printer.connectionTypeString})",
      );

      // For BLE printers, use manually chunked ESC/POS commands
      if (printer.connectionType == ConnectionType.BLE) {
        await _printWithManualChunking(printer);
      } else {
        // For other printers, use the widget method
        await flutterThermalPrinterPlugin.printWidget(
          context,
          printer: printer,
          printOnBle: false,
          widget: receiptWidget(),
        );
      }

      Get.back(); // Close dialog
      Get.snackbar('Success', 'Receipt printed successfully');
    } catch (e) {
      Get.back(); // Close dialog
      log("Error printing receipt: $e");
      Get.snackbar('Error', 'Failed to print receipt: $e');
    }
  }

  // Print with manual chunking for BLE printers
  Future<void> _printWithManualChunking(Printer printer) async {
    try {
      // Generate ESC/POS commands in very small chunks
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);

      // Instead of generating one large command set, we'll send multiple
      // small commands in sequence, each under the 237 byte limit

      // Chunk 1: Company name
      List<int> chunk1 = [];
      chunk1 += generator.text(
        'Coinone Global Solutions',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
      await flutterThermalPrinterPlugin.printData(printer, chunk1);
      await Future.delayed(const Duration(milliseconds: 200));

      // Chunk 2: Website
      List<int> chunk2 = [];
      chunk2 += generator.text(
        'www.coinone.com',
        styles: const PosStyles(align: PosAlign.center),
      );
      chunk2 += generator.hr();
      await flutterThermalPrinterPlugin.printData(printer, chunk2);
      await Future.delayed(const Duration(milliseconds: 200));

      // Chunk 3: Header
      List<int> chunk3 = [];
      chunk3 += generator.text('Item       Price', styles: const PosStyles());
      chunk3 += generator.hr();
      await flutterThermalPrinterPlugin.printData(printer, chunk3);
      await Future.delayed(const Duration(milliseconds: 200));

      // Chunk 4: Products
      List<int> chunk4 = [];
      chunk4 += generator.text('Potato : 25.00', styles: const PosStyles());
      chunk4 += generator.text('Tomato : 15.50', styles: const PosStyles());
      await flutterThermalPrinterPlugin.printData(printer, chunk4);
      await Future.delayed(const Duration(milliseconds: 200));

      // Chunk 5: More products
      List<int> chunk5 = [];
      chunk5 += generator.text('Carrot : 10.00', styles: const PosStyles());
      chunk5 += generator.hr();
      await flutterThermalPrinterPlugin.printData(printer, chunk5);
      await Future.delayed(const Duration(milliseconds: 200));

      // Chunk 6: Total
      List<int> chunk6 = [];
      chunk6 += generator.text(
        'Total  :  50.50',
        styles: const PosStyles(bold: true),
      );
      await flutterThermalPrinterPlugin.printData(printer, chunk6);
      await Future.delayed(const Duration(milliseconds: 200));

      // Chunk 7: Thank you
      List<int> chunk7 = [];
      chunk7 += generator.text(
        'Thank you!',
        styles: const PosStyles(align: PosAlign.center),
      );
      chunk7 += generator.cut();
      await flutterThermalPrinterPlugin.printData(printer, chunk7);

      return;
    } catch (e) {
      log("Error in chunked printing: $e");
      rethrow;
    }
  }

  // Create the receipt widget (used for non-BLE printers)
  Widget receiptWidget() {
    return SizedBox(
      width: 50,
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'MY COMPANY',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Center(
                child: Text(
                  'www.mycompany.com',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const Divider(thickness: 1),
              _buildReceiptRow('Item', 'Price', fontSize: 12),
              const Divider(),
              _buildReceiptRow('Product A', '\$25.00', fontSize: 12),
              _buildReceiptRow('Product B', '\$15.50', fontSize: 12),
              _buildReceiptRow('Product C', '\$10.00', fontSize: 12),
              const Divider(thickness: 1),
              _buildReceiptRow('Total', '\$50.50', isBold: true, fontSize: 12),
              const SizedBox(height: 4),
              const Center(
                child: Text('Thank you!', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Receipt row widget with configurable font size
  Widget _buildReceiptRow(
    String leftText,
    String rightText, {
    bool isBold = false,
    double fontSize = 16,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            rightText,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
