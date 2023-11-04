import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M08 - Form (B)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final String title = 'Adrián López Villalba';
  int _activeCurrentStep = 0;
  final _formKey = GlobalKey<FormBuilderState>();

  List<Step> stepList() => [
        Step(
            isActive: _activeCurrentStep >= 0,
            title: const Text('Personal'),
            content: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15.0),
                child: Column(
                  children: [
                    Text(
                      'Personal',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'Per replicar el exemple del Powerpoint, vagi a "Upload" o pulsi el botó de "Continue".',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            )),
        Step(
            state: StepState.editing,
            isActive: _activeCurrentStep >= 1,
            title: const Text('Contact'),
            content: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15.0),
                child: Column(
                  children: [
                    Text(
                      'Contact',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'Per replicar el exemple del Powerpoint, vagi a "Upload" o pulsi el botó de "Continue".',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            )),
        Step(
            // state: _activeCurrentStep <= 2
            //     ? StepState.editing
            //     : StepState.complete,
            state: StepState.complete,
            isActive: _activeCurrentStep >= 2,
            title: const Text('Upload'),
            content:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              FormBuilderTextField(
                name: 'Email',
                decoration: secondaryTextFieldDecoration(Icons.email, "Email"),
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                keyboardType: TextInputType.multiline,
                minLines: 4,
                maxLines: null,
                name: 'Address',
                decoration: secondaryTextFieldDecoration(Icons.home, "Address"),
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: 'Mobile',
                decoration:
                    secondaryTextFieldDecoration(Icons.phone, "Mobile No"),
              ),
              SizedBox(
                height: 10,
              ),
            ]))
      ];

  InputDecoration secondaryTextFieldDecoration(
      IconData prefixIcon, String hintText) {
    return InputDecoration(
      prefixIcon: Icon(prefixIcon),
      prefixIconColor: Theme.of(context).colorScheme.inversePrimary,
      hintText: hintText,
      hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.inversePrimary),
        borderRadius: BorderRadius.circular(15.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }

  void alertDialog(BuildContext context, String contentText) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Submission Completed"),
        icon: const Icon(Icons.check_circle),
        content: Text(contentText),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Tancar'),
            child: const Text('Tancar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        // Here we have initialized the stepper widget
        body: FormBuilder(
          key: _formKey,
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _activeCurrentStep,
            steps: stepList(),
            // onStepContinue takes us to the next step
            onStepContinue: () {
              if (_activeCurrentStep == stepList().length - 1) {
                // Validate and save the form values
                _formKey.currentState?.saveAndValidate();
                String? formString = _formKey.currentState?.value.toString();
                alertDialog(context, formString!);
                return;
              }

              if (_activeCurrentStep < (stepList().length - 1)) {
                setState(() {
                  _activeCurrentStep += 1;
                });
              }
            },
            // onStepCancel takes us to the previous step
            onStepCancel: () {
              if (_activeCurrentStep == 0) {
                return;
              }
              setState(() {
                _activeCurrentStep -= 1;
              });
            },
            // onStepTap allows to directly click on the particular step we want
            onStepTapped: (int index) {
              setState(() {
                _activeCurrentStep = index;
              });
            },
            controlsBuilder: (context, controls) {
              return Row(
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: controls.onStepContinue,
                    child: const Text('CONTINUE'),
                  ),
                  TextButton(
                    onPressed: controls.onStepCancel,
                    child: const Text('CANCEL'),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
