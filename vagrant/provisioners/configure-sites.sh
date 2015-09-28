#!/usr/bin/env box
<cftry>
<cfscript>
	
	system 	= createObject( "java", "java.lang.System" )
	CLIParams = listToArray( system.getProperty( 'cfml.cli.argument.list' ) )
	if( arrayLen( CLIParams ) ) {
		vagrantParentPath = CLIParams[1]
	} else {
		vagrantParentPath = '<Your repo clone dir>'
	} 

	// Helper functions for provisioning the sites
	util = new vagrant.provisioners.lib.ProvisionerUtil()
	
	util._echo( '' )
	util._echo( "================= START CONFIGURE-SITES.SH #now()# =================" )
	util._echo( '' )
	
	//Clean up previous mess
	util.removePreviousConfig()
	
	// Get all the YAML configs
	siteConfigPaths = util.getSiteConfigs()
	siteConfigs = {}
	
	// Loop over each sites' config
	for( siteConfigPath in siteConfigPaths ) {
	
		// Default site name to config path for error logging in case we never made it past the parsing
		siteName = siteConfigPath
	
		// Configure each site in a try/catch so if one errors, the rest can still complete	
		try {
			// Parse the YAML
			config = util.getYAMLParser().yamlToCfml( fileRead( siteConfigPath ) )
			config[ '__configFile__' ] = siteConfigPath
			config = util.defaultConfig( config )
			siteName = config['name']
			
			// Set up the Nginx servers
			util.configureNginx( config, siteConfigPath )
			
			// Process the CF mappings 
			util.configureMappings( config, siteConfigPath )
			
			// Process the CF data sources
			util.configureDataSources( config, vagrantParentPath )
			
			// Process the CF mappings 
			util.configureHosts( config )
		
			// Add error=false to the config struct for the index page we'll create that lists all the sites
			siteConfigs[ siteConfigPath ] = { 'error' : false }.append( config )
						
			util._echo( "" )	
		} catch( Any e ) { 
			util._echo( "================= Error configuring site '#siteName#'.  Error to follow. =================" )
			util._echo( e.message )
			util._echo( e.detail )
			util._echo( e.stackTrace )
			util._echo( "================= end '#siteName#' error =================" )
			
			// If configuration failed, flag it and add the error struct.
			siteConfigs[ siteConfigPath ] = { 'error' : true, 'errorStruct' : e, 'name' : listLast( siteConfigPath, '/' ) }
		}
	}
	
	// Write out an index page for the default site that will list all the apps we configured on the VM
	util.writeDefaultIndex( siteConfigs )
		
	util._echo( '' )
	util._echo( "================= FINISH CONFIGURE-SITES.SH #now()# =================" )
	util._echo( '' )

	
</cfscript>
<cfcatch>
	<!--- This is a workaround for the default CLI template being broken in CommandBox.  COMMANDBOX-220 --->
	<cfdump var="#cfcatch#" format="text">
</cfcatch>
</cftry>