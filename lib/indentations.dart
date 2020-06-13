/*
 * The Indentations class that fixes indentations within
 * the contents of a java file passed in. 
 */
class Indentations {

  /* The file content after the changes are made to the file. */
  String fileContent = "";

  /*
   * The constructor of the indentations class which 
   * creates an instance of an Indentations object. 
   */
  Indentations();
  
  /*
   * The main method of the Indentations class. Calls
   * the methods and runs the software that will fix the
   * indentations in the java file contents.
   */
  String main(String file) {
    fileContent = file;
    fixIndentations(fileContent.split("\n"));
    return fileContent;
  }

  /*
   * The method that runs the majority of the indentation
   * code that takes in the lines of content and 
   * fixes the indentation in each line. 
   */
  fixIndentations(List<String> lines) {
    fileContent = "";
    int levels = 0;
    String lineToWrite = "";
    String newline = "";
    int lineNum = 1;
    int numLines = lines.length;
    bool comment = false;
    for (String l in lines) {
      if (lineNum < numLines) {
        newline = "\n";
      }
      if (l.trim() == "") {
        lineToWrite = l + newline;
      } else {
        String line = l.trim();
        if (line.indexOf("//") == 0) {
          lineToWrite = generateIndentation(levels) + line + newline;
        } else if (line.trim().endsWith("*/")) {
          lineToWrite = generateIndentation(levels) + line + newline;
          comment = false;
        } else if (line.startsWith("/**") || line.startsWith("/*")) {
          lineToWrite = generateIndentation(levels) + line + newline;
          comment = true;
        } else if (!comment && elseIndentMark(line)) {
          levels -= 1;
          lineToWrite = generateIndentation(levels) + line + newline;
          levels += 1;
        } else if (!comment && isIndentMark(line)) {
          lineToWrite = generateIndentation(levels) + line + newline;
          levels += 1;
        } else if (!comment && isEndIndentMark(line)) {
          levels -= 1;
          lineToWrite = generateIndentation(levels) + line + newline;
        } else {
          lineToWrite = generateIndentation(levels) + line + newline;
        }
      }
      fileContent += lineToWrite;
      lineNum += 1;
    }
  }

  /*
   * Returns true if this line indicates an indent
   * in the next line and false otherwise. 
   */
  bool isIndentMark(String line) {
    if (line.trim().endsWith("{")) {
      return true;
    } else if (line.contains("//")) {
      String subLine = line.substring(0, line.indexOf("//"));
      if (subLine.trim().endsWith("{")) {
        return true;
      }
    }
    return false;
  }

  bool isEndIndentMark(String line) {
    if (line.trim() == "}" || line.trim() == "};") {
      return true;
    }
    return false;
  }

  bool elseIndentMark(String line) {
    if (line.contains("}")) {
      if (line.contains("else") && line.indexOf("}") < line.indexOf("else")) {
        return true;
      }
      if (line.contains("else if") && line.indexOf("}") < line.indexOf("else if")) {
        return true;
      }
    } else {
      return false;
    }
    return false;
  }

  /*
   * Takes in a line and returns a breakdown of the line based
   * on the braces in the line, assuming that there are 
   * multiple instances of { and } in the line.
   */
  String getMultiBraceBreakdown(String line, int numBraces) {
    String linesToWrite = "";
    List<int> braceIndices = getBraceIndices(line);
    while (braceIndices.length != 0) {
      int index = braceIndices[0];
      String brace = charAt(line, index);
      if (brace == "{") {
        String openBraceLine = "";
        if (index == line.length - 1) {
          openBraceLine = line.substring(0);
          linesToWrite += generateIndentation(numBraces) + openBraceLine.trim() + "\n";
          numBraces += 1;
        } else {
          openBraceLine = line.substring(0, index + 1);
          linesToWrite += generateIndentation(numBraces) + openBraceLine.trim() + "\n";
          numBraces += 1;
          line = line.substring(index + 1);
        }
        braceIndices = getBraceIndices(line);
      } else {
        String closedBraceLine = "";
        closedBraceLine = line.substring(0, index);
        linesToWrite += generateIndentation(numBraces) + closedBraceLine.trim() + "\n";
        numBraces -= 1;
        linesToWrite += generateIndentation(numBraces) + "}" + "\n";
        if (index != line.length - 1) {
          line = line.substring(index + 1);
        }
        braceIndices = getBraceIndices(line);
      }
    }
    if (line != "") {
      linesToWrite += generateIndentation(numBraces) + line.trim() + "\n";
    }
    return linesToWrite;
  }

  /*
   * Takes in a line and returns a breakdown of the line based
   * on an open brace, assuming that there is only a 
   * single instance of that brace in the line. 
   */
  String getOpenBraceBreakdown(String line, int numBraces) {
    String lineToWrite = "";
    String indentation = generateIndentation(numBraces);
    int openBraceIndex = line.indexOf("{") + 1;
    lineToWrite += indentation + line.substring(0, openBraceIndex).trim() + "\n";
    numBraces += 1;
    String remainingCode = removeAfterBrace(line, "{");
    if (remainingCode != "") {
      indentation = generateIndentation(numBraces);
      lineToWrite += indentation + remainingCode.trim() + "\n";
    }
    return lineToWrite;
  }

  /*
   * Takes in a line and returns a breakdown of the line based
   * on an closed brace, assuming that there is only a 
   * single instance of that brace in the line. 
   */
  String getClosedBraceBreakdown(String line, int numBraces) {
    String lineToWrite = "";
    String indentation = generateIndentation(numBraces);
    String codeBefore = removeBeforeBrace(line, "}");
    if (codeBefore != "") {
      lineToWrite += indentation + codeBefore.trim() + "\n";
    }
    numBraces -= 1;
    indentation = generateIndentation(numBraces);
    lineToWrite += indentation + "}" + "\n";
    String codeAfter = removeAfterBrace(line, "}");
    if (codeAfter != "") {
      lineToWrite += indentation + codeAfter.trim() + "\n";
    }
    return lineToWrite;
  }

  /*
   * Takes in a line and returns a list of all the indices
   * in the line that contain a "{" or a "}" character. 
   * Assumes that the line has characters but if it does 
   * not find any characters, returns an empty list. 
   */
  List<int> getBraceIndices(String line) {
    List<int> indices = new List<int>();
    for (int i = 0; i < line.length; i++) {
      if (charAt(line, i) == "{" || charAt(line, i) == "}") {
        indices.add(i);
      }
    }
    return indices;
  }

  /*
   * Gets the net brace count. Checks through the line
   * for braces and calculates the net indentation after
   * accounting for each brace. Assumes that there are 
   * multiple open and closed braces in the line.
   */
  int getNetBrace(String line, int numBraces) {
    for (int i = 0; i < line.length; i++) {
      if (charAt(line, i) == "{") {
        numBraces += 1;
      }
      if (charAt(line, i) == "}") {
        numBraces -= 1;
      }
    }
    return numBraces;
  }

  /*
   * Helper method that returns true if the line provided 
   * contains only one brace (either open or closed) and 
   * false otherwise. Assumes that there is a brace in the line.
   */
  bool isSingleBraceLine(String line) {
    int braceCount = 0;
    for (int i = 0; i < line.length; i++) {
      if (charAt(line, i) == "{" || charAt(line, i) == "}") {
        braceCount += 1;
      }
    }
    return braceCount == 1;
  }

  /*
   * Takes in the number of indentation levels needed
   * and returns the generated indentation to add to 
   * the front of a line. 
   */
  String generateIndentation(int levels) {
    String indent = "";
    for (int i = 0; i < levels; i++) {
      indent += "    ";
    }
    return indent;
  }

  /*
   * Takes in the line as a String and removes and returns the 
   * code after the "{" or "}" characters assuming that the
   * character exists in the line. Does not include 
   * the character itself.
   */
  String removeAfterBrace(String line, String brace) {
    int index = line.indexOf(brace, 0);
    if (line.length - 1 <= index) {
      return "";
    } else {
      return line.substring(index + 1);
    }
  }

  /*
   * Takes in the line as a String and removes and returns the
   * code before the "{" or "}" characters assuming that the 
   * character exists in the line. Does not include the character
   * itself.
   */
  String removeBeforeBrace(String line, String brace) {
    int index = line.indexOf(brace);
    return line.substring(0, index);
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