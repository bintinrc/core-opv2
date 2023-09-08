package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.JsonUtils;
import com.google.common.base.Preconditions;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings({"unused", "WeakerAccess"})
public abstract class AbstractTable<T extends DataEntity<?>> extends OperatorV2SimplePage {

  private Class<T> entityClass;
  protected Map<String, String> columnLocators = new HashMap<>();
  protected Map<String, String> actionButtonsLocators = new HashMap<>();
  protected Map<String, Function<Integer, String>> columnReaders = new HashMap<>();
  protected Map<String, Function<String, String>> columnValueProcessors = new HashMap<>();
  protected String tableLocator;

  public AbstractTable(WebDriver webDriver) {
    super(webDriver);
  }

  public void setTableLocator(String tableLocator) {
    this.tableLocator = tableLocator;
  }

  public Map<String, String> getColumnLocators() {
    return columnLocators;
  }

  public void setEntityClass(Class<T> entityClass) {
    this.entityClass = entityClass;
  }

  public void setColumnLocators(Map<String, String> columnLocators) {
    this.columnLocators.putAll(columnLocators);
  }

  public Map<String, String> getActionButtonsLocators() {
    return actionButtonsLocators;
  }

  public void setActionButtonsLocators(Map<String, String> actionButtonsLocators) {
    this.actionButtonsLocators.putAll(actionButtonsLocators);
  }

  public void setColumnReaders(Map<String, Function<Integer, String>> columnReaders) {
    this.columnReaders.putAll(columnReaders);
  }

  public void setColumnValueProcessors(
      Map<String, Function<String, String>> columnValueProcessors) {
    this.columnValueProcessors = columnValueProcessors;
  }

  public List<String> readColumn(String columnId) {
    if (!columnLocators.containsKey(columnId)) {
      throw new IllegalArgumentException(
          "Unknown Column Id [" + columnId + "]. Available are: " + columnLocators.keySet());
    }
    int rowCount = getRowsCount();
    List<String> values = new ArrayList<>();
    for (int i = 1; i <= rowCount; i++) {
      values.add(getColumnText(i, columnId));
    }
    return values;
  }

  protected abstract String getTextOnTable(int rowNumber, String columnDataClass);

  @SuppressWarnings("SameParameterValue")
  public abstract void selectRow(int rowNumber);

  protected void selectEntity(String columnId, String value) {
    filterByColumn(columnId, value);
    selectRow(1);
  }

  @SuppressWarnings("SameParameterValue")
  protected void selectEntities(String columnId, List<String> values) {
    values.forEach(value -> selectEntity(columnId, value));
  }

  public abstract void clickColumn(int rowNumber, String columnId);

  public String getColumnText(int rowNumber, String columnId) {
    Preconditions.checkArgument(StringUtils.isNotBlank(columnId),
        "'columnId' cannot be null or blank string.");
    String columnLocator = columnLocators.get(columnId);
    Preconditions.checkArgument(StringUtils.isNotBlank(columnLocator),
        "Locator for columnId [" + columnId + "] was not defined.");
    String text;

    if (columnReaders.containsKey(columnId)) {
      text = columnReaders.get(columnId).apply(rowNumber);
    } else {
      if (StringUtils.isNotBlank(tableLocator)) {
        text = executeInContext(tableLocator, () -> getTextOnTable(rowNumber, columnLocator));
      } else {
        text = getTextOnTable(rowNumber, columnLocator);
      }
    }

    if (columnValueProcessors.containsKey(columnId)) {
      text = columnValueProcessors.get(columnId).apply(text);
    }

    if (StringUtils.isNotBlank(text) && text.matches("\\s*-?[\\d.]+\\s*")) {
      return text.trim();
    } else {
      return StringUtils.trimToEmpty(StringUtils.strip(StringUtils.normalizeSpace(text), "-"));
    }
  }

  public abstract void clickActionButton(int rowNumber, String actionId);

  public abstract String getRowLocator(int index);

  public abstract int getRowsCount();

  public Map<String, String> readRow(int rowIndex) {
    return columnLocators.keySet().stream()
        .collect(Collectors.toMap(
            columnId -> columnId,
            columnId -> getColumnText(rowIndex, columnId)
        ));
  }

  public T readEntity(int rowIndex) {
    Map<String, String> data =
        readRow(rowIndex).entrySet().stream()
            .filter(entry -> StringUtils.isNotBlank(entry.getValue()))
            .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
    return JsonUtils.fromMapCamelCase(data, entityClass);
  }

  public List<T> readAllEntities() {
    return IntStream.rangeClosed(1, getRowsCount())
        .mapToObj(this::readEntity)
        .collect(Collectors.toList());
  }

  public List<T> readAllEntities(String keyProperty) {
    boolean done = false;
    List<T> entries = new ArrayList<>();
    while (!done) {
      List<T> nextEntries = readAllEntities();
      if (!entries.isEmpty()) {
        Object last = entries.get(entries.size() - 1).getProperty(keyProperty);
        Object nextLast = nextEntries.get(nextEntries.size() - 1).getProperty(keyProperty);
        if (Objects.equals(last, nextLast)) {
          done = true;
        }
      }
      entries.addAll(nextEntries);
      scrollIntoView(getRowLocator(nextEntries.size()));
    }
    Set<Object> set = new HashSet<>(entries.size());
    return entries.stream().filter(p -> set.add(p.getProperty(keyProperty)))
        .collect(Collectors.toList());
  }

  public List<T> readFirstEntities(int count) {
    int rowsCount = getRowsCount();
    count = Math.min(rowsCount, count);
    return IntStream.rangeClosed(1, count)
        .mapToObj(this::readEntity)
        .collect(Collectors.toList());
  }

  public List<String> readFirstRowsInColumn(String columnId, int count) {
    int rowsCount = getRowsCount();
    count = Math.min(rowsCount, count);
    return IntStream.rangeClosed(1, count)
        .mapToObj(rowIndex -> this.getColumnText(rowIndex, columnId))
        .collect(Collectors.toList());
  }

  public AbstractTable<T> filterByColumn(String columnId, Object value) {
    return filterByColumn(columnId, String.valueOf(value));
  }

  @SuppressWarnings("UnusedReturnValue")
  public AbstractTable<T> filterByColumn(String columnId, String value) {
    Preconditions.checkArgument(StringUtils.isNotBlank(columnId),
        "'columnId' cannot be null or blank string.");
    String columnLocator = columnLocators.get(columnId);
    Preconditions.checkArgument(StringUtils.isNotBlank(columnLocator),
        "Locator for columnId [" + columnId + "] was not defined.");
    executeInContext(getTableLocator(), () -> {
      WebElement we = findElementBy(By.cssSelector(
          f("th.%s > nv-search-input-filter > md-input-container input", columnLocator)));
      sendKeys(we, value);
      pause400ms();
    });
    return this;
  }

  public void clearColumnFilter(String columnId) {
    Preconditions.checkArgument(StringUtils.isNotBlank(columnId),
        "'columnId' cannot be null or blank string.");
    String columnLocator = columnLocators.get(columnId);
    Preconditions.checkArgument(StringUtils.isNotBlank(columnLocator),
        "Locator for columnId [" + columnId + "] was not defined.");
    executeInContext(getTableLocator(), () -> {
      WebElement we = findElementBy(By.cssSelector(
          f("th.%s > nv-search-input-filter > md-input-container input", columnLocator)));
      we.clear();
      pause400ms();
    });
  }

  protected abstract String getTableLocator();

  public boolean isEmpty() {
    return getRowsCount() == 0;
  }
}
