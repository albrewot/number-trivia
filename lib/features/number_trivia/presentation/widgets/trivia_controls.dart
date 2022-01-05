import 'package:cleancode/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String? inputStr;
  TextEditingController inputController = TextEditingController();

  void _dispatchRandomNumber() {
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetTriviaForRandomNumber(),
    );
  }

  void _dispatchConcreteNumber() {
    inputController.clear();
    FocusScope.of(context).unfocus();
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetTriviaForConcreteNumber(inputStr!),
    );
    inputStr = "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: inputController,
          onChanged: (value) {
            setState(() {
              inputStr = value;
            });
          },
          onSubmitted: (_) => _dispatchConcreteNumber(),
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.primaryVariant),
            ),
            hintText: "Input a number",
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _dispatchConcreteNumber,
                child: const Text("Get Trivia"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _dispatchRandomNumber,
                child: const Text("Get Random Trivia"),
              ),
            ),
          ],
        )
      ],
    );
  }
}
