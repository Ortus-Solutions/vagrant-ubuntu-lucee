component {
    public any function init() {
        _setupYamlParser();

        return this;
    }

    public any function YAMLToCFML( required string yaml ) {
    	var results = _getYamlParser().load( arguments.yaml );
        return results ?: {};
    }

    public any function CFMLToYAML( required any data ) {
        return _getYamlParser().dump( arguments.data );
    }

	// PRIVATE
    private void function _setupYamlParser() {
        var javaLib = [ "snakeyaml-1.15.jar" ];
        var parser  = CreateObject( "java", "org.yaml.snakeyaml.Yaml", javaLib ).init();

        _setYamlParser( parser );
    }

    private any function _getYamlParser() output=false {
        return _yamlParser;
    }
    private void function _setYamlParser( required any yamlParser ) output=false {
        _yamlParser = arguments.yamlParser;
    }
}