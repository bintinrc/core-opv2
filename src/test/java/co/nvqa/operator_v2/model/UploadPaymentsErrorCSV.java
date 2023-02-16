package co.nvqa.operator_v2.model;

import com.opencsv.bean.CsvBindByName;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UploadPaymentsErrorCSV {

  @CsvBindByName(column = "request_id")
  private String requestId;

  @CsvBindByName(column = "batch_id")
  private String batchId;

  @CsvBindByName(column = "shipper_id")
  private String shipperId;

  @CsvBindByName(column = "message")
  private String message;

}
