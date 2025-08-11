<!--- <cfapplication name="EmployeeLeaveRequest_supervisor" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,0,20,0)#"> --->
<!DOCTYPE html>
<html lang="en"><!-- InstanceBegin template="/Templates/fullpage.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
  <!--- <link rel="shortcut icon" href="/favicon.ico" />
	<link rel="stylesheet" type="text/css"  href="/css/text.css" />
   <link rel="stylesheet" type="text/css"  href="/css/main.css" /> --->
   <!--- <!--[if lte IE 6]><link rel="stylesheet" type="text/css" href="/css/olderIESupport.css" />
<![endif]--> --->
	<!--- <link rel="stylesheet" type="text/css"  href="/css/print.css" media="print" />
 <script src="/scripts/main.js" type="text/javascript"></script>
	<script src="/SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
	<link href="/SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" /> --->
	
	<!-- InstanceBeginEditable name="doctitle" -->
		<title>Leave Request Page - Supervisor</title>
	<!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="head" -->
	<!-- InstanceEndEditable -->
    <link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.css">
</head>

<body>
<div id="wrapper">
    <div id="headercontainer" class="container-fluid p-3">
        <div id="headerimages" class="d-flex align-items-center">
            <a href="http://www.mesa.k12.co.us">
                <img src="images/logo.jpg" alt="Mesa County Valley School District 51 logo" class="img-fluid" style="max-height: 80px;">
            </a>
        </div>

        <div id="headersprybar">
            <!--- <cfinclude template="/templates/components/sprybar.cfm" /> --->
        </div>
    </div>

    <!-- Green bar at bottom -->
    <div class="bg-success" style="height: 10px;"></div>

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

<cfif url.Stepnum eq 0>
	<cfif NOT isDefined("username")>

    <div class="alert alert-warning mt-3" role="alert">
        You are not logged in or the program has been inactive for 20 minutes.
    </div>

    <cfif NOT isDefined("submitform")>

        <div class="container mt-4" style="max-width: 500px;">
            <cfif isDefined("tryagain")>
                <div class="alert alert-danger" role="alert">
                    Invalid Username or Password or you are unauthorized — Try again
                </div>
            </cfif>

            <form method="post" action="">
                <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input
                    type="text"
                    id="username"
                    name="username"
                    class="form-control"
                    required
                    >
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input
                        type="password"
                        id="password"
                        name="password"
                        class="form-control"
                        required
                    >
                </div>


                <button type="submit" name="Submituser" class="btn btn-primary">Submit</button>
            </form>
        </div>

    </cfif>

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
<cfelseif url.Stepnum eq 1>
	<!--- query to get requests --->
    <cfquery name="GetRequests" datasource="mesa_web">
    	SELECT *
        FROM	LeaveReq_tblRequest
        WHERE	(((supervisor = '#Session.email#') OR (supervisor = '#session.username#@d51schools.org')) AND (supviewed IS NULL) AND yearofrequest >= '2025-2026')
        or 
        (((supervisor2 = '#Session.email#') OR (supervisor2 = '#session.username#@d51schools.org')) AND (sup2viewed IS NULL) AND yearofrequest >= '2025-2026')
        ORDER BY DateEntered, userid
    </cfquery>

    <table class="table table-bordered table-striped table-hover">
        <caption class="visually-hidden">List of pending leave requests</caption>
        <thead class="table-light">
            <tr>
                <th scope="col" colspan="3" class="text-center">Leave Requests: Pending</th>
            </tr>
            <tr>
                <th scope="col">Employee</th>
                <th scope="col">Request Dates</th>
                <th scope="col">Requested On</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="GetRequests">
                <tr>
                    <td>
                        <a href="supervisornew.cfm?StepNum=2&requestid=#requestid#&emp_username=#userid#">
                            #EncodeForHTML(userid)#
                        </a>
                    </td>
                    <td>#LSDateFormat(dtFrom,'mm/dd/yyyy')# - #LSDateFormat(dtTo,'mm/dd/yyyy')#</td>
                    <td>#LSDateFormat(dateentered,'mm/dd/yyyy')#</td>
                </tr>
            </cfoutput>
        </tbody>
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
    
        
    <table class="table table-bordered table-striped table-hover">
        <caption class="visually-hidden">List of viewed leave requests</caption>
        <thead class="table-light">
            <tr>
                <th scope="col" colspan="3" class="text-center">Leave Requests: Viewed</th>
            </tr>
            <tr>
                <th scope="col">Employee</th>
                <th scope="col">Request Dates</th>
                <th scope="col">Requested On</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="GetRequests">
                <tr>
                    <td>
                        <a href="supervisornew.cfm?StepNum=2&requestid=#requestid#&emp_username=#userid#">
                            #EncodeForHTML(userid)#
                        </a>
                    </td>
                    <td>#LSDateFormat(dtFrom, 'mm/dd/yyyy')# - #LSDateFormat(dtTo, 'mm/dd/yyyy')#</td>
                    <td>#LSDateFormat(dateentered, 'mm/dd/yyyy')#</td>
                </tr>
            </cfoutput>
        </tbody>
    </table>

<cfelseif url.Stepnum eq 2>
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
    <cfform name="ReviewedRequest" action="supervisornew.cfm?StepNum=3" method="post" style="max-width: 900px; margin: auto;">
        <cfoutput query="GetReq_Info">
            <div class="card mb-4">
                <div class="card-header text-center fw-bold">Leave Request Information</div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <strong>Name:</strong><br />
                            #GetEmpName.Full_Name#
                        </div>
                        <div class="col-md-4">
                            <strong>Requested Dates:</strong><br />
                            #Requesteddates#<br />
                            #LSDateFormat(dtFrom,'mm/dd/yyyy')# - #LSDateFormat(dtTo,'mm/dd/yyyy')#
                        </div>
                        <div class="col-md-4">
                            <strong>Type of Request:</strong><br />
                            <cfset requestTypes = {
                                1 = "Bereavement: relationship: #bereavementrelate#",
                                2 = "Jury/Witness",
                                3 = "Officiating/Judging",
                                4 = "Community Service",
                                5 = "Emergency",
                                6 = "Leave without pay",
                                7 = "FMLA own serious health condition",
                                8 = "FMLA care of immediate family member with a serious health condition",
                                9 = "Day or Personal Leave",
                                10 = "Vacation",
                                11 = "FMLA military Exigency Leave",
                                12 = "FMLA: Military caregiver leave",
                                13 = "Sick Leave"
                            }>
                            #requestTypes[GetReq_Info.requesttype]#
                        </div>
                    </div>

                    <div class="mb-3">
                        <strong>Date Entered:</strong> #LSDateFormat(GetReq_Info.dateentered,'mm/dd/yyyy')#
                    </div>

                    <div class="mb-3">
                        <strong>Status:</strong>
                        <cfif GetReq_Info.approved EQ 'A'>
                            has been <strong>Approved</strong>
                        <cfelseif GetReq_Info.approved EQ 'P'>
                            is <strong>Pending</strong> personal leave available for the fiscal year July through June
                        <cfelseif GetReq_Info.approved EQ 'D'>
                            has been <strong>Denied</strong>
                        <cfelse>
                            No Action has been taken by Human Resources
                        </cfif>.
                    </div>

                    <div class="mb-3">
                        <cfif GetReq_Info.subfindernum NEQ 0>
                            A sub request has been made in subfinder: #GetReq_Info.subfindernum#<br /><br />
                        <cfelse>
                            <cfif GetReq_Info.Subrequested EQ 'No'>
                                A Sub has not been requested or is not needed.<br /><br />
                            <cfelse>
                                A Sub has been requested.<br /><br />
                            </cfif>
                        </cfif>
                    </div>

                    <div class="container my-4" role="region" aria-labelledby="comments-to-hr-heading">
                        <h2 id="comments-to-hr-heading" class="h5">Comments to HR</h2>
                        <div class="p-3 border rounded bg-light" aria-describedby="hr-comments">
                            <p id="hr-comments" class="mb-0">
                            <cfoutput>#GetReq_Info.commentstohr#</cfoutput>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </cfoutput>

        <!-- Supervisor Review Section -->
        <fieldset class="mb-3" role="radiogroup" aria-labelledby="review-label">
            <legend id="review-label" class="form-label fw-bold">I support this request:</legend>

            <div class="form-check form-check-inline">
                <input
                    type="radio"
                    name="reviewed"
                    id="reviewed_yes"
                    value="yes"
                    class="form-check-input"
                    <cfif GetReq_Info.supviewed EQ 'yes'>checked</cfif>>
                <label class="form-check-label" for="reviewed_yes">Yes</label>
            </div>

            <div class="form-check form-check-inline">
                <input
                    type="radio"
                    name="reviewed"
                    id="reviewed_no"
                    value="no"
                    class="form-check-input"
                    <cfif GetReq_Info.supviewed NEQ 'yes'>checked</cfif>>
                <label class="form-check-label" for="reviewed_no">No</label>
            </div>
        </fieldset>

        <div class="mb-3">
            <label for="supcomments" class="form-label fw-bold">Reason:</label>
            <input
                type="text"
                name="supcomments"
                id="supcomments"
                size="125"
                class="form-control"
                value="<cfoutput>#GetReq_Info.supcomments#</cfoutput>"
            >
        </div>

        <div class="text-center">
            <cfinput type="submit" name="submit" value="Submit" class="btn btn-primary">
        </div>
    </cfform>

<cfelseif url.Stepnum eq 3>
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
<cfelseif url.Stepnum eq 4>
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