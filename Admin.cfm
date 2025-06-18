<cfapplication name="EmployeeLeaveRequest" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,8,0,0)#">
<!--- <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/fullpage.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
 --->
<!DOCTYPE html> 
<html lang="en">
 <head>
<!--- 	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
  <link rel="shortcut icon" href="/favicon.ico" />
	<link rel="stylesheet" type="text/css"  href="/css/text.css" />
   <link rel="stylesheet" type="text/css"  href="/css/main.css" />
   <!--[if lte IE 6]><link rel="stylesheet" type="text/css" href="/css/olderIESupport.css" />
<![endif]-->
	<link rel="stylesheet" type="text/css"  href="/css/print.css" media="print" />
 <script src="/scripts/main.js" type="text/javascript"></script>
	<script src="/SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
	<link href="/SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" /> --->
	
	<!-- InstanceBeginEditable name="doctitle" -->
		<title>Leave Request Admin</title>
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
    		<h1 class="text-center display-5 fw-bold my-4">Leave Request - Admin Page</h1>
				 <!-- InstanceBeginEditable name="Content" -->
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
        
<!--- <cfif (cgi.https eq "off") and 
	(cgi.SERVER_NAME does not contain "intranet")>
	<cflocation url="https://www.mesa.k12.co.us/apps/LeaveRequest/Admin.cfm" addtoken="no">
	<cfabort>
</cfif> --->

<cfif not isdefined('StepNum')>
	<cfset StepNum=0>
</cfif>

<cfif StepNum eq 0>
	<cfif not isdefined ('username')>
	You are not logged in or the program has been inactive for 20 minutes.<br />	
	</cfif>

<!--- User Login --->
<!--- <cfif not isdefined ('username') and not isdefined ('submitform')>
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
</cfif> --->

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
            <cflocation url="Admin.cfm?tryagain" addtoken="no">
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
                <cflocation url="Admin.cfm?StepNum=1&#urlencodedformat(NOW())#" addtoken="no">
            <cfelse>
            	<cflocation url="Admin.cfm?tryagain" addtoken="no">
            </cfif>
        </cfif>
    
    </cfif>
<cfelseif StepNum eq 1>
	<cfif isDefined('session.username')>
        <div class="container mt-4">
            <div class="row justify-content-center bg-light">
                <div class="col-md-6 col-lg-5 bg-light">
                    <div class="card shadow-sm">
                        <div class="card-header bg-success text-white text-center">
                            <h2 class="h4 mb-0" id="chooseActionHeading">Choose Action</h2>
                        </div>
                        <div class="card-body">
                            <cfform name="viewaction" method="post" action="admin.cfm?StepNum=2" aria-labelledby="chooseActionHeading">
                                <fieldset class="mb-3">
                                    <legend class="visually-hidden">Select an action to view leave requests</legend>
                                    <p class="mb-3">Select the type of leave requests you'd like to view:</p>

                                    <div class="form-check mb-2">
                                        <cfinput type="radio" name="view" value="1" id="viewAllRequests" class="form-check-input" checked>
                                        <label for="viewAllRequests" class="form-check-label">View All Requests (Pending, Approved, Denied)</label>
                                    </div>

                                    <div class="form-check mb-2">
                                        <cfinput type="radio" name="view" value="2" id="viewApprovedRequests" class="form-check-input">
                                        <label for="viewApprovedRequests" class="form-check-label">View Approved Requests</label>
                                    </div>

                                    <div class="form-check mb-3">
                                        <cfinput type="radio" name="view" value="3" id="viewDeniedRequests" class="form-check-input">
                                        <label for="viewDeniedRequests" class="form-check-label">View Denied Requests</label>
                                    </div>
                                </fieldset>

                                <div class="d-grid">
                                    <cfinput type="submit" name="submit" value="Continue" class="btn btn-primary btn-lg">
                                </div>
                            </cfform>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <cfinclude template="Logout_admin.cfm">
    </cfif>
<!--- Stepnum eq 2 - Redirect to Appropriate Area --->    
<cfelseif StepNum eq 2>
	<cfif isdefined('form.view')>
		<cfif #Form.view# eq 1>
            <cflocation url="admin.cfm?StepNum=10">
        <cfelseif #Form.view# eq 2>
            <cflocation url="admin.cfm?StepNum=20">
        <cfelseif #Form.view# eq 3>
            <cflocation url="admin.cfm?StepNum=30">
        </cfif>
    <cfelseif isdefined('view')>
    	<cfif #view# eq 1>
    		<cflocation url="admin.cfm?StepNum=10">
        </cfif>
    </cfif>

<!--- Stepnum eq 10 - View Pending --->
<cfelseif StepNum eq 10>
	<cfset GoToStepNum = 1>
	<!--- Get LIst of Pending Requests --->
    <cfset currentRequestYear = "2024-2025">

    <cfquery name="GetRequests" datasource="mesa_web">
        SELECT
            requestid,
            dateentered,
            requesteddates,
            requesttype,
            supviewed,
            supvieweddate,
            UserID,
            supervisor2,
            sup2viewed,
            sup2vieweddate,
            dtFrom,
            dtTo,
            NumDays,
            emptype,
            commentstohr, approved 
        FROM
            LeaveReq_tblRequest
        WHERE
            Approved IS NULL
            AND yearofrequest = <cfqueryparam value="#currentRequestYear#" cfsqltype="cf_sql_varchar">
            <cfif structKeyExists(session, 'username')>
                <cfif session.Username eq 'kubersox'>
                    AND emptype = 2
                <cfelseif session.Username eq 'oldmwilcox'>
                    AND emptype = 1
                </cfif>
            </cfif>
        ORDER BY
            emptype, Userid, dateentered
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
    
    <div class="container mt-4">
        <div class="card mb-4 shadow-sm">
            <div class="card-header bg-success text-white fw-bold">
                <h2 class="mb-0 fs-5">Pending Requests - Certified</h2>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-bordered mb-0" aria-describedby="certifiedPendingRequestsHeading">
                        <caption class="visually-hidden" id="certifiedPendingRequestsHeading">List of pending leave requests for certified employees.</caption>
                        <thead>
                            <tr>
                                <th scope="col">Request ID</th>
                                <th scope="col">Employee Name (ID)</th>
                                <th scope="col">Date Entered</th>
                                <th scope="col">Requested Date(s)</th>
                                <th scope="col">Request Type</th>
                                <th scope="col">Supervisor Viewed / Date</th>
                                <th scope="col">Supervisor 2 Viewed / Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfif GetPending_Cert.RecordCount GT 0>
                                <cfloop query="GetPending_Cert">
                                    <tr>
                                        <td><cfoutput><a href="Admin.cfm?StepNum=11&requestid=#URLEncodedFormat(requestid)#&userid=#URLEncodedFormat(UserID)#" aria-label="View details for request ID #requestid#">#requestid#</a></cfoutput></td>
                                        <td><cfoutput>#HtmlEditFormat(Full_Name)# (#HtmlEditFormat(EmpID)#)</cfoutput></td>
                                        <td><cfoutput>#LSDateFormat(dateentered,'mm/dd/yyyy')#</cfoutput></td>
                                        <td>
                                            <cfoutput>#HtmlEditFormat(RequestedDates)#<br>
                                            <span class="small text-muted">(#LSDateFormat(dtFrom,'mm/dd/yyyy')# - #LSDateFormat(dtTo,'mm/dd/yyyy')#)</cfoutput></span>
                                        </td>

                                        <!--- get leavetype --->
                                        <cfquery name="GetLeaveType" datasource="mesa_web">
                                            SELECT LeaveType
                                            FROM LeaveReq_tblLeaveType
                                            WHERE code = #requesttype#                                            
                                        </cfquery>

                                        <td><cfoutput>#HtmlEditFormat(GetLeaveType.LeaveType)#</cfoutput></td>
                                        <td><cfoutput>#HtmlEditFormat(supviewed)# / #LSDateFormat(supvieweddate,'mm/dd/yyyy')#</cfoutput></td>
                                        <td><cfoutput>#HtmlEditFormat(sup2viewed)# / #LSDateFormat(sup2vieweddate,'mm/dd/yyyy')#</cfoutput></td>
                                    </tr>
                                </cfloop>
                            <cfelse>
                                <tr>
                                    <td colspan="7" class="text-center p-3">
                                        <cfoutput>
                                            No pending certified requests found for <cfoutput>#currentRequestYear#</cfoutput>.
                                        </cfoutput>
                                    </td>
                                </tr>
                            </cfif>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container mt-4">
        <div class="card mb-4 shadow-sm">
            <div class="card-header bg-success text-white fw-bold"> <h2 class="mb-0 fs-5">Pending Requests - Classified</h2>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-bordered mb-0" aria-describedby="classifiedPendingRequestsHeading">
                        <caption class="visually-hidden" id="classifiedPendingRequestsHeading">List of pending leave requests for classified employees.</caption>
                        <thead>
                            <tr>
                                <th scope="col">Request ID</th>
                                <th scope="col">Employee Name (ID)</th>
                                <th scope="col">Date Entered</th>
                                <th scope="col">Requested Date(s)</th>
                                <th scope="col">Request Type</th>
                                <th scope="col">Supervisor Viewed / Date</th>
                                <th scope="col">Supervisor 2 Viewed / Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfif GetPending_Class.RecordCount GT 0>
                                <cfloop query="GetPending_Class">
                                    <tr>
                                        <td><cfoutput><a href="Admin.cfm?StepNum=11&requestid=#URLEncodedFormat(requestid)#&userid=#URLEncodedFormat(UserID)#" aria-label="View details for request ID #requestid#">#requestid#</a></cfoutput></td>
                                        <td><cfoutput>#HtmlEditFormat(Full_Name)# (#HtmlEditFormat(EmpID)#)</cfoutput></td> <td><cfoutput>#LSDateFormat(dateentered,'mm/dd/yyyy')#</cfoutput></td>
                                        <td>
                                            <cfoutput>#HtmlEditFormat(RequestedDates)#<br>
                                            <span class="small text-muted">(#LSDateFormat(dtFrom,'mm/dd/yyyy')# - #LSDateFormat(dtTo,'mm/dd/yyyy')#)</span></cfoutput>
                                        </td>

                                        <!--- get leavetype --->
                                        <cfquery name="GetLeaveType" datasource="mesa_web">
                                            SELECT LeaveType
                                            FROM LeaveReq_tblLeaveType
                                            WHERE code = #requesttype#                                            
                                        </cfquery>

                                        <td><cfoutput>#HtmlEditFormat(GetLeaveType.LeaveType)#</cfoutput></td>
                                        <td><cfoutput>#HtmlEditFormat(supviewed)# / #LSDateFormat(supvieweddate,'mm/dd/yyyy')#</cfoutput></td>
                                        <td><cfoutput>#HtmlEditFormat(sup2viewed)# / #LSDateFormat(sup2vieweddate,'mm/dd/yyyy')#</cfoutput></td>
                                    </tr>
                                </cfloop>
                            <cfelse>
                                <tr>
                                    <td colspan="7" class="text-center p-3">
                                        <cfoutput>
                                            No pending classified requests found.
                                        </cfoutput>
                                    </td>
                                </tr>
                            </cfif>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!--- <cfinclude template="Back_Admin.cfm">
    <cfinclude template="Logout_admin.cfm"> --->

    <div class="container mt-4 d-flex justify-content-between align-items-center">
        <cfform name="back" method="post" action="Admin.cfm?StepNum=#GoToStepNum#">
            <cfinput type="submit" name="back" value="Back" class="btn btn-secondary">
        </cfform>

        <cfform name="adminlogout" method="post" action="admin.cfm?StepNum=999">
            <cfinput type="submit" name="logout" value="Logout" class="btn btn-danger">
        </cfform>
    </div>
<!--- StepNum eq 11 - View and Approve Individual Request --->
<cfelseif StepNum eq 11>
	<cfform name="AppDenyReq" method="post" action="Admin.cfm?StepNum=12">
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
        
        
        <div class="card mb-3 shadow-sm mx-auto" style="max-width: 800px;">
            <div class="card-header bg-info text-dark fw-bold">
                <h2 class="mb-0 fs-5">Approved Days This Year: <span class="fw-bold">#HtmlEditFormat(GetDaysApp.DaysApp)#</span></h2>
            </div>
            <div class="card-body text-center py-3">
                <h3 class="fs-4 mb-0">Number of Days Approved this year: <span class="fw-bold">#HtmlEditFormat(GetDaysApp.DaysApp)#</span></h5>
            </div>
        </div>


        <div class="container mt-4">
            <div class="card-header bg-success text-white fw-bold">
                <h2 class="mb-0 fs-5">Pending Request for: #HtmlEditFormat(GetEmpInfo.Full_Name)#</h2>
            </div>
            
            <div class="card-body">
                <h3 class="fs-6 mb-2 text-success">Employee Information</h3>
                <div class="row mb-3 bg-light">
                    <div class="col-md-4">
                        <strong>Name:</strong> <span class="d-block">#HtmlEditFormat(GetEmpInfo.Full_Name)#</span>
                    </div>

                    <div class="col-md-4">
                        <strong>Emp ID:</strong> <span class="d-block">#HtmlEditFormat(GetEmpInfo.EmpID)#</span>
                    </div>
                    
                    <div class="col-md-4">
                        <strong>Building:</strong> <span class="d-block">
                            <cfif GetEmpInfo.Building eq 'columbus'>New Emerson<cfelse>#HtmlEditFormat(GetEmpInfo.Building)#</cfif>
                        </span>
                    </div>

                </div>

                <hr class="mt-4">
            </div>
            
                <!--- Request Information --->
        
            <h3 class="fs-6 mb-2 text-success">Request Details</h3>
            <div class="row mb-2 bg-light">
                <div class="col-md-6">
                    <strong>Request ID:</strong> <span class="d-block">#HtmlEditFormat(GetReqData.RequestID)#</span>
                </div>
                <div class="col-md-6">
                    <strong>Date Entered:</strong> <span class="d-block">#LSDateFormat(GetReqData.dateentered,'mm/dd/yyyy')#</span>
                </div>
            </div>
            <div class="row mb-3 bg-light">
                <div class="col-12">
                    <strong>Date(s) Requested:</strong> <span class="d-block">#HtmlEditFormat(GetReqData.RequestedDates)#</span>
                    <span class="d-block small text-muted">(#LSDateFormat(GetReqData.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetReqData.dtTo,'mm/dd/yyyy')#)</span>
                    <strong>Number of Days:</strong> <span class="d-block">#HtmlEditFormat(GetReqData.NumDays)#</span>
                </div>
            </div>

            <div class="row mb-3 bg-light">
                <div class="col-12">
                    <cfquery name="GetLeaveType" datasource="mesa_web">
                        SELECT LeaveType
                        FROM LeaveReq_tblLeaveType
                        WHERE code = <cfqueryparam value="#GetReqData.requesttype#" cfsqltype="CF_SQL_VARCHAR">
                    </cfquery>
                    <strong>Request Type:</strong> <span class="d-block">#HtmlEditFormat(GetLeaveType.LeaveType)#</span>
                    <cfif GetReqData.requesttype eq 1>
                        - <span class="d-block">#HtmlEditFormat(GetReqData.bereavementrelate)#</span>
                    <cfelseif GetReqData.requesttype eq 9>
                        Reason: <span class="d-block">#HtmlEditFormat(GetReqData.dayleavereason)#</span>
                    <cfelseif GetReqData.requesttype eq 2 OR GetReqData.Requesttype eq 4>
                        Attachment:
                        <cfif GetReqData.Attachment eq 'Mailing'>
                            Mailing Form
                        <cfelse>
                            <a href="./Attachments/#URLEncodedFormat(GetReqData.Attachment)#" target="_blank" aria-label="View attachment #HtmlEditFormat(GetReqData.Attachment)#">#HtmlEditFormat(GetReqData.Attachment)#</a>
                        </cfif>
                    </cfif>
                </div>
            </div>

            <div class="row mb-3 bg-light">
                <div class="col-12">
                    <cfif GetReqData.subfinderNum gt 0>
                        <strong>Subfinder Number:</strong> <span class="d-block">#HtmlEditFormat(GetReqData.subfinderNum)#</span>
                    <cfelse>
                        <strong>Sub Needed:</strong> <span class="d-block">#HtmlEditFormat(GetReqData.subrequested)#</span>
                    </cfif>
                </div>
            </div>

            <div class="row mb-3 bg-light">
                <div class="col-md-6">
                    <strong>Employee Signature:</strong> <span class="d-block">#HtmlEditFormat(GetReqData.signature)#</span>
                </div>
                <div class="col-md-6">
                    <strong>Date:</strong> <span class="d-block">#LSDateFormat(GetReqData.signaturedate,'mm/dd/yyyy')#</span>
                </div>
            </div>

            <div class="row mb-3 bg-light">
                <div class="col-md-6">
                    <strong>Principal/Supervisor:</strong> <span class="d-block">#HtmlEditFormat(GetReqData.supervisor)#</span>
                </div>
                <div class="col-md-6">
                    <strong>Supported/Reviewed:</strong> <span class="d-block">#HtmlEditFormat(GetReqData.supviewed)# on Date: #LSDateFormat(GetReqData.supvieweddate,'mm/dd/yyyy')#</span>
                    <strong>Comment:</strong> <span class="d-block">#HtmlEditFormat(GetReqData.supcomments)#</span>
                </div>
            </div>

            <div class="row mb-3 bg-light">
                <div class="col-md-6">
                    <strong>Principal/Supervisor 2:</strong> <span class="d-block">#HtmlEditFormat(GetReqData.supervisor2)#</span>
                </div>
                <div class="col-md-6">
                    <strong>Supported/Reviewed:</strong> <span class="d-block">#HtmlEditFormat(GetReqData.sup2viewed)# on Date: #LSDateFormat(GetReqData.sup2vieweddate,'mm/dd/yyyy')#</span>
                </div>
            </div>

            <div class="row mb-3 bg-light">
                <div class="col-12">
                    <strong>Comments To HR:</strong> <span class="d-block">#HtmlEditFormat(GetReqData.commentstohr)#</span>
                </div>
            </div>
            
                    <!--- Approve / Deny section --->
            <fieldset class="mb-3"> 
                <legend class="fs-6 mb-3 text-success">Approve / Deny Request</legend> 
                <div class="row mb-3 bg-light py-2">
                    <div class="col-12">
                        <div class="form-check form-check-inline">
                            <cfinput type="radio" name="app_deny" value="A" id="app_deny_A" checked="yes" class="form-check-input">
                            <label class="form-check-label" for="app_deny_A">Approved</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <cfinput type="radio" name="app_deny" value="P" id="app_deny_P" class="form-check-input">
                            <label class="form-check-label" for="app_deny_P">Pending</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <cfinput type="radio" name="app_deny" value="D" id="app_deny_D" class="form-check-input">
                            <label class="form-check-label" for="app_deny_D">Denied</label>
                        </div>
                    </div>
                </div>
            </fieldset>

            <div class="row mb-3 bg-light py-2"> 
                <div class="col-12">
                    <label for="appdays" class="form-label">If Approved, number of days approved for:</label>
                    <cfinput type="text" name="appdays" value="0" id="appdays" class="form-control" style="max-width: 150px;">
                </div>
            </div>

            <div class="row mb-3 bg-light py-2"> 
                <div class="col-12">
                    <label for="comments" class="form-label">Comments:</label>
                    <cftextarea name="comments" rows="4" cols="70" id="comments" class="form-control"></cftextarea>
                </div>
            </div>

            <div class="row mb-3 bg-light py-2"> 
                <div class="col-md-6">
                    <strong>Approved/Denied By:</strong> <span class="d-block">#HtmlEditFormat(Session.FullName)#</span>
                </div>
                <div class="col-md-6">
                    <strong>Date:</strong> <span class="d-block">#LSDateFormat(NOW(),'mm/dd/yyyy')#</span>
                </div>
            </div>


            <div class="row mb-3 bg-light py-2"> <div class="col-12">
                <cfif IsDefined("GetReqData.EmpType") AND GetReqData.RecordCount GT 0 AND GetReqData.EmpType eq 2>
                    <div class="form-check">
                        <cfinput type="checkbox" name="emailPayroll" value="true" id="emailPayroll" class="form-check-input">
                        <label class="form-check-label" for="emailPayroll">Send Email to Payroll</label>
                    </div>
                </cfif>
            </div>
        </div>

        <div class="d-flex justify-content-center gap-3 mt-4">
            <cfinput type="submit" name="submit" value="Submit" class="btn btn-success">
            <cfinput type="submit" name="Delete" value="Delete Request" class="btn btn-outline-danger">
        </div>
            </cfoutput>
        </cfform>
        <div class="container mt-4 d-flex justify-content-between align-items-center">
            <cfform name="back" method="post" action="Admin.cfm?StepNum=#GoToStepNum#">
                <cfinput type="submit" name="back" value="Back" class="btn btn-secondary">
            </cfform>

            <cfform name="adminlogout" method="post" action="admin.cfm?StepNum=999">
                <cfinput type="submit" name="logout" value="Logout" class="btn btn-danger">
            </cfform>
        </div>
    </div>
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
    	<cflocation url="Admin.cfm?StepNum=15">
    </cfif>
    <cflocation url="Admin.cfm?StepNum=13">
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
    <cflocation url="Admin.cfm?StepNum=14">
    
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
                <cfoutput><b>#GetReqInfo.comments#</b></cfoutput>
            </cfif>
        <cfelseif #GetReqInfo.approved# eq 'D'>
            Unfortunately, we are unable to approve your request for <cfoutput>#GetReqInfo.NumDays#</cfoutput> days off from <cfoutput>#LSDateFormat(GetReqInfo.dtFrom,'mm/dd/yyyy')#</cfoutput> to <cfoutput>#LSDateFormat(GetReqInfo.dtTo,'mm/dd/yyyy')#</cfoutput>.<br /><br />
            <cfoutput><b>#GetReqInfo.comments#</b></cfoutput><br /><br />
            We understand that this may be disappointing, and we apologize for any inconvenience it may cause.<br /><br />
            If you would like to appeal this decision, please complete the following <a href="https://resources.finalsite.net/images/v1728911194/mesak12cous/fv0qwpzabq6scr9ezacg/DayLeaveAppealRequestFormLicensedStaff.pdf">form</a> and follow the instructions provided.
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
    </cfif>
    
   	
    <cflocation url="Admin.cfm?StepNum=2&view=1">
<!--- StepNum eq 15 - Delete Requests --->
<cfelseif StepNum eq 15>
<cfform method="post" action="Admin.cfm?StepNum=998" format="html">
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

    <cfparam name="URL.currentPage" default="1">
    <cfparam name="recordsPerPage" default="20">
    <cfset startRow = ((URL.currentPage - 1) * recordsPerPage) + 1>
    
    <cfquery name="GetID" datasource="accounts">
        SELECT EmpID, Full_Name, Username, fname, lname
        FROM	accounts
    </cfquery>
    
    <cfquery name="GetApproved" dbtype="query" timeout="600">
        SELECT
            requestid, dateentered, requesteddates, requesttype, supviewed, supvieweddate,
            EmpID, Full_Name, Username, UserID, fname, lname, dtFrom, dtTo
        FROM GetAppRequests, GetID
        WHERE GetAppRequests.UserID = GetID.Username
        AND yearofrequest = '2024-2025'
        ORDER BY lname, fname, dateentered, requesteddates
    </cfquery>

    <!---- NEW QUERY TEST --->
    <cfset totalRecords = GetApproved.RecordCount>
    <cfset totalPages = Ceiling(totalRecords / recordsPerPage)>
    <cfset startRow = ((URL.currentPage - 1) * recordsPerPage) + 1>
    <cfset endRow = Min(startRow + recordsPerPage - 1, totalRecords)>

    <!--- END OF NEW QUERY --->

    <div class="card mb-3 shadow-sm mx-auto" style="max-width: 1200px;">
        <div class="card-header bg-success text-white fw-bold text-center">
            <h2 class="mb-0 fs-5">
                <cfif isDefined('a') AND a eq 1>Certified<cfelse>Classified</cfif> Approved Requests
            </h2>
        </div>
        <div class="card-body p-0"> 
            <div class="table-responsive"> 
                <table class="table table-striped table-hover table-bordered mb-0"> 
                    <thead class="table-light">
                        <tr>
                            <th scope="col">Request ID</th>
                            <th scope="col">User & Emp ID</th>
                            <th scope="col">Date Entered</th>
                            <th scope="col">Requested Date(s)</th>
                            <th scope="col">Request Type</th>
                            <th scope="col">Supervisor Viewed / Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="GetApproved">
                            <cfquery name="GetID" datasource="accounts">
                                SELECT EmpID
                                FROM accounts
                                WHERE Username = <cfqueryparam value="#GetApproved.userid#" cfsqltype="CF_SQL_VARCHAR">
                            </cfquery>
                            <cfquery name="GetLeaveType" datasource="mesa_web">
                                SELECT LeaveType
                                FROM LeaveReq_tblLeaveType
                                WHERE code = <cfqueryparam value="#GetApproved.requesttype#" cfsqltype="CF_SQL_VARCHAR">
                            </cfquery>

                            <tr>
                                <td>
                                    <a href="Admin.cfm?StepNum=21&requestid=#HtmlEditFormat(GetApproved.requestid)#&userid=#HtmlEditFormat(GetApproved.userid)#">
                                        #HtmlEditFormat(GetApproved.Requestid)#
                                    </a>
                                </td>
                                <td>#HtmlEditFormat(GetApproved.Full_Name)#, #HtmlEditFormat(GetID.EmpID)#</td>
                                <td>#LSDateFormat(GetApproved.dateentered,'mm/dd/yy')#</td>
                                <td>
                                    #HtmlEditFormat(GetApproved.requesteddates)#<br />
                                    <span class="small text-muted">From: #LSDateFormat(GetApproved.dtFrom,'mm/dd/yyyy')# - #LSDateFormat(GetApproved.dtTo,'mm/dd/yyyy')#</span>
                                </td>
                                <td>#HtmlEditFormat(GetLeaveType.LeaveType)#</td>
                                <td>#HtmlEditFormat(GetApproved.supviewed)# / #LSDateFormat(GetApproved.supvieweddate,'mm/dd/yyyy')#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        </div>
    </div>	
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
    
    <div class="card mb-3 shadow-sm mx-auto" style="max-width: 800px;">
        <div class="card-header bg-info text-dark fw-bold text-center">
            <h2 class="mb-0 fs-5">Approved Days This Year</h2>
        </div>
        <div class="card-body text-center py-3">
            <p class="mb-0 fs-4 fw-bold">Number of Days Approved this year: #HtmlEditFormat(GetDaysApp.DaysApp)#</p>
        </div>
    </div>

    <div class="card mb-4 shadow-sm mx-auto" style="max-width: 800px;"> 
        <div class="card-header bg-primary text-white fw-bold">
            <h2 class="mb-0 fs-5">Pending Request for: #HtmlEditFormat(GetEmpInfo.Full_Name)#</h2>
        </div>
        <div class="card-body">
            <h3 class="fs-6 mb-3 text-secondary">Employee Information</h3>
            <div class="row g-2 mb-0 bg-light py-2 px-3 border rounded">
                <div class="col-md-4">
                    <p class="mb-0"><strong>Name:</strong><br> #HtmlEditFormat(GetEmpInfo.Full_Name)#</p>
                </div>
                <div class="col-md-4">
                    <p class="mb-0"><strong>Emp ID:</strong><br> #HtmlEditFormat(GetEmpInfo.EmpID)#</p>
                </div>
                <div class="col-md-4">
                    <p class="mb-0"><strong>Building:</strong><br>
                        <cfif GetEmpInfo.Building eq 'columbus'>New Emerson<cfelse>#HtmlEditFormat(GetEmpInfo.Building)#</cfif>
                    </p>
                </div>
            </div>
        </div>
    </div>
            <!--- Request Information --->
    <div class="card mb-4 shadow-sm mx-auto" style="max-width: 800px;"> 
        <h3 class="fs-6 mb-3 text-secondary">Request Details</h3>
        <div class="row g-2 mb-4 bg-light py-2 px-3 border rounded">
            <div class="col-md-6">
                <p class="mb-0"><strong>Request ID:</strong> #HtmlEditFormat(GetReqData.RequestID)#</p>
            </div>
            <div class="col-md-6">
                <p class="mb-0"><strong>Date Entered:</strong> #LSDateFormat(GetReqData.dateentered,'mm/dd/yyyy')#</p>
            </div>
            <div class="col-12 mt-3"> <p class="mb-0"><strong>Date(s) Requested:</strong> #HtmlEditFormat(GetReqData.requesteddates)#</p>
                <p class="mb-0 small text-muted">From: #LSDateFormat(GetReqData.dtFrom,'mm/dd/yyyy')# - To: #LSDateFormat(GetReqData.dtTo,'mm/dd/yyyy')#</p>
            </div>
        </div>
    </div>

    <!--- Get Leave Type --->
    <cfquery name="GetLeaveType" datasource="mesa_web">
        SELECT	LeaveType
        FROM	LeaveReq_tblLeaveType
        WHERE	code = '#GetReqData.requesttype#'
    </cfquery>

    <div class="card mb-4 shadow-sm mx-auto" style="max-width: 800px;"> 
        <div class="col-12 mt-3">
            <p class="mb-0">
                <strong>Request Type:</strong> #HtmlEditFormat(GetLeaveType.LeaveType)#
                <cfif GetReqData.requesttype eq 1>
                    - #HtmlEditFormat(GetReqData.bereavementrelate)#
                </cfif>
            </p>
        </div>
    

        <div class="col-12 mt-3">
            <p class="mb-0">
                <cfif GetReqData.subfinderNum gt 0>
                    <strong>Subfinder Number:</strong> #HtmlEditFormat(GetReqData.subfinderNum)#
                <cfelse>
                    <strong>Sub Needed:</strong> #HtmlEditFormat(GetReqData.subrequested)#
                </cfif>
            </p>
        </div>

        <div class="col-md-6 mt-3">
            <p class="mb-0"><strong>Employee Signature:</strong> #HtmlEditFormat(GetReqData.signature)#</p>
        </div>
        <div class="col-md-6 mt-3">
            <p class="mb-0"><strong>Date:</strong> #LSDateFormat(GetReqData.signaturedate,'mm/dd/yyyy')#</p>
        </div>

        <div class="col-md-6 mt-3">
            <p class="mb-0"><strong>Principal/Supervisor:</strong> #HtmlEditFormat(GetReqData.supervisor)#</p>
        </div>
        <div class="col-md-6 mt-3">
            <p class="mb-0"><strong>Reviewed:</strong> #HtmlEditFormat(GetReqData.supviewed)#<br>
            <span class="small text-muted">Date Reviewed: #LSDateFormat(GetReqData.supvieweddate,'mm/dd/yyyy')#</span></p>
        </div>

        <div class="col-12 mt-3">
            <p class="mb-0"><strong>Comments to HR:</strong> #HtmlEditFormat(GetReqData.Commentstohr)#</p>
        </div>
    </div>

    <div class="card mb-4 shadow-sm mx-auto" style="max-width: 800px;"> 
        <h3 class="fs-6 mb-3 text-secondary">Approval Status</h3>
        <div class="row g-2 mb-4 bg-light py-2 px-3 border rounded">
            <div class="col-12">
                <p class="mb-0">
                    <strong>Status:</strong>
                    <cfif GetReqData.Approved eq 'A'>
                        <span class="badge bg-success fs-6">Approved</span>
                    <cfelseif GetReqData.Approved eq 'P'>
                        <span class="badge bg-warning text-dark fs-6">Pending</span>
                    <cfelse>
                        <span class="badge bg-danger fs-6">Denied</span>
                    </cfif>
                </p>
            </div>
            <div class="col-md-6 mt-3">
                <p class="mb-0"><strong>Approved By:</strong> #HtmlEditFormat(GetReqData.ApprovedUser)#</p>
            </div>
            <div class="col-md-6 mt-3">
                <p class="mb-0"><strong>On:</strong> #LSDateFormat(GetReqData.approvedDate,'mm/dd/yyyy')#</p>
            </div>
            <div class="col-12 mt-3">
                <p class="mb-0"><strong>Comments:</strong> #HtmlEditFormat(GetReqData.Comments)#</p>
            </div>
        </div>
    </div>

    </cfoutput>
    <div class="card mb-4 shadow-sm mx-auto t" style="max-width: 800px;">
        <div class="card-body"> 
            <div class="row g-2 bg-light"> 
                <div class="col-md-6">
                    <cfinclude template="Back_Admin.cfm">
                </div>
                <div class="col-md-6 text-end"> 
                    <cfinclude template="Logout_admin.cfm">
                </div>
            </div>
        </div> 
    </div>
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
                    <td><a href="Admin.cfm?StepNum=31&requestid=#GetDenied.requestid[i]#&userid=#GetDenied.userid[i]#">#GetDenied.Requestid[i]#</a></td>
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
<cflocation url="Admin.cfm?StepNum=10">
<!--- Logout --->
<cfelseif StepNum eq 999>
	<cfcookie name="CFID" expires="now">
	<cfcookie name="CFTOKEN" expires="now">
	<cfscript>
   		StructClear(Session);
	</cfscript>
	<cflocation url="Admin.cfm">
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