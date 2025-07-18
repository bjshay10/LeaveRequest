component 
{
	this.name = "EmployeeLeaveRequest" & left( hash( getCurrentTemplatePath()), 64 );

	this.searchImplicitScopes=TRUE; // run Cf like it used to prior to 2021 update 13 - THIS SHOULD ONLY BE A TEMPORARY FIX !!

	this.applicationTimeout = CreateTimeSpan( 1, 0, 0, 0 ); // 1 day

	this.customTagPaths = [ expandPath( '/CustomTags' ) ];


	this.sessionManagement = true;
	this.sessionTimeout = CreateTimeSpan( 0, 2, 0, 0 ); // 2 hours
	

	// this.datasource = "mesa_web";

	this.blockedExtForFileUpload = "cfm, cfc, jsp";


	public boolean function onApplicationStart() 
	{
	//	application.fileServerIPAddress 		= "127.0.0.1";
	//	application.customerServiceEmailAddress = "support@d51schools.org";
	//	application.mailServerIPAddress 		= "10.5.11.99";

	
		return true; 
	}

	public void function onSessionStart() 
	{ 
		session.created = Now(); // timestamp when this session was created;
		session.IPCreated = cgi.remote_addr;	// where did this user come from?
		// session.loggedIn = false;	// new users are logged out by default;
		// session.isAdmin = false;	// no way a new user can be an admin if they haven't logged in yet.
		
	


	} // end on session start

	// the target page is passed in for reference, 
    // but you are not required to include it
	function onRequestStart( string targetPage ) 
	{

	}

	function onRequest( string targetPage ) 
	{
		try 
		{
           include arguments.targetPage;
		} 
		catch (any e) 
		{
			WriteOutput( "Error trying to include template." );
			WriteDump( e );
        }
	}
	
	function onRequestEnd( string targetPage ) 
	{
		
	}

	function onSessionEnd( struct SessionScope, struct ApplicationScope ) 
	{
	}
	function onApplicationEnd( struct ApplicationScope ) 
	{

	}

	function onError( any Exception, string EventName ) 
	{
		WriteOutput( "bad thing happened!" );
		WriteDump( arguments.exception );
		WriteDump( arguments.eventName );
	}

	public boolean function onMissingTemplate( required string targetPage ) 
	{ 
		WriteOutput( "The #arguments.targetPage# page was not found!" );
		// log this 404 somewhere for later research...
		return true; 
	} 


}