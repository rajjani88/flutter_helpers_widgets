import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contractor/commons/gap.dart';
import 'package:flutter_contractor/screens/quotation/widgets/total_widget.dart';
import 'package:flutter_contractor/screens/quotation/widgets/transaction_row.dart';
import 'package:flutter_contractor/utils/text_styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

class InvoiceWidget extends StatelessWidget {
  final String invoiceNumber;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final List<InvoiceItem> items;
  final double subtotal;
  final double gstTax;
  final double otherTaxes;
  final double grandTotal;

  const InvoiceWidget({
    required this.invoiceNumber,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.items,
    required this.subtotal,
    required this.gstTax,
    required this.otherTaxes,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotation'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('#$invoiceNumber'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Date: 01/01/23'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Quotation Title',
                    style: AppStyles.textNormal16(),
                  ),
                ],
              ),
            ),
            Text('To'),
            Text('Customer Name: $customerName'),
            Text('Phone: $customerPhone'),
            Text('Email: $customerEmail'),
            Table(
              border: TableBorder.all(),
              children: [
                transactionHeaderRow(),
                for (final item in items)
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(item.name),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('${item.qty}'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('${item.price.toStringAsFixed(2)}'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('${item.total.toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
              ],
            ),
            gap(),
            TotalWidget(subtotal: 600, gstTax: 18, otherTax: 0),
            ElevatedButton(
              onPressed: () async {
                final pdf = await generatePdf();
                final String filePath = pdf.absolute.path;
                final Uri uri = Uri.file(filePath);
                sharePdfOnWhatsApp(pdf, context);
                //OpenFilex.open(filePath);

                // if (!File(uri.toFilePath()).existsSync()) {
                //   throw Exception('$uri does not exist!');
                // }
                // if (!await launchUrl(uri)) {
                //   throw Exception('Could not launch $uri');
                // }
              },
              child: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> generatePdf() async {
    // Use your chosen PDF library to create the PDF document
    // and populate it with the invoice data
    final pdf = pw.Document();
    // ... (implement PDF generation logic here)

    final grandTotal = subtotal + gstTax + otherTaxes;

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text('#$invoiceNumber'),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text('Date: 01/01/23'),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(
                  'Quotation Title',
                  style: pw.TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          pw.Text('To'),
          pw.Text('Customer Name: $customerName'),
          pw.Text('Phone: $customerPhone'),
          pw.Text('Email: $customerEmail'),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Text('Item Name'),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Text('Qty'),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Text('Price'),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Text('Total'),
                  ),
                ],
              ),
              for (final item in items)
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8.0),
                      child: pw.Text(item.name),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8.0),
                      child: pw.Text('${item.qty}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8.0),
                      child: pw.Text('${item.price.toStringAsFixed(2)}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8.0),
                      child: pw.Text('${item.total.toStringAsFixed(2)}'),
                    ),
                  ],
                ),
            ],
          ),
          pw.Table(
            columnWidths: const {
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(1),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Text(
                    'Subtotal',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(subtotal.toStringAsFixed(2)),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(
                    'GST Tax',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(gstTax.toStringAsFixed(2)),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(
                    'Other Tax',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(otherTaxes.toStringAsFixed(2)),
                ],
              ),
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#D3D3D3'),
                ),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Grand Total',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      grandTotal.toStringAsFixed(2),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ]);
      },
    ));

    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/$invoiceNumber.pdf");
    print(file.path);
    return file.writeAsBytes(await pdf.save());
  }

  Future<void> requestStoragePermission() async {
    await Permission.storage.request();
  }

  //function share filke on whatsapp
  Future<void> sharePdfOnWhatsApp(File pdfFile, BuildContext context) async {
    // Check for WhatsApp availability
    requestStoragePermission();
    if (await Permission.storage.isGranted) {
      // Generate and share the PDF
      print(pdfFile.path);
      final whatsappAvailable =
          await canLaunchUrl(Uri.parse('whatsapp://send?text=Hello'));
      try {
        await WhatsappShare.shareFile(
            filePath: [pdfFile.path], phone: '91Your_Number_to_send');
      } catch (e) {
        print('error $e');
      }
      // if (whatsappAvailable) {
      //   await launchUrl(
      //       Uri.parse('whatsapp://send?text=Invoice&document=${pdfFile.path}'));
      // } else {
      //   // Handle WhatsApp not being installed
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('WhatsApp not installed')),
      //   );
      // }
    } else {
      // Request permission or handle the case where permission is denied
    }
  }
}

class InvoiceItem {
  final String name;
  final int qty;
  final double price;
  final double total;

  const InvoiceItem({
    required this.name,
    required this.qty,
    required this.price,
    required this.total,
  });
}
