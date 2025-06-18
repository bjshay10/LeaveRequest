<cfapplication name="EmployeeLeaveRequest_supervisor" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,0,20,0)#">
<!--- <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/fullpage.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
 --->
<!DOCTYPE html> 
<html lang="en">
<head>
	<!--- <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
  <link rel="shortcut icon" href="/favicon.ico" />
	<link rel="stylesheet" type="text/css"  href="/css/text.css" />
   <link rel="stylesheet" type="text/css"  href="/css/main.css" /> --->
   <!--[if lte IE 6]><link rel="stylesheet" type="text/css" href="/css/olderIESupport.css" />
<![endif]-->
	<!--- <link rel="stylesheet" type="text/css"  href="/css/print.css" media="print" />
 <script src="/scripts/main.js" type="text/javascript"></script>
	<script src="/SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
	<link href="/SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" /> --->
	
	<!-- InstanceBeginEditable name="doctitle" -->
		<title>Leave Request Supervisor</title>
	<!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="head" -->
	<!-- InstanceEndEditable -->
    <link rel="stylesheet" type="text/css" href="css/custom.css" />
    <link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.css" />
</head>

<body>
<div id="wrapper">
	<!--- <div id="headercontainer">
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
  	<div id="maincontentfull"> --->
    		<h1 class="text-center display-5 fw-bold my-4">Leave Request - Supervisor Page</h1>
				 <!-- InstanceBeginEditable name="Content" -->


<!--- <cfif (cgi.https eq "off") and 
	(cgi.SERVER_NAME does not contain "intranet")>
	<cflocation url="https://www.mesa.k12.co.us/apps/LeaveRequest/supervisornew.cfm" addtoken="no">
	<cfabort>
</cfif> --->

<cfif not isdefined('StepNum')>
	<cfset StepNum = 0>
</cfif>

<cfif StepNum eq 0>
	<cfif not isdefined ('username')>
	    <h2>Welcome to the Leave Request - Supervisor page.  Please Log in.</h2><br />	
	</cfif>

    <!--- User Login --->
    <cfif not isdefined ('username') and not isdefined ('submitform')>
        <p>&nbsp; </p>
        <div class="centered-section">
            <cfif isdefined('tryagain')>
                <pan class="red">Invalid Username or Password or you are unauthorized- - Try again</span>
                </div>
            </cfif>
            <!--- <cfform name="form2" method="post" action="" width="500" height="550">
                <!---<cfformgroup type="panel" label="Leave Request Form">--->
                <table align="center"><tr><td align="center">
                    <label for="username">Username:</label> <cfinput name="username" id="username" type="text" size="20" label="Username:" onkeydown="if(Key.isDown(Key.ENTER)) Submituser.dispatchEvent({type:'click'});"><br />

                    <label for="password">Password:</label> <cfinput name="password" type="password" id="password" size="20" label="Password:" onkeydown="if(Key.isDown(Key.ENTER)) Submituser.dispatchEvent({type:'click'});"><br />
                <cfinput type="submit" name="Submituser" value="Submit">
                </td></tr></table>
            </cfform> --->

            <div class="login-container">
                <cfform class="login-form" action="" method="post">
                    <div class="form-group">
                        <label for="username">Username:</label>
                        <cfinput name="username" id="username" type="text" size="20" required="yes" message="Username is required.">
                    </div>

                    <div class="form-group">
                        <label for="password">Password:</label>
                        <cfinput name="password" type="password" id="password" size="20" required="yes" message="Password is required.">
                    </div>

                    <cfinput type="submit" name="Submituser" value="Submit">
                </cfform>
            </div>
        </div>
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
	<cfquery name="GetPendingRequests" datasource="mesa_web">
        SELECT *
        FROM LeaveReq_tblRequest
        WHERE
            (
                (supervisor = <cfqueryparam value="#Session.email#" cfsqltype="cf_sql_varchar"> OR supervisor = <cfqueryparam value="#session.username#@d51schools.org" cfsqltype="cf_sql_varchar">)
                AND supviewed IS NULL
                AND yearofrequest >= <cfqueryparam value="2024-2025" cfsqltype="cf_sql_varchar">
            )
            OR
            (
                (supervisor2 = <cfqueryparam value="#Session.email#" cfsqltype="cf_sql_varchar"> OR supervisor2 = <cfqueryparam value="#session.username#@d51schools.org" cfsqltype="cf_sql_varchar">)
                AND sup2viewed IS NULL
                AND yearofrequest >= <cfqueryparam value="2024-2025" cfsqltype="cf_sql_varchar">
            )
        ORDER BY DateEntered, userid
    </cfquery>

    <div class="card mb-5 shadow-sm">
        <div class="card-header bg-success text-white fw-bold">
            <h2 class="mb-0 fs-5">Leave Requests: Pending</h2>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-striped table-hover mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>Employee</th>
                            <th>Request Dates</th>
                            <th>Requested On</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif GetPendingRequests.RecordCount eq 0>
                            <tr>
                                <td colspan="3" class="text-center text-muted py-3">No pending leave requests found.</td>
                            </tr>
                        <cfelse>
                            <cfoutput query="GetPendingRequests">
                                <tr>
                                    <td>
                                        <a href="supervisornew.cfm?StepNum=2&requestid=#requestid#&emp_username=#userid#" class="text-decoration-underline">
                                            #HtmlEditFormat(userid)#
                                        </a>
                                    </td>
                                    <td>#LsDateFormat(dtFrom,'mm/dd/yyyy')# - #LSDateFormat(dtTo,'mm/dd/yyyy')#</td>
                                    <td>#lsdateformat(dateentered,'mm/dd/yyyy')#</td>
                                </tr>
                            </cfoutput>
                        </cfif>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <cfquery name="GetViewedRequests" datasource="mesa_web">
        SELECT *
        FROM LeaveReq_tblRequest
        WHERE
            (
                (supervisor = <cfqueryparam value="#Session.email#" cfsqltype="cf_sql_varchar"> OR supervisor = <cfqueryparam value="#session.username#@d51schools.org" cfsqltype="cf_sql_varchar">)
                AND (supviewed = 'Yes' OR supviewed = 'No')
                AND yearofrequest >= <cfqueryparam value="2024-2025" cfsqltype="cf_sql_varchar">
            )
            OR
            (
                (supervisor2 = <cfqueryparam value="#Session.email#" cfsqltype="cf_sql_varchar"> OR supervisor2 = <cfqueryparam value="#session.username#@d51schools.org" cfsqltype="cf_sql_varchar">)
                AND (sup2viewed = 'Yes' OR sup2viewed = 'No')
                AND yearofrequest >= <cfqueryparam value="2024-2025" cfsqltype="cf_sql_varchar">
            )
        ORDER BY DateEntered, userid
    </cfquery>

    <div class="card mb-5 shadow-sm">
        <div class="card-header bg-success text-white fw-bold">
            <h2 class="mb-0 fs-5">Leave Requests: Viewed</h2>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-striped table-hover mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>Employee</th>
                            <th>Request Dates</th>
                            <th>Requested On</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif GetViewedRequests.RecordCount eq 0>
                            <tr>
                                <td colspan="3" class="text-center text-muted py-3">No viewed leave requests found.</td>
                            </tr>
                        <cfelse>
                            <cfoutput query="GetViewedRequests">
                                <tr>
                                    <td>
                                        <a href="supervisornew.cfm?StepNum=2&requestid=#requestid#&emp_username=#userid#" class="text-decoration-underline">
                                            #HtmlEditFormat(userid)#
                                        </a>
                                    </td>
                                    <td>#LsDateFormat(dtFrom,'mm/dd/yyyy')# - #LSDateFormat(dtTo,'mm/dd/yyyy')#</td>
                                    <td>#lsdateformat(dateentered,'mm/dd/yyyy')#</td>
                                </tr>
                            </cfoutput>
                        </cfif>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="card mb-5 shadow-sm">
        <cfform  action="supervisornew.cfm?stepnum=4" method="post">
            <input type="submit" name="logout" Value="Logout" class="btn btn-primary"/>           
        </cfform>
    </div>



<cfelseif StepNum eq 2>
    <cfset Session.emp_username = '#emp_username#'>
    <cfset Session.requestid = '#requestid#'>

    <cfquery name="GetReq_Info" datasource="mesa_web">
        SELECT *
        FROM LeaveReq_tblRequest
        WHERE requestid = <cfqueryparam value="#Session.RequestID#" cfsqltype="cf_sql_varchar">
        AND Userid = <cfqueryparam value="#Session.emp_username#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfquery name="GetEmpName" datasource="accounts">
        SELECT Full_Name, username
        FROM accounts
        WHERE Username = <cfqueryparam value="#Session.emp_username#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif GetReq_Info.RecordCount GT 0>
        <cfif GetReq_Info.Supervisor eq Session.email OR GetReq_Info.Supervisor eq "#session.username#@d51schools.org">
            <cfset Session.SupNum = 1>
        <cfelseif GetReq_Info.Supervisor2 eq Session.email OR GetReq_Info.Supervisor2 eq "#session.username#@d51schools.org">
            <cfset Session.SupNum = 2>
        <cfelse>
            <cfset Session.SupNum = 0> </cfif>
    <cfelse>
        <cfset Session.SupNum = 0> </cfif>

    <div class="container mt-4">
        <cfoutput query="GetReq_Info">
            <div class="card mb-4 shadow-sm">
                <div class="card-header bg-success text-white fw-bold">
                    <h2 id="leaveRequestInfoHeading" class="mb-0 fs-5">Leave Request Information for #HtmlEditFormat(GetEmpName.Full_Name)#</h2>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-bordered mb-0" aria-labelledby="leaveRequestInfoHeading">
                            <caption class="visually-hidden">Detailed information about the leave request for #HtmlEditFormat(GetEmpName.Full_Name)#</caption>
                            <thead>
                                <tr>
                                    <th scope="col" style="width: 33%;">Employee Name</th>
                                    <th scope="col" style="width: 33%;">Requested Dates</th>
                                    <th scope="col" style="width: 34%;">Type of Request</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-label="Employee Name">#HtmlEditFormat(GetEmpName.Full_Name)#</td>
                                    <td data-label="Requested Dates">
                                        #HtmlEditFormat(Requesteddates)#<br>
                                        <span class="small text-muted">(#LsDateFormat(dtFrom,'mm/dd/yyyy')# - #LSDateFormat(dtTo,'mm/dd/yyyy')#)</span>
                                    </td>
                                    <td data-label="Type of Request">
                                        <cfif GetReq_Info.requesttype eq 1>
                                            Bereavement: relationship: #HtmlEditFormat(bereavementrelate)#
                                        <cfelseif GetReq_Info.requesttype eq 2>
                                            Jury/Witness
                                        <cfelseif GetReq_Info.requesttype eq 3>
                                            Officiating/Judging
                                        <cfelseif GetReq_Info.requesttype eq 4>
                                            Community Service
                                        <cfelseif GetReq_info.requesttype eq 5>
                                            Emergency
                                        <cfelseif GetReq_Info.requesttype eq 6>
                                            Leave without pay
                                        <cfelseif GetReq_Info.requesttype eq 7>
                                            FMLA own serious health condition
                                        <cfelseif GetReq_Info.requesttype eq 8>
                                            FMLA care of immediate family member with a serious health condition
                                        <cfelseif GetReq_Info.requesttype eq 9>
                                            Day or Personal Leave
                                        <cfelseif GetReq_Info.requesttype eq 10>
                                            Vacation
                                        <cfelseif GetReq_Info.requesttype eq 11>
                                            FMLA military Exigency Leave
                                        <cfelseif GetReq_Info.requesttype eq 12>
                                            FMLA: Military caregiver leave
                                        <cfelseif GetReq_Info.requesttype eq 13>
                                            Sick Leave
                                        </cfif>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" data-label="Date Entered">Date Entered: #LsDateFormat(GetReq_Info.dateentered,'mm/dd/yyyy')#</td>
                                </tr>
                                <tr>
                                    <td colspan="3" data-label="HR Status">
                                        Status:
                                        <cfif GetReq_Info.approved eq 'A'>
                                            has been <strong class="text-success">Approved</strong>
                                        <cfelseif GetReq_Info.approved eq 'P'>
                                            is <strong class="text-warning">Pending</strong> personal leave available for the fiscal year July through June
                                        <cfelseif GetReq_Info.approved eq 'D'>
                                            has been <strong class="text-danger">Denied</strong>
                                        <cfelse>
                                            No Action has been taken by Human Resources
                                        </cfif>.
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" data-label="Sub Request Information">
                                        <cfif GetReq_Info.subfindernum neq 0>
                                            A sub request has been made in subfinder: #HtmlEditFormat(GetReq_Info.subfindernum)#<br><br>
                                        <cfelse>
                                            <cfif GetReq_Info.Subrequested eq 'No'>
                                                A Sub has not been requested or is not needed.<br><br>
                                            <cfelse>
                                                A Sub has been requested.<br><br>
                                            </cfif>
                                        </cfif>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" data-label="Comments to HR">
                                        Comments to HR: #HtmlEditFormat(GetReq_Info.commentstohr)#
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <cfform name="ReviewedRequest" action="supervisornew.cfm?StepNum=3" method="post" class="card shadow-sm p-4">
                <h3 class="h5 mb-3" id="supervisorReviewHeading">Supervisor Review</h3>
                <div class="mb-3">
                    <p>I support this request:</p>
                    <fieldset aria-labelledby="supervisorReviewHeading">
                        <legend class="visually-hidden">Supervisor support for leave request</legend>
                        <cfset isYesChecked = (GetReq_Info.supviewed eq 'yes')>
                        <cfset isNoChecked = (GetReq_Info.supviewed eq 'no' OR NOT Len(Trim(GetReq_Info.supviewed)))>

                        <div class="form-check form-check-inline">
                            <cfinput type="radio" name="reviewed" value="yes" id="reviewedYes" class="form-check-input" checked="#isYesChecked#">
                            <label for="reviewedYes" class="form-check-label">Yes</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <cfinput type="radio" name="reviewed" value="no" id="reviewedNo" class="form-check-input" checked="#isNoChecked#">
                            <label for="reviewedNo" class="form-check-label">No</label>
                        </div>
                    </fieldset>
                </div>

                <div class="mb-3">
                    <label for="supComments" class="form-label">Reason for support/denial (comments):</label>
                    <cfinput type="text" name="supcomments" id="supComments" size="125" value="#HtmlEditFormat(GetReq_Info.supcomments)#" class="form-control" aria-describedby="supCommentsHelpText">
                    <div id="supCommentsHelpText" class="form-text">Provide any additional comments regarding your decision.</div>
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <a href="supervisornew.cfm?StepNum=1" class="btn btn-secondary" role="button" aria-label="Go back to the list of pending and viewed requests">Back to Requests</a>
                    <cfinput type="submit" name="submit" value="Submit Review" class="btn btn-primary">
                </div>
            </cfform>
        </cfoutput>
    </div>
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

    <cflocation url="supervisornew.cfm">
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