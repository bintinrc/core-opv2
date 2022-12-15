package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;
import lombok.Getter;
import lombok.Setter;

/**
 * @author Son Ha
 */
@Setter
@Getter
public class CoreV2PickupJobsParams extends DataEntity<CoreV2PickupJobsParams> {

  private String id;
  private String status;
  private String priorityLevel;
  private String driverName;
  private String shipperId;
  private String shipperName;
  private String pickupAddress;
  private String tags;

  public CoreV2PickupJobsParams() {
  }

  public CoreV2PickupJobsParams(Map<String, ?> data) {
    fromMap(data);
  }

}
