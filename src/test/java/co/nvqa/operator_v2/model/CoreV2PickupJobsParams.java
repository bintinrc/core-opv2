package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

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

  public CoreV2PickupJobsParams() {
  }

  public CoreV2PickupJobsParams(Map<String, ?> data) {
    fromMap(data);
  }

}
