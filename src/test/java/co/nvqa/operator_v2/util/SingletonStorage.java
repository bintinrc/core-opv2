package co.nvqa.operator_v2.util;

/**
 * @author Ferdinand Kurniadi
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
public class SingletonStorage {

  private static SingletonStorage instance;
  private String tmpId = null;

  private SingletonStorage() {
  }

  public String getTmpId() {
    return tmpId;
  }

  public void setTmpId(String tmpId) {
    this.tmpId = tmpId;
  }

  public static SingletonStorage getInstance() {
    if (instance == null) {
      instance = new SingletonStorage();
    }

    return instance;
  }
}
