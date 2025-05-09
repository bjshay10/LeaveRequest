<cfapplication name="EmployeeLeaveRequest" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,0,20,0)#">
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
				<center>Leave Request Form</center>
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
	<cfform name="form2" method="post" action="" format="flash" width="500" height="550"  skin="haloblue">
		<cfformgroup type="panel" label="Leave Request Form">
		<cfinput name="username" type="text" size="20" label="Username:" onkeydown="if(Key.isDown(Key.ENTER)) Submituser.dispatchEvent({type:'click'});">

 	 	<cfinput name="password" type="password" size="20" label="Password:" onkeydown="if(Key.isDown(Key.ENTER)) Submituser.dispatchEvent({type:'click'});">
</td>
    	<cfinput type="submit" name="Submituser" value="Submit">
		
		</cfformgroup>
   	</cfform>
</cfif>

<!--- Check Username and Password --->
	<cfif isdefined ("submituser")>
        <cfquery name="getaccounts" datasource="accounts">
            SELECT     
                Accounts.Username, Accounts.Building, Building.building_number, Accounts.Full_Name, Accounts.Groups, Accounts.SocSecNum
            FROM         
                Accounts INNER JOIN
                          Building ON Accounts.Building = Building.Building
            WHERE
                (ACCOUNTS.USERNAME = '#username#') and 
                (Accounts.password = '#password#')
        </cfquery>
        
        <!--- valid username and password --->
        <cfif getaccounts.recordcount eq 0>
            <cflocation url="index.cfm?tryagain" addtoken="no">
        <cfelse>
            <!--- Set Session Variable username, building ect. --->
            <cfset Session.Username = '#getaccounts.Username#'>
            <cfset Session.Building = '#getaccounts.Building#'>
            <cfset Session.BuildingNum = '#getaccounts.building_number#'>
            <cfset Session.FullName = '#getaccounts.Full_Name#'>
            <cfset Session.Groups = '#getaccounts.Groups#'>
            <cfset Session.SSN = '#getaccounts.SocSecNum#'>
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
                <tr>
                	<td>
                    	<strong>Classified Positions include: </strong>All Administrators (including Principals), Instructional Assistants, Nutrition Services, Secretaries, Grounds, maintenance, etc.<br />
                        <strong>Certified Positions include: </strong>Teachers, Nurses, Psychologists, Audiologists, etc.<br />
                        <strong>For further information concerning the rules regulating your position continue to read below.</strong><br /><br />
                    </td>
                </tr>
                <tr align="Left">
                	<td >
                    	<table border="1" width="100%"><tr><td>
                    	Teachers, Nurses, Psychologists, Audiologists, etc.<br />
                    	<input type="radio" name="EmpType" value="1" /><strong>Certified Employees:</strong><br /><br />
                        All Administrators (including Principals), Instructional Assistants, Nutrition Services, Secretaries, Grounds, maintenance, etc.<br />
                        <input type="radio" name="EmpType" value="2" /><strong>Classified Employees and Administrators:</strong><br />
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
       	    	<tr>
                	<td>
                    	<strong>Certified Day Leave: Employee's covered under MVEA</strong><br />
                        Day leave may be used for sick leave of the employee, to attend to the illness of immediate family, emergency, and personal business for the employee.  Day Leave is not intended for vacation for the employee.  In the event an employee is requesting 3 consecutive days or more of leave, he/she must submit a &quot;Request and approval for Leave&quot; form as soon as possible to his/her administrator(s).  The form will contain an affirmation that the leave will not be used for vacation.  <strong>Days immediately preceding and/or following vacation periods and the first and last student contact days are not usable for day leave excepting in case of illness.</strong>
                    </td>
            	</tr>
            	<tr>
                	<td>
                    	<ul>
                        	<li><strong>GOLDEN TICKET:</strong> Awarded from a pool of teachers who use 4 or fewer days of day leave in the prior year.  Golden tickets can be used for days that are not usable for day leave, such as days immediately preceding and/or following vacation periods.  Golden Ticket usage is charged against the employees day leave balance.</li>
                        </ul>
                    </td>
                </tr>
                <tr>
                	<td>
                    	<strong>Classified Personnel Leave:  Employee's covered under Board Policy* and AFSCME**</strong><br />
                        Personal leave may be used for emergency and personal business for the employee.  Personal leave is not intended for vacation for the employee.  In the event an employee is requesting leave he/she must submit a �Request and Approval for Leave� form as soon as possible to his/her administrator(s).  The form will contain an affirmation that the leave will not be used for vacation.  <strong>Days immediately preceding and/or following vacation periods or holidays are not usable for personal leave.</strong>  Personal leave my not be used for the purpose of a job interview, recreation, or entertainment.
                    </td>
                </tr>
                <tr>
                	<td>
                    	<ul>
                        	<li>260 day employees Board Policy* may use 3 days of sick leave per fiscal year for the purpose of conducting personal business.</li>
                            <li>Less thean 260 days may use 6 days of sick leave per fiscal year for the purpose of conducting personal business.</li>
                            <li>260 day employees AFSCME** may use 3 days of sick leave per fiscal year for the purpose of conducting personal business.</li>
                            <li>Less than 260 days may use 6 days of sick leave per fiscal year for the purpose of conducting personal business.</li>
                        </ul>
                    </td>
                </tr>
                <tr>
                	<td>
                    	<strong>Board Policy* and AFSCME** Members</strong><br />
                        * Board Policy Employees include: Classified Administrators, Classified Exempt Employees, Executive Secretaries, Food Service Workers, Grounds Personnel, Instructional Assistant, Maintenance Workers, Specialist, warehouse, and all other classified positions not covered by AFSCME.<br /><br />
                        ** AFSCME (American Federation of State and County Municipal Employees) Employees include: Clerks, Secretaries, Custodians, Garage Workers and Technicians.
                    </td>
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
    	SELECT	RequestID, userid, requesteddates, requesttype, approved
        FROM	LeaveReq_tblRequest
        WHERE	userid = '#Session.Username#' and yearofrequest = '2010-2011'
        ORDER BY approved, requesteddates
    </cfquery>
    
    <table width="100%">
    	<tr>
        	<td colspan="5" align="center">Leave Requests Entered Into the System</td>
        </tr>
        <tr>
        	<td>Request ID (click to view request)</td>
            <td>User Name</td>
            <td>Dates Requested</td>
            <td>Leave Type</td>
            <td>Status</td>
        </tr>
        <cfoutput query="GetRequests">
        	<tr>
            	<td><a href="index.cfm?StepNum=5&requestID=#GetRequests.RequestID#">#RequestID#</a></td>
                <td>#userid#</td>
                <td>#requesteddates#</td>
                <cfif #GetRequests.requesttype# eq 1>
                	<td>Bereavement</td>
                <cfelseif #GetRequests.requesttype# eq 2>
                	<td>Jury/Witness</td>
                <cfelseif #GetRequests.requesttype# eq 3>
                	<td>Officiating/Judging</td>
                <cfelseif #GetRequests.requesttype# eq 4>
                	<td>Community Service</td>
                <cfelseif #GetRequests.requesttype# eq 5>
                	<td>Emergency</td>
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
            	<td colspan="4">
                	Enter Date(s) you are Requesting:
                    <cfif isdefined('Session.ReqDates')>
                    	<cfinput type="text" name="ReqDates" size="125" required="yes" message="You must enter the Date(s) you are requesting leave for" value="#Session.ReqDates#"><br />
                    <cfelse>
                    	<cfinput type="text" name="ReqDates" size="125" required="yes" message="You must enter the Date(s) you are requesting leave for"><br />
                    </cfif>
                </td>
            </tr>
            <!--- if Certified Employee --->
            <cfif Session.EmpType eq 1>
            	<tr>
                    <td colspan="4">Check Leave Type You Are Requesting:  for an explanation of leave types please refer to the MVEA agreement</td>
                </tr>
                <cfif isdefined('Session.LeaveType')>
                <tr>
                	<td colspan="2">
                    	<!--- Day Leave --->
                        <strong>Day Leave Section 9.1</strong><br />
                        <cfif #Session.LeaveType# eq 9>
                        	<cfinput type="radio" name="LeaveType" value="9" required="yes" message="You must select a type of leave" checked="yes">Day Leave: <em>if 3 consecutive days or more, or the day before or after a holiday,</em><br />
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="9" required="yes" message="You must select a type of leave">Day Leave: <em>if 3 consecutive days or more, or the day before or after a holiday,</em><br />
                        </cfif>
                        &nbsp;&nbsp;&nbsp;&nbsp;<strong>I affirm that this leave is not being used for vacation;</strong> <em>purpose of the Day Leave if the day before or after holiday</em>
                        <cfif isdefined('Sesssion.dayleavereason')>
                        	<cfinput type="text" name="dayleavereason" value="#Session.dayleavereason#"><br />
                        <cfelse>
                        	<cfinput type="text" name="dayleavereason"><br />
                        </cfif>
                        <strong>FMLA</strong> <em>(to rum concurrent with Day Leave)</em><br />
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
                        </cfif>
                    </td>
                    <td colspan="2">
                    	<cfif #Session.LeaveType# eq 1>
                        	<cfinput type="radio" name="LeaveType" value="1" required="yes" message="You must select a type of leave"><strong>Bereavement Section 9.2</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>Statement of relationship required</em> <input type="text" name="bereavementrelationship" size="20" value="<cfoutput>#Session.bereavementrelationship#</cfoutput>" /><br /><br />
                        <cfelse>
                            <cfinput type="radio" name="LeaveType" value="1" required="yes" message="You must select a type of leave"><strong>Bereavement Section 9.2</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>Statement of relationship required</em> <input type="text" name="bereavementrelationship" size="20" /><br /><br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 4>
                        	<cfinput type="radio" name="LeaveType" value="4" required="yes" message="You must select a type of leave" checked="yes"><strong>Community Service Section 9.4</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong><em> submit documentation</em><br /><br />
                        <cfelse>
                            <cfinput type="radio" name="LeaveType" value="4" required="yes" message="You must select a type of leave"><strong>Community Service Section 9.4</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong><em> submit documentation</em><br /><br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 3>
                        	<cfinput type="radio" name="LeaveType" value="3" required="yes" message="You must select a type of leave" checked="yes"><strong>Officiating/Judging Section 9.5</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong><em> submit documentation</em><br /><br />
                        <cfelse>
                            <cfinput type="radio" name="LeaveType" value="3" required="yes" message="You must select a type of leave"><strong>Officiating/Judging Section 9.5</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong><em> submit documentation</em><br /><br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 5>
                        	<cfinput type="radio" name="LeaveType" value="5" required="yes" message="You must select a type of leave" checked="yes"><strong>Emergency Section 9.6</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong> <em>submit documentation</em>
                        <cfelse>
                            <cfinput type="radio" name="LeaveType" value="5" required="yes" message="You must select a type of leave"><strong>Emergency Section 9.6</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong> <em>submit documentation</em>	                        
                        </cfif>
                    </td>
                </tr>
                <tr>
                	<td colspan="2">
                    	<!--- Leave without pay --->
                        <cfif #Session.LeaveType# eq 6>
                        	<cfinput type="radio" name="LeaveType" value="6" required="yes" message="You must select a type of leave" checked="yes"><strong>Leave without Pay</strong><br />
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="6" required="yes" message="You must select a type of leave"><strong>Leave without Pay</strong><br />
                        </cfif>
                    </td>
                    <td colspan="2">
                    	<!--- Jury/Witness --->  
                        <cfif #Session.LeaveType# eq 2>
                        	<cfinput type="radio" name="LeaveType" value="2" required="yes" message="You must select a type of leave" checked="yes"><strong>Jury/Witness Section 9.7-8</strong><br />
                    		&nbsp;&nbsp;&nbsp;&nbsp;<em>Documentation required:</em><strong>MUST</strong><em> submit subpoena or juror certificate with this form</em>
                        <cfelse>                      
                            <cfinput type="radio" name="LeaveType" value="2" required="yes" message="You must select a type of leave"><strong>Jury/Witness Section 9.7-8</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>Documentation required:</em><strong>MUST</strong><em> submit subpoena or juror certificate with this form</em>
                        </cfif>
                    </td>
                </tr>
                <cfelse>
                <!--- if session.leavetype not exists begin--->
                <tr>
                	<td colspan="2">
                    	<!--- Day Leave --->
                        <strong>Day Leave Section 9.1</strong><br />
                        <cfinput type="radio" name="LeaveType" value="9" required="yes" message="You must select a type of leave">Day Leave: <em>if 3 consecutive days or more, or the day before or after a holiday,</em><br />
                        &nbsp;&nbsp;&nbsp;&nbsp;<strong>I affirm that this leave is not being used for vacation;</strong> <em>purpose of the Day Leave if the day before or after holiday</em>
                        <cfinput type="text" name="dayleavereason" ><br />
                        <strong>FMLA</strong> <em>(to rum concurrent with Day Leave)</em><br />
                        Purpose of Day Leave: if 11 or more consecutive days
                        <cfinput type="radio" name="LeaveType" value="7" required="yes" message="You must select a type of leave">FMLA own serious health condition (if more than 11 consecutive days)<br />
                        <cfinput type="radio" name="LeaveType" value="8" required="yes" message="You must select a type of leave">FMLA care for immediate family member with a serious health condition (if more than 11 consecutive days)<br />
                        <cfinput type="radio" name="LeaveType" value="11" required="yes" message="You must select a type of leave">FMLA Military Exigency Leave<br />
                        <cfinput type="radio" name="LeaveType" value="12" required="yes" message="You must select a type of leave">FMLA Military Caregiver Leave<br />
                    </td>
                    <td colspan="2">
                    	
                    	<cfinput type="radio" name="LeaveType" value="1" required="yes" message="You must select a type of leave"><strong>Bereavement Section 9.2</strong><br />
                    	&nbsp;&nbsp;&nbsp;&nbsp;<em>Statement of relationship required</em> <input type="text" name="bereavementrelationship" size="20" /><br /><br />
                        <cfinput type="radio" name="LeaveType" value="4" required="yes" message="You must select a type of leave"><strong>Community Service Section 9.4</strong><br />
                    	&nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong><em> submit documentation</em><br /><br />
                        <cfinput type="radio" name="LeaveType" value="3" required="yes" message="You must select a type of leave"><strong>Officiating/Judging Section 9.5</strong><br />
                    	&nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong><em> submit documentation</em><br /><br />
                        <cfinput type="radio" name="LeaveType" value="5" required="yes" message="You must select a type of leave"><strong>Emergency Section 9.6</strong><br />
                  		&nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong> <em>submit documentation</em>	                        
                    </td>
                </tr>
                <tr>
                	<td colspan="2">
                    	<!--- Leave without pay --->
                        <cfinput type="radio" name="LeaveType" value="6" required="yes" message="You must select a type of leave"><strong>Leave without Pay</strong><br />
                    </td>
                    <td colspan="2">
                    	<!--- Jury/Witness --->   
                       <cfinput type="radio" name="LeaveType" value="2" required="yes" message="You must select a type of leave"><strong>Jury/Witness Section 9.7-8</strong><br />
                        &nbsp;&nbsp;&nbsp;&nbsp;<em>Documentation required:</em><strong>MUST</strong><em> submit subpoena or juror certificate with this form</em>
                    </td>
                </tr>
                </cfif>
                    
                
                <!--- if Session.LeaveType not exists end--->
                <tr>
                	<td colspan="4">
                    	&bull;<strong>I have requested a substitute, please enter Subfinder Job #:</strong>
                    	<cfif isdefined('Session.subfinderid')><cfinput type="text" name="subfindernum" value="#Session.subfinderid#" required="yes" validate="integer" message="Sub Finder Number must be numeric"><cfelse><cfinput type="text" name="subfindernum" value="0" validate="integer" required="yes" message="Sub Finder Number must be numeric"></cfif>
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
                    <td colspan="4">Check Leave Type You Are Requesting:  for an explanation of leave types please refer to the AFSCME agreement, or Board Policy</td>
                </tr>
                	<tr><td colspan="2">
                    	<strong>Personal</strong><br />
                    	<cfinput type="radio" name="LeaveType" value="9" required="yes" message="You must select a type of leave">Personal Leave, <strong>I affirm that this leave is not being used for vacation</strong><br />
                    	<strong>FMLA</strong> <em>(to run concurrent with Personal Leave)</em><br />
                        <cfinput type="hidden" name="dayleavereason"><br />
                    	<cfinput type="radio" name="LeaveType" value="7" required="yes" message="You must select a type of leave">FMLA own serious health condition (if more than 11 consecutive days)<br />
                    	<cfinput type="radio" name="LeaveType" value="8" required="yes" message="You must select a type of leave">FMLA care for immediate family member with a serious health condition (if more than 11 consecutive days)<br />
                        <cfinput type="radio" name="LeaveType" value="11" required="yes" message="You must select a type of leave">FMLA Military Exigency Leave<br />
                        <cfinput type="radio" name="LeaveType" value="12" required="yes" message="You must select a type of leave">FMLA Military Caregiver Leave
                    </td>
                    <td colspan="2">
                    	<cfinput type="radio" name="LeaveType" value="13" required="yes" message="You must select a type of Leave"><strong>Sick Leave</strong><br />
                    	<cfinput type="radio" name="LeaveType" value="1" required="yes" message="You must select a type of leave"><strong>Bereavement</strong><br />
                    	&nbsp;&nbsp;&nbsp;&nbsp;<em>Statement of relationship required</em> <input type="text" name="bereavementrelationship" size="20" /><br />
                        <cfinput type="radio" name="LeaveType" value="4" required="yes" message="You must select a type of leave"><strong>Community Service</strong><br />
                    	&nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong><em> submit documentation</em><br />
                        <cfinput type="radio" name="LeaveType" value="3"required="yes" message="You must select a type of leave"><strong>Officiating/Judging</strong><br />
  		                &nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong><em> submit documentation</em><br />
                    </td>
                </tr><tr>
                </tr><tr>
                	<td colspan="2">
                    	 <cfinput type="radio" name="LeaveType" value="6" required="yes" message="You must select a type of leave"><strong>Leave without Pay</strong><br />
                    </td>
                    <td colspan="2">
                    	 <cfinput type="radio" name="LeaveType" value="5" required="yes" message="You must select a type of leave"><strong>Emergency</strong><br />
                  		&nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong> <em>submit documentation</em>
                    </td>
                </tr>
                <tr>
                	<td colspan="2">
                    	<cfinput type="radio" name="LeaveType" value="10" required="yes" message="You must select a type of leave"><strong>Vacation</strong>
                    </td>
                    <td colspan="2">
                    	<cfinput type="radio" name="LeaveType" value="2" required="yes" message="You must select a type of leave"><strong>Jury/Witness</strong><br />
                    	&nbsp;&nbsp;&nbsp;&nbsp;<em>Documentation required:</em><strong>MUST</strong><em> submit subpoena or juror certificate with this form</em>
                    </td>
                </tr>
                <cfelse>
                <tr>
                    <td colspan="4">Check Leave Type You Are Requesting:  for an explanation of leave types please refer to the AFSCME agreement, or Board Policy</td>
                </tr>
                	<tr><td colspan="2">
                    	<strong>Personal</strong><br />
                        <cfif #Session.LeaveType# eq 9>
                        	<cfinput type="radio" name="LeaveType" value="9" required="yes" message="You must select a type of leave" checked="yes">Personal Leave, <strong>I affirm that this leave is not being used for vacation</strong><br />
                        	<cfinput type="text" name="dayleavereason" value="#Session.dayleavereason#"><br />
                        <cfelse>
                    		<cfinput type="radio" name="LeaveType" value="9" required="yes" message="You must select a type of leave">Personal Leave, <strong>I affirm that this leave is not being used for vacation</strong><br />
                            <cfinput type="text" name="dayleavereason" ><br />
                        </cfif>
                    	<strong>FMLA</strong> <em>(to run concurrent with Personal Leave)</em><br />
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
                    </td>
                    <td colspan="2">
                    	<cfif #Session.LeaveType# eq 13>
                        	<cfinput type="radio" name="LeaveType" value="13" required="yes" message="You must select a type of leave" checked="yes"><strong>Sick Leave</strong><br />	
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="13" required="yes" message="You must select a type of leave"><strong>Sick Leave</strong><br />	
                        </cfif>
                        <cfif #SEssion.LeaveType# eq 1>
                        	<cfinput type="radio" name="LeaveType" value="1" required="yes" message="You must select a type of leave" checked="yes"><strong>Bereavement</strong><br />
                    		&nbsp;&nbsp;&nbsp;&nbsp;<em>Statement of relationship required</em> <input type="text" name="bereavementrelationship" size="20" value="<cfoutput>#Session.bereavementrelationship#</cfoutput>" /><br />
                        <cfelse>
                    		<cfinput type="radio" name="LeaveType" value="1" required="yes" message="You must select a type of leave"><strong>Bereavement</strong><br />
                    		&nbsp;&nbsp;&nbsp;&nbsp;<em>Statement of relationship required</em> <input type="text" name="bereavementrelationship" size="20" /><br />
                        </cfif>
						<cfif #Session.LeaveType# eq 4>
                        	<cfinput type="radio" name="LeaveType" value="4" required="yes" message="You must select a type of leave" checked="yes"><strong>Community Service</strong><br />
                    		&nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong><em> submit documentation</em><br />
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="4" required="yes" message="You must select a type of leave"><strong>Community Service</strong><br />
                    		&nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong><em> submit documentation</em><br />
                        </cfif>
                        <cfif #Session.LeaveType# eq 3>
                        	<cfinput type="radio" name="LeaveType" value="3"required="yes" message="You must select a type of leave" checked="yes"><strong>Officiating/Judging</strong><br />
  		                	&nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong><em> submit documentation</em><br />
                        <cfelse>
                        	<cfinput type="radio" name="LeaveType" value="3"required="yes" message="You must select a type of leave"><strong>Officiating/Judging</strong><br />
  		                	&nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong><em> submit documentation</em><br />
                        </cfif>
                    </td>
                </tr><tr>
                </tr><tr>
                	<td colspan="2">
                    	<cfif #Session.LeaveType# eq 6>
                        	<cfinput type="radio" name="LeaveType" value="6" required="yes" message="You must select a type of leave" checked="yes"><strong>Leave without Pay</strong><br />
                        <cfelse>
                    		<cfinput type="radio" name="LeaveType" value="6" required="yes" message="You must select a type of leave"><strong>Leave without Pay</strong><br />
                        </cfif>
                    </td>
                    <td colspan="2">
                    	<cfif #Session.LeaveType# eq 5>
                        	<cfinput type="radio" name="LeaveType" value="5" required="yes" message="You must select a type of leave" checked="yes"><strong>Emergency</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong> <em>submit documentation</em>
                        <cfelse>
                            <cfinput type="radio" name="LeaveType" value="5" required="yes" message="You must select a type of leave"><strong>Emergency</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<strong>MUST</strong> <em>submit documentation</em>
                        </cfif>
                    </td>
                </tr>
                <tr>
                	<td colspan="2">
                    	<cfif #Session.LeaveType# eq 10>
                        	<cfinput type="radio" name="LeaveType" value="10" required="yes" message="You must select a type of leave" checked="yes"><strong>Vacation</strong>
                        <cfelse>
                    		<cfinput type="radio" name="LeaveType" value="10" required="yes" message="You must select a type of leave"><strong>Vacation</strong>
                        </cfif>
                    </td>
                    <td colspan="2">
                    	<cfif #Session.LeaveType# eq 2>
                            <cfinput type="radio" name="LeaveType" value="2" required="yes" message="You must select a type of leave" checked="yes"><strong>Jury/Witness</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>Documentation required:</em><strong>MUST</strong><em> submit subpoena or juror certificate with this form</em>

                        <cfelse>
                            <cfinput type="radio" name="LeaveType" value="2" required="yes" message="You must select a type of leave"><strong>Jury/Witness</strong><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;<em>Documentation required:</em><strong>MUST</strong><em> submit subpoena or juror certificate with this form</em>
                        </cfif>
                    </td>
                </tr>
            	</cfif>
                <tr>
                	<cfif isdefined('Session.subrequested_yn')>
                    	<cfif #Session.subrequested_yn# eq 'Yes'>
                        	<td colspan="4">
                    	&bull;<strong>Substitute requested<cfinput type="radio" name="subrequested_yn" value="Yes" required="yes" message="You must select if a sub was required or not" checked="yes">Yes  <cfinput type="radio" name="subrequested_yn" value="No" required="yes" message="You must select if a sub was required or not">Not Needed</strong>
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
                </tr>
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
                        <td colspan="4">Comments to Human Resources:<cftextarea cols="50" rows="4" name="comments" value="#SEssion.CommentsTo#"></cftextarea></td>
                    <cfelse>
                        <td colspan="4">Comments to Human Resources:<cftextarea cols="50" rows="4" name="comments" value="#SEssion.CommentsTo#"></cftextarea></td>
                    </cfif>
                <cfelse>
                	<cfif #Session.EmpType# eq 2>
                        <td colspan="4">Comments to Human Resources:<cftextarea cols="50" rows="4" name="comments"></cftextarea></td>
                    <cfelse>
                        <td colspan="4">Comments to Human Resources:<cftextarea cols="50" rows="4" name="comments"></cftextarea></td>
                    </cfif>
                </cfif>
            </tr>
            <tr>
            	<td colspan="3">Employee Signature (type in name):<cfif isdefined('Session.EmpSig')><cfinput type="text" name="EmpSig" size="50" required="yes" message="Enter your name as you would sign ex: John Q. Smith" value="#Session.EmpSig#"><cfelse><cfinput type="text" name="EmpSig" size="50" required="yes" message="Enter your name as you would sign ex: John Q. Smith"></cfif></td>
                <td>Date: <cfoutput>#LSDateFormat(NOW(),'mm/dd/yyyy')#</cfoutput></td>
            </tr>
            <tr>
            	<td colspan="4">Enter Supervisor's Email address:<cfif isdefined('Session.SupEmail')><cfinput type="text" name="SupEmail" size="50" value="#Session.SupEmail#"><cfelse><cfinput type="text" name="SupEmail" size="50"></cfif>
       				<cfinput type="submit" name="SearchSup" value="Search for Email">
                </td>
            </tr>
            <tr>
            	<td colspan="4">
                	Enter Secretary or Secondary Supervisor's Email address:<cfif isdefined('Session.SupEmail2')><cfinput type="text" name="SupEmail2" size="50" value="#Session.SupEmail2#"><cfelse><cfinput type="text" name="SupEmail2" size="50"></cfif>
       				<cfinput type="submit" name="SearchSup2" value="Search for Email">	
                </td>
            </tr>
            <tr>
            	<td colspan="4">* Any requests for &quot;Community Service,&quot; &quot;Officiating,&quot; &quot;Emergency,&quot; or &quot;Jury/Witness&quot; will not be reviewed until documentation has arrived.</td>
            </tr>
            <tr align="center">
            	<td colspan="4"><cfinput type="submit" name="Submit" value="Submit"></td>
            </tr>
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
                <td>Sub Needed/Subfinder ##</td>
                <td>Supervisor</td>
                <td>Viewed By Supervisor</td>
                <td>Approved by Human Resources</td>
            </tr>
            <tr>
            	<td>#requesteddates#</td>
                <cfif #GetRequestData.requesttype# eq 1>
                	<td>Bereavement</td>
                <cfelseif #GetRequestData.requesttype# eq 2>
                	<td>Jury/Witness</td>
                <cfelseif #GetRequestData.requesttype# eq 3>
                	<td>Officiating/Judging</td>
                <cfelseif #GetRequestData.requesttype# eq 4>
                	<td>Community Service</td>
                <cfelseif #GetRequestData.requesttype# eq 5>
                	<td>Emergency</td>
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
         	destination="\\Loki\2003$\apps\LeaveRequest\Attachments\">
         	<p>Thank you, your file has been uploaded.</p>
     </cfif>
     
	 <cfif #form.uploadfile# eq 'mail'>
        <cfset Session.FileName= 'mailing'>
     <cfelse>
        <cfset Session.FileName = '#cffile.clientfileName#.#cffile.clientfileext#'>
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
    	SELECT	Full_Name, Username, fname, lname, building
        FROM	accounts
        WHERE	#form.searchcolumn# like '%#form.searchinfo#%' AND Groups NOT LIKE '%students'
    </cfquery>
</cfif>
<cfif isdefined('SupEmail')>
	<cfset Session.SupEmail2 = '#SupEmail#@d51schools.org'>
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
                        <td><a href="index.cfm?StepNum=8&SupEmail=#username#">#username#@d51schools.org</a></td>
                    </tr>
                </cfoutput>
            </table>
        </cfif>
    </cfform>
<!--- notification of request entry then redirect send email to supervisor--->
<cfelseif StepNum eq 996>

<!--- Send Email to Employee Supervisor basied on data entered in SupEmail text box
		If not a valid email address (contains @d51schools.org) give option to print request --->

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
    <cfset Session.ReqDates = '#Form.ReqDates#'>
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
    	<cfset Session.subrequested_yn = '#Form.subrequested_yn#'>
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
    <cfset Session.yearofrequest = '2010-2011'>
    <cfset Session.FileName = ''>
    <cfif isdefined('form.SearchSup')>
    	<cflocation url="index.cfm?StepNum=7">
    <cfelseif isdefined('form.SearchSup2')>
    	<cflocation url="index.cfm?StepNum=8">
	<cfelseif #Session.LeaveType# eq 2 OR #Session.LeaveType# eq 4>
   		<cflocation url="index.cfm?StepNum=6">
    <cfelse>
        <cflocation url="index.cfm?StepNum=998">
    </cfif>
<!--- Insert Request Into Database --->
<cfelseif StepNum eq 998>
	
    <!--- Insert Request Data Into Database --->
    <cfquery name="InsertReqData" datasource="mesa_web">
    	INSERT INTO LeaveReq_tblRequest
        			(requestid, userid, dateentered, yearofrequest, requesteddates, requesttype, dayleavereason, subfindernum, subrequested, bereavementrelate,
                    signature, signaturedate, supervisor, supervisor2, emptype, Attachment, commentstohr)
        VALUES		('#Session.RequestID#', '#Session.Username#', #Session.DateEntered#, '#Session.yearofrequest#', '#Session.ReqDates#', '#Session.LeaveType#', '#Session.dayleavereason#', '#Session.subfinderid#', '#Session.subrequested_yn#', '#Session.bereavementrelationship#', '#Session.EmpSig#', #Session.DateEntered#, '#Session.SupEmail#', '#Session.SupEmail2#', #Session.EmpType#, '#Session.FileName#', '#Session.CommentsTo#')
        
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