<!--- <cfapplication name="EmployeeLeaveRequest" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,2,0,0)#"> --->
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
		<title>Leave Request Page</title>
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
	        <center>Request and Approval for Leave</center>
		</h1>
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
        
<!--- <cfif (cgi.https eq "off") and 
	(cgi.SERVER_NAME does not contain "intranet")>
	<cflocation url="https://www.mesa.k12.co.us/apps/LeaveRequest/index.cfm" addtoken="no">
	<cfabort>
</cfif> --->

<cfif not isdefined('StepNum')>
	<cfset StepNum=0>
</cfif>

<cfif StepNum eq 0>
	<cfif not isdefined ('username')>
	Welcome to the Leave Request Form.  Please Log in.<br />	
	</cfif>

<!--- User Login --->
<cfif not isdefined ('username') and not isdefined ('submitform')>
	<cfif isDefined('tryagain')>
        <div class="alert alert-danger text-center" role="alert" aria-live="assertive">
            Invalid Username or Password or you are unauthorized — Try again.
        </div>
    </cfif>

    <cfform name="form2" method="post" action="">
        <div class="container mt-4" style="max-width: 400px;">
            <div class="card shadow">
                <div class="card-body">
                    <h2 class="card-title text-center mb-4">Login</h2>

                    <div class="mb-3">
                        <label for="username" class="form-label">Username</label>
                        <cfinput type="text" name="username" id="username"
                                class="form-control" size="20"
                                label="Username" required="yes"
                                onkeydown="if(event.key === 'Enter') document.querySelector('[name=Submituser]').click();">
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <cfinput type="password" name="password" id="password"
                                class="form-control" size="20"
                                label="Password" required="yes"
                                onkeydown="if(event.key === 'Enter') document.querySelector('[name=Submituser]').click();">
                    </div>

                    <div class="text-center">
                        <cfinput type="submit" name="Submituser" value="Submit" class="btn btn-primary w-100">
                    </div>
                </div>
            </div>
        </div>
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
	<cfform name="form2" method="post" action="index.cfm?StepNum=2">
        <fieldset class="container p-4 border rounded shadow-sm" style="max-width: 500px; margin: auto;">
            <legend class="h5 mb-3 text-center">Select Action</legend>

            <p class="text-center">Enter New Request or View Previous Request</p>

            <div class="form-check mb-2 text-center">
                <input class="form-check-input" type="radio" name="Action" id="actionNew" value="New" required>
                <label class="form-check-label" for="actionNew">Enter New Request</label>
            </div>

            <div class="form-check mb-3 text-center">
                <input class="form-check-input" type="radio" name="Action" id="actionView" value="View">
                <label class="form-check-label" for="actionView">View Previous Request</label>
            </div>

            <div class="text-center">
                <input type="submit" name="submitaction" value="Submit" class="btn btn-primary">
            </div>
        </fieldset>

        <div class="text-center mt-3">
            <input type="submit" name="logout" value="Logout" class="btn btn-secondary">
        </div>
    </cfform>
    
<!--- Redirect to Appropriate Selection --->
<cfelseif StepNum eq 2>
	<cfinclude template="logout.cfm">

    <cfif #Form.Action# eq "New">
        <!-- First Select Classified or Certified -->
        <cfform name="SelectEmpType" action="index.cfm?StepNum=4&#urlencodedformat(NOW())#" method="post">
            <fieldset class="container p-4 border rounded shadow-sm" style="max-width: 700px; margin: auto;">
                <legend class="h5 mb-3 text-center">Select Employee Type</legend>

                <div class="mb-4">
                    <p>
                        Teachers, Nurses, Psychologists, Audiologists, Speech Language Pathologists, etc.
                    </p>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="EmpType" id="certified" value="1" required>
                        <label class="form-check-label" for="certified">
                            Certified Employees
                        </label>
                    </div>
                </div>

                <div class="mb-4">
                    <p>
                        All Administrators (including Principals), Paraprofessionals, Nutrition Services, Secretaries, Grounds, Maintenance, etc.
                    </p>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="EmpType" id="support" value="2">
                        <label class="form-check-label" for="support">
                            Support Staff Employees and Administrators
                        </label>
                    </div>
                </div>

                <div class="text-center">
                    <input type="submit" name="submitemptype" value="Submit" class="btn btn-primary">
                </div>
            </fieldset>

            <div class="text-center mt-3">
                <input type="submit" name="logout" value="Logout" class="btn btn-secondary">
            </div>
        </cfform>

    <cfelseif #Form.Action# eq "View">
        <cflocation url="index.cfm?StepNum=3&#urlencodedformat(NOW())#">
    </cfif>
<!--- View Existing Requests --->
<cfelseif StepNum eq 3>
	<cfinclude template="logout.cfm">

    <!--- Get a list of Requests the user has entered --->
    <cfquery name="GetRequests" datasource="mesa_web">
        SELECT	RequestID, userid, requesteddates, requesttype, approved, dtFrom, dtTo
        FROM	LeaveReq_tblRequest
        WHERE	userid = '#Session.Username#' AND yearofrequest = '2024-2025'
        ORDER BY approved, requesteddates
    </cfquery>

    <table class="table table-bordered table-striped table-hover" style="width: 100%;" summary="Table listing submitted leave requests for the 2024-2025 school year.">
        <caption class="visually-hidden">Leave Requests Entered Into the System</caption>
        <thead class="table-success">
            <tr>
                <th scope="col">Request ID (click to view)</th>
                <th scope="col">User Name</th>
                <th scope="col">Dates From-To</th>
                <th scope="col">Leave Type</th>
                <th scope="col">Status</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="GetRequests">
                <tr>
                    <td>
                        <a href="index.cfm?StepNum=5&requestID=#RequestID#"
                        aria-label="View details for request ID #RequestID#">#RequestID#</a>
                    </td>
                    <td>#userid#</td>
                    <td>#LSDateFormat(dtFrom,'mm/dd/yyyy')# - #LSDateFormat(dtTo,'mm/dd/yyyy')#</td>
                    <td>
                        <cfset leaveTypes = [
                            "", "Bereavement", "Jury/Witness", "Officiating/Judging", "Community Service",
                            "", "Leave without Pay", "FMLA own serious health condition",
                            "FMLA care for immediate family member", "Day or Personal Leave",
                            "Vacation", "FMLA Military Exigency Leave",
                            "FMLA Military Caregiver Leave", "Sick Leave", "Military Leave"
                        ]>
                        #leaveTypes[Val(requesttype)]#
                    </td>
                    <td>
                        <cfif approved eq 'A'>
                            Approved
                        <cfelseif approved eq 'D'>
                            Denied
                        <cfelse>
                            Pending
                        </cfif>
                    </td>
                </tr>
            </cfoutput>
        </tbody>
    </table>

<!--- Enter New Request --->
<cfelseif StepNum eq 4>
	<cfinclude template="logout.cfm">
	
    <cfif isdefined('form.submitemptype')>
		<cfset Session.EmpType = '#Form.EmpType#'>
    </cfif>

    <!--- Leave Request Form --->
    <cfform 
        name="LeaveReqForm" 
        action="index.cfm?StepNum=997&#urlencodedformat(NOW())#" 
        method="post" 
        class="needs-validation" 
        role="form" 
        novalidate
    >

            <!--- Name, ID, Building, Requesting Dates is the same for all types of Staff --->
            
            <!--- Display Error Message (if errcode = 1) --->
            <cfif isdefined('errcode') AND errcode EQ 1>
                <div class="alert alert-danger" role="alert">
                    <h3 class="h5">You Must Enter a Bereavement Relationship</h3>
                    <p>Make sure to select the type of leave.</p>
                </div>
            </cfif>

            <!-- Begin Bootstrap Grid -->
            <!--- <div class="row g-3 mb-4 p-3 rounded">
                <div>
                    <label class="form-label fw-bold">Date:</label>
                    <span><cfoutput>#LSDateFormat(NOW(),'mm/dd/yyyy')#</cfoutput></span>
                </div>
            </div> --->

            <div class="row g-3 mb-4 border p-3 rounded">
                <!-- Name -->
                <div class="col-md-6">
                    <label for="EmpName" class="form-label fw-bold">Name</label>
                    <cfoutput>
                        <cfinput 
                            type="text" 
                            name="EmpName" 
                            id="EmpName"
                            class="form-control"
                            value="#Session.FullName#" 
                            required="yes">
                    </cfoutput>
                </div>

                <!-- ID Number -->
                <div class="col-md-3">
                    <label for="EmpID" class="form-label fw-bold">ID#</label>
                    <cfquery name="GetID" datasource="accounts">
                        SELECT EmpID
                        FROM accounts
                        WHERE Username = '#Session.Username#'
                    </cfquery>
                    <cfoutput>
                        <cfinput 
                            type="text" 
                            name="EmpID" 
                            id="EmpID"
                            class="form-control"
                            value="#GetID.EmpID#" 
                            required="yes">
                    </cfoutput>
                </div>

                <!-- School -->
                <div class="col-md-3">
                    <label for="EmpBuilding" class="form-label fw-bold">School</label>
                    <cfoutput>
                        <cfinput 
                            type="text" 
                            name="EmpBuilding" 
                            id="EmpBuilding"
                            class="form-control"
                            value="#Session.Building#" 
                            required="yes">
                    </cfoutput>
                </div>
            </div>

            <!--- SECOND ROW --->
            <div class="row g-3 mb-4 border p-3 rounded">
                <!-- From Date -->
                <div class="col-md-4">
                    <label for="ReqDateFrom" class="form-label fw-bold">Dates Requested: From (use date picker)</label>
                    <div class="form-text">Select the first day of your leave</div>
                    <input
                    type="date"
                    id="ReqDateFrom"
                    name="ReqDateFrom"
                    class="form-control"
                    <cfif isdefined('Session.ReqDateFrom')>value="<cfoutput>#Session.ReqDateFrom#</cfoutput>"</cfif>
                    required
                    />
                </div>

                <!-- To Date -->
                <div class="col-md-4">
                    <label for="ReqDateTo" class="form-label fw-bold">To (use date picker)</label>
                    <div class="form-text">Select the last day of your leave</div>
                    <input
                    type="date"
                    id="ReqDateTo"
                    name="ReqDateTo"
                    class="form-control"
                    <cfif isdefined('Session.ReqDateTo')>value="<cfoutput>#Session.ReqDateTo#</cfoutput>"</cfif>
                    required
                    />
                </div>

                <!-- Number of Days -->
                <div class="col-md-4">
                    <label for="ReqNumDays" class="form-label fw-bold">Number of Days Requested:</label>
                    <div class="form-text">(If less than 1 day, put hours in comments to HR)</div>
                    <input
                    type="text"
                    id="ReqNumDays"
                    name="ReqNumDays"
                    class="form-control"
                    <cfif isdefined('Session.ReqNumDays')>value="<cfoutput>#Session.ReqNumDays#</cfoutput>"</cfif>
                    required
                    />
                </div>
            </div>

            
            <cfif Session.EmpType eq 1>
                <fieldset role="radiogroup" aria-labelledby="leaveOptions1Label" class="mb-4 border p-3 rounded">
                    <legend id="leaveOptions1Label" class="form-label fw-bold">Select Leave Type for Certified Employees:</legend>
                    <div class="row  g-3 mb-4 border p-3 rounded">
                        <div class="col-md-6">
                            <!-- Day Leave -->
                            <div class="form-check mb-2">
                                <cfset checked_9 = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 9) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_9" name="LeaveType" value="9" required <cfoutput>#checked_9#</cfoutput>>
                                <label class="form-check-label" for="LeaveType_9">
                                    <strong>Day Leave Section 9.1</strong><br>
                                    <em>This leave may not be used for vacation or job interviews. Must provide comments to HR if taking 3 or more consecutive days or a blackout day*</em>
                                </label>
                            </div>
                            <cfif isDefined("Session.dayleavereason")>
                                <input type="hidden" name="dayleavereason" value="<cfoutput>#htmlEditFormat(Session.dayleavereason)#</cfoutput>">
                            <cfelse>
                                <input type="hidden" name="dayleavereason" value="">
                            </cfif>
                            
                            <!-- Military Leave -->
                            <div class="form-check mb-2">
                                <cfset checked_14 = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 14) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_14" name="LeaveType" value="14" required <cfoutput>#checked_14#</cfoutput>>
                                <label class="form-check-label" for="LeaveType_14">
                                    <strong>Military Leave 8.4</strong><br>
                                    <em>(documentation required)</em>
                                </label>
                            </div>

                            <!-- Leave without Pay -->
                            <div class="form-check mb-2">
                                <cfset checked_6 = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 6) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_6" name="LeaveType" value="6" required <cfoutput>#checked_6#</cfoutput>>
                                <label class="form-check-label" for="LeaveType_6">
                                    <strong>Leave without Pay</strong>
                                </label>
                            </div>
                        </div>

                        <div class="col-md-6 p-3 rounded">
                            <!-- Bereavement Section -->
                            <div class="form-check mb-2">
                                <cfset checked_1 = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 1) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_1" name="LeaveType" value="1" required <cfoutput>#checked_1#</cfoutput>>
                                <label class="form-check-label" for="LeaveType_1">
                                    <strong>Bereavement Section</strong>
                                </label>
                                <em class="form-text ms-4">Immediate family members**</em>

                                <!-- Hidden Label for Accessibility -->
                                <label for="bereavementrelationship" class="visually-hidden">Relationship of deceased</label>

                                <cfif isDefined("Session.bereavementrelationship")>
                                    <input
                                        type="text"
                                        id="bereavementrelationship"
                                        name="bereavementrelationship"
                                        class="form-control mt-1 ms-4"
                                        size="20"
                                        maxlength="50"
                                        value="<cfoutput>#htmlEditFormat(Session.bereavementrelationship)#</cfoutput>">
                                <cfelse>
                                    <input
                                        type="text"
                                        id="bereavementrelationship"
                                        name="bereavementrelationship"
                                        class="form-control mt-1 ms-4"
                                        size="20"
                                        maxlength="50">
                                </cfif>
                            </div>


                            <!-- Community Service Section -->
                            <div class="form-check mb-2">
                                <cfset checked_4 = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 4) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_4" name="LeaveType" value="4" required <cfoutput>#checked_4#</cfoutput>>
                                <label class="form-check-label" for="LeaveType_4">
                                    <strong>Community Service Section 9.4</strong>
                                </label>
                                <em class="form-text ms-4">(preapproval and documentation required)</em>
                            </div>

                            <!-- Officiating/Judging Section -->
                            <div class="form-check mb-2">
                                <cfset checked_3 = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 3) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_3" name="LeaveType" value="3" required <cfoutput>#checked_3#</cfoutput>>
                                <label class="form-check-label" for="LeaveType_3">
                                    <strong>Officiating/Judging Section 9.5</strong>
                                </label>
                                <em class="form-text ms-4">(documentation required)</em>
                            </div>

                            <!-- Jury/Witness Section -->
                            <div class="form-check mb-2">
                                <cfset checked_2 = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 2) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_2" name="LeaveType" value="2" required <cfoutput>#checked_2#</cfoutput>>
                                <label class="form-check-label" for="LeaveType_2">
                                    <strong>Jury/Witness Section 9.7-8</strong>
                                </label>
                                <em class="form-text ms-4">(documentation required)</em>
                            </div>
                        </div>
                    </div>
                </fieldset>

                <div class="row g-3 mb-4 border p-3 rounded">
                    <div class="col-12 d-flex align-items-center">
                        <label for="subfindernum" class="form-label fw-bold me-2 mb-0">
                            Reported Aesop/Frontline Job #:
                        </label>
                        <cfif isDefined("Session.subfinderid")>
                            <input
                                type="text"
                                id="subfindernum"
                                name="subfindernum"
                                class="form-control w-auto"
                                required
                                validate="integer"
                                message="Aesop/Frontline Job number must be entered and it must be numeric"
                                value="<cfoutput>#htmlEditFormat(Session.subfinderid)#</cfoutput>"
                                aria-describedby="subfinderHelp"
                            >
                        <cfelse>
                            <input
                                type="text"
                                id="subfindernum"
                                name="subfindernum"
                                class="form-control w-auto"
                                required
                                validate="integer"
                                message="Aesop/Frontline Job number must be entered and it must be numeric"
                                aria-describedby="subfinderHelp"
                            >
                        </cfif>
                        <span id="subfinderHelp" class="visually-hidden">
                            Must be a numeric job number from Aesop/Frontline.
                        </span>
                    </div>
                </div>


            <cfelse>
                <fieldset role="radiogroup" aria-labelledby="leaveOptions2Label" class="mb-4 border p-3 rounded">
                    <legend id="leaveOptions2Label" class="form-label fw-bold">Select Leave Type for Classified Employees:</legend>
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <strong>Personal</strong>***<br />
                            <div class="form-check mb-2">
                                
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 9) ? 'checked' : ''>
                                <input 
                                    type="radio" 
                                    class="form-check-input" 
                                    id="LeaveType_9" 
                                    name="LeaveType" 
                                    value="9" 
                                    required 
                                    #checked#
                                >
                                <label class="form-check-label" for="LeaveType_9">
                                    <strong>Personal Leave</strong>***
                                </label>
                                <em class="form-text ms-4">
                                    This leave may not be used for vacation or job interviews. Must provide reason in comments to HR if taking 3 or more consecutive days or a blackout day*
                                </em>
                                <cfif isDefined("Session.dayleavereason")>
                                    <cfinput type="hidden" name="dayleavereason" value="<cfoutput>#Session.dayleavereason#</cfoutput>">
                                <cfelse>
                                    <cfinput type="hidden" name="dayleavereason">
                                </cfif>
                            </div>

                            <!-- Sick Leave -->
                            <div class="form-check mb-2">
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 13) ? 'checked' : ''>
                                <input 
                                    type="radio" 
                                    class="form-check-input" 
                                    id="LeaveType_13" 
                                    name="LeaveType" 
                                    value="13" 
                                    required 
                                    #checked#
                                >
                                <label class="form-check-label" for="LeaveType_13">
                                    <strong>Sick Leave</strong>
                                </label>
                                <em class="form-text ms-4">(If applicable FMLA will be followed)</em>
                            </div>

                            <!-- Leave without Pay -->
                            <div class="form-check mb-2">
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 6) ? 'checked' : ''>
                                <input 
                                    type="radio" 
                                    class="form-check-input" 
                                    id="LeaveType_6" 
                                    name="LeaveType" 
                                    value="6" 
                                    required 
                                    #checked#
                                >
                                <label class="form-check-label" for="LeaveType_6">
                                    <strong>Leave without Pay</strong>
                                </label>
                            </div>
                            
                            <!-- Vacation -->
                            <div class="form-check mb-2">
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 10) ? 'checked' : ''>
                                <input 
                                    type="radio" 
                                    class="form-check-input" 
                                    id="LeaveType_10" 
                                    name="LeaveType" 
                                    value="10" 
                                    required 
                                    #checked#
                                >
                                <label class="form-check-label" for="LeaveType_10">
                                    <strong>Vacation (YEAR-ROUND EMPLOYEES ONLY)</strong>
                                </label>
                            </div>
                            <div class="form-check mb-3">
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 2) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_2" name="LeaveType" value="2" required #checked#>
                                <label class="form-check-label" for="LeaveType_2">
                                    <strong>Jury/Witness</strong>
                                </label>
                                <em class="form-text ms-4">(Documentation required)</em>
                            </div>
                            <!-- FMLA - Own Serious Health Condition -->
                            <!--- <div class="form-check mb-2">
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 7) ? 'checked' : ''>
                                <input 
                                    type="radio" 
                                    class="form-check-input" 
                                    id="LeaveType_7" 
                                    name="LeaveType" 
                                    value="7" 
                                    required 
                                    #checked#
                                >
                                <label class="form-check-label" for="LeaveType_7">
                                    <strong>FMLA - Own Serious Health Condition</strong>
                                </label>
                                <em class="form-text ms-4">(if more than 11 consecutive days)</em>
                            </div>
                            <div class="form-check mb-2">
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 8) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_8" name="LeaveType" value="8" required #checked#>
                                <label class="form-check-label" for="LeaveType_8">
                                    <strong>FMLA - Care for Immediate Family Member</strong>
                                </label>
                                <em class="form-text ms-4">(serious health condition, if more than 11 consecutive days)</em>
                            </div>

                            <div class="form-check mb-2">
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 8) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_8" name="LeaveType" value="8" required #checked#>
                                <label class="form-check-label" for="LeaveType_8">
                                    <strong>FMLA - Care for Immediate Family Member</strong>
                                </label>
                                <em class="form-text ms-4">(serious health condition, if more than 11 consecutive days)</em>
                            </div>
                            
                            <!-- FMLA Military Exigency Leave -->
                            <div class="form-check mb-2">
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 11) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_11" name="LeaveType" value="11" required #checked#>
                                <label class="form-check-label" for="LeaveType_11">
                                    <strong>FMLA - Military Exigency Leave</strong>
                                </label>
                            </div>

                            <!-- FMLA Military Caregiver Leave -->
                            <div class="form-check mb-2">
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 12) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_12" name="LeaveType" value="12" required #checked#>
                                <label class="form-check-label" for="LeaveType_12">
                                    <strong>FMLA - Military Caregiver Leave</strong>
                                </label>
                            </div> --->

                        
                        </div>

                        <div class="col-md-6">
                            <div class="form-check mb-3">
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 1) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_1" name="LeaveType" value="1" required #checked#>
                                <label class="form-check-label" for="LeaveType_1">
                                    <strong>Bereavement</strong>
                                </label>
                                <div class="ms-4">
                                    <em>(Immediate Family Members**)</em>
                                    <div class="mt-1">
                                        <label for="bereavementrelationship" class="form-label visually-hidden">Relationship</label>
                                        <input 
                                            type="text" 
                                            class="form-control form-control-sm w-auto d-inline-block" 
                                            id="bereavementrelationship" 
                                            name="bereavementrelationship" 
                                            size="20" 
                                            maxlength="50"
                                            <cfif isDefined("Session.bereavementrelationship")>
                                                value="#Session.bereavementrelationship#"
                                            </cfif>
                                        >
                                    </div>
                                </div>
                            </div>
                            <div class="form-check mb-3">
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 4) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_4" name="LeaveType" value="4" required #checked#>
                                <label class="form-check-label" for="LeaveType_4">
                                    <strong>Community Service</strong>
                                </label>
                                <em class="form-text ms-4">(Preapproval &amp; documentation required)</em>
                            </div>
                            <div class="form-check mb-3">
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 3) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_3" name="LeaveType" value="3" required #checked#>
                                <label class="form-check-label" for="LeaveType_3">
                                    <strong>Officiating/Judging</strong>
                                </label>
                                <em class="form-text ms-4">(Documentation required)</em>
                            </div>
                            <div class="form-check mb-3">
                                <cfset checked = (isDefined("Session.LeaveType") AND Session.LeaveType EQ 14) ? 'checked' : ''>
                                <input type="radio" class="form-check-input" id="LeaveType_14" name="LeaveType" value="14" required #checked#>
                                <label class="form-check-label" for="LeaveType_14">
                                    <strong>Military Leave</strong> (Documentation Required)
                                </label>
                            </div>
                        </div>
                    </div>
                </fieldset>
            </cfif>

            <div class="row g-3 mb-4 border p-3 rounded">
                <div class="mb-3">
                    <label for="comments" class="form-label fw-bold">Comments to HR:</label>
                    <cfif isdefined('Session.CommentsTo')>
                        <cftextarea 
                        id="comments" 
                        name="comments" 
                        class="form-control" 
                        rows="4"><cfoutput>#htmlEditFormat(Session.CommentsTo)#</cfoutput></cftextarea>
                    <cfelse>
                        <textarea id="comments" name="comments" class="form-control" rows="4"></textarea>
                    </cfif>
                </div>
            </div>


            <div class="row g-3 mb-4 border p-3 rounded align-items-center">
                <!-- Signature Input -->
                <div class="col-md-6">
                    <label for="EmpSig" class="form-label fw-bold">Employee Signature (type in name):</label>
                    <cfif isdefined('Session.EmpSig')>
                        <input
                            type="text"
                            id="EmpSig"
                            name="EmpSig"
                            class="form-control"
                            required
                            maxlength="50"
                            aria-describedby="EmpSigHelp"
                            value="<cfoutput>#htmlEditFormat(Session.EmpSig)#</cfoutput>"
                            placeholder="Enter your name as you would sign ex: John Q. Smith"
                        >
                    <cfelse>
                        <input
                            type="text"
                            id="EmpSig"
                            name="EmpSig"
                            class="form-control"
                            required
                            maxlength="50"
                            aria-describedby="EmpSigHelp"
                            placeholder="Enter your name as you would sign ex: John Q. Smith"
                        >
                    </cfif>
                    <div id="EmpSigHelp" class="form-text">Required</div>
                </div>

                <!-- Display-Only Date -->
               <div class="col-md-6 d-flex flex-column justify-content-end mt-0">
                    <p id="signedDateLabel" class="fw-bold mb-1">Date Signed:</p>
                    <p class="form-control-plaintext mb-0" aria-labelledby="signedDateLabel">
                        <cfoutput>#LSDateFormat(NOW(), 'mm/dd/yyyy')#</cfoutput>
                    </p>
                </div>
            </div>



            <div class="row g-3 mb-4 border p-3 rounded">
                <div class="mb-3">
                    <label for="SupEmail" class="form-label fw-bold">
                        Enter Supervisor's Email address <strong>(you must search for email address)</strong>:
                    </label>
                    <div class="row g-2 align-items-center">
                        <div class="col-md-9">
                        <cfif isdefined('Session.SupEmail')>
                            <input type="text" id="SupEmail" name="SupEmail" class="form-control" value="<cfoutput>#htmlEditFormat(Session.SupEmail)#</cfoutput>" readonly>
                        <cfelse>
                            <input type="text" id="SupEmail" name="SupEmail" class="form-control" readonly>
                        </cfif>
                        </div>
                        <div class="col-md-3">
                        <button type="submit" name="SearchSup" class="btn btn-primary w-100">Search for Email</button>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="SupEmail2" class="form-label fw-bold">
                        Enter Secretary or Secondary Supervisor's Email address <strong>(you must search for email address)</strong>:
                    </label>
                    <div class="row g-2 align-items-center">
                        <div class="col-md-9">
                        <cfif isdefined('Session.SupEmail2')>
                            <input type="text" id="SupEmail2" name="SupEmail2" class="form-control" value="<cfoutput>#htmlEditFormat(Session.SupEmail2)#</cfoutput>" readonly>
                        <cfelse>
                            <input type="text" id="SupEmail2" name="SupEmail2" class="form-control" readonly>
                        </cfif>
                        </div>
                        <div class="col-md-3">
                        <button type="submit" name="SearchSup2" class="btn btn-primary w-100">Search for Email</button>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="mt-4 mb-5">
                <div class="text-center mb-3">
                    <button type="submit" name="Submit" class="btn btn-primary">Submit</button>
                </div>

                <div>
                    <strong><span class="fw-bold">Definitions:</span></strong><br />
                    <strong>*Blackout day:</strong> The day immediately preceding and/or following a vacation period as defined on the adopted District Calendar or the first or last student contact days.<br /><br />
                    <strong>**Immediate Family Member:</strong> father, father-in-law, step-father, mother, mother-in-law, step-mother, grandparents, grandchild, sister, sister-in-law, step-sister, brother, brother-in-law, step-brother, son-in-law, daughter-in-law, husband, wife, child, stepchild, or individual living in household.<br /><br />

                    <cfif Session.EmpType eq 2>
                        <strong>***Personal Leave:</strong> Full-time employees may be granted personal leave as follows:
                        <ul>
                            <li>Year-Round employees may use three (3) days of sick leave per fiscal year, beginning July 1st, for the purpose of conducting personal business.</li>
                            <li>Employees who are not year-round may use six (6) days of sick leave per fiscal year, beginning July 1st, for the purpose of conducting personal business.</li>
                            <li>Personal leave is charged against accrued sick leave, and is not accumulative from contract year-to-year.</li>
                        </ul>
                        <br /><br />
                        Click on the following to view the full Leaves and Absences Policies:<br />
                        <ul>
                            <li><a href="https://www.mesa.k12.co.us/board/policies/documents/gdc.pdf" target="_blank" rel="noopener noreferrer">Support Staff</a></li>
                            <li><a href="https://www.mesa.k12.co.us/board/policies/documents/gcd.pdf" target="_blank" rel="noopener noreferrer">Administrators</a></li>
                        </ul>
                    </cfif>
                </div>

                <cfif Session.EmpType eq 1>
                    <div class="mt-4">
                        <p><strong>Employees covered under MVEA</strong><br />
                        Day leave may be used for sick leave of the employee, to attend to the illness of immediate family, emergency, and personal business for the employee. In the event an employee is requesting 3 consecutive days or more of leave, he/she must submit a &quot;Request and approval for Leave&quot; form as soon as possible to his/her administrator(s). The form will contain an affirmation that the leave will not be used for vacation or job interviews. <strong>Days immediately preceding and/or following vacation periods and the first and last student contact days are not usable for day leave excepting in case of illness or if there are extenuating circumstances.</strong></p>

                        <p>For more information on available leave options please see joint MVEA Agreement section 9</p>

                        <p>In the event an Employee Leave Request is denied, the Covered Employee may file an appeal.&nbsp; The appeal must be submitted in writing to the Human Resources Department no later than 30 calendar days after the date of the leave and shall include a statement as to why the leave should be approved. The Employee Leave Request Appeals Panel shall consist of representation from MVEA, Human Resources and administration. The following criteria will be reviewed and taken into consideration by the Employee Leave Request Appeal Panel:</p>

                        <ol>
                            <li>Day Leave Usage History</li>
                            <li>Reason for the Request</li>
                            <li>Covered Employee Provided Statement</li>
                            <li>Any additional information as requested by the panel</li>
                        </ol>
                    </div>
                </cfif>
            </div>

        <div class="mt-4">
            <button type="submit" name="logout" class="btn btn-secondary">Logout</button>
        </div>
    </cfform>   

<!--- View Specific Request --->
<cfelseif StepNum eq 5>    
    <cfquery name="GetRequestData" datasource="mesa_web">
        SELECT *
        FROM LeaveReq_tblRequest
        WHERE RequestID = <cfqueryparam value="#RequestID#" cfsqltype="cf_sql_integer">
        AND userid = <cfqueryparam value="#Session.Username#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfoutput query="GetRequestData">
        <cfset leaveTypes = [
            "", "Bereavement", "Jury/Witness", "Officiating/Judging", "Community Service",
            "", "Leave without Pay", "FMLA own serious health condition",
            "FMLA care for immediate family member with a serious health condition", "Day or Personal Leave",
            "Vacation", "FMLA Military Exigency Leave", "FMLA Military Caregiver Leave",
            "Sick Leave", "Military Leave"
        ]>

        <table class="table table-bordered table-striped" width="100%" summary="Details of Leave Request ID #RequestID#">
            <caption class="visually-hidden">Details of Leave Request ID #RequestID#</caption>
            <thead class="table-success">
                <tr>
                    <th colspan="6" scope="colgroup" class="text-center">Leave Request ##: #RequestID#</th>
                </tr>
                <tr>
                    <th scope="col">Dates of Request</th>
                    <th scope="col">Type of Leave</th>
                    <th scope="col">Sub Needed / Aesop</th>
                    <th scope="col">Supervisor</th>
                    <th scope="col">Viewed by Supervisor</th>
                    <th scope="col">HR Approval Status</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>#LSDateFormat(dtFrom, 'mm/dd/yyyy')# - #LSDateFormat(dtTo, 'mm/dd/yyyy')#</td>
                    <td>#leaveTypes[Val(requesttype)]#</td>
                    <td>#subrequested# / #subfindernum#</td>
                    <td>#supervisor#</td>
                    <td>#supviewed#</td>
                    <td>
                        <cfif approved eq "A">
                            Approved
                        <cfelseif approved eq "D">
                            Denied
                        <cfelse>
                            Pending
                        </cfif>
                    </td>
                </tr>
            </tbody>
        </table>
    </cfoutput>

<!--- 6 = Attach file if Jury Duty or Community Service Selected --->
<cfelseif StepNum eq 6>
    <cfoutput>
        <cfif isDefined("fileUpload")>
            <cfif form.uploadfile neq 'mail'>
                <cffile action="upload"
                    fileField="fileUpload"
                    nameconflict="makeunique"
                    destination="C:\ColdFusion2021\cfusion\wwwroot\LeaveRequest\Attachments\">
                <div class="alert alert-success">Thank you, your file has been uploaded.</div>
            </cfif>

            <cfif form.uploadfile eq 'mail'>
                <cfset Session.FileName = 'mailing'>
            <cfelse>
                <cfset Session.FileName = "#cffile.serverFileName#.#cffile.serverFileExt#">
            </cfif>

            <cflocation url="index.cfm?StepNum=998">
        </cfif>
    </cfoutput>

    <form enctype="multipart/form-data" method="post" class="mt-4" aria-labelledby="uploadSection">
        <fieldset>
            <legend id="uploadSection" class="h5 mb-3">Submit Form</legend>

            <div class="form-check mb-2">
                <input class="form-check-input" type="radio" name="uploadfile" id="uploadOptionMail" value="mail" required>
                <label class="form-check-label" for="uploadOptionMail">Mail Form to Human Resources Office</label>
            </div>

            <div class="form-check mb-3">
                <input class="form-check-input" type="radio" name="uploadfile" id="uploadOptionAttach" value="attach" required>
                <label class="form-check-label" for="uploadOptionAttach">Upload File</label>
            </div>

            <div class="mb-3">
                <label for="fileUpload" class="form-label">Choose File to Upload</label>
                <input class="form-control" type="file" id="fileUpload" name="fileUpload" aria-describedby="fileHelp">
                <div id="fileHelp" class="form-text">Accepted formats: PDF, DOCX, etc.</div>
            </div>

            <button type="submit" class="btn btn-primary">Upload File or Continue</button>
        </fieldset>
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
    <a href="https://www.mesa.k12.co.us/apps/LeaveRequest/supervisornew.cfm">Click Here to Review Leave Request</a>	
</cfmail>

<cfif isdefined('Session.SupEmail2')>
<cfif #SEssion.SupEmail2# gt ''>
    <cfmail from="hr@d51schools.org" to="#Session.SupEmail2#" subject="Leave Request Form" type="html">
        #Session.EmpName# has made a Leave Request.  Click on the following link to review the request.<br />
        <a href="https://www.mesa.k12.co.us/apps/LeaveRequest/supervisornew.cfm">Click Here to Review Leave Request</a>	
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
	<cfscript>
        // Invalidate the session
        StructClear(Session);
        SessionInvalidate(); // Ends the session
    </cfscript>

    <cflocation url="index.cfm">
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