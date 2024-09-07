import 'package:flutter/material.dart';
import 'package:teste_tecnico_semeq/helpers/tree_view.dart';
import 'package:teste_tecnico_semeq/repositories/entities/tree_entity.dart';
import 'package:teste_tecnico_semeq/repositories/tree_repository.dart';
import 'package:teste_tecnico_semeq/views/home/home_bloc.dart';
import 'package:teste_tecnico_semeq/views/login/login_bloc.dart';
import 'package:teste_tecnico_semeq/views/login/login_view.dart';
import 'package:teste_tecnico_semeq/repositories/login_repository.dart';

class HomeView extends StatefulWidget {
  final String accessToken;

  const HomeView(this.accessToken, {Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(TreeRepository());
    _homeBloc.checkAndFetchTree(widget.accessToken);
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  void _refreshTree() {
    _homeBloc.fetchTree(widget.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 210,
              decoration: const BoxDecoration(
                color: Colors.pink,
              ),
              padding: const EdgeInsets.only(top: 25, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginView(
                            LoginBloc(LoginRepository()), 
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Hello',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: StreamBuilder<List<TreeEntity>>(
                stream: _homeBloc.treeStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<TreeEntity> treeData = snapshot.data!;
                    return TreeView(
                      treeData: treeData,
                      treeRepository: TreeRepository(),
                      accessToken: widget.accessToken,
                      onRefresh: _refreshTree, 
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
