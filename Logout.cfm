<cfscript>
	// Invalidate the session
	StructClear(Session);
	SessionInvalidate(); // Ends the session
</cfscript>

<cflocation url="index.cfm">