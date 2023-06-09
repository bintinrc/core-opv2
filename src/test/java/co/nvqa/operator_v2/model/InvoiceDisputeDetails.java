package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import lombok.Getter;
import lombok.Setter;

/**
 * @author Madusha Ushan
 */
@Getter
@Setter
public class InvoiceDisputeDetails extends DataEntity<InvoiceDisputeDetails> {

  private String caseNumber;
  private String numberOfTids;
  private String buildingName;
  private String disputeFiledDate;
  private String shipperId;
  private String invoiceId;
  private String caseStatus;
}