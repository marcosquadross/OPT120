import 'package:flutter/material.dart';
import 'package:opt120/services/user_api.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "OPT120",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        actions: [],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(15.0),
                child: const Row(
                  children: [
                    Text(
                      'OPT120',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    title: const Text("Usuários"),
                    leading: const Icon(Icons.person),
                    onTap: () => Navigator.of(context).pushNamed('/userList'),
                  ),
                  ListTile(
                    title: const Text("Atividades"),
                    leading: const Icon(Icons.local_activity),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/activityList'),
                  ),
                  ListTile(
                    title: const Text("Atribuir Atividades"),
                    leading: const Icon(Icons.check),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/userActivityList'),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () async => {
                await UserApi().logout(),
                Navigator.of(context).pushReplacementNamed('/'),
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: 0,
              itemBuilder: (context, index) {
                return Container();
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
