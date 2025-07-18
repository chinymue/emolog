import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Emolog',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

// class MyAppState extends ChangeNotifier {
//   var feeling = ['Terrefic', 'Happy', 'Chill', 'Bored', 'Sad', 'Anger'];
//   var currentFeeling = 'Chill';
//   void toggleFeelingNow(String newFeeling) {
//     if (feeling.contains(newFeeling)) {
//       currentFeeling = newFeeling;
//       notifyListeners();
//     }
//   }

//   double moodPoint = 3.0;
//   void updateMoodPoint(double newMoodPoint) {
//     if (newMoodPoint >= 1.0 && newMoodPoint <= 5.0) {
//       moodPoint = newMoodPoint;
//       notifyListeners();
//     }
//   }

//   String? note;
//   void toggleTakeNote(String? newNote) {
//     if (newNote != null) {
//       note = newNote;
//       notifyListeners();
//     }
//   }
// }

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(child: EmologForm()),
      ),
    );
  }
}

class EmologForm extends StatefulWidget {
  const EmologForm({super.key});

  @override
  State<EmologForm> createState() => _EmologFormState();
}

class _EmologFormState extends State<EmologForm> {
  // global key to identify Form widget & validation
  final _formkey = GlobalKey<FormState>();

  // text controller.
  final TextEditingController _textController = TextEditingController();

  // used to discard resources used by obj when don't need obj anymore, avoid mmr leak
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // // some funct to react w/ addListener
  // void _printLastestValue() {
  //   final text = _textController.text;
  //   print('$text (${text.characters.length})');
  // }

  // // listener of TextEditingController
  // @override
  // void initState() {
  //   super.initState();
  //   _textController.addListener(_printLastestValue);
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Hi sweetie, how is your day?',
            style: TextStyle(
              color: Color.fromRGBO(
                165,
                56,
                96,
                1.0,
              ), //rgb(58, 5, 25), rgb(103, 13, 47), rgb(165, 56, 96), rgb(239, 136, 173)
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 500,
            child: TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Tell me your feelings',
              ),
              // validator receives text that user entered
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: _textController,
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              if (_formkey.currentState!.validate()) {
                final text = _textController.text;
                // form is valid
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$text has been recorded')),
                );
                // showDialog(
                //   context: context,
                //   builder: (context) {
                //     return AlertDialog(content: Text(text));
                //   },
                // );
                _textController.clear();
              }
            },
            child: const Text('Submit', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _noteController = TextEditingController();
//   double? tempMood;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final appState = context.read<MyAppState>();
//     tempMood ??= appState.moodPoint;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appState = context.read<MyAppState>();
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             HelloMessage(),
//             MoodPointSlider(
//               tempMood: tempMood!,
//               onMoodChanged: (value) => setState(() => tempMood = value),
//               onMoodSubmit: (value) => appState.updateMoodPoint(value),
//             ),
//             NotePlaceholder(
//               appState: appState,
//               noteController: _noteController,
//             ),
//             SizedBox(height: 15),
//             FeelingList(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HelloMessage extends StatelessWidget {
//   const HelloMessage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'Chào, bạn cảm thấy thế nào?',
//       style: TextStyle(
//         fontFamily: 'Fuchsia',
//         fontFamilyFallback: ['Arial'],
//         fontSize: 30,
//       ),
//     );
//   }
// }

// class MoodPointSlider extends StatelessWidget {
//   final double tempMood;
//   final ValueChanged<double> onMoodChanged;
//   final ValueChanged<double> onMoodSubmit;

//   const MoodPointSlider({
//     super.key,
//     required this.tempMood,
//     required this.onMoodChanged,
//     required this.onMoodSubmit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 400,
//       child: Slider(
//         value: tempMood,
//         onChanged: onMoodChanged,
//         onChangeEnd: onMoodSubmit,
//         min: 1.0,
//         max: 5.0,
//         divisions: 4,
//         label: tempMood.toStringAsFixed(0),
//       ),
//     );
//   }
// }

// class NotePlaceholder extends StatelessWidget {
//   const NotePlaceholder({
//     super.key,
//     required this.appState,
//     required this.noteController,
//   });

//   final MyAppState appState;
//   final TextEditingController noteController;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           width: 500,
//           child: TextField(
//             textAlign: TextAlign.center,
//             controller: noteController,
//             decoration: InputDecoration(hintText: 'Nhập trạng thái của bạn'),
//           ),
//         ),
//         SizedBox(height: 15),
//         ElevatedButton(
//           onPressed: () {
//             final note = noteController.text;
//             appState.toggleTakeNote(note);
//             print('Submitted note: $note');
//             print(appState.note);
//           },
//           child: Text('Lưu ghi chú'),
//         ),
//       ],
//     );
//   }
// }

// class FeelingList extends StatelessWidget {
//   const FeelingList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final appState = context.watch<MyAppState>();
//     return Wrap(
//       spacing: 8,
//       children: appState.feeling.map((feeling) {
//         final selected = appState.currentFeeling == feeling;
//         return ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: selected ? Colors.pinkAccent : null,
//           ),
//           onPressed: () {
//             appState.toggleFeelingNow(feeling);
//           },
//           child: Text(
//             feeling,
//             style: TextStyle(color: selected ? Colors.white : null),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

// class FeelingListEmoji extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(itemBuilder: );
//   }

// }
