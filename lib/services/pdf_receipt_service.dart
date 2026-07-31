import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';

/// Service Pembuatan, Preview, dan Download Struk PDF (Kriteria Serkom 2: Eksternal Storage & Printing)
class PdfReceiptService {
  static final PdfReceiptService instance = PdfReceiptService._init();
  PdfReceiptService._init();

  /// Membuat Dokumen PDF Struk Pesanan
  Future<pw.Document> buildPdfDocument(OrderModel order) async {
    final pdf = pw.Document();
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final dateStr = DateFormat(
      'dd MMMM yyyy, HH:mm',
    ).format(DateTime.tryParse(order.createdAt ?? '') ?? DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // HEADER TOKO ROTI
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#0C4A3E'),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'TOKO ROTI SERKOM',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'NOTA / STRUK PEMBELIAN ONLINE',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // INFORMASI TRANSAKSI & PELANGGAN
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'No. Pesanan: #${order.id}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      pw.Text('Tanggal: $dateStr'),
                      pw.Text(
                        'Status: ${order.status.toUpperCase()}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: order.status == 'completed'
                              ? PdfColors.green
                              : PdfColors.orange,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Pelanggan: ${order.customerName}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text('No. HP: ${order.phone}'),
                      pw.Text('Alamat: ${order.address}'),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),

              // TABEL DETAIL DAFTAR ITEM PESANAN
              pw.Text(
                'Rincian Pesanan:',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              pw.SizedBox(height: 8),

              pw.TableHelper.fromTextArray(
                headers: ['Produk', 'Jumlah', 'Harga Satuan', 'Subtotal'],
                data: order.items.map((item) {
                  final productName = item.product?.name ?? 'Roti';
                  final priceStr = currencyFormatter.format(
                    item.product?.price ?? 0,
                  );
                  final subtotalStr = currencyFormatter.format(item.subtotal);
                  return [productName, '${item.qty}x', priceStr, subtotalStr];
                }).toList(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#0C4A3E'),
                ),
                rowDecoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey300),
                  ),
                ),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
              ),

              pw.SizedBox(height: 20),

              // TOTAL BAYAR
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#F5F0E8'),
                      borderRadius: pw.BorderRadius.circular(6),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#0C4A3E'),
                        width: 1,
                      ),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Text(
                          'TOTAL BAYAR: ',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          currencyFormatter.format(order.totalPrice),
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                            color: PdfColor.fromHex('#0C4A3E'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.Spacer(),

              // FOOTER TERIMA KASIH
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Divider(thickness: 0.5),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Terima Kasih Telah Berbelanja di Toko Roti Serkom!',
                      style: pw.TextStyle(
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  /// Preview & Print PDF Struk di Aplikasi (Pop-up Interactive Viewer)
  Future<void> previewPdf(BuildContext context, OrderModel order) async {
    final pdf = await buildPdfDocument(order);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Struk_Order_${order.id}.pdf',
    );
  }

  /// Download & Simpan File PDF Struk ke HP (Membuka Save/Share Sheet & Menyimpan File)
  Future<File?> downloadAndSavePdf(OrderModel order) async {
    try {
      final pdf = await buildPdfDocument(order);
      final pdfBytes = await pdf.save();
      final fileName = 'Struk_Order_${order.id}.pdf';

      // 1. Panggil dialog simpan/share Android bawaan (Bisa simpan ke Download / Drive / WA / Folder HP)
      await Printing.sharePdf(bytes: pdfBytes, filename: fileName);

      // 2. Simpan juga secara fisik ke folder penyimpanan aplikasi
      Directory? dir;
      if (Platform.isAndroid) {
        final downloadFolder = Directory('/storage/emulated/0/Download');
        if (await downloadFolder.exists()) {
          dir = downloadFolder;
        } else {
          dir = await getExternalStorageDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      if (dir != null) {
        final filePath = '${dir.path}/$fileName';
        final file = File(filePath);
        return await file.writeAsBytes(pdfBytes);
      }
      return null;
    } catch (e) {
      print('Gagal simpan PDF: $e');
      return null;
    }
  }
}
