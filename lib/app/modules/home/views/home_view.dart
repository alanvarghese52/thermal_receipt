import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thermal Receipt Printer'),
        centerTitle: true,
        actions: [
          Obx(
            () =>
                controller.isScanning.value
                    ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                    : IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => controller.startScan(),
                      tooltip: 'Scan for printers',
                    ),
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () => controller.stopScan(),
            tooltip: 'Stop Scan',
            color:
                controller.isScanning.value
                    ? Colors.white
                    : Colors.grey.shade400,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status bar
          Container(
            color: Colors.blue.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Obx(
                  () =>
                      controller.isScanning.value
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(
                            Icons.bluetooth,
                            color: Colors.blue,
                            size: 24,
                          ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => Text(
                      controller.isScanning.value
                          ? 'Scanning for printers...'
                          : controller.printers.isEmpty
                          ? 'No printers found'
                          : '${controller.printers.length} printer(s) found',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    controller.selectedPrinter.value != null
                        ? 'Connected: ${controller.selectedPrinter.value!.name ?? "Unknown"}'
                        : 'Not connected',
                    style: TextStyle(
                      color:
                          controller.selectedPrinter.value != null
                              ? Colors.green
                              : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Printer list
          Expanded(
            child: Obx(
              () =>
                  controller.printers.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            controller.isScanning.value
                                ? const CircularProgressIndicator()
                                : const Icon(
                                  Icons.print_disabled,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                            const SizedBox(height: 16),
                            Text(
                              controller.isScanning.value
                                  ? 'Scanning for printers...'
                                  : 'No printers found',
                              style: const TextStyle(fontSize: 16),
                            ),
                            if (!controller.isScanning.value)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ElevatedButton.icon(
                                  onPressed: () => controller.startScan(),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Scan Again'),
                                ),
                              ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: controller.printers.length,
                        itemBuilder: (context, index) {
                          final printer = controller.printers[index];
                          final bool isConnected = printer.isConnected ?? false;
                          final bool isSelected =
                              controller.selectedPrinter.value?.address ==
                              printer.address;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            elevation: isSelected ? 4 : 1,
                            color: isSelected ? Colors.blue.shade50 : null,
                            child: ListTile(
                              leading: Icon(
                                _getPrinterIcon(printer.connectionType),
                                color: isConnected ? Colors.green : Colors.grey,
                              ),
                              title: Text(
                                printer.name ?? 'Unknown Printer',
                                style: TextStyle(
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                              subtitle: Text(
                                'Address: ${printer.address ?? "Unknown"}\n'
                                'Type: ${printer.connectionTypeString}',
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isConnected ? Colors.red : Colors.green,
                                ),
                                onPressed: () async {
                                  if (isConnected) {
                                    await controller.disconnectPrinter(printer);
                                  } else {
                                    await controller.connectPrinter(printer);
                                  }
                                },
                                child: Text(
                                  isConnected ? 'Disconnect' : 'Connect',
                                ),
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
            ),
          ),

          // Print button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed:
                      controller.selectedPrinter.value != null
                          ? () => controller.printReceipt(context)
                          : null,
                  icon: const Icon(Icons.print),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  label: const Text(
                    'PRINT RECEIPT',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get appropriate icon based on printer type
  IconData _getPrinterIcon(ConnectionType? type) {
    switch (type) {
      case ConnectionType.BLE:
        return Icons.bluetooth;
      case ConnectionType.USB:
        return Icons.usb;
      case ConnectionType.NETWORK:
        return Icons.wifi;
      default:
        return Icons.print;
    }
  }
}
