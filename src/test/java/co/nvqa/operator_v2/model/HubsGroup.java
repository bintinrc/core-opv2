package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.operator_v2.util.TestUtils;
import java.util.Arrays;
import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;

/**
 * @author Sergey Mishanin
 */
public class HubsGroup extends DataEntity<HubsGroup> {

  private Long id;
  private String name;
  private List<String> hubs;

  public Long getId() {
    return id;
  }

  public HubsGroup setId(Long id) {
    this.id = id;
    return this;
  }

  public HubsGroup setId(String id) {
    return setId(Long.valueOf(id));
  }

  public String getName() {
    return name;
  }

  public HubsGroup setName(String name) {
    if ("GENERATED".equalsIgnoreCase(name)) {
      name = "HG-" + TestUtils.generateDateUniqueString();
    }
    this.name = name;
    return this;
  }

  public List<String> getHubs() {
    return hubs;
  }

  public void setHubs(String hubs) {
    this.hubs = Arrays.asList(hubs.split(","));
    this.hubs.sort(String::compareTo);
  }

  @Override
  public String toString() {
    return new ToStringBuilder(this)
        .append("id", id)
        .append("name", name)
        .append("hubs", hubs)
        .toString();
  }
}
