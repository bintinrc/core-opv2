package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.JsonUtils;
import co.nvqa.operator_v2.model.DataEntity;
import com.google.common.base.Preconditions;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings({"unused", "WeakerAccess"})
public abstract class AbstractTable<T extends DataEntity> extends OperatorV2SimplePage
{
    private Class<T> entityClass;
    protected Map<String, String> columnLocators = new HashMap<>();
    protected Map<String, String> actionButtonsLocators = new HashMap<>();
    protected Map<String, Function<Integer, String>> columnReaders = new HashMap<>();

    public AbstractTable(WebDriver webDriver)
    {
        super(webDriver);
    }

    public Map<String, String> getColumnLocators()
    {
        return columnLocators;
    }

    public void setEntityClass(Class<T> entityClass)
    {
        this.entityClass = entityClass;
    }

    public void setColumnLocators(Map<String, String> columnLocators)
    {
        this.columnLocators.putAll(columnLocators);
    }

    public Map<String, String> getActionButtonsLocators()
    {
        return actionButtonsLocators;
    }

    public void setActionButtonsLocators(Map<String, String> actionButtonsLocators)
    {
        this.actionButtonsLocators.putAll(actionButtonsLocators);
    }

    public void setColumnReaders(Map<String, Function<Integer, String>> columnReaders)
    {
        this.columnReaders.putAll(columnReaders);
    }

    protected abstract String getTextOnTable(int rowNumber, String columnDataClass);

    @SuppressWarnings("SameParameterValue")
    public abstract void selectRow(int rowNumber);

    protected void selectEntity(String columnId, String value)
    {
        filterByColumn(columnId, value);
        selectRow(1);
    }

    @SuppressWarnings("SameParameterValue")
    protected void selectEntities(String columnId, List<String> values)
    {
        values.forEach(value -> selectEntity(columnId, value));
    }

    public String getColumnText(int rowNumber, String columnId)
    {
        Preconditions.checkArgument(StringUtils.isNotBlank(columnId), "'columnId' cannot be null or blank string.");
        String columnLocator = columnLocators.get(columnId);
        Preconditions.checkArgument(StringUtils.isNotBlank(columnLocator), "Locator for columnId [" + columnId + "] was not defined.");
        String text;

        if(columnReaders.containsKey(columnId))
        {
            text = columnReaders.get(columnId).apply(rowNumber);
        }
        else
        {
            text = getTextOnTable(rowNumber, columnLocator);
        }

        return StringUtils.trimToEmpty(StringUtils.strip(StringUtils.normalizeSpace(text.trim()), "-"));
    }

    public abstract void clickActionButton(int rowNumber, String actionId);

    public abstract int getRowsCount();

    public Map<String, String> readRow(int rowIndex)
    {
        return columnLocators.keySet().stream()
                .collect(Collectors.toMap(
                        columnId -> columnId,
                        columnId -> getColumnText(rowIndex, columnId)
                ));
    }

    public T readEntity(int rowIndex)
    {
        Map<String, String> data =
                readRow(rowIndex).entrySet().stream()
                        .filter(entry -> StringUtils.isNotBlank(entry.getValue()))
                        .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
        return JsonUtils.fromMapCamelCase(data, entityClass);
    }

    public List<T> readAllEntities()
    {
        return IntStream.rangeClosed(1, getRowsCount())
                .mapToObj(this::readEntity)
                .collect(Collectors.toList());
    }

    public List<T> readFirstEntities(int count)
    {
        int rowsCount = getRowsCount();
        count = rowsCount>=count? count : rowsCount;
        return IntStream.rangeClosed(1, count)
                .mapToObj(this::readEntity)
                .collect(Collectors.toList());
    }

    public List<String> readFirstRowsInColumn(String columnId, int count)
    {
        int rowsCount = getRowsCount();
        count = rowsCount>=count? count : rowsCount;
        return IntStream.rangeClosed(1, count)
                .mapToObj(rowIndex -> this.getColumnText(rowIndex, columnId))
                .collect(Collectors.toList());
    }

    @SuppressWarnings("UnusedReturnValue")
    public AbstractTable filterByColumn(String columnId, String value)
    {
        Preconditions.checkArgument(StringUtils.isNotBlank(columnId), "'columnId' cannot be null or blank string.");
        String columnLocator = columnLocators.get(columnId);
        Preconditions.checkArgument(StringUtils.isNotBlank(columnLocator), "Locator for columnId [" + columnId + "] was not defined.");
        searchTableCustom1(columnLocator, value);
        return this;
    }
}
