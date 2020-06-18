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

  /*
   * Returns whether or not this line marks 
   * the end of an indentation or not. 
   */
  bool isEndIndentMark(String line) {
    if (line.trim() == "}" || line.trim() == "};") {
      return true;
    }
    return false;
  }

  /*
   * Returns whether or not this line contains an else indentation or not. 
   * else indentation refers to whether or not there is a closed brace and requires different
   * indentation due to it's association with an else statement.
   */
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