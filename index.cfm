<cfapplication name="EmployeeLeaveRequest" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,2,0,0)#">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/fullpage.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
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
		<title></title>
	<!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="head" -->
	<!-- InstanceEndEditable -->
</head>

<body>
<div id="wrapper">
	<div id="headercontainer">
  	<div id="headerimages"><a href="http://www.mesa.k12.co.us"><img src="/images/logo.jpg" align="left" alt="Mesa County Valley School District 51" /></a>
  	  <cfinclude template="/templates/components/rotatingphotos.cfm" />
		</div>
		<div id="headersprybar">
  		<cfinclude template="/templates/components/sprybar.cfm" />
		</div> 
	</div>
	<div id="headersearchbar">
		<cfinclude template="/templates/components/searchbar.cfm" />	
   </div>
	<div id="maincontainer">
  	<div id="maincontentfull">
    		<span class="heading">
					<!-- InstanceBeginEditable name="PageTitle" -->
				<center>Request and Approval for Leave</center>
			<!-- InstanceEndEditable -->
   	  	</span><br />
				 <!-- InstanceBeginEditable name="Content" -->
<!--- begin Steps --->
<!--- Steps
		0 = Not Logged In
		1 = Logged In (Select Enter New or View Existing)
		2 = Select Classified or Certified Employee
		3 = View Existing Requests (lists requests)
		4 = Enter New Request Form
		5 = View Specific Request
		6 = Attach File for Community Service or Jury Duty (from 997 if Jury duty or community service selected.  continue to insert)
		7 = Search for Supervisor (return to enter new)
		996 = Email Supervisor
		997 = Set Session variables
		998 = Insert request into db
		999 = Logout --->
        
<cfif (cgi.https eq "off") and 
	(cgi.SERVER_NAME does not contain "intranet")>
	<cflocation url="https://www.mesa.k12.co.us/apps/LeaveRequest/index.cfm" addtoken="no">
	<cfabort>
</cfif>

<cfif not isdefined('StepNum')>
	<cfset StepNum=0>
</cfif>

<cfif StepNum eq 0>
	<cfif not isdefined ('username')>
	Welcome to the Leave Request Form.  Please Log in.<br />	
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
            <cflocation url="index.cfm?tryagain" addtoken="no">
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
            <cflocation url="index.cfm?StepNum=1&#urlencodedformat(NOW())#" addtoken="no">
        </cfif>    
    </cfif>
<!--- Staff Member is Logged in and Can choose to see existing or Enter New Request --->
<cfelseif StepNum eq 1>
	<cfform name="form2" method="post" action="index.cfm?StepNum=2" width="500" height="550" skin="blue">
    	<table width="100%" align="center">
        	<tr align="center">
            	<td>Select Action: Enter New Request or View Previous Request</td>
            </tr>
            <tr align="center">
            	<td><input type="radio" name="Action" value="New" />Enter New Request</td>
            </tr>
            <tr align="center">
                <td><input type="radio" name="Action" value="View" />View Previous Request</td>
            </tr>
            <tr align="center">
            	<td><input type="submit" name="submitaction" value="Submit" /></td>
            </tr>
        </table>
        <table width="100%">
        	<tr><td><input type="submit" name="logout" value="Logout" /></td></tr>
        </table>
    </cfform>
    
<!--- Redirect to Appropriate Selection --->
<cfelseif StepNum eq 2>
	<cfinclude template="logout.cfm">
	<cfif #Form.Action# eq "New">
    	<!--- First Select Classified or Certified --->
        <cfform name="SelectEmpType" action="index.cfm?StepNum=4&#urlencodedformat(NOW())#" method="post" width="650" height="550" skin="blue">
            <table width="100%">
            	<tr align="center">
                	<td>Select Employee Type</td>
                </tr>
                <tr align="Left">
                	<td >
                    	<table border="1" width="100%"><tr>
                    	  <td>
                    	Teachers, Nurses, Psychologists, Audiologists, Speech Language Pathologists, etc.<br />
                    	<input type="radio" name="EmpType" value="1" /><strong>Certified Employees:</strong><br /><br />
                        All Administrators (including Principals), Paraprofessionals, Nutrition Services, Secretaries, Grounds, Maintenance, etc.<br />
                        <input type="radio" name="EmpType" value="2" />
                        <strong>Support Staff Employees and Administrators:</strong><br />
                    	<!---<select name="EmpType">Employee Type
                        	<option value="1">Certified Employees</option>
                            <option value="2">Classified Employees and Administrators</option>
                        </select>--->
                        </td></tr></table>
                    </td>
                </tr>
                <tr align="center">
                	<td><input type="submit" name="submitemptype" value="Submit" /></td>
                </tr>
            </table>
            <table width="100%">
              <tr><td><input type="submit" name="logout" value="Logout" /></td></tr>
            </table>
        </cfform>
    <cfelseif #Form.Action# eq "View">
    	<cflocation url="index.cfm?StepNum=3&#urlencodedformat(NOW())#">
    </cfif>
<!--- View Existing Requests --->
<cfelseif StepNum eq 3>
	<cfinclude template="logout.cfm">
    
    <!--- Get a list of Requests the users has entered --->
    <cfquery name="GetRequests" datasource="mesa_web">
    	SELECT	RequestID, userid, requesteddates, requesttype, approved,dtFrom, dtTo
        FROM	LeaveReq_tblRequest
        WHERE	userid = '#Session.Username#' and yearofrequest = '2024-2025'
        ORDER BY approved, requesteddates
    </cfquery>
    
    <table width="100%">
    	<tr>
        	<td colspan="5" align="center">Leave Requests Entered Into the System</td>
        </tr>
        <tr>
        	<td>Request ID (click to view request)</td>
            <td>User Name</td>
            <td>Dates From-To</td>
            <td>Leave Type</td>
            <td>Status</td>
        </tr>
        <cfoutput query="GetRequests">
        	<tr>
            	<td><a href="index.cfm?StepNum=5&requestID=#GetRequests.RequestID#">#RequestID#</a></td>
                <td>#userid#</td>
                <td>#LSDateFormat(dtFrom,'mm/dd/yyyy')#-#LSDateFormat(dtTo,'mm/dd/yyyy')#</td>
                <cfif #GetRequests.requesttype# eq 1>
                	<td>Bereavement</td>
                <cfelseif #GetRequests.requesttype# eq 2>
                	<td>Jury/Witness</td>
                <cfelseif #GetRequests.requesttype# eq 3>
                	<td>Officiating/Judging</td>
                <cfelseif #GetRequests.requesttype# eq 4>
                	<td>Community Service</td>
                <cfelseif #GetRequests.requesttype# eq 5>
                	<!---<td>Emergency</td>--->
                <cfelseif #GetRequests.requesttype# eq 6>
                	<td>Leave without Pay</td>
                <cfelseif #GetRequests.requesttype# eq 7>
                	<td>FMLA own serious health condition</td>
                <cfelseif #GetRequests.requesttype# eq 8>
                	<td>FMLA care for immediate family member with a serious health condition</td>
                <cfelseif #GetRequests.requesttype# eq 9>
                	<td>Day or Personal Leave</td>
               	<cfelseif #GetRequests.requesttype# eq 10>
                	<td>Vacation</td>
                <cfelseif #GetRequests.requesttype# eq 11>
                	<td>FMLA Military Exigency Leave</td>
                <cfelseif #GetRequests.requesttype# eq 12>
                	<td>FMLA Military Caregiver Leave</td>
                <cfelseif #GetRequests.requesttype# eq 13>
                	<td>Sick Leave</td>
                <cfelseif #GetRequests.requesttype# eq 14>
                	<td>Military Leave</td>
                </cfif>
                
                <cfif #GetRequests.approved# eq 'A'>
                	<td>Approved</td>
                <cfelseif #GetRequests.approved# eq 'D'>
                	<td>Denied</td>
                <cfelse>
                	<td>Pending</td>
                </cfif>
            </tr>
		</cfoutput>
    </table>

<!--- Enter New Request --->
<cfelseif StepNum eq 4>
	<cfinclude template="logout.cfm">
	<cfif isdefined('form.submitemptype')>
		<cfset Session.EmpType = '#Form.EmpType#'>
    </cfif>
    <!--- Leave Request Form --->
    <cfform name="LeaveReqForm" action="index.cfm?StepNum=997&#urlencodedformat(NOW())#" method="post" width="850" height="550">
        <!--- Name, ID, Building, Requesting Dates is the same for all types of Staff --->
		<table width="100%">
        	<tr>
      			<cfif isdefined('errcode')>
                	<cfif #errcode# eq 1>
                    	<td colspan="4"><h3><font color="##FF0000">You Must Enter a Bereavement Relationship</font></h3> make sure to select type of leave                        </td>
                    </cfif>
                </cfif>
            	<td colspan="2">
                	Name:<cfoutput><cfinput type="text" name="EmpName" value="#Session.FullName#" size="50" required="yes"></cfoutput>
                </td>
                <td>
                	<!--- Query to get ID Number --->
                	<cfquery name="GetID" datasource="accounts">
                    	SELECT EmpID
                        FROM	accounts
                        WHERE	Username = '#Session.Username#'
                    </cfquery>
                	ID#:<cfoutput><cfinput type="text" name="EmpID" value="#GetID.EmpID#" size="10" required="yes"></cfoutput>
                </td>
                <td>
                	School:<cfoutput><cfinput type="text" name="EmpBuilding" value="#Session.Building#" size="50" required="yes"></cfoutput>
                </td>
            </tr>
            <tr>
            	<td>
                	Dates Requested:<br />From (use date picker):<br />
                    <cfif isdefined('Session.ReqDateFrom')>
                    	<cfinput type="datefield" name="ReqDateFrom" required="yes" message="You must enter the Start date of your leave request" value="#Session.ReqDateFrom#">
                    <cfelse>
                    	<cfinput type="datefield" name="ReqDateFrom" required="yes" message="You must enter the Start date of your leave request" readonly="yes">	
                    </cfif>
                </td>
                <td>
                	<br />To (use date picker):<br />
                    <cfif isdefined('Session.ReqDateTo')>
                    	<cfinput type="datefield" name="ReqDateTo" required="yes" message="You must enter the End date of your leave request" value="#Session.ReqDateTo#">
                    <cfelse>
                    	<cfinput type="datefield" name="ReqDateTo" required="yes" message="You must enter the End date of your leave request" readonly="yes">	
                    </cfif>
                </td>
                <td colspan="2">
                	<p><br />
                	Number of Days Requested: (number only)
                	<br />(If less than 1 day put hours in comments to HR)
              	  </p>
					<cfif isdefined('Session.ReqNumDays')>
                    	<cfinput type="text" name="ReqNumDays" required="yes" message="Enter the number of days requested" value="#Session.ReqNumDays#">
                    <cfelse>
                    	<cfinput type="text" name="ReqNumDays" required="yes" message="Enter the number of days requested">	
                    </cfif>	
                </td>
            </tr>
            <!---<tr>
            	<td colspan="4">
                	Enter Date(s) you are Requesting:<br />
                    
                    <br /><br />
					<cfif isdefined('Session.ReqDates')>
                    	<cfinput type="text" maxlength="150" name="ReqDates" size="125" required="yes" message="You must enter the Date(s) you are requesting leave for" value="#Session.ReqDates#"><br />
                    <cfelse>
                    	<cfinput type="text" maxlength="150" name="ReqDates" size="125" required="yes" message="You must enter the Date(s) you are requesting leave for"><br />
                    </cfif>
                </td>
            </tr>--->
            <!--- if Certified Employee --->
            <cfif Session.EmpType eq 1>
            	<tr>
                    <td colspan="4">Check Leave Type You Are Requesting:  </td>
                </tr>
                <cfif isdefined('Session.LeaveType')>
                <tr>
                	<td colspan="2">
                    	<!--- Day Leave ---><br />
                        <cfif #Session.LeaveType# eq 9>
                        	<cfinput type="radio" name="LeaveType" value="9" required="yes" message="You must select a type of leave" checked="yes">
                        	<strong>Day Leave Section 9.1</strong>: <em><br />&nbsp;&nbsp;&nbsp;&nbsp;This leave may not be used for vacation or job interviews.  Must provide comments to HR if taking 3 or more consecutive days or a blackout day*</em><br />
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="9" required="yes" message="You must select a type of leave">
                        	<strong>Day Leave Section 9.1</strong>: <em><br />&nbsp;&nbsp;&nbsp;&nbsp;This leave may not be used for vacation or job interviews.  Must provide comments to HR if taking 3 or more consecutive days or a blackout day*</em><br />
                        </cfif>
                        <cfif isdefined('Sesssion.dayleavereason')>
                        	<cfinput type="hidden" name="dayleavereason" value="#Session.dayleavereason#"><br />
                        <cfelse>
                        	<cfinput type="hidden" name="dayleavereason"><br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 14>                       
                            <cfinput type="radio" name="LeaveType" value="14" required="yes" message="You must select a type of leave" checked="yes">
                            <strong>Military Leave</strong> 8.4<br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>(documentation required)</em><br />
                        <cfelse>
                            <cfinput type="radio" name="LeaveType" value="14" required="yes" message="You must select a type of leave">
                            <strong>Military Leave</strong> 8.4 <br />
                             &nbsp;&nbsp;&nbsp;&nbsp;<em>(documentation required)</em><br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 6>
                        	<cfinput type="radio" name="LeaveType" value="6" required="yes" message="You must select a type of leave" checked="yes"><strong>Leave without Pay</strong><br />
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="6" required="yes" message="You must select a type of leave"><strong>Leave without Pay</strong><br />
                        </cfif>
                    <!---<strong>FMLA</strong> <em>(to rum concurrent with Day Leave)</em><br />
                        Purpose of Day Leave: if 11 or more consecutive days
                        <cfif #Session.LeaveType# eq 7>
                        	<cfinput type="radio" name="LeaveType" value="7" required="yes" message="You must select a type of leave" checked="yes">FMLA own serious health condition (if more than 11 consecutive days)<br />
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="7" required="yes" message="You must select a type of leave">FMLA own serious health condition (if more than 11 consecutive days)<br />
                        </cfif>
                        <cfif #Session.LeaveType# Eq 8>
                        	<cfinput type="radio" name="LeaveType" value="8" required="yes" message="You must select a type of leave" checked="yes">FMLA care for immediate family member with a serious health condition (if more than 11 consecutive days)<br />
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="8" required="yes" message="You must select a type of leave">FMLA care for immediate family member with a serious health condition (if more than 11 consecutive days)<br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 11>
                        	<cfinput type="radio" name="LeaveType" value="11" required="yes" message="You must select a type of leave" checked="yes">FMLA Military Exigency Leave<br />
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="11" required="yes" message="You must select a type of leave">FMLA Military Exigency Leave<br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 12>
                        	<cfinput type="radio" name="LeaveType" value="12" required="yes" message="You must select a type of leave" checked="yes">FMLA Military Caregiver Leave<br />
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="12" required="yes" message="You must select a type of leave">FMLA Military Caregiver Leave<br />
                        </cfif>---></td>
                    <td colspan="2">
                    	<cfif #Session.LeaveType# eq 1>
                        	<cfinput type="radio" name="LeaveType" value="1" required="yes" message="You must select a type of leave"><strong>Bereavement Section </strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>Immediate family members**</em> <input type="text" name="bereavementrelationship" size="20" value="<cfoutput>#Session.bereavementrelationship#</cfoutput>" /><br /><br />
                        <cfelse>
                            <cfinput type="radio" name="LeaveType" value="1" required="yes" message="You must select a type of leave"><strong>Bereavement Section </strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>Immediate family members**</em> <cfinput type="text" name="bereavementrelationship" size="20" maxlength="50" /><br /><br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 4>
                        	<cfinput type="radio" name="LeaveType" value="4" required="yes" message="You must select a type of leave" checked="yes"><strong>Community Service Section 9.4</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em> (preapproval and documentation required)</em><br /><br />
                        <cfelse>
                            <cfinput type="radio" name="LeaveType" value="4" required="yes" message="You must select a type of leave"><strong>Community Service Section 9.4</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em> (preapproval and documentation required)</em><br /><br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 3>
                        	<cfinput type="radio" name="LeaveType" value="3" required="yes" message="You must select a type of leave" checked="yes"><strong>Officiating/Judging Section 9.5</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>(documentation required)</em><br /><br />
                        <cfelse>
                            <cfinput type="radio" name="LeaveType" value="3" required="yes" message="You must select a type of leave"><strong>Officiating/Judging Section 9.5</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>(documentation required)</em><br /><br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 5>
                        	<!---<cfinput type="radio" name="LeaveType" value="5" required="yes" message="You must select a type of leave" checked="yes"><strong>Emergency Section 9.6</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong> <em>submit documentation</em>--->
                        <cfelse>
                            <!---<cfinput type="radio" name="LeaveType" value="5" required="yes" message="You must select a type of leave"><strong>Emergency Section 9.6</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong> <em>submit documentation</em>	 --->                       
                        </cfif>
                        <cfif #Session.LeaveType# eq 2>
                        	<cfinput type="radio" name="LeaveType" value="2" required="yes" message="You must select a type of leave" checked="yes"><strong>Jury/Witness Section 9.7-8</strong><br />
                    		&nbsp;&nbsp;&nbsp;&nbsp;<em>(documentation required)</em>
                        <cfelse>                      
                            <cfinput type="radio" name="LeaveType" value="2" required="yes" message="You must select a type of leave">
                            <strong>Jury/Witness Section 9.8</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>(documentation required)</em>
                        </cfif>
                    </td>
                </tr>
                <tr>
                	<td colspan="2">
                    	<!--- Leave without pay --->
                        
                    </td>
                    <td colspan="2">
                    	<!--- Jury/Witness --->  
                        
                    </td>
                </tr>
                <cfelse>
                <!--- if session.leavetype not exists begin--->
                <tr>
                	<td colspan="2">
                    	<p>
                    	<!--- Day Leave ---><br />
                        <cfinput type="radio" name="LeaveType" value="9" required="yes" message="You must select a type of leave">
                        <strong>Day Leave Section 9.1</strong>: <em><br />&nbsp;&nbsp;&nbsp;&nbsp;This leave may not be used for vacation or job interviews.  Must provide comments to HR if taking 3 or more consecutive days or a blackout day*</em><br />
                        <cfinput type="hidden" name="dayleavereason" >
                    	<br />
                        <cfinput type="radio" name="LeaveType" value="14" required="yes" message="You must select a type of leave">
                        <strong>Military Leave</strong> 8.4<br />
                    	&nbsp;&nbsp;&nbsp;&nbsp;<em>(documentation required)</em><br /><br />
                        <!--- Leave without pay --->
                        <cfinput type="radio" name="LeaveType" value="6" required="yes" message="You must select a type of leave"><strong>Leave without Pay</strong><br />
						<!---<strong>FMLA</strong> <em>(to rum concurrent with Day Leave)</em><br />
                        Purpose of Day Leave: if 11 or more consecutive days
                        <cfinput type="radio" name="LeaveType" value="7" required="yes" message="You must select a type of leave">FMLA own serious health condition (if more than 11 consecutive days)<br />
                        <cfinput type="radio" name="LeaveType" value="8" required="yes" message="You must select a type of leave">FMLA care for immediate family member with a serious health condition (if more than 11 consecutive days)<br />
                        <cfinput type="radio" name="LeaveType" value="11" required="yes" message="You must select a type of leave">FMLA Military Exigency Leave<br />
                        <cfinput type="radio" name="LeaveType" value="12" required="yes" message="You must select a type of leave">FMLA Military Caregiver Leave<br />--->
                    </td>
                    <td colspan="2">
                    	
                    	<cfinput type="radio" name="LeaveType" value="1" required="yes" message="You must select a type of leave"><strong>Bereavement Section </strong><br />
                    	&nbsp;&nbsp;&nbsp;&nbsp;<em>Immediate family members**</em> <input type="text" name="bereavementrelationship" size="20" /><br /><br />
                        <cfinput type="radio" name="LeaveType" value="4" required="yes" message="You must select a type of leave"><strong>Community Service Section 9.4</strong><br />
                    	&nbsp;&nbsp;&nbsp;&nbsp;<em> (preapproval and documentation required)</em><br /><br />
                        <cfinput type="radio" name="LeaveType" value="3" required="yes" message="You must select a type of leave"><strong>Officiating/Judging Section 9.5</strong><br />
                    	&nbsp;&nbsp;&nbsp;&nbsp;<em>(documentation required)</em><br /><br />
                        <!--- Jury/Witness --->   
                       <cfinput type="radio" name="LeaveType" value="2" required="yes" message="You must select a type of leave">
                       <strong>Jury/Witness Section 9.8</strong><br />
                        &nbsp;&nbsp;&nbsp;&nbsp;<em>(documentation required)</em>
                        <!---<cfinput type="radio" name="LeaveType" value="5" required="yes" message="You must select a type of leave"><strong>Emergency Section 9.6</strong><br />
                  		&nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong> <em>submit documentation</em>	--->                        
                    </td>
                </tr>
                <tr>
                	<td colspan="2">
                    	
                    </td>
                    <td colspan="2">
                    	
                    </td>
                </tr>
                </cfif>
                    
                
                <!--- if Session.LeaveType not exists end--->
                <tr>
                	<td colspan="4">
                    	&bull;<strong>Reported Aesop/Frontline Job #:</strong>
                    	<cfif isdefined('Session.subfinderid')><cfinput type="text" name="subfindernum" value="#Session.subfinderid#" required="yes" validate="integer" message="Aesop/Frontline Job number must be entered and it must be numeric"><cfelse><cfinput type="text" name="subfindernum" validate="integer" required="yes" message="Aesop/Frontline Job number must be entered and it must be numeric"></cfif>
                    </td>
                </tr>
                <tr>
                	<td colspan="2">
                    </td>
                    <td colspan="2">
                    </td>
                </tr>
            <!--- Classified Employees or Administrators --->
            <cfelseif Session.EmpType eq 2>
            	<cfif not isdefined('Session.LeaveType')>
                <tr>
                    <td colspan="4">Check Leave Type You Are Requesting:</td>
                </tr>
                	<tr>
                    <td colspan="2">
                    	
                    	<cfinput type="radio" name="LeaveType" value="9" required="yes" message="You must select a type of leave">
                    	<strong>Personal Leave</strong>***<br />
                        &nbsp;&nbsp;&nbsp;&nbsp;<em>This leave may not be used for vacation or job interviews.  Must provide reason in comments to HR if taking 3 or more consecutive days or a blackout day*</em>
                        <cfinput type="hidden" name="dayleavereason"><br />
                   	  <!---<cfinput type="radio" name="LeaveType" value="7" required="yes" message="You must select a type of leave">FMLA own serious health condition (if more than 11 consecutive days)<br />
                    	<cfinput type="radio" name="LeaveType" value="8" required="yes" message="You must select a type of leave">FMLA care for immediate family member with a serious health condition (if more than 11 consecutive days)<br />
                        <cfinput type="radio" name="LeaveType" value="11" required="yes" message="You must select a type of leave">FMLA Military Exigency Leave<br />
                        <cfinput type="radio" name="LeaveType" value="12" required="yes" message="You must select a type of leave">FMLA Military Caregiver Leave--->
                        <cfinput type="radio" name="LeaveType" value="13" required="yes" message="You must select a type of Leave"><strong>Sick Leave</strong><br /><em>&nbsp;&nbsp;&nbsp;&nbsp;(If applicable FMLA will be followed)</em><br />
                        <cfinput type="radio" name="LeaveType" value="6" required="yes" message="You must select a type of leave"><strong>Leave without Pay</strong><br />
                        <cfinput type="radio" name="LeaveType" value="10" required="yes" message="You must select a type of leave">
                    	<strong>Vacation</strong>
                    	<strong>(YEAR-ROUND EMPLOYEES ONLY)</strong>
                    </td>
                    
                    <td colspan="2">
                    
                    	  <cfinput type="radio" name="LeaveType" value="1" required="yes" message="You must select a type of leave">
                    	  <strong>Bereavement</strong><br />
                    	  &nbsp;&nbsp;&nbsp;&nbsp;<em>(Immediate Family Members**)</em> 
                    	  <input type="text" name="bereavementrelationship" size="20" /><br />
                    	  <cfinput type="radio" name="LeaveType" value="4" required="yes" message="You must select a type of leave">
                    	  <strong>Community Service</strong><br />
                    	  &nbsp;&nbsp;&nbsp;&nbsp;<em> (Preapproval &amp; documentation required)</em><br />
                    	  <cfinput type="radio" name="LeaveType" value="3"required="yes" message="You must select a type of leave">
                    	  <strong>Officiating/Judging</strong><br />
                   	  	  &nbsp;&nbsp;&nbsp;&nbsp;<em>(Documentation required)</em><br />
                    	  <cfinput type="radio" name="LeaveType" value="14" required="yes" message="You must select a type of Leave">
                    	  <strong>Military Leave</strong><br />
                          &nbsp;&nbsp;&nbsp;&nbsp;<em>(Documentation Required)</em><br />
                          <cfinput type="radio" name="LeaveType" value="2" required="yes" message="You must select a type of leave"><strong>Jury/Witness</strong><br />
                   			&nbsp;&nbsp;&nbsp;&nbsp;<em>(Documentation required)</em>
                  	  </td>
                </tr>
                <tr>
                	<td colspan="2">                    	 
                    </td>
                    <td colspan="2">
                    	<!--- <cfinput type="radio" name="LeaveType" value="5" required="yes" message="You must select a type of leave"><strong>Emergency</strong><br />
                  		&nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong> <em>submit documentation</em>--->
                    </td>
                </tr>
                <cfelse>
                <tr>
                    <td colspan="4">Check Leave Type You Are Requesting:</td>
                </tr>
                	<tr>
                    <td colspan="2">
                    	<strong>Personal</strong>***<br />
                        <cfif #Session.LeaveType# eq 9>
                        	<cfinput type="radio" name="LeaveType" value="9" required="yes" message="You must select a type of leave" checked="yes">
                        	<strong>Personal Leave</strong>***<br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>This leave may not be used for vacation or job interviews.  Must provide reason in comments to HR if taking 3 or more consecutive days or a blackout day*</em>
                          <cfinput type="hidden" name="dayleavereason" value="#Session.dayleavereason#"><br />
                        <cfelse>
                    		<cfinput type="radio" name="LeaveType" value="9" required="yes" message="You must select a type of leave">
                    		<strong>Personal Leave</strong>***<br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>This leave may not be used for vacation or job interviews.  Must provide reason in comments to HR if taking 3 or more consecutive days or a blackout day*</em>
                            <cfinput type="hidden" name="dayleavereason" ><br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 13>
                        	<cfinput type="radio" name="LeaveType" value="13" required="yes" message="You must select a type of leave" checked="yes"><strong>Sick Leave</strong><br />&nbsp;&nbsp;&nbsp;&nbsp;<em>(If applicable FMLA will be followed)</em><br />	
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="13" required="yes" message="You must select a type of leave"><strong>Sick Leave</strong><br />	
                        </cfif>
                        <cfif #Session.LeaveType# eq 6>
                        	<cfinput type="radio" name="LeaveType" value="6" required="yes" message="You must select a type of leave" checked="yes"><strong>Leave without Pay</strong><br />
                        <cfelse>
                    		<cfinput type="radio" name="LeaveType" value="6" required="yes" message="You must select a type of leave"><strong>Leave without Pay</strong><br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 10>
                        	<cfinput type="radio" name="LeaveType" value="10" required="yes" message="You must select a type of leave" checked="yes">
                        	<strong>Vacation (YEAR-ROUND EMPLOYEES ONLY)</strong>
                            <cfelse>
                    		<cfinput type="radio" name="LeaveType" value="10" required="yes" message="You must select a type of leave">
                    		<strong>Vacation (YEAR-ROUND EMPLOYEES ONLY)</strong>
                        </cfif>
                    	<!---<strong>FMLA</strong> <em>(to run concurrent with Personal Leave)</em><br />
                    	Purpose of Personal/Sick Leave: <em>if 11 or more consecutive days</em><br />
                        <cfif #Session.LeaveType# eq 7>
                        	<cfinput type="radio" name="LeaveType" value="7" required="yes" message="You must select a type of leave" checked="yes">FMLA own serious health condition (if more than 11 consecutive days)<br />
                        <cfelse>
                    		<cfinput type="radio" name="LeaveType" value="7" required="yes" message="You must select a type of leave">FMLA own serious health condition (if more than 11 consecutive days)<br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 8>
                        	<cfinput type="radio" name="LeaveType" value="8" required="yes" message="You must select a type of leave" checked="yes">FMLA care for immediate family member with a serious health condition (if more than 11 consecutive days)<br />
                        <cfelse>
                    		<cfinput type="radio" name="LeaveType" value="8" required="yes" message="You must select a type of leave">FMLA care for immediate family member with a serious health condition (if more than 11 consecutive days)<br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 11>
                        	<cfinput type="radio" name="LeaveType" value="11" required="yes" message="You must select a type of leave" checked="yes">FMLA Military Exigency Leave<br />
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="11" required="yes" message="You must select a type of leave">FMLA Military Exigency Leave<br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 12>
                        	<cfinput type="radio" name="LeaveType" value="12" required="yes" message="You must select a type of leave" checked="yes">FMLA Military Caregiver Leave
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="12" required="yes" message="You must select a type of leave">FMLA Military Caregiver Leave
                        </cfif>
						--->
                    </td>
                    <td colspan="2">
                    	
                        <cfif #SEssion.LeaveType# eq 1>
                        	<cfinput type="radio" name="LeaveType" value="1" required="yes" message="You must select a type of leave" checked="yes"><strong>Bereavement</strong><br />
                    		&nbsp;&nbsp;&nbsp;&nbsp;<em>(Immediate Family Members**)</em> 
                    		<input type="text" name="bereavementrelationship" size="20" value="<cfoutput>#Session.bereavementrelationship#</cfoutput>" /><br />
                        <cfelse>
                    		<cfinput type="radio" name="LeaveType" value="1" required="yes" message="You must select a type of leave"><strong>Bereavement</strong><br />
                    		&nbsp;&nbsp;&nbsp;&nbsp;<em>(Immediate Family Members**)</em>
                    		<input type="text" name="bereavementrelationship" size="20" /><br />
                        </cfif>
						<cfif #Session.LeaveType# eq 4>
                        	<cfinput type="radio" name="LeaveType" value="4" required="yes" message="You must select a type of leave" checked="yes"><strong>Community Service</strong><br />
                    		&nbsp;&nbsp;&nbsp;&nbsp;<em>(Preapproval &amp; documentation required)</em><br />
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="4" required="yes" message="You must select a type of leave"><strong>Community Service</strong><br />
                    		&nbsp;&nbsp;&nbsp;&nbsp;<em>(Preapproval &amp; documentation required)</em><br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 3>
                        	<cfinput type="radio" name="LeaveType" value="3"required="yes" message="You must select a type of leave" checked="yes"><strong>Officiating/Judging</strong><br />
  		                	&nbsp;&nbsp;&nbsp;&nbsp;<em>(Documentation required)</em><br />
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="3"required="yes" message="You must select a type of leave"><strong>Officiating/Judging</strong><br />
  		                	&nbsp;&nbsp;&nbsp;&nbsp;<em>(Documentation required)</em><br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 14>
                        	<cfinput type="radio" name="LeaveType" value="14" required="yes" message="You must select a type of leave" checked="yes"><strong>Military Leave</strong> (Documentation Required)<br />	
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="14" required="yes" message="You must select a type of leave"><strong>Military Leave</strong> (Documentation Required)<br />	
                        </cfif>
                        <cfif #Session.LeaveType# eq 2>
                            <cfinput type="radio" name="LeaveType" value="2" required="yes" message="You must select a type of leave" checked="yes"><strong>Jury/Witness</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>(Documentation required)</em>
                            <cfelse>
                            <cfinput type="radio" name="LeaveType" value="2" required="yes" message="You must select a type of leave"><strong>Jury/Witness</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>(Documentation required)</em>
                    	</cfif>
                    </td>
                </tr><tr>
                </tr><tr>
                	<td colspan="2">
                    	
                    </td>
                    <td colspan="2">
                    	
                    	<cfif #Session.LeaveType# eq 5>
                        	<!---<cfinput type="radio" name="LeaveType" value="5" required="yes" message="You must select a type of leave" checked="yes"><strong>Emergency</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong> <em>submit documentation</em>--->
                        <cfelse>
                            <!---<cfinput type="radio" name="LeaveType" value="5" required="yes" message="You must select a type of leave"><strong>Emergency</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong> <em>submit documentation</em>--->
                        </cfif>
                    </td>
                </tr>
                <tr>
                	<td colspan="2">
                    	
                    </td>
                    <td colspan="2">
                    	
                    </td>
                </tr>
            	</cfif>
                <!---<tr>
                	<cfif isdefined('Session.subrequested_yn')>
                    	<cfif #Session.subrequested_yn# eq 'Yes'>
                        	<td colspan="4"><strong>Substitute requested
                    	<cfinput type="radio" name="subrequested_yn" value="Yes" required="yes" message="You must select if a sub was required or not" checked="yes">Yes  <cfinput type="radio" name="subrequested_yn" value="No" required="yes" message="You must select if a sub was required or not">Not Needed</strong>
                    </td>
						<cfelse>
                        	<td colspan="4">
                                &bull;<strong>Substitute requested<cfinput type="radio" name="subrequested_yn" value="Yes" required="yes" message="You must select if a sub was required or not">Yes  <cfinput type="radio" name="subrequested_yn" value="No" required="yes" message="You must select if a sub was required or not" checked="Yes">Not Needed</strong>
                            </td>
						</cfif>
                    <cfelse>
                        <td colspan="4">
                            &bull;<strong>Substitute requested<cfinput type="radio" name="subrequested_yn" value="Yes" required="yes" message="You must select if a sub was required or not">Yes  <cfinput type="radio" name="subrequested_yn" value="No" required="yes" message="You must select if a sub was required or not">Not Needed</strong>
                        </td>
                    </cfif>
                </tr>--->
                <tr>
                	<td colspan="2">
                    </td>
                    <td colspan="2">
                    </td>
                </tr>
            </cfif>
            <tr>
            	<cfif isdefined('Session.CommentsTo')>
					<cfif #Session.EmpType# eq 2>
                        <td colspan="4">Comments to HR:<br /><cftextarea cols="50" rows="4" name="comments" value="#SEssion.CommentsTo#" ></cftextarea></td>
                    <cfelse>
                    	<!---Comments to HR or explanation if day before or after a vacation period--->
                        <td colspan="4">Comments to HR:<br /><cftextarea cols="50" rows="4" name="comments" value="#SEssion.CommentsTo#"></cftextarea></td>
                    </cfif>
                <cfelse>
                	<cfif #Session.EmpType# eq 2>
                        <td colspan="4">Comments to HR:<br /><cftextarea cols="50" rows="4" name="comments"></cftextarea></td>
                    <cfelse>
                        <td colspan="4">Comments to HR:<br /><cftextarea cols="50" rows="4" name="comments"></cftextarea></td>
                    </cfif>
                </cfif>
            </tr>
            <tr>
            	<td colspan="3">Employee Signature (type in name):<cfif isdefined('Session.EmpSig')><cfinput type="text" name="EmpSig" size="50" required="yes" message="Enter your name as you would sign ex: John Q. Smith" value="#Session.EmpSig#"><cfelse><cfinput type="text" name="EmpSig" size="50" required="yes" message="Enter your name as you would sign ex: John Q. Smith" maxlength="50"></cfif></td>
                <td>Date: <cfoutput>#LSDateFormat(NOW(),'mm/dd/yyyy')#</cfoutput></td>
            </tr>
            <tr>
            	<td colspan="4">Enter Supervisor's Email address <strong>(you must search for email address)</strong>:
       	      <cfif isdefined('Session.SupEmail')><cfinput type="text" name="SupEmail" size="50" value="#Session.SupEmail#" readonly="yes"><cfelse><cfinput type="text" name="SupEmail" size="50" readonly="yes"></cfif>
       				<cfinput type="submit" name="SearchSup" value="Search for Email">
                </td>
            </tr>
            <tr>
            	<td colspan="4">
                	Enter Secretary or Secondary Supervisor's Email address <strong>(you must search for email address)</strong>:
       	      <cfif isdefined('Session.SupEmail2') ><cfinput type="text" name="SupEmail2" size="50" value="#Session.SupEmail2#" readonly="yes"><cfelse><cfinput type="text" name="SupEmail2" size="50" readonly="yes"></cfif>
       				<cfinput type="submit" name="SearchSup2" value="Search for Email">	
                </td>
            </tr>
            <!---<tr>
            	<td colspan="4">&nbsp;</td>
            </tr>--->
            <tr align="center">
            	<td colspan="4"><cfinput type="submit" name="Submit" value="Submit"></td>
            </tr>
            <tr>
            	<td colspan="4">
                    <strong><u>Definitions:</u></strong><br />
                    <strong>*Blackout day:</strong> The day immediately preceding and/or follwoing a vacation period as defined on the adopted District Calendar or the first or last student contact days.<br /><br />
                    <strong>**Immediate Family Member:</strong> father, father-in-law, step-father, mother, mother-in-law, step-mother, grandparents, grandchild, sister, sister-in-law, step-sister, brother, brother-in-law, step-brother, son-in-law, daughter-in-law, husband, wife, child, stepchild, or individual living in household.<br /><br />
                    <cfif Session.EmpType eq 2>
                        <strong>***Personal Leave:</strong> Full-time employees may be granted personal leave as follows:
                        <ul>
                            <li>Year-Round employees may use three (3) days of sick leave per fiscal year, beginning July 1st, for the purpose of conducting personal business.</li>
                            <li>Employees who are not year-round may use six (6) days of sick leave per fiscal year, beginning July 1st, for the purpose of conducting personal business.</li>
                            <li>Personal leave is charged against accrued sick leave, and is not accumulative from contract year-to-year.</li>
                        </ul> <br /><br />
                        Click on the following to view the full Leaves and Absences Policies:<br />
                        <ul>
                            <li><a href="https://www.mesa.k12.co.us/board/policies/documents/gdc.pdf" target="_blank">Support Staff</a></li>
                            <li><a href="https://www.mesa.k12.co.us/board/policies/documents/gcd.pdf" target="_blank">Adminstrators</a></li>
                        </ul>
                   </cfif>            
                </td>
            </tr>
            <cfif Session.EmpType eq 1>
            <tr>
            	<td colspan="4"><p><strong>Employees covered under MVEA</strong><br />
            	  Day leave may be used for sick leave of the employee, to attend to the illness of immediate family, emergency, and personal business for the employee.  In the event an employee is requesting 3 consecutive days or more of leave, he/she must submit a &quot;Request and approval for Leave&quot; form as soon as possible to his/her administrator(s).  The form will contain an affirmation that the leave will not be used for vacation or job interviews. <strong>Days immediately preceding and/or following vacation periods and the first and last student contact days are not usable for day leave excepting in case of illness or if there are extenuating circumstances.</strong></p>
            	  <p>For more information on available leave options please see joint MVEA Agreement section 9</p>
            	  <p>In the event an Employee  Leave Request is denied, the Covered Employee may file an appeal.&nbsp; The  appeal must be submitted in writing to the Human Resources Department no later  than 30 calendar days after the date of the leave and shall include a statement  as to why the leave should be approved. &nbsp;The Employee Leave Request  Appeals Panel shall consist of representation from MVEA, Human Resources and  administration.&nbsp; The following criteria will be reviewed and taken into  consideration by the Employee Leave Request Appeal Panel:</p>
                  <ol>
                    <li>Day Leave Usage History </li>
                    <li>Reason for the Request</li>
                    <li>Covered Employee Provided Statement</li>
                    <li>Any additional information as requested  by the panel</li>
                </ol></td>
            </tr>
            </cfif>
        </table>
        <table width="100%">
            <tr><td><input type="submit" name="logout" value="Logout" /></td></tr>
        </table>
    </cfform>

<!--- View Specific Request --->
<cfelseif StepNum eq 5>    
    <!--- Get Request Data --->
    <cfquery name="GetRequestData"  datasource="mesa_web">
    	SELECT *
        FROM	LeaveReq_tblRequest
        WHERE	RequestID = #RequestID# and userid = '#Session.Username#'
    </cfquery>
    
    <cfoutput query="GetRequestData">
        <table width="100%" border="1">
            <tr>
                <td align="center" colspan="6">Leave Request ##: #RequestID#</td>
            </tr>
            <tr>
            	<td>Dates of Requested</td>
                <td>Type of Leave Request</td>
                <td>Sub Needed/Aesop/Frontline ##</td>
                <td>Supervisor</td>
                <td>Viewed By Supervisor</td>
                <td>Approved by Human Resources</td>
            </tr>
            <tr>
            	<td>#LSDateFormat(dtFrom,'mm/dd/yyyy')#-#LSDateFormat(dtTo,'mm/dd/yyyy')#</td>
                <cfif #GetRequestData.requesttype# eq 1>
                	<td>Bereavement</td>
                <cfelseif #GetRequestData.requesttype# eq 2>
                	<td>Jury/Witness</td>
                <cfelseif #GetRequestData.requesttype# eq 3>
                	<td>Officiating/Judging</td>
                <cfelseif #GetRequestData.requesttype# eq 4>
                	<td>Community Service</td>
                <cfelseif #GetRequestData.requesttype# eq 5>
                	<!---<td>Emergency</td>--->
                <cfelseif #GetRequestData.requesttype# eq 6>
                	<td>Leave without Pay</td>
                <cfelseif #GetRequestData.requesttype# eq 7>
                	<td>FMLA own serious health condition</td>
                <cfelseif #GetRequestData.requesttype# eq 8>
                	<td>FMLA care ofr immediate family member with a serious health condition</td>
                <cfelseif #GetRequestData.requesttype# eq 9>
                	<td>Day or Personal Leave</td>
               	<cfelseif #GetRequestData.requesttype# eq 10>
                	<td>Vacation</td>
                <cfelseif #GetRequestData.requesttype# eq 11>
                	<td>FMLA Military Exigency Leave</td>
                <cfelseif #GetRequestData.requesttype# eq 12>
                	<td>FMLA Military Caregiver Leave</td>
                <cfelseif #GetRequestData.requesttype# eq 13>
                	<td>Sick Leave</td>
                <cfelseif #GetRequestData.requesttype# eq 14>
                	<td>Military Leave</td>
                </cfif>
                <td>#subrequested#/#subfindernum#</td>
                <td>#supervisor#</td>
                <td>#supviewed#</td>
                <td>#approved#</td>
            </tr>
        </table>
    </cfoutput>
<!--- 6 = Attach file if Jury Duty or Community Service Selected --->
<cfelseif StepNum eq 6>
<cfif isDefined("fileUpload")>
	<cfif #form.uploadfile# neq 'mail'>
    	<cffile action="upload"
       		fileField="fileUpload"
            nameconflict="makeunique"
         	destination="\\BSWEBS11\distweb$\apps\LeaveRequest\Attachments\">
         	<p>Thank you, your file has been uploaded.</p>
     </cfif>
     
	 <cfif #form.uploadfile# eq 'mail'>
        <cfset Session.FileName= 'mailing'>
     <cfelse>
        <cfset Session.FileName = '#cffile.serverFileName#.#cffile.serverFileExt#'>
     </cfif>
     <cflocation url="index.cfm?StepNum=998">
</cfif>
<form enctype="multipart/form-data" method="post">
<input type="radio" name="uploadfile" value="mail" />Mail Form to Human Resources Office<br />
<input type="radio" name="uploadfile" value="attach" />Upload File<br />
<input type="file" name="fileUpload" /><br />
<input type="submit" value="Upload File or Continue" />
</form>
<!--- 7 = Search for Supervisor --->
<cfelseif StepNum eq 7>

<cfif isdefined('form.search')>
	<cfquery name="SearchSup" datasource="accounts">
    	SELECT	Full_Name, Username, fname, lname, building, Email
        FROM	accounts
        WHERE	#form.searchcolumn# like '%#form.searchinfo#%' AND Groups NOT LIKE '%students'
        order by lname, fname
    </cfquery>
</cfif>
<cfif isdefined('SupEmail')>
	<cfset Session.SupEmail = '#SupEmail#'>
    <cflocation url="index.cfm?StepNum=4">
</cfif>
	<cfform name="SearchSupEmail" method="post" action="index.cfm?StepNum=7">
    	<table width="100%" border="1">
        	<tr>
            	<td align="center">Search for Supervisors Email</td>
            </tr>
            <tr>
            	<td align="center">
                	<cfinput type="text" name="searchinfo" width="120" label="Search for:">
                    <cfselect name="searchcolumn" label="in:"  width="90">
                        <option value="lname">LastName</option>
                        <option value="fname">FirstName</option>
                    </cfselect>
                </td>
            </tr>
            <tr>
            	<td align="center"><cfinput type="submit" name="search" value="Search"></td>
            </tr>
        </table>
        <cfif isdefined('form.search')>
        	<table width="100%" border="1">
            	<tr>
                	<td align="center" colspan="5">Results: (click email address to return to Leave Request Form)</td>
                </tr>
                <tr>
                	<td>Full Name</td>
                    <td>Last Name</td>
                    <td>First Name</td>
                    <td>Building</td>
                    <td>Email</td>
                </tr>
                <cfoutput query="SearchSup">
                	<tr>
                    	<td>#Full_Name#</td>
                        <td>#lname#</td>
                        <td>#fname#</td>
                        <td>#building#</td>
                        <td><a href="index.cfm?StepNum=7&SupEmail=#Email#">#Email#</a></td>
                    </tr>
                </cfoutput>
            </table>
        </cfif>
    </cfform>
<!--- Sup 2 Email --->
<cfelseif StepNum eq 8>
<cfif isdefined('form.search')>
	<cfquery name="SearchSup" datasource="accounts">
    	SELECT	Full_Name, Username, fname, lname, building, Email
        FROM	accounts
        WHERE	#form.searchcolumn# like '%#form.searchinfo#%' AND Groups NOT LIKE '%students'
        order by lname, fname
    </cfquery>
</cfif>
<cfif isdefined('SupEmail2')>
	<cfset Session.SupEmail2 = '#SupEmail2#'>
    <cflocation url="index.cfm?StepNum=4">
</cfif>
	<cfform name="SearchSupEmail" method="post" action="index.cfm?StepNum=8">
    	<table width="100%" border="1">
        	<tr>
            	<td align="center">Search for Supervisors Email</td>
            </tr>
            <tr>
            	<td align="center">
                	<cfinput type="text" name="searchinfo" width="120" label="Search for:">
                    <cfselect name="searchcolumn" label="in:"  width="90">
                        <option value="lname">LastName</option>
                        <option value="fname">FirstName</option>
                    </cfselect>
                </td>
            </tr>
            <tr>
            	<td align="center">You must click search button
            	  <cfinput type="submit" name="search" value="Search"></td>
            </tr>
        </table>
        <cfif isdefined('form.search')>
        	<table width="100%" border="1">
            	<tr>
                	<td align="center" colspan="5">Results: (click email address to return to Leave Request Form)</td>
                </tr>
                <tr>
                	<td>Full Name</td>
                    <td>Last Name</td>
                    <td>First Name</td>
                    <td>Building</td>
                    <td>Email</td>
                </tr>
                <cfoutput query="SearchSup">
                	<tr>
                    	<td>#Full_Name#</td>
                        <td>#lname#</td>
                        <td>#fname#</td>
                        <td>#building#</td>
                        <td><a href="index.cfm?StepNum=8&SupEmail2=#email#">#email#</a></td>
                    </tr>
                </cfoutput>
            </table>
        </cfif>
    </cfform>
<!---Testing redirect from errors --->
<cfelseif StepNum eq 9>
	<cfif Session.bereavementrelationship eq '' and isdefined('errcode')>
    	<cfif #errcode# eq 1>
    		<cflocation url="index.cfm?StepNum=4&errcode=1">
        </cfif>
	<cfelse>
    	<cflocation url="index.cfm?StepNum=998">
    </cfif>
<!--- notification of request entry then redirect send email to supervisor--->
<cfelseif StepNum eq 996>

<!--- Send Email to Employee Supervisor basied on data entered in SupEmail text box
		If not a valid email address (contains d51schools.org) give option to print request --->

<cfmail from="hr@d51schools.org" to="#Session.SupEmail#" subject="Leave Request Form" type="html">
    #Session.EmpName# has made a Leave Request.  Click on the following link to review the request.<br />
    <a href="http://www.mesa.k12.co.us/apps/LeaveRequest/supervisornew.cfm">Click Here to Review Leave Request</a>	
</cfmail>

<cfif isdefined('Session.SupEmail2')>
<cfif #SEssion.SupEmail2# gt ''>
    <cfmail from="hr@d51schools.org" to="#Session.SupEmail2#" subject="Leave Request Form" type="html">
        #Session.EmpName# has made a Leave Request.  Click on the following link to review the request.<br />
        <a href="http://www.mesa.k12.co.us/apps/LeaveRequest/supervisornew.cfm">Click Here to Review Leave Request</a>	
    </cfmail>
</cfif>
</cfif>

Your Request for Leave has been entered into the system.  This page will automatically refresh.
<meta http-equiv="Refresh" content="5;URL=index.cfm?StepNum=1" />

<!--- Set Session Variables to Insert Request --->
<cfelseif StepNum eq 997>
	<cfinclude template="logout.cfm">
    
    <!--- Set Session Variables --->
    <cfset Session.EmpName = '#Form.EmpName#'>
    <cfset Session.EmpID = '#Form.EmpID#'>
    <cfset Session.EmpBuilding = '#Form.EmpBuilding#'>
    <!---<cfset Session.ReqDates = '#Form.ReqDates#'>--->
    <cfset Session.ReqDateFrom = '#Form.ReqDateFrom#'>
    <cfset Session.ReqDateTo = '#Form.ReqDateTo#'>
    <cfset Session.ReqNumDays= '#Form.ReqNumDays#'>
    
    <cfset Session.LeaveType = '#Form.LeaveType#'>
    <cfset Session.dayleavereason = '#Form.dayleavereason#'>
    <cfset Session.bereavementrelationship = '#Form.bereavementrelationship#'>
    
    <!--- if Certified --->
    <cfif Session.EmpType eq 1>
    	<cfset Session.subfinderid = '#Form.subfindernum#'>
    <cfelse>
    	<cfset Session.subfinderid = 0>
    </cfif>
    <!--- If Classified --->
    <cfif Session.EmpType eq 2>
    	<cfset Session.subrequested_yn = ''>
    <cfelse>
    	<cfset Session.subrequested_yn = ''>
    </cfif>
    <cfset Session.EmpSig = '#Form.EmpSig#'>
    <cfset TempSup1 = #Replace(#Form.SupEmail#, " ", "", "all")#>
    <cfset Session.SupEmail = '#TempSup1#'>
    <cfset TempSup2 = #Replace(#Form.SupEmail2#, " ", "", "all")#>
    <cfset Session.SupEmail2 = '#TempSup2#'>
    <cfset Session.CommentsTo = '#Form.Comments#'>
    
    <!--- Get Max RequestID and increment --->
    <cfquery name="GetMaxReqID" datasource="mesa_web">
    	SELECT	MAX(requestid) as MaxID
        FROM	LeaveReq_tblRequest
    </cfquery>
    <cfset Session.RequestID = #GetMaxReqID.MaxID# + 1>
    
    <cfset Session.DateEntered = '#NOW()#'>
    <cfset Session.yearofrequest = '2024-2025'>
    <cfset Session.FileName = ''>
    <cfif isdefined('form.SearchSup')>
    	<cflocation url="index.cfm?StepNum=7">
    <cfelseif isdefined('form.SearchSup2')>
    	<cflocation url="index.cfm?StepNum=8">
	<cfelseif #Session.LeaveType# eq 2 OR #Session.LeaveType# eq 4>
   		<cflocation url="index.cfm?StepNum=6">
    <cfelseif #Session.LeaveType# eq 1>
    	<cfif #Session.bereavementrelationship# eq ''>
    		<cflocation url="index.cfm?StepNum=9&errcode=1">
        <cfelse>
        	<cflocation url="index.cfm?StepNum=998">
        </cfif>
    <cfelse>
        <cflocation url="index.cfm?StepNum=998">
    </cfif>
<!--- Insert Request Into Database --->
<cfelseif StepNum eq 998>
	
    <!--- Insert Request Data Into Database --->
    <cfquery name="InsertReqData" datasource="mesa_web">
    	INSERT INTO LeaveReq_tblRequest
        			(requestid, userid, dateentered, yearofrequest, requesttype, dayleavereason, subfindernum, subrequested, bereavementrelate,
                    signature, signaturedate, supervisor, supervisor2, emptype, Attachment, commentstohr, dtFrom, dtTo, NumDays)
        VALUES		('#Session.RequestID#', '#Session.Username#', #Session.DateEntered#, '#Session.yearofrequest#', '#Session.LeaveType#', '#Session.dayleavereason#', '#Session.subfinderid#', '#Session.subrequested_yn#', '#Session.bereavementrelationship#', '#Session.EmpSig#', #Session.DateEntered#, '#Session.SupEmail#', '#Session.SupEmail2#', #Session.EmpType#, '#Session.FileName#', '#Session.CommentsTo#', '#Session.ReqDateFrom#', '#Session.ReqDateTo#', '#Session.ReqNumDays#')
        
    </cfquery>
    
    <!--- Insert / Update Employee Information --->
    
    
    <!--- Go to request entered ---> 
    <cflocation url="index.cfm?StepNum=996">
    
<!--- Logout of system ---> 
<cfelseif StepNum eq 999>
	<cfcookie name="CFID" expires="now">
	<cfcookie name="CFTOKEN" expires="now">
	<cfscript>
   		StructClear(Session);
	</cfscript>
	<cflocation url="index.cfm">
<!--- End Steps --->
</cfif>

    <!-- InstanceEndEditable --> 	
  	</div>
	 	<br class="clearfloat" />
  	<div id="footer" class="noprint">
  	<cfinclude template="/templates/components/footer.cfm">
  </div>
</div>
</div>
  <!-- end #footer -->

<!-- end #container -->

</body>
<!-- InstanceEnd --></html>