package co.nvqa.operator_v2.model;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class RouteLogsUi {

  private Long id;
  private String date;
  private Long routeId;
  private String status;
  private String driverName;
  private List<String> tags;
  private String routePassword;
  private String hub;
  private String zone;
  private String driverTypeName;
  private String Comments;
}
