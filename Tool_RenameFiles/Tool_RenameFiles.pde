import java.io.*;
String index = "0";
PrintWriter code;

void setup() {
  code = createWriter("code.txt");
  String path = "Products/Gaming Laptop";
  File folder = new File(sketchPath(path));
  File[] files = folder.listFiles();

  for (int i = 0; i < files.length; i++) {
    String test = files[i].getName();
    String newString = "";
    if (test.contains("_₱ ")) {
      newString = test.replaceAll("_₱ ", "_₱");
    } else if (test.contains("_P")) {
      newString = test.replaceAll("_P", "_₱");
    }
    File newFile = new File(sketchPath(path) + "/" + newString);
    files[i].renameTo(newFile);
  }
  folder = new File(sketchPath(path));
  files = folder.listFiles();

  for (int i = 0; i < files.length; i++) {
    File file = files[i];
    String[] fileName = file.getName().split("_");
    String name = fileName[0];
    String price = "";

    if (fileName.length > 1) {
      price = fileName[1].substring(0, fileName[1].length() - 4);
    } else {
      println(file.getName());
    }

    code.println("<div class=\"product\">");
    code.println("<img src=\"" + path + "/" + file.getName() + "\">");
    code.println("<h2>" + name + "<br />" + price + "</h2>");
    code.println("</div>");
    index = str(int(index) + 1);
  }

  println(index + " products");

  code.flush();
  code.close();
  exit();
}
