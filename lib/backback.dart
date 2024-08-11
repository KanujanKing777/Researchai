import 'package:flutter/material.dart';

Map<String, String> parseTextToMap(String inputText) {
  Map<String, String> result = {};
  List<String> keys = [" ", ];
  List<String> lines = inputText.split('\n');

  for(var line in lines){
    if (line.trim().isEmpty) continue;
    line = line.replaceAll('*', '');
    if(line.startsWith('I')){
      keys.add(line);
    }
    else{
      result[keys.last] = (result[keys.last] ?? "") + line + '\n';
    }
  }  
  return result;
}

String parseTextToMap2(String inputText) {

  inputText = inputText.replaceAll("*", ""); 
  inputText = inputText.replaceAll(":", "\n");
  return inputText;
}