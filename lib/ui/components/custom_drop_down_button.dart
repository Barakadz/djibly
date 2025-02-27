import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropDownButton<T> extends StatefulWidget {
  final String hintText;
  final T initvalue;
  final List<ItemObject> itemsList;
  final Function onChange;
  const CustomDropDownButton({Key key, this.hintText, this.initvalue, this.itemsList, this.onChange}) : super(key: key);

  @override
  CustomDropDownButtonState<T> createState() => CustomDropDownButtonState<T>();
}

class CustomDropDownButtonState<T> extends State<CustomDropDownButton<T>> {
  T selected_value;
  List<ItemObject> items;
  @override
  void initState() {
    super.initState();
    selected_value = widget.initvalue;
    items = widget.itemsList;
  }

  DropdownMenuItem<T> getButtonItems(ItemObject item){

    return DropdownMenuItem<T>(
      child:
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(item.label.toUpperCase()??'',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),),
            ),
            (item.value == this.selected_value)?
                Icon(Icons.check, color: Colors.teal,):
                Container()
          ],
        ),
      ),
      value: item.value??'',
    );
  }

  @override
  Widget build(BuildContext context){
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor:Colors.white
      ),
      child: DropdownButtonFormField<T>(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 5.0),
            filled: false,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0)
            ),
          ),
          items:items.map<DropdownMenuItem<T>>((e){
            return getButtonItems(e);
          }).toList(),
          isExpanded: true,
          onChanged: (T value) {
              setState(() {
                this.selected_value = value;
              });
              widget.onChange?.call();
          },
          hint: Text(widget.hintText),
          value: this.selected_value,
        ),
    );
  }
}

class ItemObject<T>{
  final String label;
  final T value;

  ItemObject({this.label, this.value});

}
