package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class ArmCombination extends DataEntity<ArmCombination> {

  private String armOutput;
  private String destinationHub;
  private String orderTag;

  public ArmCombination() {
  }

  public ArmCombination(Map<String, ?> data) {
    fromMap(data);
  }

  public String getArmOutput() {
    return armOutput;
  }

  public void setArmOutput(String armOutput) {
    this.armOutput = armOutput;
  }

  public String getDestinationHub() {
    return destinationHub;
  }

  public void setDestinationHub(String destinationHub) {
    this.destinationHub = destinationHub;
  }

  public String getOrderTag() {
    return orderTag;
  }

  public void setOrderTag(String orderTag) {
    this.orderTag = orderTag;
  }
}