package co.nvqa.operator_v2.cucumber.glue;

import com.fasterxml.jackson.databind.ObjectMapper;
import cucumber.api.TypeRegistry;
import cucumber.api.TypeRegistryConfigurer;
import io.cucumber.cucumberexpressions.CaptureGroupTransformer;
import io.cucumber.cucumberexpressions.ParameterType;
import io.cucumber.cucumberexpressions.TypeReference;
import io.cucumber.datatable.TableCellByTypeTransformer;
import io.cucumber.datatable.TableEntryByTypeTransformer;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 *
 * @author Sergey Mishanin
 */
@SuppressWarnings("unused")
public class TypeRegistryConfiguration implements TypeRegistryConfigurer
{
    @Override
    public void configureTypeRegistry(TypeRegistry typeRegistry)
    {
        JacksonTableTransformer jacksonTableTransformer = new JacksonTableTransformer();
        typeRegistry.setDefaultDataTableEntryTransformer(jacksonTableTransformer);

        typeRegistry.defineParameterType(new ParameterType<>("strings",
                Collections.singletonList("\"([^\"\\\\]*(\\\\.[^\"\\\\]*)*)\"|'([^'\\\\]*(\\\\.[^'\\\\]*)*)'"),
                new TypeReference<List<String>>(){}.getType(),
                (CaptureGroupTransformer<List<String>>) s ->
                        Arrays.asList(s[0]
                                .replaceAll("\\\\\"", "\"")
                                .replaceAll("\\\\'", "'")
                                .split(", ")),
                false,
                false)
        );

    }

    @Override
    public Locale locale()
    {
        return Locale.ENGLISH;
    }

    private static final class JacksonTableTransformer implements TableEntryByTypeTransformer, TableCellByTypeTransformer
    {

        private final ObjectMapper objectMapper = new ObjectMapper();

        @Override
        public <T> T transform(Map<String, String> entry, Class<T> type, TableCellByTypeTransformer cellTransformer) {
            return objectMapper.convertValue(entry, type);
        }

        @Override
        public <T> T transform(String value, Class<T> cellType) {
            return objectMapper.convertValue(value, cellType);
        }
    }
}
