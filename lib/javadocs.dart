
/*
 * JavadocComments class adds javadoc comment 
 * templates before method headers
 * and class headers.  
 */

class JavadocComments {

  /* The content of the file before editing. */
  String fileContent = "";

  /* The content of the file after editing. */
  String alteredFileContent = "";

  /* The format of a class javadoc tempalte. */
  final String classJavadoc = 
  "/**\n" + 
  " * \n" + 
  " * @author\n" + 
  " */";

  /* The regex pattern that matches a method header. */
  RegExp methodPattern = RegExp(
    "(\\p{Space})*(public |protected |private )?" + 
    "(static )?" +
    "(void |[\\w\\W]+ )" +
    "([a-zA-Z0-9]+)" +
    "\\(" + 
    "(([\\w\\W]+ [a-zA-Z0-9]+)|" + 
    "(([\\w\\W]+ [a-zA-Z0-9]+, )+[\\w\\W]+ [a-zA-Z0-9]+))?" + 
    "\\) ?\\{"
  );

  /* The regex pattern that matches a class header. */
  RegExp classPattern = RegExp(
    "(\\p{Space})*(public |protected |private )?" +
    "(static )?" + 
    "(class )" +
    "(extends |implements )?" +
    "([a-zA-Z0-9]+) ?\\{"
  );

  /* The JavadocComments constructor */
  JavadocComments();
  
  /*
   * The main method of the Comments class that executes 
   * the code. Takes in a String of file contents and returns 
   * a String of altered file contents with the changes.
   */
  String main(String file) {
    fileContent = file;
    List<String> contentList = fileContent.split("\n");
    addJavadocs(contentList);
    return alteredFileContent;
  }

  /*
   * A helper method that takes in the file 
   * content as a list and adds javadoc comment
   * templates before class and method headers. 
   * Alters the file content by writing the changed lines
   * to the String alteredFileContent.
   */
  addJavadocs(List<String> lines) {
    alteredFileContent = "";
    bool javadocFound = false;
    int lineNum = 1;
    int numLines = lines.length;
    String javadoc = "";
    for (String line in lines) {
      String newline = "";
      if (lineNum < numLines) {
        newline = "\n";
      }
      if (!line.trimLeft().startsWith("/**") && line.trimLeft().startsWith("/*")) {
        alteredFileContent += line + newline;
      } else if (line.trim().startsWith("/**") && line.trim().endsWith("*/")) {
        javadocFound = false;
        javadoc += line + newline;
      } else if (line.trimLeft().startsWith("/**")) {
        javadocFound = true;
        javadoc += line + newline;
      } else if (line.trimRight().endsWith("*/")) {
        javadocFound = false;
        javadoc += line + newline;
      } else if (javadocFound) {
        javadoc += line + newline;
      } else if (line == "" || line.trim() == "") {
        alteredFileContent += line + newline;
      } else if (methodPattern.stringMatch(line) == line) {
        if (javadoc != "") {
          if (validateJavadocComment(line, javadoc)) {
            alteredFileContent += javadoc;
          } else {
            alteredFileContent += "------- INCORRECT JAVADOC FORMAT -------\n";
            alteredFileContent += javadoc;
            alteredFileContent += "----------------------------------------\n";
          }
          alteredFileContent += line + newline;
          javadoc = "";
        } else {
          String comment = generateMethodJavadoc(line);
          alteredFileContent += comment;
          alteredFileContent += line + newline;
        }
      } else if (classPattern.stringMatch(line) == line) {
        print(line);
        if (javadoc != "") {
          alteredFileContent += javadoc;
          alteredFileContent += line + newline;
          javadoc = "";
        } else {
          alteredFileContent = alteredFileContent + classJavadoc;
          alteredFileContent = alteredFileContent + line + newline;
        }
      } else {
        alteredFileContent = alteredFileContent + line + newline;
        javadoc = "";
      }
      lineNum++;
    }
  }

  /*
   * Helper method that checks whether or not the javadoc is 
   * valid. If it is then returns true otherwise returns false; 
   */
  bool validateJavadocComment(String header, String javadocComment) {
    bool returnVal = containsReturn(header);
    List<String> paramNames = getParamList(header);
    if (returnVal) {
      if (!(javadocComment.contains("@return") || javadocComment.contains("returns")
        || javadocComment.contains("returning")|| javadocComment.contains("return"))) {
        return false;
      }
    }
    for (String name in paramNames) {
      if (!(javadocComment.contains("@param " + name) || javadocComment.contains(name.toUpperCase()))) {
        return false;
      }
    }
    return true;
  }

  /*
   * Helper method that generates a general format
   * for a javadoc for a method using the method header.
   * Returns the javadoc as a String.
   */
  String generateMethodJavadoc(String header) {
    int params = countParameters(header);
    bool returnVal = containsReturn(header);
    int indentation = countIndentations(header);
    List<String> paramNames = getParamList(header);
    String indent = "";
    for (int i = 0; i < indentation; i++) {
      indent += "\t";
    }
    String comment = indent + "/**\n" + indent + " *\n";
    for (int i = 0; i < params; i++) {
      comment = comment + indent + " * @param " + paramNames.removeAt(0) + "\n";
    }
    if (returnVal) {
      comment = comment + indent + " * @return\n";
    }
    comment = comment + indent + " */\n";
    return comment;
  }

  /*
   * Helper method that takes in the method header 
   * and returns how many parameters the method contains.
   */
  int countParameters(String header) {
    return getParamList(header).length;
  }

  /*
   * Helper method that takes in the method header
   * and returns a list of Strings that represent the 
   * names of the parameters mentioned in the header.
   */
  List<String> getParamList(String header) {
    int open = header.indexOf("(");
    int close = header.indexOf(")");
    String paramString = header.substring(open + 1, close);
    List<String> segments = paramString.split(",");
    List<String> names = new List<String>();
    for (var param in segments) {
      List<String> paramSplit = param.split(" ");
      names.add(paramSplit.last);
    }
    return names;
  }

  /*
   * Helper method that takes in the header
   * and returns whether or not this header 
   * contains a return value or is void. 
   */
  bool containsReturn(String header) {
    return !header.contains("void");
  }

  /*
   * Helper method that takes in the header and counts the
   * indentations before the method header begins.
   */
  int countIndentations(String header) {
    int count = 0;
    int spaceCount = 0;
    for (int i = 0;i < header.length; i++) {
      var c = header[i];
      if (c != '\t' && c != ' ') {
        break;
      }
      if (c == '\t') {
        count += 1;
      }
      if (c == ' ') {
        spaceCount++;
      }
    }
    return count + (spaceCount / 4).round();
  }

}