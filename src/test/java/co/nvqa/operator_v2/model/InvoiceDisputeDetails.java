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
  private String numberOfTIDs;
  private String numberOfInvalidTIDs;
  private String numberOfValidTIDs;
  private String numberOfPendingTIDs;
  private String numberOfAcceptedTIDs;
  private String numberOfRejectedTIDs;
  private String numberOfErrorTIDs;
  private String buildingName;
  private String disputeFiledDate;
  private String shipperId;
  private String shipperName;
  private String disputePersonName;
  private String invoiceId;
  private String caseStatus;
}