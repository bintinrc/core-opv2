package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@Getter
@Setter
public class DriverAnnouncement extends DataEntity<DriverAnnouncement> {

  private Long driverAnnouncementId;
  private String fromName;
  private String subject;
  private String priority;
  private Long sentTime;
  private Long readTime;
  private Integer readCount;
  private Integer sendCount;
  private String csvUrl;
}
