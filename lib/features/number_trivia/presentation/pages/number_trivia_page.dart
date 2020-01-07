import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Number Trivia')), body: buildBody(context));
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      builder: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay('Start Searching');
                  }
                },
              ),

              SizedBox(
                height: 20,
              ),
              // Bottom half
              Column(
                children: <Widget>[
                  // TextField
                  Placeholder(
                    fallbackHeight: 40,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Placeholder(
                        fallbackHeight: 30,
                      )),
                      SizedBox(width: 10),
                      Expanded(
                          child: Placeholder(
                        fallbackHeight: 30,
                      )),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay(
    Key key,
    @required this.message,
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              message,
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
        ));
    return null;
  }
}
