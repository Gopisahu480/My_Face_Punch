import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeDisplay extends StatelessWidget {
  final DateTime currentTime;

  const DateTimeDisplay({Key? key, required this.currentTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd-MMM-yyyy').format(currentTime);
    final formattedTime = DateFormat('hh:mm a').format(currentTime);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Padding(
            //   padding: EdgeInsets.only(left: 20),
            //   child: const Text(
            //     'Server Time :  ',
            //     style: TextStyle(
            //         fontSize: 16,
            //         fontFamily: 'Cupertino',
            //         fontWeight: FontWeight.bold),
            //   ),
            // ),
            // Text(
            //   '$formattedTime',
            //   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            // ),
             ShaderMask(
                shaderCallback: (bounds) => LinearGradient(colors: [
                  const Color.fromARGB(255, 5, 81, 143),
                  Colors.deepPurple,
                ]).createShader(bounds),
                child: Text(
                  '$formattedTime',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(colors: [
                  Colors.grey.shade800,
                  Colors.grey,
                ]).createShader(bounds),
                child: Text(
                  '$formattedDate',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
                ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
