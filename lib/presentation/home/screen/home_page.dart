import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:talk/bloc/homeData/home_data_bloc.dart';
import 'package:talk/data/repository/homeData_repository.dart';
import 'package:talk/routes/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final int _limit = 15;
  final int _loadingDataThreshold = 1;
  bool _hasMoreData = true;
  final List<DocumentSnapshot> _data = [];

  @override
  void initState() {
    super.initState();
    context.read<HomeDataBloc>().add(GetInitialData());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        HomeDataRepository()
            .getMoreData(lastDocument: _data.last)
            .then((value) {
          if (value.docs.length < _limit) {
            setState(() {
              _hasMoreData = false;
            });
          }
          setState(() {
            _data.addAll(value.docs);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: addDummyDataToFirebase,
                child: const Text("Add Dummy Data to Firebase"),
              ),
              TextButton(
                onPressed: () {
                  GoRouter.of(context)
                      .goNamed(AppRouteConstantsPrivate.settings);
                },
                child: const Text("Goto Profile Settings"),
              ),
              BlocListener<HomeDataBloc, HomeDataState>(
                listener: (context, state) {
                  if (state is HomeDataError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                      ),
                    );
                  }
                  if (state is HomeDataLoaded) {
                    _data.addAll(state.data);
                  }
                },
                child: BlocBuilder<HomeDataBloc, HomeDataState>(
                  builder: (context, state) {
                    return Expanded(
                      child: SizedBox(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            _data.clear();
                            _hasMoreData = true;
                            context.read<HomeDataBloc>().add(GetInitialData());
                          },
                          //New bloc
                          child: BlocBuilder<HomeDataBloc, HomeDataState>(
                              builder: (context, state) {
                            if (state is HomeDataLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is HomeDataLoaded) {
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: _data.length + _loadingDataThreshold,
                                itemBuilder: (context, index) {
                                  if (index >= _data.length && _hasMoreData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (index >= _data.length && !_hasMoreData) {
                                    return const Center(
                                      child: Text("No more data"),
                                    );
                                  }
                                  return (index >= _data.length)
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ListTile(
                                          title: Text(_data[index]['message']),
                                          subtitle: Text(
                                              DateFormat('yyyy-MM-dd – kk:mm')
                                                  .format(_data[index]
                                                          ['timestamp']
                                                      .toDate())),
                                          leading: Image.network(
                                              _data[index]['imageUrl']),
                                        );
                                },
                              );
                            } else {
                              return const Center(
                                child: Text("No data"),
                              );
                            }
                          }),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addDummyDataToFirebase() {
    FirebaseFirestore.instance.collection('testingData').add({
      'timestamp': DateTime.now(),
      'message': 'Hello from Talk message from HomePage.dart',
      'author': 'Talk App',
      'imageUrl': 'https://picsum.photos/200/300',
    });
  }
}
