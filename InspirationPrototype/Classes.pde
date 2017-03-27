import java.util.concurrent.ConcurrentHashMap;

class Poem {
  private String poemId;
  private String poemText;
  private String poemKeyword;
  private long timestamp;
  
  public Poem(String id, long ts, String text, String keyword)
  {
   timestamp = ts;
   poemId = id;
   poemText = text;
   poemKeyword = keyword;
  }
  
  String getId()
  {
   return poemId; 
  }
  
  String getText()
  {
   return poemText; 
  }
  
  String getKeyword()
  {
   return poemKeyword; 
  }
  
  long getTimestamp()
  {
    return timestamp;
  }
}

import java.util.Collection;
import java.util.Enumeration;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

/**
 * The ImageList holds all loaded images.
 * 
 * @author Mathias Markl
 */
public class PoemList {

    private ConcurrentHashMap<String, Poem> poems;
    private Random random;

    public PoemList() {
      poems = new ConcurrentHashMap<String, Poem>();
      random = new Random();
    }

    public void clearList() {
      poems.clear();
    }

    public void addPoem(Poem poem) {
      if (!poems.containsKey(poem.getId())) {
       poems.put(poem.getId(), poem);
      }
    }

    public int size() {
      return poems.size();
    }

    public Enumeration<String> getIds() {
      return poems.keys();
    }

    public Collection<Poem> getCopyList() {
      return poems.values();
    }

    public Poem getPoem(String key) {
      return poems.get(key);
    }

    public Poem getRandom() {
      if (poems.isEmpty()) {
          return null;
      } else {
          return getPoem(random.nextInt(poems.size()));
      }
    }

    public Poem getMostRecentPoem() {
      Poem outputPoem = null;
  
      for (Poem poem : poems.values()) {
        if (outputPoem == null) {
          outputPoem = poem;
        }
  
        if (img.getTimestamp() > outputPoem.getTimestamp()) {
          outputPoem = poem;
        }
      }

      return outputPoem;
    }

    public Poem getPoem(int index) {
      int counter = 0;

      for (Poem poem : poems.values()) {
        if (counter == index) {
          return poem;
        }
       counter++;
      }

      return null;
    }
}