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
    removeMultiLine(contentList);
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
    int lineNum = 1;
    int numLines = lines.length;
    String toWrite = "";
    bool openReached = false;
    bool closeReached = false;
    bool oneLine = false;
    String newline = "";
    for (String line in lines) {
      if (lineNum < numLines) {
        newline = "\n";
      } else {
        newline = "";
      }
      if (line.contains("/*") && line.contains("*/")) {
        if (line.indexOf("/**") != line.indexOf("/*")) {
          openReached = false;
          closeReached = false;
          oneLine = true;
        }
      } else if (line.contains("/*")) {
        if (line.indexOf("/**") != line.indexOf("/*")) {
          openReached = true;
          closeReached = false;
        }
      } else if (line.contains("*/")) {
        if (openReached) {
          openReached = false;
          closeReached = true;
        }
      }
      toWrite = line;
      int open = toWrite.indexOf("/*");
      int close = toWrite.indexOf("*/") + 2;
      if (oneLine) {
        toWrite = line.replaceFirst(line.substring(open, close), "");
      } else if (openReached && !closeReached) {
        toWrite = "";
      } else if (closeReached) {
        toWrite = line.substring(close);
        openReached = false;
        closeReached = false;
      }
      oneLine = false;
      alteredFileContent += toWrite + newline;
    }
  }
}
