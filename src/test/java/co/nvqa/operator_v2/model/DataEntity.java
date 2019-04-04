package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.Pair;
import co.nvqa.commons.util.JsonUtils;
import co.nvqa.commons.util.NvAssert;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvMatchers;
import co.nvqa.commons.util.NvTestRuntimeException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.reflect.FieldUtils;
import org.apache.commons.lang3.reflect.MethodUtils;
import org.apache.commons.text.translate.CsvTranslators;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings({"unused", "WeakerAccess"})
public abstract class DataEntity<T extends DataEntity> implements NvAssert, NvMatchers
{
    private static final CsvTranslators.CsvUnescaper UNESCAPER = new CsvTranslators.CsvUnescaper();

    public DataEntity()
    {
    }

    public DataEntity(Map<String, ?> data)
    {
        fromMap(data);
    }

    public DataEntity(T entity)
    {
        merge(entity);
    }

    private static Method findSetter(Class<?> clazz, String property, Class<?> valueType)
    {
        Method[] methods = clazz.getMethods();
        String setterName = sanitizeString("set" + property);

        for (Method method : methods)
        {
            if (StringUtils.equals(setterName, sanitizeString(method.getName()))
                    && method.getParameterCount() == 1
                    && method.getParameterTypes()[0].isAssignableFrom(valueType))
            {
                return method;
            }
        }

        return null;
    }

    private static Method findGetter(Class<?> clazz, String property)
    {
        Method[] methods = clazz.getMethods();
        String getterName = sanitizeString("get" + property);

        for (Method method : methods)
        {
            if (StringUtils.equals(getterName, sanitizeString(method.getName())) && method.getParameterCount() == 0)
            {
                return method;
            }
        }

        return null;
    }

    private static Field findPropertyField(Class<?> clazz, String property)
    {
        String propertyName = sanitizeString(property);
        Field[] fields = FieldUtils.getAllFields(clazz);
        Field field = null;

        for (Field f : fields)
        {
            if (StringUtils.equals(propertyName, sanitizeString(f.getName())))
            {
                field = f;
                break;
            }
        }

        return field;
    }

    protected static String sanitizeString(String value)
    {
        return StringUtils.normalizeSpace(value.trim().toLowerCase()).replaceAll("\\s", "_");
    }

    protected static String[] splitCsvLine(String csvLine)
    {
        return csvLine.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)");
    }

    protected static String getValueIfIndexExists(String[] values, int index)
    {
        return values.length > index ? StringUtils.trimToNull(StringUtils.strip(UNESCAPER.translate(values[index]), "\"")) : null;
    }

    public static <T extends DataEntity<?>> List<T> fromCsvFile(Class<T> clazz, String fileName, boolean ignoreHeader)
    {
        try
        {
            List<String> csvLines = FileUtils.readLines(new File(fileName), Charset.defaultCharset());

            if (ignoreHeader)
            {
                csvLines.remove(0);
            }
            return csvLines.stream().map(csvLine ->
            {
                try
                {
                    T dataEntity = clazz.getDeclaredConstructor().newInstance();
                    dataEntity.fromCsvLine(csvLine);
                    return dataEntity;
                } catch (InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException ex)
                {
                    String message = String.format("Could not create new instance of %s data entity.", clazz.getName());
                    NvLogger.error(message);
                    throw new NvTestRuntimeException(ex);
                }
            }).collect(Collectors.toList());
        } catch (IOException ex)
        {
            NvLogger.warn("Could not read file [" + fileName + "]");
            return new ArrayList<>();
        }
    }

    public static <T extends DataEntity<?>> T fromMap(Class<T> clazz, Map<String, String> data)
    {
        try
        {
            T dataEntity = clazz.getDeclaredConstructor().newInstance();
            dataEntity.fromMap(data);
            return dataEntity;
        } catch (InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException ex)
        {
            String message = String.format("Could not create new instance of %s data entity", clazz.getName());
            NvLogger.error(message);
            throw new NvTestRuntimeException(ex);
        }
    }

    public void fromMap(Map<String, ?> data)
    {
        data.forEach(this::setProperty);
    }

    public void fromJson(String json)
    {
        fromMap(JsonUtils.fromJsonCamelCaseToMap(json));
    }

    public void fromJson(ObjectMapper mapper, String json)
    {
        fromMap(JsonUtils.fromJsonToMap(mapper, json));
    }

    @SuppressWarnings("unchecked")
    public void merge(T entity)
    {
        fromMap(entity.toMap());
    }

    public Map<String, ?> toMap()
    {
        return FieldUtils.getAllFieldsList(this.getClass()).stream()
                .map(field -> new Pair<>(field.getName(), getProperty(field.getName())))
                .filter(pair -> pair.second != null)
                .collect(Collectors.toMap(
                        pair -> pair.first,
                        pair -> pair.second
                ));
    }

    private void setProperty(String property, Object value)
    {
        Class<?> clazz = this.getClass();

        try
        {
            if (property.contains("."))
            {
                String entityName = property.substring(0, property.indexOf("."));
                String nestedPropertyName = property.substring(property.indexOf(".") + 1);
                DataEntity<?> entity = initNestedDataEntity(entityName);
                if (entity != null) {
                    entity.setProperty(nestedPropertyName, value);
                }
                return;
            }

            Method setter = findSetter(clazz, property, value.getClass());

            if (setter != null)
            {
                MethodUtils.invokeMethod(this, true, setter.getName(), value);
            } else
            {
                Field field = findPropertyField(clazz, property);

                if (field != null)
                {
                    if (field.getType().isAssignableFrom(value.getClass()))
                    {
                        FieldUtils.writeField(field, this, value, true);
                    }
                }
            }
        } catch (Exception ex)
        {
            String message = String.format("Could not set %s property to %s data entity", property, this.getClass().getName());
            NvLogger.error(message);
        }
    }

    private DataEntity<?> initNestedDataEntity(String property)
    {
        Field field = findPropertyField(this.getClass(), property);

        DataEntity<?> nestedEntity = null;

        if (field != null)
        {
            try
            {
                nestedEntity = (DataEntity<?>) FieldUtils.readField(field, this, true);
                if (nestedEntity == null){
                    nestedEntity = (DataEntity<?>) field.getType().newInstance();
                    FieldUtils.writeField(field, this, nestedEntity, true);
                }
            } catch (Exception ex){
                NvLogger.error(ex.getMessage());
                nestedEntity = null;
            }
        }

        return nestedEntity;
    }

    @SuppressWarnings("unchecked")
    private <U> U getProperty(String property)
    {
        Class<?> clazz = this.getClass();

        try
        {
            Method getter = findGetter(clazz, property);

            if (getter != null)
            {
                return (U) MethodUtils.invokeMethod(this, true, getter.getName());
            } else
            {
                Field field = findPropertyField(clazz, property);

                if (field != null)
                {
                    return (U) FieldUtils.readField(field, this, true);
                }
            }
        } catch (Exception ex)
        {
            String message = String.format("Could not get %s property of %s data entity", property, this.getClass().getName());
            NvLogger.error(message);
        }

        return null;
    }

    public void fromCsvLine(String csvLine)
    {
    }

    @SuppressWarnings("unchecked")
    public void compareWithActual(T actualEntity, String... ignoredProperties)
    {
        Map<String, ?> expectedData = toMap();
        Map<String, ?> actualData = actualEntity.toMap();

        expectedData.forEach((propertyName, expectedValue) ->
        {
            if (expectedValue != null && !ArrayUtils.contains(ignoredProperties, propertyName))
            {
                String message = StringUtils.capitalize(StringUtils.join(StringUtils.splitByCharacterTypeCamelCase(propertyName), " "));

                if (expectedValue instanceof String)
                {
                    String actualValue = StringUtils.normalizeSpace(String.valueOf(actualData.get(propertyName)).trim());
                    String strExpectedValue = StringUtils.normalizeSpace(String.valueOf(expectedValue).trim());
                    assertThat(message, actualValue, equalTo(strExpectedValue));
                } else
                {
                    assertThat(message, actualData.get(propertyName), equalTo(expectedValue));
                }
            }
        });
    }
}
