import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:glossario/DAO/DAO_termo.dart';
import 'package:glossario/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeProfessor(),
    );
  }
}

class HomeProfessor extends StatefulWidget {
  @override
  _HomeProfessorState createState() => _HomeProfessorState();
}

class _HomeProfessorState extends State<HomeProfessor> {
  final DAOTermo _daoTermo = DAOTermo();
  String filter = 'Todos';

  void _showAddTermDialog({Map<String, dynamic>? term, String? id}) {
    TextEditingController titleController =
        TextEditingController(text: term?['titulo'] ?? '');
    TextEditingController descriptionController =
        TextEditingController(text: term?['descricao'] ?? '');
    bool isActive = term?['ativo'] ?? true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(term == null
                  ? 'Adicionar Termo Técnico'
                  : 'Editar Termo Técnico'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Título do Termo Técnico',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ativo'),
                      Switch(
                        value: isActive,
                        onChanged: (bool value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Map<String, dynamic> newTerm = {
                      "titulo": titleController.text,
                      "descricao": descriptionController.text,
                      "ativo": isActive,
                    };
                    if (term == null) {
                      _daoTermo.addTermo(newTerm);
                    } else {
                      _daoTermo.updateTermo(id!, newTerm);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Termo Técnico'),
          content:
              Text('Tem certeza de que deseja excluir este termo técnico?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _daoTermo.deleteTermo(id);
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Professor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Visualizar Termos Técnicos'),
                DropdownButton<String>(
                  value: filter,
                  onChanged: (String? newValue) {
                    setState(() {
                      filter = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Todos',
                      child: Text('Todos'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Ativos',
                      child: Text('Ativos'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Inativos',
                      child: Text('Inativos'),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _daoTermo.getTermos(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final terms = snapshot.data!.docs.map((doc) {
                    return {
                      "id": doc.id,
                      "titulo": doc['titulo'],
                      "descricao": doc['descricao'],
                      "ativo": doc['ativo'],
                    };
                  }).toList();

                  return ListView.builder(
                    itemCount: terms.length,
                    itemBuilder: (context, index) {
                      if (filter == 'Todos' ||
                          (filter == 'Ativos' && terms[index]['ativo']) ||
                          (filter == 'Inativos' && !terms[index]['ativo'])) {
                        return Card(
                          child: ListTile(
                            title: Text(terms[index]['titulo']),
                            subtitle: Text(terms[index]['descricao']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showAddTermDialog(
                                        term: terms[index],
                                        id: terms[index]['id']);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(
                                        terms[index]['id']);
                                  },
                                ),
                                Switch(
                                  value: terms[index]['ativo'],
                                  onChanged: (bool value) {
                                    _daoTermo.updateTermo(terms[index]['id'], {
                                      "ativo": value,
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTermDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
