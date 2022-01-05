import 'package:cleancode/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:cleancode/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:cleancode/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:cleancode/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return SingleChildScrollView(
      child: BlocProvider<NumberTriviaBloc>(
        create: (context) => inj<NumberTriviaBloc>(),
        child: Column(
          children: [
            _topHalf(context),
            _bottomHalf(context),
          ],
        ),
      ),
    );
  }

  _topHalf(context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
        builder: (context, state) {
          if (state is NumberTriviaInitial) {
            return const TriviaMessage(message: "Start Searching!");
          } else if (state is ErrorTrivia) {
            return TriviaMessage(message: state.message);
          } else if (state is LoadingTrivia) {
            return const LoadingWidget();
          } else if (state is LoadedTrivia) {
            return TriviaDisplay(trivia: state.trivia);
          } else {
            return const LoadingWidget();
          }
        },
      ),
    );
  }

  _bottomHalf(context) {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: TriviaControls(),
    );
  }

  _appBar() {
    return AppBar(
      title: const Text("AppBar"),
    );
  }
}
