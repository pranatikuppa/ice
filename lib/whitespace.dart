
/*
 * Whitespace class follows the CS 61B Whitespace section of 
 * the Style Check Guide in order to fix minor space errors
 * within code.  
 */
class Whitespace {

  /* The file content after the changes are made to the file. */
  String fileContent = "";

  /* The constructor of the Whitespace class. */
  Whitespace();
  
  /* 
   * The main method of the Whitespace class.
   * It takes in the file contents as a String and returns
   * a String with the changed file contents.
   */
  String main(String file) {
    fileContent = file;
    List<String> noSpaceBeforeKeywords = ["++", "--", ";", ")"];
    for (String item in noSpaceBeforeKeywords) {
      noSpaceBefore(fileContent.split("\n"), item);
    }
    List<String> noSpaceAfterKeywords = ["(", "!", "++", "--"];
    for (String item in noSpaceAfterKeywords) {
      noSpaceAfter(fileContent.split("\n"), item);
    }
    List<String> spaceBeforeKeywords = ["&&", "||", "{", "*", "+", "-", "/", "=", "+=", "assert", "catch", "do", "else", "finally", 
                                        "for", "if", "return", "synchronized", "try", "while"];
    for (String item in spaceBeforeKeywords) {
      spaceBefore(fileContent.split("\n"), item);
    }
    List<String> spaceAfterKeywords = ["&&", "||", ";", ",", "+", "/", "-", "*", "=", "+=", "assert", "catch", "do", "else", "finally", 
			                                "for", "if", "return", "synchronized", "try", "while"];
    for (String item in spaceAfterKeywords) {
      spaceAfter(fileContent.split("\n"), item);
    }
    removeTrailingBlank(fileContent.split("\n"));
    return fileContent;
  }
  
  /*
   * Method that takes in the lines of a file and ensures
   * that the desired character(s) have no spaces before it
   * in lines that it appears.
   */
  noSpaceBefore(List<String> lines, String item) {
    fileContent = "";
    String toWrite = "";
    int itemLen = item.length;
    bool changed = false;
    int numLines = lines.length;
    int lineNum = 1;
    for (String line in lines) {
      if (line.contains(item)) {
        int ind = line.indexOf(item, 0);
        int numPotentialErrs = numItems(line, item, itemLen);
        List<int> indices = allIndices(line, item, ind, itemLen);
        for (int i = 0; i < numPotentialErrs; i++) {
          if (toWrite == "") {
            if (charAt(line, indices[i] - 1) == " ") {
              toWrite = line.substring(0, indices[i]).trimRight();
              toWrite += line.substring(indices[i]);
              indices = allIndices(toWrite, item, toWrite.indexOf(item, 0), itemLen);
              changed = true;
            }
          } else {
            String temp = toWrite.substring(indices[i]);
            toWrite = toWrite.substring(0, indices[i]).trimRight();
            toWrite += temp;
            indices = allIndices(toWrite, item, toWrite.indexOf(item, 0), itemLen);
            changed = true;
          }
        }
        if (toWrite != "") {
          fileContent += toWrite;
          if (lineNum < numLines) {
            fileContent += "\n";
          }
        }
        toWrite = "";
      }
      if (!changed) {
        fileContent += line;
        if (lineNum < numLines) {
            fileContent += "\n";
          }
      }
      changed = false;
      lineNum++;
    }
  }

  /*
   * Method that takes in the lines of a file and ensures
   * that the desired character(s) have no spaces after it in
   * lines that it appears.
   */
  noSpaceAfter(List<String> lines, item) {
    fileContent = "";
    String toWrite = "";
    int itemLen = item.length;
    bool changed = false;
    int numLines = lines.length;
    int lineNum = 1;
    for (String line in lines) {
      if (line.contains(item)) {
        int ind = line.indexOf(item, 0);
        int numPotentialErrs = numItems(line, item, itemLen);
        List<int> indices = allIndices(line, item, ind, itemLen);
        for (int i = 0; i < numPotentialErrs; i++) {
          if (toWrite == "") {
            if (charAt(line, indices[i] + 1) == " ") {
              toWrite = line.substring(0, indices[i] + itemLen);
              toWrite += line.substring(indices[i] + itemLen).trimLeft();
              indices = allIndices(toWrite, item, toWrite.indexOf(item, 0), itemLen);
              changed = true;
            }
          } else {
            String temp = toWrite.substring(indices[i] + itemLen).trimLeft();
            toWrite = toWrite.substring(0, indices[i] + itemLen);
            toWrite += temp;
            indices = allIndices(toWrite, item, toWrite.indexOf(item, 0), itemLen);
            changed = true;
          }
        }
        if (toWrite != "") {
          fileContent += toWrite;
          if (lineNum < numLines) {
            fileContent += "\n";
          }
        }
        toWrite = "";
      }
      if (!changed) {
        fileContent += line;
        if (lineNum < numLines) {
            fileContent += "\n";
        }
      }
      changed = false;
      lineNum++;
    }
  }

  /*
   * Method that takes in the lines of a file and ensures
   * that the desired character(s) have a space before it in
   * lines that it appears. 
   */
  spaceBefore(List<String> lines, String item) {
    fileContent = "";
    int itemLen = item.length;
    String toWrite = "";
    bool changed = false;
    String proper = "";
    int numLines = lines.length;
    int lineNum = 1;
    for (String line in lines) {
      if (line.contains(item)) {
        int ind = line.indexOf(item);
        int numPotentialErrs = numItems(line, item, itemLen);
        List<int> indices = allIndices(line, item, ind, itemLen);
        for (int i = 0; i < numPotentialErrs; i++) {
          if (toWrite == "") {
            proper = getProperBefore(line, ind);
            if (charAt(line, ind - 1) != " " && !checkMult(line, item) 
              && !checkMultiComment(line, item, indices[i])) {
              toWrite = line.substring(0, indices[i]);
              toWrite += " " + line.substring(indices[i]);
              indices = allIndices(toWrite, item, toWrite.indexOf(item), itemLen);
              changed = true;
            } else if (proper.trim() != line.trim() && !checkMult(line, item) 
              && !checkMultiComment(line, item, indices[i])) {
              toWrite = line.substring(0, indices[i]).trimRight();
              toWrite += " " + line.substring(indices[i]);
              indices = allIndices(toWrite, item, toWrite.indexOf(item), itemLen);
              changed = true;
            }
          } else {
            if (!checkMult(toWrite, item) && !checkMultiComment(toWrite, item, indices[i])) {
              proper = getProperBefore(toWrite, indices[i]);
              String temp = " " + toWrite.substring(indices[i]);
              toWrite = toWrite.substring(0, indices[i]).trimRight();
              toWrite += temp;
              indices = allIndices(toWrite, item, toWrite.indexOf(item), itemLen);
              changed = true;
            }
          }
        }
        if (toWrite != "") {
          fileContent += toWrite;
          if (lineNum < numLines) {
            fileContent += "\n";
          }
        }
        toWrite = "";
      }
      if (!changed) {
        fileContent += line;
        if (lineNum < numLines) {
            fileContent += "\n";
        }
      }
      changed = false;
      lineNum++;
    }
  }

  /*
   * Method that takes in the lines of a file and ensures
   * that the desired character(s) has a space after it
   * in lines that it appears. 
   */
  spaceAfter(List<String> lines, String item) {
    fileContent = "";
    String toWrite = "";
    int itemLen = item.length;
    bool changed = false;
    int numLines = lines.length;
    int lineNum = 1;
    for (String line in lines) {
      if (line.contains(item)) {
        int ind = line.indexOf(item, 0);
        int numPotentialErrs = numItems(line, item, itemLen);
        String proper = "";
        List<int> indices = allIndices(line, item, ind, itemLen);
        for (int i = 0; i < numPotentialErrs; i++) {
          if (toWrite == "") {
            proper = getProperAfter(line, ind, itemLen);
            if (indices[i] == line.length - 1) {
              toWrite = line + " ";
              indices = allIndices(toWrite, item, toWrite.indexOf(item, 0), itemLen);
              changed = true;
            } else if (proper.trim() != line.trim() && !checkMult(line, item)
              && !checkMultiComment(line, item, indices[i])) {
              toWrite = line.substring(0, indices[i] + itemLen);
              toWrite += " " + line.substring(indices[i] + itemLen).trimLeft();
              indices = allIndices(toWrite, item, toWrite.indexOf(item, 0), itemLen);
              changed = true;
            }
          } else {
            if (indices[i] == toWrite.length - 1) {
              toWrite = toWrite + " ";
              indices = allIndices(toWrite, item, toWrite.indexOf(item, 0), itemLen);
              changed = true;
            } else if (!checkMult(toWrite, item) && !checkMultiComment(toWrite, item, indices[i])) {
              proper = getProperAfter(toWrite, indices[i], itemLen);
              String temp = toWrite.substring(indices[i] + itemLen).trimLeft();
              toWrite = toWrite.substring(0, indices[i] + itemLen) + " ";
              toWrite += temp;
              indices = allIndices(toWrite, item, toWrite.indexOf(item, 0), itemLen);
              changed = true;
            }
          }
        }
        if (toWrite != "") {
          fileContent += toWrite;
          if (lineNum < numLines) {
            fileContent += "\n";
          }
        }
        toWrite = "";
      }
      if (!changed) {
        fileContent += line;
        if (lineNum < numLines) {
            fileContent += "\n";
        }
      }
      changed = false;
      lineNum++;
    }
  }

  /*
   * Reads a line and counts all appearances of item within
   * it. Takes in the line, the item and the item's length. 
   */
  int numItems(String line, String item, int itemLen) {
    int total = 0;
    String temp = line;
    while (temp.contains(item) && !(temp.trim() == item)) {
      total++;
      int ind = temp.indexOf(item, 0);
      if (itemLen == 1) {
        temp = temp.substring(ind + itemLen);
      } else {
        temp = temp.substring(ind + itemLen - 1);
      }
    }
    return total;
  }

  /*
   * Reads a line and using the line, the item the first index 
   * of the item and the item's length, returns a list of
   * all the indices of a string snippet within that line.
   */
  List<int> allIndices(String line, String item, int ind, int itemLen) {
    List<int> indices = new List<int>();
    indices.add(ind);
    int curr = 0;
    if (itemLen == 1) {
      curr = ind + itemLen;
    } else {
      curr = ind + itemLen - 1;
    }
    String temp = line.substring(curr);
    while (temp.contains(item) && !(temp.trim() == item)) {
      curr += temp.indexOf(item, 0);
      indices.add(curr);
      if (itemLen == 1) {
        curr += itemLen;
        temp = temp.substring(temp.indexOf(item, 0) + itemLen);
      } else {
        curr += itemLen - 1;
        temp = temp.substring(temp.indexOf(item, 0) + itemLen - 1);
      }
    }
    return indices;
  }

  /*
   * Inspects a line and determines if the occurence of item is
   * a multiple (ex. item is "+", checks if the first occurence 
   * in line is "++" or "+="). Takes in the line and the item. 
   */
  bool checkMult(String line, String item) {
    int ind = line.indexOf(item);
    if ((item == "+" || item == "-" || item == "=")
      && (charAt(line, ind + 1) == "+" || charAt(line, ind + 1) == "-"
      || charAt(line, ind + 1) == "=")) {
      return true;
    } else if ((item == "+" && charAt(line, ind + 1) == "=") || item == "="
      && charAt(line, ind - 1) == "+") {
      return true;
    } else if (item == "/" && charAt(line, ind + 1) == "/") {
      return true;
    } else if (item == "/" && charAt(line, ind - 1) == "/") {
      return true;
    } else {
      return false;
    }
  }

  /*
   * Read a line and using the line and the index, determins if 
   * a certain '/' is part of a multiline comment declaration.  
   */
  bool checkMultiSlash(String line, int ind) {
    if (charAt(line, ind + 1) == '*' || charAt(line, ind - 1) == '*') {
      return true;
    }
    return false;
  }

  /*
   * Reads a line and using the line and the index determines if
   * a certain '*' being inspected is part of a multiline comment
   * declaration. 
   */
  bool checkMultiStar(String line, int ind) {
    if (charAt(line, ind + 1) == '/' || charAt(line, ind - 1) == '/') {
      return true;
    } else if (charAt(line, ind + 1) == '*' || charAt(line, ind - 1) == '*') {
      return true; 
    }
    return false;
  }

  /*
   * Reads a line and using the line, the item and the first index
   * of the item, determins if a certain element being inspected
   * is part of a multiline comment declaration.  
   */
  bool checkMultiComment(String line, String item, int ind) {
    if (item.trim() == "*" && checkMultiStar(line, ind)) {
      return true;
    } else if (item.trim() == "/" && checkMultiSlash(line, ind)) {
      return true;
    } else {
      return false;
    }
  }

  /*
   * Takes in the line, the index and the item length and inspects a 
   * line and determins the proper format if there were to be a space
   * after an item (substring representing character(s)). 
   */
  String getProperAfter(String line, int ind, int itemLen) {
    String proper = "";
    if (ind != line.length - 1 && (ind + itemLen) <= line.length - 1) {
      String portion = line.substring(0, ind + itemLen);
      String end = line.substring(ind + itemLen).trim();
      proper = portion + " " + end;
    }
    return proper;
  }

  /*
   * Takes in the line, the index and the item length and inspects
   * a line and determins the proper format if there were to be 
   * a space before an item (substring representing character(s)). 
   */
  String getProperBefore(String line, int ind) {
    String portion = line.substring(0, ind).trim();
    String end = line.substring(ind);
    String proper = portion + " " + end;
    return proper;
  }

  /*
   * Takes in the lines of a file and ensures that each line in it
   * has no trailing blanks.  
   */
  removeTrailingBlank(List<String> lines) {
    fileContent = "";
    String toWrite = "";
    int lineNum = 1;
    int numLines = lines.length;
    for (String line in lines) {
      toWrite = line.trimRight();
      fileContent += toWrite;
      if (lineNum < numLines) {
        fileContent += "\n";
      }
      lineNum++;
    }
  }

  /*
   * Takes in the index and the String and finds the 
   * character at the index within String s and 
   * returns the character as a String. 
   */
  String charAt(String s, int index) {
    if (index == -1) {
      return "";
    } else if (index + 1 > s.length) {
      return s.substring(index);
    } else {
      return s.substring(index, index + 1);
    }
  }

}
