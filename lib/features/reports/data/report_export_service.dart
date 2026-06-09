import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'report_models.dart';

class ReportExportService {
  Future<File> exportCsv({
    required List<ReportRow> rows,
    required List<ReportColumn> columns,
  }) async {
    final buffer = StringBuffer();

    buffer.writeln(
      columns.map((column) => _escapeCsvValue(column.label)).join(','),
    );

    for (final row in rows) {
      buffer.writeln(
        columns
            .map((column) => _escapeCsvValue(row.valueForColumn(column)))
            .join(','),
      );
    }

    final directory = await getApplicationDocumentsDirectory();
    final fileName = _buildFileName(extension: 'csv');
    final file = File('${directory.path}/$fileName');

    // BOM helps Excel open UTF-8 CSV with accents correctly.
    return file.writeAsBytes(utf8.encode('\uFEFF${buffer.toString()}'));
  }

  Future<File> exportExcel({
    required List<ReportRow> rows,
    required List<ReportColumn> columns,
  }) async {
    final excel = Excel.createExcel();

    const sheetName = 'Reporte';
    final sheet = excel[sheetName];
    final defaultSheet = excel.getDefaultSheet();

    if (defaultSheet != null && defaultSheet != sheetName) {
      excel.delete(defaultSheet);
    }

    sheet.appendRow(
      columns.map((column) => TextCellValue(column.label)).toList(),
    );

    for (final row in rows) {
      sheet.appendRow(
        columns
            .map((column) => _toExcelCell(row.valueForColumn(column)))
            .toList(),
      );
    }

    for (var index = 0; index < columns.length; index++) {
      sheet.setColumnWidth(index, _columnWidth(columns[index]));
    }

    final bytes = excel.encode();

    if (bytes == null) {
      throw Exception('No se pudo generar el archivo Excel.');
    }

    final directory = await getApplicationDocumentsDirectory();
    final fileName = _buildFileName(extension: 'xlsx');
    final file = File('${directory.path}/$fileName');

    return file.writeAsBytes(bytes);
  }

  Future<void> shareFile(File file) async {
    await SharePlus.instance.share(
      ShareParams(text: 'Reporte generado', files: [XFile(file.path)]),
    );
  }

  CellValue _toExcelCell(Object? value) {
    if (value == null) {
      return TextCellValue('');
    }

    if (value is int) {
      return IntCellValue(value);
    }

    if (value is double) {
      return DoubleCellValue(value);
    }

    return TextCellValue(value.toString());
  }

  double _columnWidth(ReportColumn column) {
    switch (column) {
      case ReportColumn.date:
      case ReportColumn.week:
      case ReportColumn.lot:
      case ReportColumn.network:
      case ReportColumn.sector:
        return 12;
      case ReportColumn.haSector:
      case ReportColumn.haTotal:
      case ReportColumn.scheduledWage:
      case ReportColumn.realWage:
      case ReportColumn.ratio:
        return 16;
      case ReportColumn.leaderCode:
      case ReportColumn.taskCode:
        return 18;
      case ReportColumn.observation:
        return 35;
      default:
        return 24;
    }
  }

  String _escapeCsvValue(Object? value) {
    if (value == null) {
      return '';
    }

    final text = value.toString();
    final mustQuote =
        text.contains(',') ||
        text.contains('"') ||
        text.contains('\n') ||
        text.contains('\r');

    final escaped = text.replaceAll('"', '""');

    if (mustQuote) {
      return '"$escaped"';
    }

    return escaped;
  }

  String _buildFileName({required String extension}) {
    final now = DateTime.now();

    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');

    return 'reporte_labores_$year$month${day}_$hour$minute$second.$extension';
  }
}

final reportExportServiceProvider = Provider<ReportExportService>((ref) {
  return ReportExportService();
});
