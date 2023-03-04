// ignore_for_file: constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';

enum TypeSelect { SINGLE, MULTI }

class ItemSearchModel {
  String unique;
  String label;
  bool? selected;

  ItemSearchModel({
    required this.unique,
    required this.label,
    this.selected = false,
  });
}

class SearchViewDialog extends StatefulWidget {
  List<ItemSearchModel> list;
  List<ItemSearchModel> listReal = [];
  bool filter;

  TypeSelect type;

  SearchViewDialog({
    Key? key,
    this.type = TypeSelect.SINGLE,
    required this.list,
    this.filter = true,
  }) : super(key: key);

  @override
  State<SearchViewDialog> createState() => _SearchViewDialogState();
}

class _SearchViewDialogState extends State<SearchViewDialog> {
  @override
  void initState() {
    super.initState();
    widget.listReal = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      elevation: 0.0,
      content: content(context),
    );
  }

  Widget content(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: height * 0.6,
        minHeight: 0,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            _section1('This is title', 'This is content'),
            widget.filter ? _section2('Search') : Container(),
            _section3(),
            space16(),
            _section4(),
          ],
        ),
      ),
    );
  }

  SizedBox space16() {
    return const SizedBox(height: 16);
  }

  Widget _section1(String title, String subTitle) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(subTitle),
        space16(),
      ],
    );
  }

  //
  Widget _section2(String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            widget.list = widget.listReal;
          } else {
            widget.list = [];
            for (int i = 0; i < widget.listReal.length; i++) {
              if (widget.listReal[i].label.contains(value)) {
                widget.list.add(widget.listReal[i]);
              }
            }
          }
          // print("zein_${value}_${widget.list.length}_${widget.listReal.length}");
          setState(() {});
        },
      ),
    );
  }

  Widget _section3() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.list.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(widget.list[index].label)),
                    Checkbox(
                      shape: widget.type == TypeSelect.SINGLE ? const CircleBorder() : null,
                      value: widget.list[index].selected,
                      onChanged: (value) {
                        if (widget.type == TypeSelect.SINGLE) {
                          for (int i = 0; i < widget.list.length; i++) {
                            widget.list[i].selected = false;
                          }
                        }
                        setState(() {
                          widget.list[index].selected = value;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _section4() {
    return Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context, widget.list);
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    });
  }
}
