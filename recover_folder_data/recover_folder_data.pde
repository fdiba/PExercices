import java.nio.*;
import java.nio.file.*;

String destination = "C:/Users/Name/Folder/recover_folder_data/data";
String mainTarget = "Z:/";

void setup() {  

  File dir = new File(mainTarget);
  String[] children = dir.list();
  if (children != null) processIt(mainTarget, children);
}
void processIt(String target, String[] elements) {

  for (int i=0; i<elements.length; i++) {

    String filename = elements[i];
    int position = filename.indexOf(".");

    if (position<0) { //new folder to explore

      String newTarget = target + "/" + filename;
      File dir = new File(newTarget);
      String[] children = dir.list();
      if (children != null) processIt(newTarget, children);
    } else {

      String xls = ".xls";
      String jpg = ".jpg";
      String txt = ".txt";
      String mtd = ".mtd";

      int xlsPos = filename.indexOf(xls);
      int jpgPos = filename.indexOf(jpg);
      int txtPos = filename.indexOf(txt);
      int mtdPos = filename.indexOf(mtd);

      if (xlsPos >=0 || jpgPos >=0 || txtPos >=0 || mtdPos >=0) {

        Path source = Paths.get(target+"/"+filename);

        String lastPartOfTarget = target.substring(mainTarget.length());
        String dest = destination + "/" + lastPartOfTarget;

        Path newDir = Paths.get(dest);

        if (!Files.exists(newDir)) {
          try {
            Files.createDirectories(newDir);
          } 
          catch(IOException ie) {
            println("-----------------");
            println(ie);
            println("-----------------");
          }
        }

        try {
          Files.copy(source, newDir.resolve(source.getFileName()));
        } 
        catch(IOException ie) {
          println("*****************");
          println(ie);
          println("*****************");
        }
      }
    }
  }
}
void draw() {
}

