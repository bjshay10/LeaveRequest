<!--- <cfapplication name="EmployeeLeaveRequest_supervisor" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,0,20,0)#"> --->
<!DOCTYPE html><html lang="en"><!-- InstanceBegin template="/Templates/fullpage.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
  <link rel="shortcut icon" href="/favicon.ico" />
	<link rel="stylesheet" type="text/css"  href="/css/text.css" />
   <link rel="stylesheet" type="text/css"  href="/css/main.css" />
   <!--[if lte IE 6]><link rel="stylesheet" type="text/css" href="/css/olderIESupport.css" />
<![endif]-->
	<link rel="stylesheet" type="text/css"  href="/css/print.css" media="print" />
 <script src="/scripts/main.js" type="text/javascript"></script>
	<script src="/SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
	<link href="/SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" />
	
	<!-- InstanceBeginEditable name="doctitle" -->
		<title>Leave Request Page - Supervisor</title>
	<!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="head" -->
	<!-- InstanceEndEditable -->
</head>

<body>
<div id="wrapper">
	<div id="headercontainer">
  	<div id="headerimages"><a href="http://www.mesa.k12.co.us"><img src="/images/logo.jpg" align="left" alt="Mesa County Valley School District 51" /></a>
		</div>
		<div id="headersprybar">
  		<!---<cfinclude template="/templates/components/sprybar.cfm" />--->
		</div> 
	</div>
	<div id="headersearchbar">
   </div>
	<div id="maincontainer">
    <div id="maincontentfull">
    <main>
  	
    		<span class="heading">
				<h1 style="font-size: large;"><!-- InstanceBeginEditable name="PageTitle" -->
				Leave Request - Supervisor Page
			<!-- InstanceEndEditable --></h1>
   	  	</span><br />
				 <!-- InstanceBeginEditable name="Content" -->
<cfif not isdefined('StepNum')>
	<cfset StepNum = 0>
</cfif>

<!--- <cfif (cgi.https eq "off") and 
	(cgi.SERVER_NAME does not contain "intranet")>
	<cflocation url="https://www.mesa.k12.co.us/apps/LeaveRequest/supervisornew.cfm" addtoken="no">
	<cfabort>
</cfif> --->

<cfif StepNum eq 0>
	<cfif not isdefined ('username')>
	You are not logged in or the program has been inactive for 20 minutes.<br />	
	</cfif>

<!--- User Login --->
	<cfif not isdefined ('username') and not isdefined ('submitform')>
	<p>&nbsp; </p>
	<cfif isdefined('tryagain')>
		<pan class="red">Invalid Username or Password or you are unauthorized- - Try again</span>
	    </div>
	</cfif>
	<cfform name="form2" method="post" action="" width="500" height="550">
		<!---<cfformgroup type="panel" label="Leave Request Form">--->
		<table align="center"><tr><td align="center">
        Username: <cfinput name="username" type="text" size="20" label="Username:" onkeydown="if(Key.isDown(Key.ENTER)) Submituser.dispatchEvent({type:'click'});"><br />

 	 	Password: <cfinput name="password" type="password" size="20" label="Password:" onkeydown="if(Key.isDown(Key.ENTER)) Submituser.dispatchEvent({type:'click'});"><br />
    	<cfinput type="submit" name="Submituser" value="Submit">
        </td></tr></table>
   	</cfform>
</cfif>

<!--- Check Username and Password --->
	<cfif isdefined('form.username')>
    	<cfoutput>#form.username#</cfoutput>
    </cfif>
    
	<cfif isdefined ("submituser")>        
		<!--- Test Validation vs AD --->
        <cftry>
        <cfldap action="query" 
           server="chief.mesa.k12.co.us"
           name="GetAccounts" 
           start="DC=mesa,DC=k12,DC=co,DC=us"
           filter="(&(objectclass=user)(SamAccountName=#form.username#))"
           username="mesa\#form.username#" 
           password="#form.password#"
           attributes = "cn,o,l,st,sn,c,mail,telephonenumber, givenname,homephone, streetaddress, postalcode, SamAccountname, physicalDeliveryOfficeName, department, memberof">
        <cfcatch>
        	<cfset getaccounts.recordcount = 0>
        </cfcatch>
        </cftry>
        <cfif getaccounts.recordcount eq 0>
            <cflocation url="supervisornew.cfm?tryagain" addtoken="no">
        <cfelse>
			<cfset Session.Username = '#GetAccounts.cn#'>
            <cfset Session.Building = '#GetAccounts.physicaldeliveryofficename#'>
            <cfset Session.email = '#GetAccounts.mail#'>
            <cfquery name="GetUserinfo" datasource="accounts">
                SELECT     
                    Accounts.Username, Accounts.Building, Building.building_number, Accounts.Full_Name, Accounts.Groups, Accounts.SocSecNum
                FROM         
                    Accounts INNER JOIN
                              Building ON Accounts.Building = Building.Building
                WHERE
                    (ACCOUNTS.USERNAME = '#session.username#')
        	</cfquery>
            <cfset Session.BuildingNum = '#GetUserInfo.Building_number#'>
           	<cfset Session.FullName = '#GetUserInfo.Full_Name#'>
            <cfset Session.Groups = '#GetUserInfo.Groups#'>
            <cfset Session.SSN = '#GetUserInfo.SocSecNum#'>
            <cflocation url="supervisornew.cfm?StepNum=1&#urlencodedformat(NOW())#" addtoken="no">
        </cfif>    
    </cfif>
<cfelseif StepNum eq 1>
	<!--- query to get requests --->
    <cfquery name="GetRequests" datasource="mesa_web">
    	SELECT *
        FROM	LeaveReq_tblRequest
        WHERE	(((supervisor = '#Session.email#') OR (supervisor = '#session.username#@d51schools.org')) AND (supviewed IS NULL) AND yearofrequest >= '2025-2026')
        or 
        (((supervisor2 = '#Session.email#') OR (supervisor2 = '#session.username#@d51schools.org')) AND (sup2viewed IS NULL) AND yearofrequest >= '2025-2026')
        ORDER BY DateEntered, userid
    </cfquery>
    <!---<cfif #GetRequests.Supervisor# eq '#Session.email#'>
    	<cfset Session.SupNum = 1>
        <cfoutput>#Session.SupNum#</cfoutput>
    <cfelseif #GetRequests.Supervisor# eq '#session.username#@d51schools.org'>
    	<cfset Session.SupNum = 1>
        <cfoutput>#Session.SupNum#</cfoutput>
    <cfelseif #GetRequests.Supervisor2# eq '#Session.email#'>
    	<cfset Session.SupNum = 2>
        <cfoutput>#Session.SupNum#</cfoutput>
    <cfelseif #GetRequests.Supervisor2# eq '#session.username#@d51schools.org'>
    	<cfset Session.SupNum = 2>
        <cfoutput>#Session.SupNum#</cfoutput>
    <cfelse>
    	<cfoutput>#Session.email#, #SEssion.username#</cfoutput>
    </cfif>--->
    <table border="1" width="100%">
    	  <tr><th colspan="3">Leave Requests: Pending</th>
        </tr><tr>
        	<td>Employee</td>
            <td>RequestDates</td>
            <td>RequestedOn</td>
        </tr>
        <cfoutput query="GetRequests">
        	<tr>
            	<td><a href="supervisornew.cfm?StepNum=2&requestid=#requestid#&emp_username=#userid#">#userid#</a></td>
                <td>#LsDateFormat(dtFrom,'mm/dd/yyyy')#-#LSDateFormat(dtTo,'mm/dd/yyyy')#</td>
                <td>#lsdateformat(dateentered,'mm/dd/yyyy')#</td>
            </tr>
        </cfoutput>
    </table>
    <!--- query to get requests --->
    <cfquery name="GetRequests" datasource="mesa_web">
    	SELECT *
        FROM	LeaveReq_tblRequest
        WHERE	(((supervisor = '#Session.email#') OR (supervisor = '#session.username#@d51schools.org')) AND (supviewed = 'Yes' or supviewed = 'No') AND yearofrequest >= '2025-2026')
        or 
        (((supervisor2 = '#Session.email#') OR (supervisor2 = '#session.username#@d51schools.org')) AND (sup2viewed = 'Yes' or supviewed = 'No') AND yearofrequest >= '2025-2026')
        ORDER BY DateEntered, userid
    </cfquery>
    
        
    <table border="1" width="100%">
    	  <tr><th colspan="3">Leave Requests: Viewed</th>
        </tr><tr>
        	<td>Employee</td>
            <td>RequestDates</td>
            <td>RequestedOn</td>
        </tr>
        <cfoutput query="GetRequests">
        	<tr>
            	<td><a href="supervisornew.cfm?StepNum=2&requestid=#requestid#&emp_username=#userid#">#userid#</a></td>
                <td>#LsDateFormat(dtFrom,'mm/dd/yyyy')#-#LSDateFormat(dtTo,'mm/dd/yyyy')#</td>
                <td>#lsdateformat(dateentered,'mm/dd/yyyy')#</td>
            </tr>
        </cfoutput>
    </table>
<cfelseif StepNum eq 2>
	<cfset Session.emp_username = '#emp_username#'>
    <cfset Session.requestid = '#requestid#'>
    <!--- Get Request Information --->
    <cfquery name="GetReq_Info" datasource="mesa_web">
    	SELECT *
        FROM LeaveReq_tblRequest
        WHERE requestid = '#Session.RequestID#' and Userid = '#Session.emp_username#'
    </cfquery>
    <!--- Get Employee Name --->
    <cfquery name="GetEmpName" datasource="accounts">
    	SELECT Full_Name, username
        FROM accounts
        WHERE	Username = '#Session.emp_username#'
    </cfquery>
	<!--- Display Request Information --->
    <cfif #GetReq_Info.Supervisor# eq '#Session.email#'>
    	<cfset Session.SupNum = 1>
    <cfelseif #GetReq_Info.Supervisor# eq '#session.username#@d51schools.org'>
    	<cfset Session.SupNum = 1>
    <cfelseif #GetReq_Info.Supervisor2# eq '#Session.email#'>
    	<cfset Session.SupNum = 2>
    <cfelseif #GetReq_Info.Supervisor2# eq '#session.username#@d51schools.org'>
    	<cfset Session.SupNum = 2>
    </cfif>
    <cfoutput>#Session.SupNuM#</cfoutput>
    <cfform name="ReviewedRequest" action="supervisornew.cfm?StepNum=3" method="post">
		<cfoutput query="GetReq_Info">
            <table border="1" width="100%">
                <tr><th align="center" colspan="3">Leave Request Information</th>
                </tr><tr>
                    <td>Name</td>
                    <td>Requested Dates</td>
                    <td>Type of Request</td>
                </tr>
                <tr>
                    <td>#GetEmpName.Full_Name#</td>
                    <td>#Requesteddates#<br />#LSDateFormat(dtFrom,'mm/dd/yyyy')#-#LSDateFormat(dtTo,'mm/dd/yyyy')#</td>
                    <cfif #GetReq_Info.requesttype# eq 1>
                        <td>Bereavement: relationship: #bereavementrelate#</td>
                    <cfelseif #GetReq_Info.requesttype# eq 2>
                        <td>Jury/Witness</td>
                    <cfelseif #GetReq_Info.requesttype# eq 3>
                        <td>Officiating/Judging</td>
                    <cfelseif #GetReq_Info.requesttype# eq 4>
                        <td>Community Service</td>
                    <cfelseif #GetReq_Info.requesttype# eq 5>
                        <td>Emergency</td>
                    <cfelseif #GetReq_Info.requesttype# eq 6>
                        <td>Leave without pay</td>
                    <cfelseif #GetReq_Info.requesttype# eq 7>
                        <td>FMLA own serious health condition</td>
                    <cfelseif #GetReq_Info.requesttype# eq 8>
                        <td>FMLA care of immediate family member with a serious health condition</td>
                    <cfelseif #GetReq_Info.requesttype# eq 9>
                        <td>Day or Personal Leave</td>
                    <cfelseif #GetReq_Info.requesttype# eq 10>
                        <td>Vacation</td>
                    <cfelseif #GetReq_Info.requesttype# eq 11>
                        <td>FMLA military Exigency Leave</td>
                    <cfelseif #GetReq_Info.requesttype# eq 12>
                        <td>FMLA: Military caregiver leave</td>
                    <cfelseif #GetReq_Info.requesttype# eq 13>
                    	<td>Sick Leave</td>
                    </cfif>
                </tr>
                <tr>
                	<td colspan="3">Date Entered: #LSDateFormat(GetReq_Info.dateentered,'mm/dd/yyyy')#</td>
                </tr>
               	<tr>
                	<td colspan="3">
                	Status:<cfif #GetReq_Info.approved# eq 'A'>has been <strong>Approved</strong>
  <cfelseif #GetReq_Info.approved# eq 'P'>is <strong>Pending</strong> personal leave available for the fiscal year July through June<cfelseif #GetReq_Info.approved# eq 'D'> has been <strong>Denied</strong><cfelse>No Action has been taken by Human Resources</cfif>.
  					</td>
                </tr>
                <tr>
                	<td colspan="3">
                    	<cfif #GetReq_Info.subfindernum# neq 0>
                            A sub request has been made in subfinder: #GetReq_Info.subfindernum#<br /><br />
                        </cfif>
                        <cfif #GetReq_Info.Subfindernum# eq 0>
                            <cfif #GetReq_Info.Subrequested# eq 'No'>
                                A Sub has not been requested or is not needed.<br /><br />
                            <cfelse>
                                A Sub has been requested.<br /><br />
                            </cfif>
                        </cfif>
                    </td>
                </tr>
                <tr>
                	<td colspan="3">
                    	Comments to HR: #GetReq_Info.commentstohr#
                    </td>
                </tr>
            </table>
        </cfoutput>
        
        <table border="0" width="100%">
        	<tr>
            	<td align="center">
                	<!---<cfif #GetReq_Info.EmpType# eq 2>
                    	<cfinput type="checkbox" label="I have Reviewed" name="reviewed" value="yes">I support this request.  Reviewed on <cfoutput>#LSDateFormat(NOW(),'mm/dd/yyyy')#</cfoutput>	
                    <cfelse>
                		<cfinput type="checkbox" label="I have Reviewed" name="reviewed" value="yes">I have reviewed this request on <cfoutput>#LSDateFormat(NOW(),'mm/dd/yyyy')#</cfoutput>
                    </cfif>--->
                    <cfif #GetReq_Info.supviewed# eq 'yes'>
                    I support this request: <cfinput type="radio" label="I have reviewed" name="reviewed" value="yes" checked="yes">Yes <cfinput type="radio" label="I have reviewed" name="reviewed" value="no">No <br />
                    <cfelse>
                    I support this request: <cfinput type="radio" label="I have reviewed" name="reviewed" value="yes">Yes <cfinput type="radio" label="I have reviewed" name="reviewed" value="no" checked="yes">No <br />
                    </cfif>
                    Reason: <cfinput type="text" label="Reason" name="supcomments" size="125" value="#GetReq_Info.supcomments#">
            </td></tr>
             <tr>
                	<td align="center"><cfinput type="submit" name="submit" value="submit"></td>
                </tr>
        </table>
        
    </cfform>
<cfelseif StepNum eq 3>
	<cfif #session.supnum# eq 1>
    	<cfset Session.reviewed = '#form.reviewed#'>
    <cfelse>
    	<cfset Session.reviewed = 'Yes'>
    </cfif>
    <cfset Session.supcomments = '#form.supcomments#'>
    <!--- Update Request --->
    <cfif #Session.SupNum# eq 1>
        <cfquery name="ViewedRequest" datasource="mesa_web">
            UPDATE LeaveReq_tblRequest
            SET	supviewed = '#Session.reviewed#',
                supvieweddate = '#LSDateFormat(NOW(),'mm/dd/yyyy')#',
                supcomments = '#Session.supcomments#'
            WHERE	requestid = '#Session.requestid#' and userid = '#Session.emp_username#'
        </cfquery>
    <cfelseif #Session.SupNum# eq 2>
    	<cfquery name="ViewedRequest" datasource="mesa_web">
            UPDATE LeaveReq_tblRequest
            SET	sup2viewed = '#Session.reviewed#',
                sup2vieweddate = '#LSDateFormat(NOW(),'mm/dd/yyyy')#'               
            WHERE	requestid = '#Session.requestid#' and userid = '#Session.emp_username#'
        </cfquery>
    </cfif>
    
    <cflocation url="supervisornew.cfm?Stepnum=1">
<cfelseif StepNum eq 4>
	You have viewed the request.
    <cfcookie name="CFID" expires="now">
	<cfcookie name="CFTOKEN" expires="now">
	<cfscript>
   		StructClear(Session);
	</cfscript>
</cfif>
    <!-- InstanceEndEditable -->
     </main>        	
  	</div>
	 	<br class="clearfloat" />
</div>
</div>
  <!-- end #footer -->
<footer>  
  		<cfinclude template="/templates/components/footer.cfm">
</footer>
<!-- end #container -->

</body>
<!-- InstanceEnd --></html>