import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  Gender selectedGender = Gender.male;
  int age = 25;
  int weight = 70;
  int height = 170;
  double bmi = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Gender'),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = Gender.male;
                        });
                      },
                      child: Container(
                        height: 100,
                        color: selectedGender == Gender.male
                            ? Colors.blue
                            : Colors.grey,
                        child: Center(
                          child: Text(
                            'Male',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = Gender.female;
                        });
                      },
                      child: Container(
                        height: 100,
                        color: selectedGender == Gender.female
                            ? Colors.pink
                            : Colors.grey,
                        child: Center(
                          child: Text(
                            'Female',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Age: $age'),
              Slider(
                value: age.toDouble(),
                min: 1,
                max: 100,
                onChanged: (newValue) {
                  setState(() {
                    age = newValue.toInt();
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Weight: $weight kg'),
              Slider(
                value: weight.toDouble(),
                min: 1,
                max: 200,
                onChanged: (newValue) {
                  setState(() {
                    weight = newValue.toInt();
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Height: $height cm'),
              Slider(
                value: height.toDouble(),
                min: 100,
                max: 250,
                onChanged: (newValue) {
                  setState(() {
                    height = newValue.toInt();
                  });
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  double heightInMeters = height / 100;
                  bmi = weight / (heightInMeters * heightInMeters);

                  String bmiResult = bmi.toStringAsFixed(1);
                  String bmiInterpretation = '';

                  if (bmi < 18.5) {
                    bmiInterpretation = 'Underweight';
                  } else if (bmi >= 18.5 && bmi < 24.9) {
                    bmiInterpretation = 'Normal weight';
                  } else if (bmi >= 25.0 && bmi < 29.9) {
                    bmiInterpretation = 'Overweight';
                  } else {
                    bmiInterpretation = 'Obesity';
                  }

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('BMI Result'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your BMI: $bmiResult'),
                            SizedBox(height: 8),
                            Text('Interpretation: $bmiInterpretation'),
                            SizedBox(height: 16),
                            AspectRatio(
                              aspectRatio: 1.6,
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(show: false),
                                  titlesData: FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  minX: 0,
                                  maxX: 4,
                                  minY: 0,
                                  maxY: 30,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: [
                                        FlSpot(0, bmi),
                                        FlSpot(4, bmi),
                                      ],
                                      isCurved: true,
                                      colors: [Colors.blue],
                                      dotData: FlDotData(show: false),
                                      belowBarData: BarAreaData(show: false),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Calculate BMI'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum Gender {
  male,
  female,
}
