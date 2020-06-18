
/*
 * RmMultiLineComments removes normal multiline comments denoted by a 
 * slash followed by a single star (/ *).
 */

class RmMultiLineComments {

  /* The content of the file before editing. */
  String fileContent = "";

  /* The content of the file after editing. */
  String alteredFileContent = "";

  /* The RmMultiLineComments constructor */
  RmMultiLineComments();
  
  /*
   * The main method of the Comments class that executes 
   * the code. Takes in a String of file contents and returns 
   * a String of altered file contents with the changes.
   */
  String main(String file) {
    fileContent = file;
    List<String> contentList = fileContent.split("\n");
    removeSingleLines(contentList);
    return alteredFileContent;
  }

  /*
   * A helper method that takes in the 
   * lines as a list and removes all the single line
   * comments from the given content. Alters
   * the data directly by writing the content
   * to the String alteredFileContent.
   */
  removeMultiLine(List<String> lines) {
    alteredFileContent = "";
    int numLines = lines.length;
    int lineNum = 1;
    for (String line in lines) {
      String newline = "";
      if (lineNum < numLines) {
        newline = "\n";
      }
      if (line.contains("//")) {
        int commentIndex = line.indexOf("//", 0);
        if (commentIndex != 0) {
          String subString = line.substring(0, commentIndex);
          if (subString.trim() == "") {
            alteredFileContent = alteredFileContent + subString;
            alteredFileContent = alteredFileContent + newline;
          }
        }
      } else {
        alteredFileContent = alteredFileContent + line;
        alteredFileContent = alteredFileContent + newline;
      }
      lineNum++;
    }
  }
}
