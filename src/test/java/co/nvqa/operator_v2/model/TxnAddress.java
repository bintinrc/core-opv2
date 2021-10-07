package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class TxnAddress extends DataEntity<TxnAddress> {

  private Double score;
  private String address;

  public TxnAddress() {
  }

  public TxnAddress(Map<String, ?> data) {
    super(data);
  }

  public Double getScore() {
    return score;
  }

  public void setScore(Double score) {
    this.score = score;
  }

  public void setScore(String score) {
    setScore(Double.parseDouble(score));
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }
}
