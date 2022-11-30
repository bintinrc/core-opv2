package co.nvqa.operator_v2.model.shipper;

import java.io.Serializable;
import java.util.Objects;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * @author Tristania Siagian
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ServiceTypeLevel implements Serializable {

  private String type;
  private String level;

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    ServiceTypeLevel that = (ServiceTypeLevel) o;
    return Objects.equals(type, that.type) &&
        Objects.equals(level, that.level);
  }

  @Override
  public int hashCode() {
    return Objects.hash(type, level);
  }


}
