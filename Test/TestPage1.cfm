<cfif not isdefined('form.login')>
	<cflocation url="LoginForm.cfm">
<cfelse>
<cfoutput>#Form.Username#</cfoutput>
</cfif>