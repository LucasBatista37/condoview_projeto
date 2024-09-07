import 'package:flutter/material.dart';

class CustomTimePicker extends StatelessWidget {
  const CustomTimePicker({
    super.key,
    required this.label,
    required this.onTimeSelected,
    this.selectedTime,
  });

  final String label;
  final Function(TimeOfDay) onTimeSelected;
  final TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (picked != null && picked != selectedTime) {
          onTimeSelected(picked);
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
              selectedTime == null
                  ? label
                  : '$label: ${selectedTime?.format(context)}',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }
}
