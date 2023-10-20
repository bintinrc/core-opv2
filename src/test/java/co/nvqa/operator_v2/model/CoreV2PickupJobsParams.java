package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
@AllArgsConstructor
public class CoreV2PickupJobsParams extends DataEntity<CoreV2PickupJobsParams> {

  private String id;
  private String status;
  private String priorityLevel;
  private String driverName;
  private String shipperId;
  private String shipperName;
  private String pickupAddress;
  private String tags;
  private String routeId;
  private String latestBy;
  private String readyBy;

  public CoreV2PickupJobsParams() {
  }

  public CoreV2PickupJobsParams(Map<String, ?> data) {
    fromMap(data);
  }

}
