import 'package:flutter/material.dart';

class CustomDataPicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? selectedDate;

  const CustomDataPicker({
    super.key,
    required this.onDateSelected,
    this.selectedDate,
  });

  @override
  State<CustomDataPicker> createState() => _CustomDataPickerState();
}

class _CustomDataPickerState extends State<CustomDataPicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: widget.selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != widget.selectedDate) {
          widget.onDateSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.selectedDate != null
                  ? '${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}'
                  : 'Selecionar Data',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_today,
                color: Color.fromARGB(255, 0, 0, 0)),
          ],
        ),
      ),
    );
  }
}
