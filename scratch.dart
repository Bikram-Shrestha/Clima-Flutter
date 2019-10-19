void main() {
  performTasks();
}

void performTasks() async {
  task1();
  print(task2());
  String result = await task2();
  task3(result);
}

void task1() {
  String result = 'Task 1 data';
  print('Task 1 is complete');
}

Future<String> task2() async {
  Duration threeSeconds = Duration(seconds: 3);
  String result;
  await Future.delayed(threeSeconds, () {
    result = 'Task 2 data';
    print('Task 2 is complete');
  });
  return result;
}

void task3(String task2Data) {
  String result = 'Task 3 data';
  try {
    double myStringAsaDouble = double.parse(result);
  } catch (e) {
    print(e);
  }
  print('Task 3 is complete with $task2Data');
}
