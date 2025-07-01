<cfapplication name="EmployeeLeaveRequest" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,8,0,0)#">
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
		<title></title>
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
				<center>Request and Approval for Leave</center>
			<!-- InstanceEndEditable --></h1>
   	  	</span><br />
				 <!-- InstanceBeginEditable name="Content" -->
<!--- begin Steps --->
<!--- Steps
		0 = Not Logged In
		1 = Select Options (view pending, approved, etc)
		2 = Redirect to selected area from 1
		10 = View Pending Requests
		11 = View Individual Pending Request
		12 = Set Session Variables for Updating Pending Request
		13 = Update pending request
		14 = Email Employee, Supervisor, and Payroll(if approved)
		15 = Delete Request
		20 = View Approved and Denied Requests
		999 = Logout --->
        
<cfif (cgi.https eq "off") and 
	(cgi.SERVER_NAME does not contain "intranet")>
	<cflocation url="https://www.mesa.k12.co.us/apps/LeaveRequest/Admin_Test.cfm" addtoken="no">
	<cfabort>
</cfif>

<cfif not isdefined('StepNum')>
	<cfset StepNum=0>
</cfif>

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
            <cflocation url="Admin_test.cfm?tryagain" addtoken="no">
        <cfelse>
        	<!--- Check to see if log in is in HR --->
            <cfquery name="GetHR" datasource="mesa_web">
            	SELECT Username
                FROM	LeaveReq_HRStaff
                WHERE	Username = '#username#'
            </cfquery>
            <cfif GetHR.RecordCount gt 0>
                <!--- Set Session Variable username, building ect. --->
                <cfset Session.Username = '#getaccounts.Username#'>
                <cfset Session.Building = '#getaccounts.Building#'>
                <cfset Session.BuildingNum = '#getaccounts.building_number#'>
                <cfset Session.FullName = '#getaccounts.Full_Name#'>
                <cfset Session.Groups = '#getaccounts.Groups#'>
                <cfset Session.SSN = '#getaccounts.SocSecNum#'>
                <cflocation url="Admin_Test.cfm?StepNum=1&#urlencodedformat(NOW())#" addtoken="no">
            <cfelse>
            	<cflocation url="Admin_test.cfm?tryagain" addtoken="no">
            </cfif>
        </cfif>
    
    </cfif>
<cfelseif StepNum eq 1>
	<!--- Logged in Select View Approved / Denied Requests or View Pending --->
    <cfform name="viewaction" method="post" action="admin_test.cfm?StepNum=2" >
        <table border="0" width="100%">
            <tr>
                <td align="center">Choose Action</td>
            </tr>
            <tr>
            	<td align="center"><cfinput type="radio" name="view" value="1">View Requests</td>
            </tr>
            <tr>
            	<td align="center"><cfinput type="radio" name="view" value="2">View Approved </td>
            </tr>
            <tr>
            	<td align="center"><cfinput type="radio" name="view" value="3">View Denied Requests</td>
            </tr>
            <tr>
            	<td align="center"><cfinput type="submit" name="submit" value="Continue"></td>
            </tr>
        </table>
    </cfform>
    
    <cfinclude template="Logout_admin.cfm">
<!--- Stepnum eq 2 - Redirect to Appropriate Area --->    
<cfelseif StepNum eq 2>
	<cfif isdefined('form.view')>
		<cfif #Form.view# eq 1>
            <cflocation url="admin_test.cfm?StepNum=10">
        <cfelseif #Form.view# eq 2>
            <cflocation url="admin_test.cfm?StepNum=20">
        <cfelseif #Form.view# eq 3>
            <cflocation url="admin_test.cfm?StepNum=30">
        </cfif>
    <cfelseif isdefined('view')>
    	<cfif #view# eq 1>
    		<cflocation url="admin_test.cfm?StepNum=10">
        </cfif>
    </cfif>
    
<!--- Stepnum eq 10 - View Pending --->
<cfelseif StepNum eq 10>
	<cfset GoToStepNum = 1>
	<!--- Get LIst of Pending Requests --->
    <cfquery name="GetRequests" datasource="mesa_web">
    	SELECT	*
        FROM	LeaveReq_tblRequest
        WHERE	Approved IS NULL and yearofrequest = '2024-2025'
        <cfif #Session.Username# eq 'kubersox'>
        	AND emptype = 2
        <cfelseif #Session.Username# eq 'oldmwilcox'>
        	AND emptype = 1
        </cfif>
        ORDER BY emptype, Userid, dateentered
    </cfquery>
    
    <cfquery name="GetID" datasource="accounts">
        SELECT EmpID, Full_Name, Username
        FROM	accounts
    </cfquery>
    
    <cfquery name="GetPending_Cert" dbtype="query">
    	SELECT	GetRequests.requestid, GetRequests.dateentered, GetRequests.requesteddates, GetRequests.requesttype, GetRequests.supviewed, GetRequests.supvieweddate,
        		GetID.EmpID, GetID.Full_Name, GetID.Username, GetRequests.UserID, GetRequests.supervisor2, GetRequests.sup2viewed, GetRequests.sup2vieweddate,GetRequests.dtFrom,
                GetRequests.dtTo, GetRequests.NumDays
        FROM	GetRequests, GetID
        WHERE	GetRequests.UserID = GetID.Username and GetRequests.Emptype = 1
        ORDER BY	GetID.Full_Name, GetRequests.requesteddates, GetRequests.dateentered
    </cfquery>
    
    <cfquery name="GetPending_Class" dbtype="query">
    	SELECT	GetRequests.requestid, GetRequests.dateentered, GetRequests.requesteddates, GetRequests.requesttype, GetRequests.supviewed, GetRequests.supvieweddate,
        		GetID.EmpID, GetID.Full_Name, GetID.Username, GetRequests.UserID, GetRequests.supervisor2, GetRequests.sup2viewed, GetRequests.sup2vieweddate,GetRequests.dtFrom,
                GetRequests.dtTo, GetRequests.NumDays
        FROM	GetRequests, GetID
        WHERE	GetRequests.UserID = GetID.Username and GetRequests.Emptype = 2
        ORDER BY	GetID.Full_Name, GetRequests.requesteddates, GetRequests.dateentered
    </cfquery>
    
    <table border="1" width="100%">
    	<tr>
        	<td align="center" colspan="7">Pending Requests - Certified</td>
        </tr>
        <tr>
        	<td>Request ID</td>
            <td>User id, Emp Num</td>
            <td>Date Entered</td>
            <td>Requested Date(s)</td>
            <td>Request Type</td>
            <td>Supervisor Viewed / Viewed Date</td>
            <td>Supervisor 2 Viewed / Viewed Date</td>
        </tr>
        <cfoutput>
            <cfloop from="1" to="#GetPending_Cert.RecordCount#" index="i">
                <tr>
                    <td><a href="Admin_test.cfm?StepNum=11&requestid=#GetPending_Cert.requestid[i]#&userid=#GetPending_Cert.userid[i]#">#GetPending_Cert.Requestid[i]#</a></td>
                    <!--- Query to get ID Number --->
                    <cfquery name="GetID" datasource="accounts">
                        SELECT EmpID
                        FROM	accounts
                        WHERE	Username = '#GetPending_Cert.userid[i]#'
                    </cfquery>
                    <td>#GetPending_Cert.Full_name[i]#, #GetPending_Cert.EmpID[i]#</td>
                    <td>#LSDateFormat(GetPending_Cert.dateentered[i],'mm/dd/yyyy')#</td>
                    <td>#GetPEnding_Cert.RequestedDates[i]#<br />#LSDateFormat(GetPending_Cert.dtFrom[i],'mm/dd/yyyy')# - #LSDateFormat(GetPending_Cert.dtTo[i],'mm/dd/yyyy')#</td>
                    <!--- Get Leave Type --->
                    <cfquery name="GetLeaveType" datasource="mesa_web">
                    	SELECT	*
                        FROM	LeaveReq_tblLeaveType
                        WHERE	code = '#GetPending_Cert.requesttype[i]#'
                    </cfquery>
                    <td>#GetLeaveType.LeaveType#</td>
                    <td>#GetPending_Cert.supviewed[i]# / #LSDateFormat(GetPending_Cert.supvieweddate[i],'mm/dd/yyyy')#</td>
                    <td>#GetPending_Cert.sup2viewed[i]# / #LSDateFormat(GetPending_Cert.sup2vieweddate[i],'mm/dd/yyyy')#</td>
                </tr>
            </cfloop>
        </cfoutput>
    </table>
    
     <table border="1" width="100%">
    	<tr>
        	<td align="center" colspan="7">Pending Requests - Classified</td>
        </tr>
        <tr>
        	<td>Request ID</td>
            <td>User id, Emp Num</td>
            <td>Date Entered</td>
            <td>Requested Date(s)</td>
            <td>Request Type</td>
            <td>Supervisor Viewed / Viewed Date</td>
            <td>Supervisor 2 Viewed / Viewed Date</td>
        </tr>
        <cfoutput>
            <cfloop from="1" to="#GetPending_Class.RecordCount#" index="i">
                <tr>
                    <td><a href="Admin_test.cfm?StepNum=11&requestid=#GetPending_Class.requestid[i]#&userid=#GetPending_Class.userid[i]#">#GetPending_Class.Requestid[i]#</a></td>
                    <!--- Query to get ID Number --->
                    <cfquery name="GetID" datasource="accounts">
                        SELECT EmpID
                        FROM	accounts
                        WHERE	Username = '#GetPending_Class.userid[i]#'
                    </cfquery>
                    <td>#GetPending_Class.Full_name[i]#, #GetPending_Class.EmpID[i]#</td>
                    <td>#LSDateFormat(GetPending_Class.dateentered[i],'mm/dd/yyyy')#</td>
                    <td>#GetPEnding_Class.RequestedDates[i]#<br />#LSDateFormat(GetPending_Class.dtFrom[i],'mm/dd/yyyy')# - #LSDateFormat(GetPending_Class.dtTo[i],'mm/dd/yyyy')#</td>
                    <!--- Get Leave Type --->
                    <cfquery name="GetLeaveType" datasource="mesa_web">
                    	SELECT	*
                        FROM	LeaveReq_tblLeaveType
                        WHERE	code = '#GetPending_Class.requesttype[i]#'
                    </cfquery>
                    <td>#GetLeaveType.LeaveType#</td>
                    <td>#GetPending_Class.supviewed[i]# / #LSDateFormat(GetPending_Class.supvieweddate[i],'mm/dd/yyyy')#</td>
                    <td>#GetPending_Class.sup2viewed[i]# / #LSDateFormat(GetPending_Class.sup2vieweddate[i],'mm/dd/yyyy')#</td>
                </tr>
            </cfloop>
        </cfoutput>
    </table>
    
    <cfinclude template="Back_Admin.cfm">
    <cfinclude template="Logout_admin.cfm">
<!--- StepNum eq 11 - View and Approve Individual Request --->
<cfelseif StepNum eq 11>
	<cfform name="AppDenyReq" method="post" action="Admin_test.cfm?StepNum=12">
	<cfset Session.RequestID = '#requestid#'>
    <cfset Session.userid = '#userid#'>
    <cfset GoToStepNum = 10>
    <!--- Query to Get Request Information --->
    <cfquery name="GetReqData" datasource="mesa_web">
    	SELECT	*
        FROM	LeaveReq_tblRequest
        WHERE	RequestID = '#SEssion.RequestID#' AND userid = '#Session.userid#'
    </cfquery>
    <!--- Get and Display Employee Information --->
    <cfquery name="GetEmpInfo" datasource="accounts">
    	SELECT	Full_name, EmpID, Building
        FROM	accounts
        WHERE	Username = '#Session.userid#'
    </cfquery>
    <cfoutput>
    <!--- Get Number of Days approved so far --->
    <cfquery name="GetDaysApp" datasource="mesa_web">
    	SELECT	SUM(numdaysapproved) as DaysApp
        FROM	LeaveReq_tblRequest
        WHERE	userid = '#Session.userid#' and yearofrequest = '2024-2025' and Approved = 'A'
    </cfquery>
    <table border="1" width="100%">
    	<tr>
        	<td align="center">Number of Days Approved this year: #GetDaysApp.DaysApp#</td>
  		</tr>
    </table>
        <table width="100%" border="1">
            <tr><th>Pending Request for: #GetEmpInfo.Full_Name#</th>
            <!--- Emp Information --->
            </tr><tr>
            	<td>
                	<table border="1" width="100%">
                    	<tr>
                        	<td>Name:</td>
                            <td>Emp ID: </td>
                            <td>Building</td>
                        </tr>
                        <tr>
                        	<td>#GetEmpInfo.Full_Name#</td>
                            <td>#GetEmpInfo.EmpID#</td>
                            <td><cfif #GetEmpInfo.Building# eq 'columbus'>New Emerson<cfelse>#GetEmpInfo.Building#</cfif></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <!--- Request Information --->
            <tr>
            	<td>
                	<table border="1" width="100%">
                    	<tr>
                        	<td>RequestID: #GetReqData.RequestID#</td>
                            <td>Date Entered: #LSDateFormat(GetReqData.dateentered,'mm/dd/yyyy')#</td>
                        </tr>
                        <tr>
                        	<td colspan="2">
                            	Date(s) Requested: #GetReqData.RequestedDates#<br />#LSDateFormat(GetReqData.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetReqData.dtTo,'mm/dd/yyyy')#<br />
                                Number of Days: #GetReqData.NumDays#
                            </td>
                        </tr>
                        <!--- Get Leave Type --->
                        <cfquery name="GetLeaveType" datasource="mesa_web">
                        	SELECT	LeaveType
                            FROM	LeaveReq_tblLeaveType
                            WHERE	code = '#GetReqData.requesttype#'
                        </cfquery>
                        <tr>
                        	<td colspan="2">
                            	Request Type: #GetLeaveType.LeaveType#
                                <cfif #GetReqData.requesttype# eq 1>
                                	- #GetReqData.bereavementrelate#
                                <cfelseif #GetReqData.requesttype# eq 9>
                                	Reason: #GetReqData.dayleavereason#
                                <cfelseif #GetReqData.requesttype# eq 2>
                                	- Attachment: 	<cfif #GetReqData.Attachment# eq 'Mailing'>
                                    					Mailing Form
                                                    <cfelse>
                                                    	<a href="./Attachments/#GetReqData.Attachment#", target="_blank">#GetReqData.Attachment#</a>
                                                    </cfif>
                                <cfelseif #GetReqData.Requesttype# eq 4>
                                	- Attachment: 	<cfif #GetReqData.Attachment# eq 'Mailing'>
                                    					Mailing Form
                                                    <cfelse>
                                                    	<a href="./Attachments/#GetReqData.Attachment#", target="_blank">#GetReqData.Attachment#</a>
                                                    </cfif>
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="2">
                            	<cfif #GetReqData.subfinderNum# gt 0>
                                	Subfinder Number: #GetReqData.subfindernum#
                                <cfelse>
                                	Sub Needed: #GetReqData.subrequested#
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                        	<td>Employee Signature: #GetReqData.signature#</td>
                            <td>Date: #LSDateFormat(GetReqData.signaturedate,'mm/dd/yyyy')#</td>
                        </tr>
                        <tr>
                        	<td>Principal/Supervisor: #GetReqData.supervisor#</td>
                            <td>
                            	Supported/Reviewed: #GetReqData.supviewed# on Date: #LSDateFormat(GetReqData.supvieweddate,'mm/dd/yyyy')#<br />
                                Comment: #GetReqData.supcomments#
                            </td>
                        </tr>
                        <tr>
                        	<td>Principal/Supervisor 2: #GetReqData.supervisor2#</td>
                            <td>Supported/Reviewed: #GetReqData.sup2viewed# on Date: #LSDateFormat(GetReqData.sup2vieweddate,'mm/dd/yyyy')#</td>
                        </tr>
                        <tr>
                        	<td colspan="2">Comments To HR: #GetReqData.commentstohr#</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <!--- Approve / Deny section --->
            <tr>
            	<td>
                	<table border="1" width="100%">
                    	<tr>
                        	<td><cfinput type="radio" name="app_deny" value="A" checked="yes">Approved</td>
                            <td><cfinput type="radio" name="app_deny" value="P">Pending</td>
                            <td><cfinput type="radio" name="app_deny" value="D">Denied</td>
                        </tr>
                        <tr>
                        	<td colspan="3">If Approved, number of days approved for:<cfinput type="text" name="appdays" value="0"></td>
                        </tr>
                        <tr>
                        	<td colspan="3">
                            	Comments: <cftextarea name="comments" rows="4" cols="70"></cftextarea>
                            </td>
                        </tr>
                        <tr>
                        	<td>Approved/Denied By: #Session.FullName#</td>
                            <td>Date: #LSDateFormat(NOW(),'mm/dd/yyyy')#</td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
            	<td>
                	<cfif #GetReqData.EmpType# eq 2><cfinput type="checkbox" name="emailPayroll" value="true">Send Email to Payroll</cfif>
                </td>
            </tr>
            <tr>
            	<td align="center">
                	<cfinput type="submit" name="submit" value="Submit">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                	<cfinput type="submit" name="Delete" value="Delete Request">
                </td>
            </tr>
        </table>
    </cfoutput>
    </cfform>
    <cfinclude template="Back_Admin.cfm">
    <cfinclude template="Logout_admin.cfm">
<!--- StepNum = 12 Set Session Variables for Approveing / Denying Request --->
<cfelseif StepNum eq 12>
	<cfset Session.AppDeny = '#Form.app_deny#'>
    <cfset Session.AppDays = '#Form.appdays#'>
    <cfset Session.comments = '#Form.comments#'>
    <cfset Session.AppDenyBy = '#Session.FullName#'>
    <cfset Session.AppDate = '#LSDateFormat(NOW(),"mm/dd/yyyy")#'>
    <cfif isdefined('form.emailPayroll')>
    	<cfset Session.EmailPayroll = 'Y'>
    <cfelse>
    	<cfset Session.EmailPayroll = 'N'>
    </cfif>
    
    <cfif isdefined('form.delete')>
    	<cflocation url="Admin_test.cfm?StepNum=15">
    </cfif>
    <cflocation url="Admin_test.cfm?StepNum=13">
<!--- StepNum = 13 Update Request --->
<cfelseif StepNum eq 13>
	<!--- Update LeaveReq_tblRequest --->
    <cfquery name="UpdateRequest" datasource="mesa_web">
    	UPDATE 	LeaveReq_tblRequest
        SET		numdaysapproved = #Session.Appdays#,
        		approved = '#Session.AppDeny#',
                approveddate = '#Session.AppDate#',
                approveduser = '#Session.AppDenyBy#',
                comments = '#Session.comments#'
        WHERE	RequestID = '#Session.requestID#' AND userid = '#Session.Userid#'
    </cfquery>
    <cflocation url="Admin_test.cfm?StepNum=14">
    
<!---StepNum = 14 Email Payroll, Employee, and Supervisor redirect to pending requests --->
<cfelseif StepNum eq 14>
	<!--- Get Request and Emp Information --->
    <cfquery name="GetReqInfo" datasource="mesa_web">
    	SELECT	*
        FROM	LeaveReq_tblRequest
        WHERE	RequestID = '#Session.RequestID#' and userid = '#Session.Userid#'
    </cfquery>
    <cfquery name="GetLeaveType" datasource="mesa_web">
    	SELECT 	LeaveType
        FROM	LeaveReq_tblLeaveType
        WHERE	Code = '#GetReqinfo.requesttype#'
    </cfquery>
    <cfquery name="GetEmpInfo" datasource="accounts">
    	SELECT	Full_Name, EmpID
        FROM	accounts
        WHERE	Username = '#Session.userid#'
    </cfquery>
    
    <!--- Get Email of person who Approved/Denied the request --->
    <cfquery name="GetAppDenEmail" datasource="accounts">
    	SELECT	Email, Full_Name
        FROM	accounts
        where	Full_Name = '#GetReqInfo.ApprovedUser#'
    </cfquery>
    
    <!--- Email Employee --->
    <cfmail to="#trim(session.userid)#@d51schools.org" from="hr@d51schools.org" subject="Request for Leave" type="html">
        Dear, #GetEmpInfo.Full_Name#,<br /><br />
        Thank you for submitting your time off request. Upon careful review:<br /><br />

        <cfif #GetReqInfo.approved# eq 'A'>
            <cfif #GetReqInfo.NumDays# eq #GetReqInfo.numdaysapproved#>
                Your request for <cfoutput>#GetReqInfo.NumDays#</cfoutput> days off from <cfoutput>#LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')#</cfoutput> to <cfoutput>#LSDateFormat(GetReqInfo.dtTo,'mm/dd/yyyy')#</cfoutput> has been <b>approved</b>.  If applicable, please ensure that you have made arrangements for substitute coverage during your absence.<br /><br />
            <cfelse>
                Your request for <cfoutput>#GetReqInfo.NumDays#</cfoutput> days off from <cfoutput>#LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')#</cfoutput> to <cfoutput>#LSDateFormat(GetReqInfo.dtTo,'mm/dd/yyyy')#</cfoutput> has been <b>approved with modifications</b>.<br /><br />
                <cfoutput>#GetReqInfo.comments#</cfoutput>
            </cfif>
        <cfelseif #GetReqInfo.approved# eq 'D'>
            Unfortunately, we are unable to approve your request for <cfoutput>#GetReqInfo.NumDays#</cfoutput> days off from <cfoutput>#LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')#</cfoutput> to <cfoutput>#LSDateFormat(GetReqInfo.dtTo,'mm/dd/yyyy')#</cfoutput>.<br /><br />
            <cfoutput>#GetReqInfo.comments#</cfoutput><br /><br />
            We understand that this may be disappointing, and we apologize for any inconvenience it may cause.<br /><br />
            If you would like to appeal this decision, please complete the following <a href="https://resources.finalsite.net/images/v1728911194/mesak12cous/fv0qwpzabq6scr9ezacg/DayLeaveAppealRequestFormLicensedStaff.pdf">form</a> and follow the instructions provided.
        </cfif>
    
    </cfmail>

<!--- <cfif #GetReqInfo.requesttype# eq 9>

Your request for leave on the following day(s): #LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetReqInfo.dtTo,'mm/dd/yyyy')#, <cfif #GetReqInfo.approved# eq 'A'>has been approved and will be paid for, pending you have time available. Please refer to the upper right corner of your most recent Leave and Earnings Statement for your Sick Leave Balance and Personal Time used. <br /><br /><cfelseif #GetReqInfo.approved# eq 'D'>has been denied.<br /><br /></cfif>

Comments: #GetReqinfo.comments#<br /><br />

Approved/Denied By: <a href="mailto:#GetAppDenEmail.Email#">#GetAppDenEmail.Full_Name#</a> 

<cfelseif #GetReqinfo.requesttype# eq 6>
Your request for leave without pay on the following day(s): #LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetReqInfo.dtTo,'mm/dd/yyyy')#, <cfif #GetReqInfo.approved# eq 'A'>has been approved.<cfelseif #GetReqInfo.approved# eq 'D'>has been denied.</cfif><br /><br />  

Comments: #GetReqinfo.comments#<br /><br />

Approved/Denied By: <a href="mailto:#GetAppDenEmail.Email#">#GetAppDenEmail.Full_Name#</a> 

<cfelseif #GetReqinfo.requesttype# eq 1>
Your request for Bereavement Leave <cfif #GetReqInfo.approved# eq 'A'>has been approved.  Make sure your absence is documented in SubFinder or on your time card as Bereavement.<cfelseif #GetReqInfo.approved# eq 'D'>has been denied.</cfif><br /><br />

Comments: #GetReqinfo.comments#<br /><br />

Approved/Denied By: <a href="mailto:#GetAppDenEmail.Email#">#GetAppDenEmail.Full_Name#</a> 

<cfelseif #GetReqinfo.requesttype# eq 3 or #GetReqInfo.requesttype# eq 4>
Your leave request for the following day(s): #LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetReqInfo.dtTo,'mm/dd/yyyy')#, <cfif #GetReqInfo.approved# eq 'A'>has been approved and will be paid for, pending receipt of proper documentation.   If you have not already done so, please submit documentation via email or interdepartmental mail to the Department of Human Resources prior to the last working day of the month.<cfelseif #GetReqInfo.approved# eq 'D'>has been denied.</cfif><br /><br />

Comments: #GetReqinfo.comments#<br /><br />

Approved/Denied By: <a href="mailto:#GetAppDenEmail.Email#">#GetAppDenEmail.Full_Name#</a> 

<cfelseif #GetReqinfo.requesttype# eq 2>
Your leave request for the following day(s): #LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetReqInfo.dtTo,'mm/dd/yyyy')#, <cfif #GetReqInfo.approved# eq 'A'>has been approved and will be paid for, pending receipt of proper documentation.   If you have not already done so, please provide a copy of either the  subpoena or juror certificate via email or interdepartmental mail to the Department of Human Resources office prior to the last working day of the month.<cfelseif #GetReqInfo.approved# eq 'D'>has been denied.</cfif><br /><br />

Comments: #GetReqinfo.comments#<br /><br />

Approved/Denied By: <a href="mailto:#GetAppDenEmail.Email#">#GetAppDenEmail.Full_Name#</a> 

<cfelseif #GetReqinfo.requesttype# eq 7 or #GetReqInfo.requesttype# eq 8 or #GetReqinfo.requesttype# eq 11 or #GetReqInfo.requesttype# eq 12>
Additional information is required.  FMLA leaves are required after an employee has missed 11 or more consecutive days for a serious health condition including:  Their own health issue, family health issue, maternity leave, or military caregiver leave.  Please contact the Human Resources Department (970-254-5120) if you have not requested FMLA paperwork.  A packet will be sent out to your home address.<br /><br />

Comments: #GetReqinfo.comments#<br /><br />

Approved/Denied By: <a href="mailto:#GetAppDenEmail.Email#">#GetAppDenEmail.Full_Name#</a> 

<cfelseif #GetReqinfo.requesttype# eq 5>
Your request for leave on the following day(s): #LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetReqInfo.dtTo,'mm/dd/yyyy')#, <cfif #GetReqInfo.approved# eq 'A'>has been approved and will be paid for, pending you have time available and the Human Resources Department receives the proper documentation. Please refer to the upper right corner of your most recent Leave and Earnings Statement for your Sick Leave Balance and Personal Time used.   Please provide documentation to the Department of Human Resources office prior to the last working day of the month.<cfelseif #GetReqInfo.approved# eq 'D'>has been denied.</cfif><br /><br />

Comments: #GetReqinfo.comments#<br /><br />

Approved/Denied By: <a href="mailto:#GetAppDenEmail.Email#">#GetAppDenEmail.Full_Name#</a> 

<cfelseif #GetReqinfo.requesttype# eq 10>
Your request for vacation leave on the following day(s): #LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetReqInfo.dtTo,'mm/dd/yyyy')#, <cfif #GetReqInfo.approved# eq 'A'>has been approved and will be paid for, pending you have time available.  Please refer to the upper right corner of your most recent Leave and Earnings Statement for your Vacation Leave balance.<cfelseif #GetReqInfo.approved# eq 'D'>has been denied.</cfif><br /><br />

Comments: #GetReqinfo.comments#<br /><br />

Approved/Denied By: <a href="mailto:#GetAppDenEmail.Email#">#GetAppDenEmail.Full_Name#</a> 

<cfelseif #GetReqinfo.requesttype# eq 13>
Your request for sick leave on the following day(s): #LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetReqInfo.dtTo,'mm/dd/yyyy')#, <cfif #GetReqInfo.approved# eq 'A'>has been approved and will be paid for, pending you have time available. Please refer to the upper right corner of your most recent Leave and Earnings Statement for your Sick Leave Balance.<cfelseif #GetReqInfo.approved# eq 'D'>has been denied.</cfif><br /><br />

Comments: #GetReqinfo.comments#<br /><br />

Approved/Denied By: <a href="mailto:#GetAppDenEmail.Email#">#GetAppDenEmail.Full_Name#</a> 
<cfelse>
</cfif> 



    </cfmail>
       
<cfif #GetReqInfo.supervisor2# gt ''>
	<cfmail to="#GetReqInfo.supervisor2#" from="hr@d51schools.org" subject="Request for Leave" type="html">
A request for leave made by: #GetEmpInfo.Full_Name# <br /><br />


For the following Date(s): #LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetReqInfo.dtTo,'mm/dd/yyyy')#<br />
Leave Request Type: #GetLeaveType.LeaveType#<br />
Date Requested: #LSDateFormat(GetReqInfo.DateEntered, 'mm/dd/yyyy')#<br />

Status:<cfif #GetReqInfo.approved# eq 'A'>has been <strong>Approved</strong>
  <cfelseif #GetReqInfo.approved# eq 'P'>is <strong>Pending</strong> personal leave available for the fiscal year July through June<cfelse> has been <strong>Denied</strong></cfif>.<br /><br />
Date Sent: #LSDateFormat(NOW(),'mm/dd/yyyy')#<br />

<cfif #GetReqInfo.subfindernum# neq 0>
	A sub request has been made in subfinder: #GetReqInfo.subfindernum#<br /><br />
</cfif>
<cfif #GetReqInfo.Subfindernum# eq 0>
	<cfif #GetReqInfo.Subrequested# eq 'No'>
    	A Sub has not been requested or is not needed.<br /><br />
    <cfelse>
    	A Sub has been requested.<br /><br />
    </cfif>
</cfif>
Comments: #GetReqInfo.Comments#
    </cfmail>
</cfif>    
    <!--- Email Payroll --->
    <!--- Email if request is Denied, any Bereavment, Any Community Service, Any Emergency, or Any Jury Duty or Leave Without Pay--->
    <!--- Get Requests Leave Type --->
    <cfquery name="GetLT" datasource="mesa_web">
        SELECT 	LeaveType, RequestType, Comments
        FROM	LeaveReq_tblRequest INNER JOIN LEaveReq_tblLeaveType ON
                LEaveReq_tblRequest.RequestType = LEaveReq_tblLeaveType.Code
        WHERE	RequestID = '#Session.RequestID#' and userid = '#Session.Userid#'
    </cfquery>
    <cfquery name="GetID" datasource="accounts">
        SELECT EmpID
        FROM	accounts
        WHERE	Username = '#Session.Userid#'
    </cfquery>
	<cfif #GetReqInfo.Approved# eq 'A'>        
        <!--- if Bereavement, CS, Emergency, Jury Duty or Leve Without Pay --->
        <!---<cfif #GetLT.RequestType# eq 1 OR #GetLT.RequestType# eq 2 OR #GetLT.RequestType# eq 3 OR #GetLT.RequestType# eq 4 OR #GetLT.RequestType# eq 5 OR #GetLT.RequestType# eq 6 or #Session.EmailPayroll# eq 'Y'>--->
        	<cfmail to="payroll@d51schools.org" from="hr@d51schools.org" subject="Request for Leave for: #GetEmpInfo.Full_Name#" type="html">
            	The Leave Request for: #GetEmpInfo.Full_Name# ###GetID.EMpID# with a Leave Type of: #GetLT.LeaveType# Date(s): #LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetReqInfo.dtTO,'mm/dd/yyyy')#.<br /><br />                
                Has been Approved.<br /><br />
                
                <cfoutput>#GetLT.Comments#</cfoutput>
            </cfmail>
        <!---</cfif>--->
    <cfelseif #GetReqInfo.APproved# eq 'D'>
    	<cfmail to="payroll@d51schools.org" from="hr@d51schools.org" subject="Request for Leave for: #GetEmpInfo.Full_Name#" type="html">
          	The Leave Request for: #GetEmpInfo.Full_Name# ###GetID.EMpID# with a Leave Type of: #GetLT.LeaveType# Date(s): #LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetReqInfo.dtTO,'mm/dd/yyyy')#.<br /><br />                
            Has been Denied.<br /><br />
            
            <cfoutput>#GetLT.Comments#</cfoutput>
        </cfmail>	
    </cfif>--->
    
   	
    <cflocation url="Admin_test.cfm?StepNum=2&view=1">
<!--- StepNum eq 15 - Delete Requests --->
<cfelseif StepNum eq 15>
<cfform method="post" action="Admin_test.cfm?StepNum=998" format="html">
	<table border="1" width="100%">
    	<tr><th colspan="3">Delete Request: <cfoutput>#Session.RequestID#</cfoutput></th>
        <!--- query to get Request data --->
        <cfquery name="GetReqInfo" datasource="mesa_web">
        	SELECT	*
            FROM	LeaveReq_tblRequest
            WHERE	Userid = '#Session.Userid#' and RequestID = '#Session.RequestID#'
        </cfquery>
        </tr><cfoutput>
            <tr>
                <!--- Get User Info --->
                <cfquery name="GetEmpInfo" datasource="accounts">
                    SELECT	Full_Name, EmpID, Building
                    FROM	Accounts
                    WHERE	Username = '#Session.UserID#'
                </cfquery>
                <td>Name: #GetEmpInfo.Full_Name#</td>
                <td>Employee ID: #GetEmpInfo.EmpID#</td>
                <td><cfif #GetEmpInfo.Building# eq 'columbus'>New Emerson<cfelse>#GetEmpInfo.Building#</cfif></td>
            </tr>
            <tr>
            	<td colspan="1">Dates: #LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetReqInfo.dtTo,'mm/dd/yyyy')#</td>
                <cfquery name="GetReqType" datasource="mesa_web">
                	SELECT	LeaveType
                    FROM	LeaveReq_tblLeaveType
                    WHERE	 code = #GetReqInfo.requesttype#
                </cfquery>
                <td colspan="1">Type: #GetReqType.LeaveType#</td>
                <td colspan="1">&nbsp;</td>
            </tr>
            <tr>
            	<td colspan="3">
                	Delete Reason:
                    <cftextarea name="DeleteReason" cols="60" rows="4"></cftextarea>
                </td>
            </tr>
            <tr>
            	<td colspan="3" align="center">
                	<cfinput type="submit" value="Delete" name="Delete">
                </td>
            </tr>
        </cfoutput>
    </table>
</cfform>
<!--- Stepnum eq 20 - View Approved / Denied Requests --->
<cfelseif StepNum eq 20>
<cfif #Session.Username# eq 'oldmwilcox'>
	<cfset Start = 1>
    <cfset End = 1>
<cfelseif #Session.Username# eq 'kubersox'>
	<cfset Start = 2>
    <!---<cfset Start = 1>--->
    <cfset End = 2>
<cfelse>
	<cfset Start = 1>
    <cfset End = 2>
</cfif>
	
<cfloop from="#Start#" to="#End#" index="a">
	<cfset GoToStepNum = 1>
	<!--- View Approved Requests --->
    <!--- Get LIst of Approved Requests --->
    <cfquery name="GetAppRequests" datasource="mesa_web">
    	SELECT	*
        FROM	LeaveReq_tblRequest
        WHERE	Approved = 'A' and yearofrequest = '2024-2025'  and EmpType = #a#
        ORDER BY userid, dateentered
    </cfquery>
    
    <cfquery name="GetID" datasource="accounts">
        SELECT EmpID, Full_Name, Username, fname, lname
        FROM	accounts
    </cfquery>
    
    <cfquery name="GetApproved" dbtype="query" timeout="600">
    	SELECT	GetAppRequests.requestid, GetAppRequests.dateentered, GetAppRequests.requesteddates, GetAppRequests.requesttype, GetAppRequests.supviewed, GetAppRequests.supvieweddate,
        		GetID.EmpID, GetID.Full_Name, GetID.Username, GetAppRequests.UserID, GetID.fname, GetID.lname, GetAppRequests.dtFrom, GetAppRequests.dtTo
        FROM	GetAppRequests, GetID
        WHERE	GetAppRequests.UserID = GetID.Username AND yearofrequest = '2024-2025'
        ORDER BY	GetID.Lname, GetID.fname, GetAppRequests.dateentered, GetAppRequests.requesteddates
    </cfquery>
    
    <table border="1" width="100%">
    	<tr>
        	<td align="center" colspan="6"><cfif #a# eq 1>Certified<cfelse>Classified</cfif> Approved Requests</td>
        </tr>
        <tr>
        	<td>Request ID</td>
            <td>User id, Emp Num</td>
            <td>Date Entered</td>
            <td>Requested Date(s)</td>
            <td>Request Type</td>
            <td>Supervisor Viewed / Viewed Date</td>
        </tr>
        <cfoutput>
            <cfloop from="1" to="#GetApproved.RecordCount#" index="i">
                <tr>
                    <td><a href="Admin_test.cfm?StepNum=21&requestid=#GetApproved.requestid[i]#&userid=#GetApproved.userid[i]#">#GetApproved.Requestid[i]#</a></td>
                    <!--- Query to get ID Number --->
                    <cfquery name="GetID" datasource="accounts">
                        SELECT EmpID
                        FROM	accounts
                        WHERE	Username = '#GetApproved.userid[i]#'
                    </cfquery>
                    <td>#GetApproved.Full_Name[i]#, #GetApproved.EmpID[i]#</td>
                    <td>#LSDateFormat(GetApproved.dateentered[i],'mm/dd/yy')#</td>
                    <td>#GetApproved.requesteddates[i]#<br />From: #LSDateFormat(getApproved.dtFrom,'mm/dd/yyyy')# - #lsDateFormat(getApproved.dtTo,'mm/dd/yyyy')#</td>
                    <!--- Get Leave Type --->
                    <cfquery name="GetLeaveType" datasource="mesa_web">
                    	SELECT	*
                        FROM	LeaveReq_tblLeaveType
                        WHERE	code = '#GetApproved.requesttype[i]#'
                    </cfquery>
                    <td>#GetLeaveType.LeaveType#</td>
                    <td>#GetApproved.supviewed[i]# / #LSDateFormat(GetApproved.supvieweddate[i],'mm/dd/yyyy')#</td>
                </tr>
            </cfloop>
        </cfoutput>
    </table>
    <!--- View Approved Requests --->
    <!--- Get LIst of Approved Requests --->
    <!---
    <cfquery name="GetPenRequests" datasource="mesa_web">
    	SELECT	*
        FROM	LeaveReq_tblRequest
        WHERE	Approved = 'P' and yearofrequest = '2024-2025' and EmpType = #a#
    </cfquery>
    
    <cfquery name="GetID" datasource="accounts">
        SELECT EmpID, Full_Name, Username, fname, lname
        FROM	accounts
    </cfquery>
    
    <cfquery name="GetPending" dbtype="query">
    	SELECT	GetPenRequests.requestid, GetPenRequests.dateentered, GetPenRequests.requesteddates, GetPenRequests.requesttype, GetPenRequests.supviewed, GetPenRequests.supvieweddate,
        		GetID.EmpID, GetID.Full_Name, GetID.Username, GetPenRequests.UserID, GetID.fname, GetID.lname, GetPenRequests.dtFrom, getPenRequests.dtTo
        FROM	GetPenRequests, GetID
        WHERE	GetPenRequests.UserID = GetID.Username AND yearofrequest = '2024-2025'
        ORDER BY	GetID.Lname, GetID.fname, GetPenRequests.dateentered, GetPenRequests.requesteddates
    </cfquery>
    
    <table border="1" width="100%">
    	<tr>
        	<td align="center" colspan="6"><cfif #a# eq 1>Certified<cfelse>Classified</cfif> Pending Days Used Requests</td>
        </tr>
        <tr>
        	<td>Request ID</td>
            <td>User id, Emp Num</td>
            <td>Date Entered</td>
            <td>Requested Date(s)</td>
            <td>Request Type</td>
            <td>Supervisor Viewed / Viewed Date</td>
        </tr>
        <cfoutput>
            <cfloop from="1" to="#GetPending.RecordCount#" index="i">
                <tr>
                    <td><a href="Admin.cfm?StepNum=21&requestid=#GetPending.requestid[i]#&userid=#GetPending.userid[i]#">#GetPending.Requestid[i]#</a></td>
                    <!--- Query to get ID Number --->
                    <cfquery name="GetID" datasource="accounts">
                        SELECT EmpID
                        FROM	accounts
                        WHERE	Username = '#GetPending.userid[i]#'
                    </cfquery>
                    <td>#GetPending.Full_Name[i]#, #GetPending.EmpID[i]#</td>
                    <td>#LSDateFormat(GetPending.dateentered[i],'mm/dd/yyyy')#</td>
                    <td>#GetPending.requesteddates[i]#<br />From: #LSDateFormat(GetPending.dtFrom,'mm/dd/yyyy')# - #lsDateFormat(GetPending.dtTo,'mm/dd/yyyy')#</td>
                    <!--- Get Leave Type --->
                    <cfquery name="GetLeaveType" datasource="mesa_web">
                    	SELECT	*
                        FROM	LeaveReq_tblLeaveType
                        WHERE	code = '#GetPending.requesttype[i]#'
                    </cfquery>
                    <td>#GetLeaveType.LeaveType#</td>
                    <td>#GetPending.supviewed[i]# / #LSDateFormat(GetPending.supvieweddate[i],'mm/dd/yyyy')#</td>
                </tr>
            </cfloop>
        </cfoutput>
    </table>
	--->
    <!--- View Denied Requests 
    <cfquery name="GetDenRequests" datasource="mesa_web">
    	SELECT	*
        FROM	LeaveReq_tblRequest
        WHERE	Approved = 'D' and yearofrequest = '2024-2025' and EmpType = #a#
    </cfquery>
    
    <cfquery name="GetID" datasource="accounts">
        SELECT EmpID, Full_Name, Username, fname, lname
        FROM	accounts
    </cfquery>
    
    
    <cfquery name="GetDenied" dbtype="query" timeout="600">
    	SELECT	GetDenRequests.requestid, GetDenRequests.dateentered, GetDenRequests.requesteddates, GetDenRequests.requesttype, GetDenRequests.supviewed, GetDenRequests.supvieweddate,
        		GetID.EmpID, GetID.Full_Name, GetID.Username, GetDenRequests.UserID, GetID.fname, GetID.lname, GetDenRequests.dtFrom, GetDenRequests.dtTo
        FROM	GetDenRequests, GetID
        WHERE	GetDenRequests.UserID = GetID.Username and yearofrequest = '2024-2025'
        ORDER BY	GetID.Lname, GetID.fname, GetDenRequests.dateentered, GetDenRequests.requesteddates
    </cfquery>
    
    <table border="1" width="100%">
    	<tr>
        	<td align="center" colspan="6"><cfif #a# eq 1>Certified<cfelse>Classified</cfif> Denied Requests</td>
        </tr>
        <tr>
        	<td>Request ID</td>
            <td>User id, Emp Num</td>
            <td>Date Entered</td>
            <td>Requested Date(s)</td>
            <td>Request Type</td>
            <td>Supervisor Viewed / Viewed Date</td>
        </tr>
        <cfoutput>
            <cfloop from="1" to="#GetDenied.RecordCount#" index="i">
                <tr>
                    <td><a href="Admin.cfm?StepNum=21&requestid=#GetDenied.requestid[i]#&userid=#GetDenied.userid[i]#">#GetDenied.Requestid[i]#</a></td>
                    <!--- Query to get ID Number --->
                    <cfquery name="GetID" datasource="accounts">
                        SELECT EmpID
                        FROM	accounts
                        WHERE	Username = '#GetDenied.userid[i]#'
                    </cfquery>
                    <td>#GetDenied.Full_Name[i]#, #GetDenied.EmpID[i]#</td>
                    <td>#LSDateFormat(GetDenied.dateentered[i],'mm/dd/yyyy')#</td>
                    <td>#GetDenied.requesteddates[i]#<br />From: #LSDateFormat(GetDenied.dtFrom,'mm/dd/yyyy')# - #lsDateFormat(GetDenied.dtTo,'mm/dd/yyyy')#</td>
                    <!--- Get Leave Type --->
                    <cfquery name="GetLeaveType" datasource="mesa_web">
                    	SELECT	*
                        FROM	LeaveReq_tblLeaveType
                        WHERE	code = '#GetDenied.requesttype[i]#'
                    </cfquery>
                    <td>#GetLeaveType.LeaveType#</td>
                    <td>#GetDenied.supviewed[i]# / #LSDateFormat(GetDenied.supvieweddate[i],'mm/dd/yyyy')#</td>
                </tr>
            </cfloop>
        </cfoutput>
    </table>--->
	
    <br /><br />
    </cfloop>
	
    <cfinclude template="Back_Admin.cfm">
    <cfinclude template="Logout_admin.cfm">
<!--- StepNum = 21 View an Approved or Denied Request --->
<cfelseif StepNum eq 21>
	<cfset Session.RequestID = '#requestid#'>
    <cfset Session.Userid = '#userid#'>
    <cfset GoToStepNum = 20>
    <!--- Query to Get Request Information --->
    <cfquery name="GetReqData" datasource="mesa_web">
    	SELECT	*
        FROM	LeaveReq_tblRequest
        WHERE	RequestID = '#SEssion.RequestID#' AND userid = '#Session.userid#'
    </cfquery>
    <!--- Get and Display Employee Information --->
    <cfquery name="GetEmpInfo" datasource="accounts">
    	SELECT	Full_name, EmpID, Building
        FROM	accounts
        WHERE	Username = '#Session.userid#'
    </cfquery>
    <cfoutput>
    <!--- Get Number of Days approved so far --->
    <cfquery name="GetDaysApp" datasource="mesa_web">
    	SELECT	SUM(numdaysapproved) as DaysApp
        FROM	LeaveReq_tblRequest
        WHERE	userid = '#Session.userid#' and yearofrequest = '2024-2025' and Approved = 'A'
    </cfquery>
    <table border="1" width="100%">
    	<tr>
        	<td align="center">Number of Days Approved this year: #GetDaysApp.DaysApp#</td>
  		</tr>
    </table>
        <table width="100%" border="1">
            <tr><th>Pending Request for: #GetEmpInfo.Full_Name#</th>
            <!--- Emp Information --->
            </tr><tr>
            	<td>
                	<table border="1" width="100%">
                    	<tr>
                        	<td>Name:</td>
                            <td>Emp ID: </td>
                            <td>Building</td>
                        </tr>
                        <tr>
                        	<td>#GetEmpInfo.Full_Name#</td>
                            <td>#GetEmpInfo.EmpID#</td>
                            <td><cfif #GetEmpInfo.Building# eq 'columbus'>New Emerson<cfelse>#GetEmpInfo.Building#</cfif></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <!--- Request Information --->
            <tr>
            	<td>
                	<table border="1" width="100%">
                    	<tr>
                        	<td>RequestID: #GetReqData.RequestID#</td>
                            <td>Date Entered: #LSDateFormat(GetReqData.dateentered,'mm/dd/yyyy')#</td>
                        </tr>
                        <tr>
                        	<td colspan="2">Date(s) Requested: #GetReqData.requesteddates#<br />From: #LSDateFormat(GetReqData.dtFrom,'mm/dd/yyyy')# - To: #LSDateFormat(GetReqData.dtTo,'mm/dd/yyyy')#</td>
                        </tr>
                        <!--- Get Leave Type --->
                        <cfquery name="GetLeaveType" datasource="mesa_web">
                        	SELECT	LeaveType
                            FROM	LeaveReq_tblLeaveType
                            WHERE	code = '#GetReqData.requesttype#'
                        </cfquery>
                        <tr>
                        	<td colspan="2">
                            	Request Type: #GetLeaveType.LeaveType#
                                <cfif #GetReqData.requesttype# eq 1>
                                	- #GetReqData.bereavementrelate#
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="2">
                            	<cfif #GetReqData.subfinderNum# gt 0>
                                	Subfinder Number: #GetReqData.subfindernum#
                                <cfelse>
                                	Sub Needed: #GetReqData.subrequested#
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                        	<td>Employee Signature: #GetReqData.signature#</td>
                            <td>Date: #LSDateFormat(GetReqData.signaturedate,'mm/dd/yyyy')#</td>
                        </tr>
                        <tr>
                        	<td>Principal/Supervisor: #GetReqData.supervisor#</td>
                            <td>Reviewed: #GetReqData.supviewed# Date Reviewed: #LSDateFormat(GetReqData.supvieweddate,'mm/dd/yyyy')#</td>
                        </tr>
                        <tr>
                        	<td colspan="2">
                            	Comments to HR: #GetReqData.Commentstohr#
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <!--- Approve / Deny section --->
            <tr>
            	<td align="center">Approved / Pending / Denied: <cfif #GetReqData.Approved# eq 'A'>Approved<cfelseif #GetReqData.Approved# eq 'P'>Pending<cfelse>Denied</cfif></td>
            </tr>
            <tr>
            	<td>Approved By: #GetReqData.ApprovedUser# ON: #LSDateFormat(GetReqData.approvedDate,'mm/dd/yyyy')#</td>
            </tr>
            <tr>
            	<td>Comments: #GetReqData.Comments#</td>
            </tr>
        </table>
    </cfoutput>
    <cfinclude template="Back_Admin.cfm">
    <cfinclude template="Logout_admin.cfm">
<!--- Stepnum eq 30 - Denied Requests --->
<cfelseif StepNum eq 30>
<cfif #Session.Username# eq 'oldmwilcox'>
	<cfset Start = 1>
    <cfset End = 1>
<cfelseif #Session.Username# eq 'kubersox'>
	<cfset Start = 2>
    <!---<cfset Start = 1>--->
    <cfset End = 2>
<cfelse>
	<cfset Start = 1>
    <cfset End = 2>
</cfif>
	
<cfloop from="#Start#" to="#End#" index="a">
	<cfset GoToStepNum = 1>
	<!--- View Approved Requests --->
    <!--- Get LIst of Approved Requests 
    <cfquery name="GetAppRequests" datasource="mesa_web">
    	SELECT	*
        FROM	LeaveReq_tblRequest
        WHERE	Approved = 'A' and yearofrequest = '2024-2025'  and EmpType = #a#
        ORDER BY userid, dateentered
    </cfquery>
    
    <cfquery name="GetID" datasource="accounts">
        SELECT EmpID, Full_Name, Username, fname, lname
        FROM	accounts
    </cfquery>
    
    <cfquery name="GetApproved" dbtype="query" timeout="600">
    	SELECT	GetAppRequests.requestid, GetAppRequests.dateentered, GetAppRequests.requesteddates, GetAppRequests.requesttype, GetAppRequests.supviewed, GetAppRequests.supvieweddate,
        		GetID.EmpID, GetID.Full_Name, GetID.Username, GetAppRequests.UserID, GetID.fname, GetID.lname, GetAppRequests.dtFrom, GetAppRequests.dtTo
        FROM	GetAppRequests, GetID
        WHERE	GetAppRequests.UserID = GetID.Username AND yearofrequest = '2024-2025'
        ORDER BY	GetID.Lname, GetID.fname, GetAppRequests.dateentered, GetAppRequests.requesteddates
    </cfquery>
    
    <table border="1" width="100%">
    	<tr>
        	<td align="center" colspan="6"><cfif #a# eq 1>Certified<cfelse>Classified</cfif> Approved Requests</td>
        </tr>
        <tr>
        	<td>Request ID</td>
            <td>User id, Emp Num</td>
            <td>Date Entered</td>
            <td>Requested Date(s)</td>
            <td>Request Type</td>
            <td>Supervisor Viewed / Viewed Date</td>
        </tr>
        <cfoutput>
            <cfloop from="1" to="#GetApproved.RecordCount#" index="i">
                <tr>
                    <td><a href="Admin.cfm?StepNum=21&requestid=#GetApproved.requestid[i]#&userid=#GetApproved.userid[i]#">#GetApproved.Requestid[i]#</a></td>
                    <!--- Query to get ID Number --->
                    <cfquery name="GetID" datasource="accounts">
                        SELECT EmpID
                        FROM	accounts
                        WHERE	Username = '#GetApproved.userid[i]#'
                    </cfquery>
                    <td>#GetApproved.Full_Name[i]#, #GetApproved.EmpID[i]#</td>
                    <td>#LSDateFormat(GetApproved.dateentered[i],'mm/dd/yy')#</td>
                    <td>#GetApproved.requesteddates[i]#<br />From: #LSDateFormat(getApproved.dtFrom,'mm/dd/yyyy')# - #lsDateFormat(getApproved.dtTo,'mm/dd/yyyy')#</td>
                    <!--- Get Leave Type --->
                    <cfquery name="GetLeaveType" datasource="mesa_web">
                    	SELECT	*
                        FROM	LeaveReq_tblLeaveType
                        WHERE	code = '#GetApproved.requesttype[i]#'
                    </cfquery>
                    <td>#GetLeaveType.LeaveType#</td>
                    <td>#GetApproved.supviewed[i]# / #LSDateFormat(GetApproved.supvieweddate[i],'mm/dd/yyyy')#</td>
                </tr>
            </cfloop>
        </cfoutput>
    </table>--->
    <!--- View Approved Requests --->
    <!--- Get LIst of Approved Requests --->
    <!---
    <cfquery name="GetPenRequests" datasource="mesa_web">
    	SELECT	*
        FROM	LeaveReq_tblRequest
        WHERE	Approved = 'P' and yearofrequest = '2024-2025' and EmpType = #a#
    </cfquery>
    
    <cfquery name="GetID" datasource="accounts">
        SELECT EmpID, Full_Name, Username, fname, lname
        FROM	accounts
    </cfquery>
    
    <cfquery name="GetPending" dbtype="query">
    	SELECT	GetPenRequests.requestid, GetPenRequests.dateentered, GetPenRequests.requesteddates, GetPenRequests.requesttype, GetPenRequests.supviewed, GetPenRequests.supvieweddate,
        		GetID.EmpID, GetID.Full_Name, GetID.Username, GetPenRequests.UserID, GetID.fname, GetID.lname, GetPenRequests.dtFrom, getPenRequests.dtTo
        FROM	GetPenRequests, GetID
        WHERE	GetPenRequests.UserID = GetID.Username AND yearofrequest = '2024-2025'
        ORDER BY	GetID.Lname, GetID.fname, GetPenRequests.dateentered, GetPenRequests.requesteddates
    </cfquery>
    
    <table border="1" width="100%">
    	<tr>
        	<td align="center" colspan="6"><cfif #a# eq 1>Certified<cfelse>Classified</cfif> Pending Days Used Requests</td>
        </tr>
        <tr>
        	<td>Request ID</td>
            <td>User id, Emp Num</td>
            <td>Date Entered</td>
            <td>Requested Date(s)</td>
            <td>Request Type</td>
            <td>Supervisor Viewed / Viewed Date</td>
        </tr>
        <cfoutput>
            <cfloop from="1" to="#GetPending.RecordCount#" index="i">
                <tr>
                    <td><a href="Admin.cfm?StepNum=21&requestid=#GetPending.requestid[i]#&userid=#GetPending.userid[i]#">#GetPending.Requestid[i]#</a></td>
                    <!--- Query to get ID Number --->
                    <cfquery name="GetID" datasource="accounts">
                        SELECT EmpID
                        FROM	accounts
                        WHERE	Username = '#GetPending.userid[i]#'
                    </cfquery>
                    <td>#GetPending.Full_Name[i]#, #GetPending.EmpID[i]#</td>
                    <td>#LSDateFormat(GetPending.dateentered[i],'mm/dd/yyyy')#</td>
                    <td>#GetPending.requesteddates[i]#<br />From: #LSDateFormat(GetPending.dtFrom,'mm/dd/yyyy')# - #lsDateFormat(GetPending.dtTo,'mm/dd/yyyy')#</td>
                    <!--- Get Leave Type --->
                    <cfquery name="GetLeaveType" datasource="mesa_web">
                    	SELECT	*
                        FROM	LeaveReq_tblLeaveType
                        WHERE	code = '#GetPending.requesttype[i]#'
                    </cfquery>
                    <td>#GetLeaveType.LeaveType#</td>
                    <td>#GetPending.supviewed[i]# / #LSDateFormat(GetPending.supvieweddate[i],'mm/dd/yyyy')#</td>
                </tr>
            </cfloop>
        </cfoutput>
    </table>
	--->
    <!--- View Denied Requests --->
    <cfquery name="GetDenRequests" datasource="mesa_web">
    	SELECT	*
        FROM	LeaveReq_tblRequest
        WHERE	Approved = 'D' and yearofrequest = '2024-2025' and EmpType = #a#
    </cfquery>
    
    <cfquery name="GetID" datasource="accounts">
        SELECT EmpID, Full_Name, Username, fname, lname
        FROM	accounts
    </cfquery>
    
    
    <cfquery name="GetDenied" dbtype="query" timeout="600">
    	SELECT	GetDenRequests.requestid, GetDenRequests.dateentered, GetDenRequests.requesteddates, GetDenRequests.requesttype, GetDenRequests.supviewed, GetDenRequests.supvieweddate,
        		GetID.EmpID, GetID.Full_Name, GetID.Username, GetDenRequests.UserID, GetID.fname, GetID.lname, GetDenRequests.dtFrom, GetDenRequests.dtTo
        FROM	GetDenRequests, GetID
        WHERE	GetDenRequests.UserID = GetID.Username and yearofrequest = '2024-2025'
        ORDER BY	GetID.Lname, GetID.fname, GetDenRequests.dateentered, GetDenRequests.requesteddates
    </cfquery>
    
    <table border="1" width="100%">
    	<tr>
        	<td align="center" colspan="6"><cfif #a# eq 1>Certified<cfelse>Classified</cfif> Denied Requests</td>
        </tr>
        <tr>
        	<td>Request ID</td>
            <td>User id, Emp Num</td>
            <td>Date Entered</td>
            <td>Requested Date(s)</td>
            <td>Request Type</td>
            <td>Supervisor Viewed / Viewed Date</td>
        </tr>
        <cfoutput>
            <cfloop from="1" to="#GetDenied.RecordCount#" index="i">
                <tr>
                    <td><a href="Admin_test.cfm?StepNum=31&requestid=#GetDenied.requestid[i]#&userid=#GetDenied.userid[i]#">#GetDenied.Requestid[i]#</a></td>
                    <!--- Query to get ID Number --->
                    <cfquery name="GetID" datasource="accounts">
                        SELECT EmpID
                        FROM	accounts
                        WHERE	Username = '#GetDenied.userid[i]#'
                    </cfquery>
                    <td>#GetDenied.Full_Name[i]#, #GetDenied.EmpID[i]#</td>
                    <td>#LSDateFormat(GetDenied.dateentered[i],'mm/dd/yyyy')#</td>
                    <td>#GetDenied.requesteddates[i]#<br />From: #LSDateFormat(GetDenied.dtFrom,'mm/dd/yyyy')# - #lsDateFormat(GetDenied.dtTo,'mm/dd/yyyy')#</td>
                    <!--- Get Leave Type --->
                    <cfquery name="GetLeaveType" datasource="mesa_web">
                    	SELECT	*
                        FROM	LeaveReq_tblLeaveType
                        WHERE	code = '#GetDenied.requesttype[i]#'
                    </cfquery>
                    <td>#GetLeaveType.LeaveType#</td>
                    <td>#GetDenied.supviewed[i]# / #LSDateFormat(GetDenied.supvieweddate[i],'mm/dd/yyyy')#</td>
                </tr>
            </cfloop>
        </cfoutput>
    </table>
	
    <br /><br />
    </cfloop>
	
    <cfinclude template="Back_Admin.cfm">
    <cfinclude template="Logout_admin.cfm">
<!--- StepNum = 31 View an Denied Request --->
<cfelseif StepNum eq 31>
	<cfset Session.RequestID = '#requestid#'>
    <cfset Session.Userid = '#userid#'>
    <cfset GoToStepNum = 30>
    <!--- Query to Get Request Information --->
    <cfquery name="GetReqData" datasource="mesa_web">
    	SELECT	*
        FROM	LeaveReq_tblRequest
        WHERE	RequestID = '#SEssion.RequestID#' AND userid = '#Session.userid#'
    </cfquery>
    <!--- Get and Display Employee Information --->
    <cfquery name="GetEmpInfo" datasource="accounts">
    	SELECT	Full_name, EmpID, Building
        FROM	accounts
        WHERE	Username = '#Session.userid#'
    </cfquery>
    <cfoutput>
    <!--- Get Number of Days approved so far --->
    <cfquery name="GetDaysApp" datasource="mesa_web">
    	SELECT	SUM(numdaysapproved) as DaysApp
        FROM	LeaveReq_tblRequest
        WHERE	userid = '#Session.userid#' and yearofrequest = '2024-2025' and Approved = 'A'
    </cfquery>
    <table border="1" width="100%">
    	<tr>
        	<td align="center">Number of Days Approved this year: #GetDaysApp.DaysApp#</td>
  		</tr>
    </table>
        <table width="100%" border="1">
            <tr><th>Pending Request for: #GetEmpInfo.Full_Name#</th>
            <!--- Emp Information --->
            </tr><tr>
            	<td>
                	<table border="1" width="100%">
                    	<tr>
                        	<td>Name:</td>
                            <td>Emp ID: </td>
                            <td>Building</td>
                        </tr>
                        <tr>
                        	<td>#GetEmpInfo.Full_Name#</td>
                            <td>#GetEmpInfo.EmpID#</td>
                            <td><cfif #GetEmpInfo.Building# eq 'columbus'>New Emerson<cfelse>#GetEmpInfo.Building#</cfif></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <!--- Request Information --->
            <tr>
            	<td>
                	<table border="1" width="100%">
                    	<tr>
                        	<td>RequestID: #GetReqData.RequestID#</td>
                            <td>Date Entered: #LSDateFormat(GetReqData.dateentered,'mm/dd/yyyy')#</td>
                        </tr>
                        <tr>
                        	<td colspan="2">Date(s) Requested: #GetReqData.requesteddates#<br />From: #LSDateFormat(GetReqData.dtFrom,'mm/dd/yyyy')# - To: #LSDateFormat(GetReqData.dtTo,'mm/dd/yyyy')#</td>
                        </tr>
                        <!--- Get Leave Type --->
                        <cfquery name="GetLeaveType" datasource="mesa_web">
                        	SELECT	LeaveType
                            FROM	LeaveReq_tblLeaveType
                            WHERE	code = '#GetReqData.requesttype#'
                        </cfquery>
                        <tr>
                        	<td colspan="2">
                            	Request Type: #GetLeaveType.LeaveType#
                                <cfif #GetReqData.requesttype# eq 1>
                                	- #GetReqData.bereavementrelate#
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="2">
                            	<cfif #GetReqData.subfinderNum# gt 0>
                                	Subfinder Number: #GetReqData.subfindernum#
                                <cfelse>
                                	Sub Needed: #GetReqData.subrequested#
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                        	<td>Employee Signature: #GetReqData.signature#</td>
                            <td>Date: #LSDateFormat(GetReqData.signaturedate,'mm/dd/yyyy')#</td>
                        </tr>
                        <tr>
                        	<td>Principal/Supervisor: #GetReqData.supervisor#</td>
                            <td>Reviewed: #GetReqData.supviewed# Date Reviewed: #LSDateFormat(GetReqData.supvieweddate,'mm/dd/yyyy')#</td>
                        </tr>
                        <tr>
                        	<td colspan="2">
                            	Comments to HR: #GetReqData.Commentstohr#
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <!--- Approve / Deny section --->
            <tr>
            	<td align="center">Approved / Pending / Denied: <cfif #GetReqData.Approved# eq 'A'>Approved<cfelseif #GetReqData.Approved# eq 'P'>Pending<cfelse>Denied</cfif></td>
            </tr>
            <tr>
            	<td>Approved By: #GetReqData.ApprovedUser# ON: #LSDateFormat(GetReqData.approvedDate,'mm/dd/yyyy')#</td>
            </tr>
            <tr>
            	<td>Comments: #GetReqData.Comments#</td>
            </tr>
        </table>
    </cfoutput>
    <cfinclude template="Back_Admin.cfm">
    <cfinclude template="Logout_admin.cfm">
<!--- Delete Request --->
<cfelseif StepNum eq 998> ---&gt;
<!--- Get Request info and put into a string --->
<cfquery name="GetReqInfo" datasource="mesa_web">
	SELECT	*
    FROM	LeaveReq_tblRequest
    WHERE	RequestID = '#Session.RequestID#' AND UserID = '#Session.UserID#'
</cfquery>
<cfset DeletedRequest = '#GetReqInfo.RequestID#,#GetReqInfo.UserID#,#GetReqInfo.RequestID#,#GetReqInfo.dateentered#,#GetReqInfo.requesttype#,#GetReqInfo.signature#,#GetReqInfo.signaturedate#,#GetReqInfo.supervisor#,#GetReqInfo.supervisor2#'>
<cfset reason = '#form.DeleteReason#'>
<cfset by = '#Session.FullName#'>
<cfset on = #NOW()#>
<!--- insert into deleted request table --->
<cfquery name="InsertDeleted" datasource="mesa_web">
	INSERT INTO	LeaveReq_tblDeleted (details, reason, deletedby, deletedon)
    VALUES ('#DeletedRequest#', '#reason#', '#by#', #on#)
</cfquery>
<!--- delete from table --->
<cfquery name="DeleteFrom" datasource="mesa_web">
	DELETE FROM LeaveReq_tblRequest
    WHERE	RequestID = '#Session.RequestID#' AND UserID = '#Session.UserID#'
</cfquery>
<!--- Return to view reqeusts --->
<cflocation url="admin_test.cfm?StepNum=10">
<!--- Logout --->
<cfelseif StepNum eq 999>
	<cfcookie name="CFID" expires="now">
	<cfcookie name="CFTOKEN" expires="now">
	<cfscript>
   		StructClear(Session);
	</cfscript>
	<cflocation url="admin_test.cfm">
<!--- End Steps --->
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