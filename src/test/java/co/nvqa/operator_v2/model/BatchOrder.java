package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class BatchOrder extends DataEntity<BatchOrder> {

  private String trackingId;
  private String type;
  private String fromName;
  private String fromAddress;
  private String toName;
  private String toAddress;
  private String status;
  private String granularStatus;
  private String createdAt;

  public BatchOrder(Map<String, ?> data) {
    super(data);
  }

}
