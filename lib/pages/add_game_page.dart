import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inicioestudotroneio/models/game_model.dart';
import 'package:inicioestudotroneio/sql/sqflite_helper.dart';

class AddGame extends StatefulWidget {
  GameModel? game;
  AddGame({super.key, this.game});

  @override
  State<AddGame> createState() => _AddGameState();
}

class _AddGameState extends State<AddGame> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String _platformValue = 'PC';
  final _companyController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.game != null) {
      DateFormat formater = DateFormat('dd/MM/yyyy');

      _titleController.text = widget.game!.title;
      _descriptionController.text = widget.game!.description;
      selectedDate = formater.parse(widget.game!.date);
      _platformValue = widget.game!.platform;
      _companyController.text = widget.game!.company;
      _imageUrlController.text = widget.game!.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: (() => Navigator.of(context).pop()),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.game == null ? 'Add Game' : "Update Game",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Title',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      hintText: 'Enter game title',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Este campo é obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Description',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'Enter your description',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Este campo é obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Year',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: DateFormat('dd/MM/yyyy').format(selectedDate),
                    suffixIcon: IconButton(
                      onPressed: () => _showDatePicker(),
                      icon: const Icon(Icons.date_range),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Platform',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _platformValue,
                  items: ['PC', 'XBOX', 'PS5']
                      .map((platform) => DropdownMenuItem<String>(
                    value: platform,
                    child: Text(platform),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _platformValue = value!;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'Select platform',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Este campo é obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Company',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFormField(
                  controller: _companyController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'Enter company',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Este campo é obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Image',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'image url',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Este campo é obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.game == null) {
                            add();
                          } else {
                            update();
                          }
                          Navigator.of(context).pop(true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.game == null
                                    ? "Added game"
                                    : "Updated game",
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        widget.game == null ? 'Add' : 'Update',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(0000),
      lastDate: DateTime(9999),
    ) as DateTime;

    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> add() async {
    await SqlHelper.createGame(
      _titleController.text,
      _descriptionController.text,
      DateFormat("dd/MM/yyyy").format(selectedDate),
      _platformValue,
      _companyController.text,
      _imageUrlController.text,
    );
  }

  Future<void> update() async {
    await SqlHelper.updateGame(
      widget.game!.id,
      _titleController.text,
      _descriptionController.text,
      DateFormat('dd/MM/yyyy').format(selectedDate),
      _platformValue,
      _companyController.text,
      _imageUrlController.text,
    );
  }
}
