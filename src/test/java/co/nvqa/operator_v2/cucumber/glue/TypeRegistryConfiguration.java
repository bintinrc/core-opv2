package co.nvqa.operator_v2.cucumber.glue;

import cucumber.api.TypeRegistry;
import cucumber.api.TypeRegistryConfigurer;
import io.cucumber.cucumberexpressions.CaptureGroupTransformer;
import io.cucumber.cucumberexpressions.ParameterType;
import io.cucumber.cucumberexpressions.TypeReference;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Locale;

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
}
