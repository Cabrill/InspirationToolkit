import java.util.concurrent.ConcurrentHashMap;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Random;

class OnScreenImage {
  private float imageX;
  private float imageY;
  private float imageHeight;
  private float imageWidth;
  private float effectiveX;
  private Image image;
  private boolean isZoomed;
  private String sourceKeyword;
  
  public OnScreenImage(Image img, float x, float y, String keyword)
  {
    image = img;
    imageX = x;
    imageY = y;
    isZoomed = false;
    sourceKeyword = keyword;
  }
  
  public float getX()
  {
    return imageX;
  }
  
  public float getY()
  {
    return imageY;
  }
  
  public float getWidth()
  {
    return imageWidth;
  }
  
  public float getHeight()
  {
    return imageHeight;
  }
  
  public float getEffectiveX()
  {
    return effectiveX;
  }
  
  public boolean getIsZoomed()
  {
   return isZoomed; 
  }
  
  public String getSourceKeyword()
  {
   return sourceKeyword; 
  }
  
  public Image getImage()
  {
    return image;
  }

  public void setX(float x)
  {
    imageX = x;
  }
  
  public void setY(float y)
  {
    imageY = y;
  }
  
  public void setWidth(float w)
  {
    imageWidth = w;
  }
  
  public void setHeight(float h)
  {
    imageHeight = h;
  }
    
  public void setEffectiveX(float ex)
  {
    effectiveX = ex;
  }
  
  public void setIsZoomed(boolean zoomed)
  {
    isZoomed = zoomed; 
  }
}

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
  
        if (poem.getTimestamp() > outputPoem.getTimestamp()) {
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