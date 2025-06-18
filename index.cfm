<cfapplication name="EmployeeLeaveRequest" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,2,0,0)#">
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
		<title>Leave Request Page</title>
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
                <h1 class="text-center display-5 fw-bold mb-4">Request and Approval for Leave</h1>
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
	    <h2>Welcome to the Leave Request Form.  Please Log in.</h2><br />	
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
        <fieldset class="border p-3 rounded bg-light mb-4">
            <legend class="fw-bold px-2 float-none w-auto visually-hidden">Select Action</legend>

            <div class="text-center mb-3 ">
                Select Action: Enter New Request or View Previous Request
            </div>

            <div class="d-flex flex-column align-items-center"> 
                <div class="form-check mb-2 shadow-sm d-inline-flex align-items-center ms-3"> 
                    <input type="radio" name="Action" value="New" id="newRequest" class="form-check-input" />
                    <label for="newRequest" class="form-check-label">Enter New Request</label>
                </div>

                <div class="form-check mb-4 shadow-sm d-inline-flex align-items-center ms-3"> 
                    <input type="radio" name="Action" value="View" id="viewRequest" class="form-check-input" />
                    <label for="viewRequest" class="form-check-label">View Previous Request</label>
                </div>
            </div>

            <div class="text-center mt-3 mb-4">
                <input type="submit" name="submitaction" value="Submit" class="btn btn-primary" />
            </div>

            <div class="col-12 text-end">
                <input type="submit" name="logout" value="Logout" class="btn btn-primary" />
            </div>
        </fieldset>
    </cfform>
    
<!--- Redirect to Appropriate Selection --->
<cfelseif StepNum eq 2>
	<cfinclude template="logout.cfm">

    <cfif Form.Action eq "New">
        <cfform name="SelectEmpType" action="index.cfm?StepNum=4&#urlencodedformat(NOW())#" method="post">
            <fieldset>
                <legend class="fw-bold px-2 float-none w-auto visually-hidden">Select Employee Type</legend>
                <div class="container border p-3 rounded bg-light"> 
                    <div class="row mb-3">
                        <div class="col-12 text-center bg-light">
                            <h2>Select Employee Type</h2> 
                        </div>
                    </div>

                    <div class="row mb-3 bg-light">
                        <div class="col-12">
                            <p class="mb-3">
                                Teachers, Nurses, Psychologists, Audiologists, Speech Language Pathologists, etc.
                            </p>
                            <div class="form-check mb-3"> 
                                <input type="radio" name="EmpType" value="1" id="certifiedEmp" class="form-check-input" />
                                <label for="certifiedEmp" class="form-check-label fw-bold">Certified Employees:</label>
                            </div>

                            <p class="mb-3">
                                All Administrators (including Principals), Paraprofessionals, Nutrition Services, Secretaries, Grounds, Maintenance, etc.
                            </p>
                            <div class="form-check mb-3"> 
                                <input type="radio" name="EmpType" value="2" id="supportStaffEmp" class="form-check-input" />
                                <label for="supportStaffEmp" class="form-check-label fw-bold">Support Staff Employees and Administrators:</label>
                            </div>
                        </div>
                    </div>

                    <div class="row mt-3 bg-light">
                        <div class="col-6 text-begin">
                            <input type="submit" name="submitemptype" value="Submit" class="btn btn-primary" />
                        </div>
                        <div class="col-6 text-end">
                            <input type="submit" name="logout" value="Logout" class="btn btn-primary" />
                        </div>
                    </div>
                </div>
            </fieldset>
        </cfform>
    <cfelseif Form.Action eq "View">
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
    
    <cfform name="SelectEmpType" action="index.cfm?StepNum=3&#urlencodedformat(NOW())#" method="post">
        <div class="container my-4"><!---  --->
            <h2 class="text-center mb-4">Leave Requests Entered Into the System</h2>

            <div class="row fw-bold border-bottom pb-2 mb-2 text-start bg-light py-2">
                <div class="col-md-3">Request ID (click to view request)</div>
                <div class="col-md-2">User Name</div>
                <div class="col-md-3">Dates From-To</div>
                <div class="col-md-2">Leave Type</div>
                <div class="col-md-2">Status</div>
            </div>

            <ul class="list-unstyled">
                <cfoutput query="GetRequests">
                    <li class="row border-bottom py-2 align-items-center bg-light">
                        <div class="col-md-3">
                            <a href="index.cfm?StepNum=5&requestID=#GetRequests.RequestID#" class="text-primary-emphasis">#RequestID#</a>
                        </div>
                        <div class="col-md-2">#userid#</div>
                        <div class="col-md-3">#LSDateFormat(dtFrom,'mm/dd/yyyy')#-#LSDateFormat(dtTo,'mm/dd/yyyy')#</div>
                        <div class="col-md-2">
                            <cfif #GetRequests.requesttype# eq 1>
                                Bereavement
                            <cfelseif #GetRequests.requesttype# eq 2>
                                Jury/Witness
                            <cfelseif #GetRequests.requesttype# eq 3>
                                Officiating/Judging
                            <cfelseif #GetRequests.requesttype# eq 4>
                                Community Service
                            <cfelseif #GetRequests.requesttype# eq 5>
                                <cfelseif #GetRequests.requesttype# eq 6>
                                Leave without Pay
                            <cfelseif #GetRequests.requesttype# eq 7>
                                FMLA own serious health condition
                            <cfelseif #GetRequests.requesttype# eq 8>
                                FMLA care for immediate family member with a serious health condition
                            <cfelseif #GetRequests.requesttype# eq 9>
                                Day or Personal Leave
                            <cfelseif #GetRequests.requesttype# eq 10>
                                Vacation
                            <cfelseif #GetRequests.requesttype# eq 11>
                                FMLA Military Exigency Leave
                            <cfelseif #GetRequests.requesttype# eq 12>
                                FMLA Military Caregiver Leave
                            <cfelseif #GetRequests.requesttype# eq 13>
                                Sick Leave
                            <cfelseif #GetRequests.requesttype# eq 14>
                                Military Leave
                            </cfif>
                        </div>
                        <div class="col-md-2">
                            <cfif #GetRequests.approved# eq 'A'>
                                Approved
                            <cfelseif #GetRequests.approved# eq 'D'>
                                Denied
                            <cfelse>
                                Pending
                            </cfif>
                        </div>
                    </li>
                </cfoutput>
            </ul>
            <div class="row mt-4 mb-3  bg-light"> 
                <div class="col-12 text-center"> 
                    <a href="index.cfm?StepNum=1" class="btn btn-secondary me-2">Back to Main</a>
                    <input type="submit" name="logout" value="Logout" class="btn btn-primary" />
                </div>
            </div>
        </div>
    </cfform>

<!--- Enter New Request --->
<cfelseif StepNum eq 4>
	<cfinclude template="logout.cfm">
	<cfif isdefined('form.submitemptype')>
		<cfset Session.EmpType = '#Form.EmpType#'>
    </cfif>
    <!--- Leave Request Form --->
    <cfform name="LeaveReqForm" action="index.cfm?StepNum=997&#urlencodedformat(NOW())#" method="post">
        <!--- Name, ID, Building, Requesting Dates is the same for all types of Staff --->
        <cfif isdefined('errcode')>
            <cfif errcode eq 1>
                <div class="row mb-3">
                    <div class="col-12">
                        <div class="alert alert-danger" role="alert">
                            <h5 class="alert-heading">You Must Enter a Bereavement Relationship</h5>
                            Make sure to select type of leave.
                        </div>
                    </div>
                </div>
            </cfif>
        </cfif>

        <div class="container mt-4">
        <div class="row mb-3 p-3 bg-light rounded">
            <div class="col-lg-6 mb-3">
                <label for="empName" class="form-label fw-bold">Name:</label>
                <cfinput type="text" name="EmpName" id="empName"
                        value="#HtmlEditFormat(Session.FullName)#"
                        size="50" required="yes" class="form-control">
            </div>

            <div class="col-lg-3 mb-3">
                <cfquery name="GetID" datasource="accounts">
                    SELECT EmpID
                    FROM accounts
                    WHERE Username = <cfqueryparam value="#Session.Username#" cfsqltype="cf_sql_varchar">
                </cfquery>
                <label for="empID" class="form-label fw-bold">ID#:</label>
                <cfinput type="text" name="EmpID" id="empID"
                        value="#HtmlEditFormat(GetID.EmpID)#"
                        size="10" required="yes" class="form-control">
            </div>

            <div class="col-lg-3 mb-3">
                <label for="empBuilding" class="form-label fw-bold">School:</label>
                <cfinput type="text" name="EmpBuilding" id="empBuilding"
                        value="#HtmlEditFormat(Session.Building)#"
                        size="50" required="yes" class="form-control">
            </div>
        </div>

        <div class="row mb-3 p-3 bg-light rounded">
            <div class="col-md-4 mb-3">
                <label for="reqDateFrom" class="form-label fw-bold">Dates Requested: From (use date picker):</label>
                <cfif isdefined('Session.ReqDateFrom') && isDate(Session.ReqDateFrom) && Session.ReqDateFrom neq "">
                    <cfinput type="date" name="ReqDateFrom" id="reqDateFrom"
                            value="#DateFormat(Session.ReqDateFrom, 'yyyy-mm-dd')#"
                            required class="form-control">
                <cfelse>
                    <input type="date" name="ReqDateFrom" id="reqDateFrom" required class="form-control">
                </cfif>
            </div>

            <div class="col-md-4 mb-3">
                <label for="reqDateTo" class="form-label fw-bold">To (use date picker):</label>
                <cfif isdefined('Session.ReqDateTo') && isDate(Session.ReqDateTo) && Session.ReqDateTo neq "">
                    <cfinput type="date" name="ReqDateTo" id="reqDateTo"
                            value="#DateFormat(Session.ReqDateTo, 'yyyy-mm-dd')#"
                            required class="form-control">
                <cfelse>
                    <input type="date" name="ReqDateTo" id="reqDateTo" required class="form-control">
                </cfif>
            </div>

            <div class="col-md-4 mb-3">
                <label for="reqNumDays" class="form-label fw-bold">Number of Days Requested: (number only)</label>
                <p class="form-text text-muted mb-2">(If less than 1 day, put hours in comments to HR)</p>
                <cfif isdefined('Session.ReqNumDays') && len(trim(Session.ReqNumDays)) GT 0>
                    <cfinput type="number" name="ReqNumDays" id="reqNumDays"
                            value="#HtmlEditFormat(Session.ReqNumDays)#"
                            required class="form-control"
                            min="0" step="any">
                <cfelse>
                    <cfinput type="number" name="ReqNumDays" id="reqNumDays"
                            required class="form-control"
                            min="0" step="any">
                </cfif>
            </div>
        </div>


        <!--- if Certified Employee --->
        <cfif Session.EmpType eq 1>
            <div class="row mb-3 p-3 bg-light"> 
                <div class="col-12">
                    <h5 class="mb-0">Check Leave Type You Are Requesting:</h5> </div>
            </div>

            <cfif isdefined('Session.LeaveType')>
                <div class="row mb-3 p-3 bg-light">
                    <div class="col-md-6">
                        <div class="form-check">
                            <cfif Session.LeaveType eq 9>
                                <cfinput type="radio" name="LeaveType" id="leaveTypeDayLeave" value="9" required="yes" message="You must select a type of leave" checked="yes" class="form-check-input">
                            <cfelse>
                                <cfinput type="radio" name="LeaveType" id="leaveTypeDayLeave" value="9" required="yes" message="You must select a type of leave" class="form-check-input">
                            </cfif>
                            <label class="form-check-label fw-bold" for="leaveTypeDayLeave">
                                Day Leave Section 9.1:
                            </label>
                            <p class="form-text text-muted ms-4">This leave may not be used for vacation or job interviews. Must provide comments to HR if taking 3 or more consecutive days or a blackout day*</p>
                        </div>
                        <cfif isdefined('Session.dayleavereason')>
                            <cfinput type="hidden" name="dayleavereason" value="#Session.dayleavereason#">
                        <cfelse>
                            <cfinput type="hidden" name="dayleavereason">
                        </cfif>

                        <div class="form-check mt-3">
                            <cfif Session.LeaveType eq 14>
                                <cfinput type="radio" name="LeaveType" id="leaveTypeMilitary" value="14" required="yes" message="You must select a type of leave" checked="yes" class="form-check-input">
                            <cfelse>
                                <cfinput type="radio" name="LeaveType" id="leaveTypeMilitary" value="14" required="yes" message="You must select a type of leave" class="form-check-input">
                            </cfif>
                            <label class="form-check-label fw-bold" for="leaveTypeMilitary">
                                Military Leave 8.4
                            </label>
                            <p class="form-text text-muted ms-4">(documentation required)</p>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-check">
                            <cfif Session.LeaveType eq 1>
                                <cfinput type="radio" name="LeaveType" id="leaveTypeBereavement" value="1" required="yes" message="You must select a type of leave" class="form-check-input" checked="yes">
                            <cfelse>
                                <cfinput type="radio" name="LeaveType" id="leaveTypeBereavement" value="1" required="yes" message="You must select a type of leave" class="form-check-input">
                            </cfif>
                            <label class="form-check-label fw-bold" for="leaveTypeBereavement">
                                Bereavement Section:
                            </label>
                            <p class="form-text text-muted ms-4">Immediate family members**
                                <cfif isdefined('Session.bereavementrelationship')>
                                    <input type="text" name="bereavementrelationship" id="bereavementrelationship" size="20" value="<cfoutput>#Session.bereavementrelationship#</cfoutput>" class="form-control d-inline-block w-auto ms-2" aria-describedby="bereavementHelpText"/>
                                <cfelse>
                                    <cfinput type="text" name="bereavementrelationship" id="bereavementrelationship" size="20" maxlength="50" class="form-control d-inline-block w-auto ms-2" aria-describedby="bereavementHelpText"/>
                                </cfif>
                            </p>
                            <small id="bereavementHelpText" class="form-text text-muted visually-hidden">Enter relationship for bereavement leave</small>
                        </div>

                        <div class="form-check mt-3">
                            <cfif Session.LeaveType eq 4>
                                <cfinput type="radio" name="LeaveType" id="leaveTypeCommunity" value="4" required="yes" message="You must select a type of leave" class="form-check-input" checked="yes">
                            <cfelse>
                                <cfinput type="radio" name="LeaveType" id="leaveTypeCommunity" value="4" required="yes" message="You must select a type of leave" class="form-check-input">
                            </cfif>
                            <label class="form-check-label fw-bold" for="leaveTypeCommunity">
                                Community Service Section 9.4
                            </label>
                            <p class="form-text text-muted ms-4">(preapproval and documentation required)</p>
                        </div>
                    </div>
                </div>
            <cfelse>
            <!--- if session.leavetype not exists begin--->
                <fieldset class="mb-4 p-3 border rounded">
                    <legend class="float-none w-auto px-2 fs-5 fw-bold">Select Leave Type:</legend>
                    <div class="row bg-light">
                        <div class="col-md-6">
                            <div class="form-check">
                                <cfinput type="radio" name="LeaveType" id="leaveTypeDayLeave" value="9" required="yes" message="You must select a type of leave" class="form-check-input">
                                <label class="form-check-label fw-bold" for="leaveTypeDayLeave">
                                    Day Leave Section 9.1:
                                </label>
                                <p class="form-text text-muted ms-4">This leave may not be used for vacation or job interviews. Must provide comments to HR if taking 3 or more consecutive days or a blackout day*</p>
                            </div>

                            <cfinput type="hidden" name="dayleavereason">

                            <div class="form-check mt-3">
                                <cfinput type="radio" name="LeaveType" id="leaveTypeMilitary" value="14" required="yes" message="You must select a type of leave" class="form-check-input">
                                <label class="form-check-label fw-bold" for="leaveTypeMilitary">
                                    Military Leave 8.4
                                </label>
                                <p class="form-text text-muted ms-4">(documentation required)</p>
                            </div>

                            <div class="form-check mt-3">
                                <cfinput type="radio" name="LeaveType" id="leaveTypeWithoutPay" value="6" required="yes" message="You must select a type of leave" class="form-check-input">
                                <label class="form-check-label fw-bold" for="leaveTypeWithoutPay">
                                    Leave without Pay
                                </label>
                            </div>

                            </div>

                        <div class="col-md-6">
                            <div class="form-check">
                                <cfinput type="radio" name="LeaveType" id="leaveTypeBereavement" value="1" required="yes" message="You must select a type of leave" class="form-check-input">
                                <label class="form-check-label fw-bold" for="leaveTypeBereavement">
                                    Bereavement Section:
                                </label>
                                <p class="form-text text-muted ms-4">
                                    <label class="form-check-label fw-bold" for="bereavementrelationship">Immediate family members**</label>
                                    <input type="text" name="bereavementrelationship" id="bereavementrelationship" size="20" class="form-control d-inline-block w-auto ms-2" aria-describedby="bereavementHelpText"/>   
                                </p>
                                <small id="bereavementHelpText" class="form-text text-muted visually-hidden">Enter relationship for bereavement leave</small>
                            </div>

                            <div class="form-check mt-3">
                                <cfinput type="radio" name="LeaveType" id="leaveTypeCommunity" value="4" required="yes" message="You must select a type of leave" class="form-check-input">
                                <label class="form-check-label fw-bold" for="leaveTypeCommunity">
                                    Community Service Section 9.4
                                </label>
                                <p class="form-text text-muted ms-4">(preapproval and documentation required)</p>
                            </div>

                            <div class="form-check mt-3">
                                <cfinput type="radio" name="LeaveType" id="leaveTypeOfficiating" value="3" required="yes" message="You must select a type of leave" class="form-check-input">
                                <label class="form-check-label fw-bold" for="leaveTypeOfficiating">
                                    Officiating/Judging Section 9.5
                                </label>
                                <p class="form-text text-muted ms-4">(documentation required)</p>
                            </div>

                            <div class="form-check mt-3">
                                <cfinput type="radio" name="LeaveType" id="leaveTypeJuryWitness" value="2" required="yes" message="You must select a type of leave" class="form-check-input">
                                <label class="form-check-label fw-bold" for="leaveTypeJuryWitness">
                                    Jury/Witness Section 9.8
                                </label>
                                <p class="form-text text-muted ms-4">(documentation required)</p>
                            </div>

                            </div>
                    </div>
                </fieldset>
            </cfif>
                
            <!--- if Session.LeaveType not exists end--->
            <div class="row mb-3">
                <div class="col-md-12 bg-light">
                    <label for="subfindernum" class="form-label fw-bold">Reported Aesop/Frontline Job #:</label>
                    <cfif isdefined('Session.subfinderid')>
                        <cfinput type="text" name="subfindernum" id="subfindernum" value="#Session.subfinderid#" required="yes" validate="integer" message="Aesop/Frontline Job number must be entered and it must be numeric" class="form-control">
                    <cfelse>
                        <cfinput type="text" name="subfindernum" id="subfindernum" validate="integer" required="yes" message="Aesop/Frontline Job number must be entered and it must be numeric" class="form-control">
                    </cfif>
                </div>
            </div>
        </div>

        <!--- Classified Employees or Administrators --->
        <cfelseif Session.EmpType eq 2>
                <div class="container mt-4">
                <cfif not isdefined('Session.LeaveType')>
                    <fieldset class="mb-4 p-3 border">
                        <legend class="float-none w-auto px-2 fs-5 fw-bold">Check Leave Type You Are Requesting:</legend>
                        <div class="row bg-light">
                            <div class="col-md-6">
                                <div class="form-check">
                                    <cfinput type="radio" name="LeaveType" id="leaveTypePersonal" value="9" required="yes" message="You must select a type of leave" class="form-check-input">
                                    <label class="form-check-label fw-bold" for="leaveTypePersonal">
                                        Personal Leave***
                                    </label>
                                    <p class="form-text text-muted ms-4">This leave may not be used for vacation or job interviews. Must provide reason in comments to HR if taking 3 or more consecutive days or a blackout day*</p>
                                    <cfinput type="hidden" name="dayleavereason">
                                </div>

                                <div class="form-check mt-3">
                                    <cfinput type="radio" name="LeaveType" id="leaveTypeSick" value="13" required="yes" message="You must select a type of Leave" class="form-check-input">
                                    <label class="form-check-label fw-bold" for="leaveTypeSick">
                                        Sick Leave
                                    </label>
                                    <p class="form-text text-muted ms-4">(If applicable FMLA will be followed)</p>
                                </div>

                                <div class="form-check mt-3">
                                    <cfinput type="radio" name="LeaveType" id="leaveTypeWithoutPay" value="6" required="yes" message="You must select a type of leave" class="form-check-input">
                                    <label class="form-check-label fw-bold" for="leaveTypeWithoutPay">
                                        Leave without Pay
                                    </label>
                                </div>

                                <div class="form-check mt-3">
                                    <cfinput type="radio" name="LeaveType" id="leaveTypeVacation" value="10" required="yes" message="You must select a type of leave" class="form-check-input">
                                    <label class="form-check-label fw-bold" for="leaveTypeVacation">
                                        Vacation (YEAR-ROUND EMPLOYEES ONLY)
                                    </label>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-check">
                                    <cfinput type="radio" name="LeaveType" id="leaveTypeBereavement" value="1" required="yes" message="You must select a type of leave" class="form-check-input">
                                    <label class="form-check-label fw-bold" for="leaveTypeBereavement">
                                        Bereavement
                                    </label>
                                    <div class="ms-4 mt-2">
                                        <label for="bereavementrelationship" class="form-label">Immediate Family Members**</label>
                                        <input type="text" name="bereavementrelationship" id="bereavementrelationship" size="20" class="form-control w-auto" aria-describedby="bereavementHelpText"/>
                                        <small id="bereavementHelpText" class="form-text text-muted">Enter relationship for bereavement leave</small>
                                    </div>
                                </div>

                                <div class="form-check mt-3">
                                    <cfinput type="radio" name="LeaveType" id="leaveTypeCommunityService" value="4" required="yes" message="You must select a type of leave" class="form-check-input">
                                    <label class="form-check-label fw-bold" for="leaveTypeCommunityService">
                                        Community Service
                                    </label>
                                    <p class="form-text text-muted ms-4">(Preapproval &amp; documentation required)</p>
                                </div>

                                <div class="form-check mt-3">
                                    <cfinput type="radio" name="LeaveType" id="leaveTypeOfficiating" value="3" required="yes" message="You must select a type of leave" class="form-check-input">
                                    <label class="form-check-label fw-bold" for="leaveTypeOfficiating">
                                        Officiating/Judging
                                    </label>
                                    <p class="form-text text-muted ms-4">(Documentation required)</p>
                                </div>

                                <div class="form-check mt-3">
                                    <cfinput type="radio" name="LeaveType" id="leaveTypeMilitaryMain" value="14" required="yes" message="You must select a type of Leave" class="form-check-input">
                                    <label class="form-check-label fw-bold" for="leaveTypeMilitaryMain">
                                        Military Leave
                                    </label>
                                    <p class="form-text text-muted ms-4">(Documentation Required)</p>
                                </div>

                                <div class="form-check mt-3">
                                    <cfinput type="radio" name="LeaveType" id="leaveTypeJuryWitness" value="2" required="yes" message="You must select a type of leave" class="form-check-input">
                                    <label class="form-check-label fw-bold" for="leaveTypeJuryWitness">
                                        Jury/Witness
                                    </label>
                                    <p class="form-text text-muted ms-4">(Documentation required)</p>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                <cfelse>
                    <fieldset class="mb-4 p-3 border">
                        <legend class="float-none w-auto px-2 fs-5 fw-bold">Check Leave Type You Are Requesting:</legend>
                        <div class="row bg-light">
                            <div class="col-md-6">
                                <div class="form-check">
                                    <cfif Session.LeaveType eq 9>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypePersonal" value="9" required="yes" message="You must select a type of leave" checked="yes" class="form-check-input">
                                    <cfelse>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypePersonal" value="9" required="yes" message="You must select a type of leave" class="form-check-input">
                                    </cfif>
                                    <label class="form-check-label fw-bold" for="leaveTypePersonal">
                                        Personal Leave***
                                    </label>
                                    <p class="form-text text-muted ms-4">This leave may not be used for vacation or job interviews. Must provide reason in comments to HR if taking 3 or more consecutive days or a blackout day*</p>
                                    <cfif isdefined('Session.dayleavereason')>
                                        <cfinput type="hidden" name="dayleavereason" value="#Session.dayleavereason#">
                                    <cfelse>
                                        <cfinput type="hidden" name="dayleavereason">
                                    </cfif>
                                </div>

                                <div class="form-check mt-3">
                                    <cfif Session.LeaveType eq 13>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeSick" value="13" required="yes" message="You must select a type of leave" checked="yes" class="form-check-input">
                                    <cfelse>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeSick" value="13" required="yes" message="You must select a type of leave" class="form-check-input">
                                    </cfif>
                                    <label class="form-check-label fw-bold" for="leaveTypeSick">
                                        Sick Leave
                                    </label>
                                    <p class="form-text text-muted ms-4">(If applicable FMLA will be followed)</p>
                                </div>

                                <div class="form-check mt-3">
                                    <cfif Session.LeaveType eq 6>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeWithoutPay" value="6" required="yes" message="You must select a type of leave" checked="yes" class="form-check-input">
                                    <cfelse>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeWithoutPay" value="6" required="yes" message="You must select a type of leave" class="form-check-input">
                                    </cfif>
                                    <label class="form-check-label fw-bold" for="leaveTypeWithoutPay">
                                        Leave without Pay
                                    </label>
                                </div>

                                <div class="form-check mt-3">
                                    <cfif Session.LeaveType eq 10>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeVacation" value="10" required="yes" message="You must select a type of leave" checked="yes" class="form-check-input">
                                    <cfelse>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeVacation" value="10" required="yes" message="You must select a type of leave" class="form-check-input">
                                    </cfif>
                                    <label class="form-check-label fw-bold" for="leaveTypeVacation">
                                        Vacation (YEAR-ROUND EMPLOYEES ONLY)
                                    </label>
                                </div>

                                </div>

                            <div class="col-md-6">
                                <div class="form-check">
                                    <cfif Session.LeaveType eq 1>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeBereavement" value="1" required="yes" message="You must select a type of leave" checked="yes" class="form-check-input">
                                    <cfelse>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeBereavement" value="1" required="yes" message="You must select a type of leave" class="form-check-input">
                                    </cfif>
                                    <label class="form-check-label fw-bold" for="leaveTypeBereavement">
                                        Bereavement
                                    </label>
                                    <div class="ms-4 mt-2">
                                        <label for="bereavementrelationship" class="form-label">Immediate Family Members**</label>
                                        <cfif isdefined('Session.bereavementrelationship')>
                                            <input type="text" name="bereavementrelationship" id="bereavementrelationship" size="20" value="<cfoutput>#Session.bereavementrelationship#</cfoutput>" class="form-control w-auto" aria-describedby="bereavementHelpText"/>
                                        <cfelse>
                                            <input type="text" name="bereavementrelationship" id="bereavementrelationship" size="20" class="form-control w-auto" aria-describedby="bereavementHelpText"/>
                                        </cfif>
                                        <small id="bereavementHelpText" class="form-text text-muted">Enter relationship for bereavement leave</small>
                                    </div>
                                </div>

                                <div class="form-check mt-3">
                                    <cfif Session.LeaveType eq 4>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeCommunityService" value="4" required="yes" message="You must select a type of leave" checked="yes" class="form-check-input">
                                    <cfelse>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeCommunityService" value="4" required="yes" message="You must select a type of leave" class="form-check-input">
                                    </cfif>
                                    <label class="form-check-label fw-bold" for="leaveTypeCommunityService">
                                        Community Service
                                    </label>
                                    <p class="form-text text-muted ms-4">(Preapproval &amp; documentation required)</p>
                                </div>

                                <div class="form-check mt-3">
                                    <cfif Session.LeaveType eq 3>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeOfficiating" value="3" required="yes" message="You must select a type of leave" checked="yes" class="form-check-input">
                                    <cfelse>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeOfficiating" value="3" required="yes" message="You must select a type of leave" class="form-check-input">
                                    </cfif>
                                    <label class="form-check-label fw-bold" for="leaveTypeOfficiating">
                                        Officiating/Judging
                                    </label>
                                    <p class="form-text text-muted ms-4">(Documentation required)</p>
                                </div>

                                <div class="form-check mt-3">
                                    <cfif Session.LeaveType eq 14>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeMilitaryMain" value="14" required="yes" message="You must select a type of Leave" checked="yes" class="form-check-input">
                                    <cfelse>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeMilitaryMain" value="14" required="yes" message="You must select a type of Leave" class="form-check-input">
                                    </cfif>
                                    <label class="form-check-label fw-bold" for="leaveTypeMilitaryMain">
                                        Military Leave
                                    </label>
                                    <p class="form-text text-muted ms-4">(Documentation Required)</p>
                                </div>

                                <div class="form-check mt-3">
                                    <cfif Session.LeaveType eq 2>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeJuryWitness" value="2" required="yes" message="You must select a type of leave" checked="yes" class="form-check-input">
                                    <cfelse>
                                        <cfinput type="radio" name="LeaveType" id="leaveTypeJuryWitness" value="2" required="yes" message="You must select a type of leave" class="form-check-input">
                                    </cfif>
                                    <label class="form-check-label fw-bold" for="leaveTypeJuryWitness">
                                        Jury/Witness
                                    </label>
                                    <p class="form-text text-muted ms-4">(Documentation required)</p>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                </cfif>
            </div>
        </cfif>
        <div class="row mb-3 bg-light">
            <div class="col-md-12">
                <label for="comments" class="form-label fw-bold">Comments to HR:</label>
                <cfif isdefined('Session.CommentsTo')>
                    <cftextarea id="comments" name="comments" class="form-control" cols="50" rows="4" value="#Session.CommentsTo#"></cftextarea>
                <cfelse>
                    <cftextarea id="comments" name="comments" class="form-control" cols="50" rows="4"></cftextarea>
                </cfif>
            </div>
        </div>
        <div class="row mb-3 bg-light">
            <div class="col-md-9">
                <label for="EmpSig" class="form-label fw-bold">Employee Signature (type in name):</label>
                <cfif isdefined('Session.EmpSig')>
                    <cfinput type="text" name="EmpSig" id="EmpSig" size="50" required="yes" message="Enter your name as you would sign ex: John Q. Smith" value="#Session.EmpSig#" class="form-control">
                <cfelse>
                    <cfinput type="text" name="EmpSig" id="EmpSig" size="50" required="yes" message="Enter your name as you would sign ex: John Q. Smith" maxlength="50" class="form-control">
                </cfif>
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <p class="form-text mb-0">
                    <span class="fw-bold">Date:</span> <cfoutput>#LSDateFormat(NOW(),'mm/dd/yyyy')#</cfoutput>
                </p>
            </div>
        </div>
        <div class="row mb-3 bg-light">
            <div class="col-md-12">
                <label for="SupEmail" class="form-label fw-bold">Enter Supervisor's Email address <span class="fw-normal">(you must search for email address)</span>:</label>
                <div class="input-group">
                    <cfif isdefined('Session.SupEmail')>
                        <cfinput type="text" name="SupEmail" id="SupEmail" value="#Session.SupEmail#" readonly="yes" class="form-control">
                    <cfelse>
                        <cfinput type="text" name="SupEmail" id="SupEmail" readonly="yes" class="form-control">
                    </cfif>
                    <cfinput type="submit" name="SearchSup" value="Search for Email" class="btn btn-secondary"> </div>
            </div>
        </div>

        <div class="row mb-3 bg-light">
            <div class="col-md-12">
                <label for="SupEmail2" class="form-label fw-bold">Enter Secretary or Secondary Supervisor's Email address <span class="fw-normal">(you must search for email address)</span>:</label>
                <div class="input-group">
                    <cfif isdefined('Session.SupEmail2')>
                        <cfinput type="text" name="SupEmail2" id="SupEmail2" value="#Session.SupEmail2#" readonly="yes" class="form-control">
                    <cfelse>
                        <cfinput type="text" name="SupEmail2" id="SupEmail2" readonly="yes" class="form-control">
                    </cfif>
                    <cfinput type="submit" name="SearchSup2" value="Search for Email" class="btn btn-secondary"> </div>
            </div>
        </div>
        <div class="row mt-4">
            <div class="col-12 text-center bg-light">
                <cfinput type="submit" name="Submit" value="Submit" class="btn btn-primary btn-lg">
            </div>
        </div>
        <div class="row mt-4 mb-4 bg-light">
            <div class="col-md-12">
                <h2 class="fw-bold text-decoration-underline">Definitions:</h2>
                <p class="mb-2">
                    <strong class="me-1">*Blackout day:</strong> The day immediately preceding and/or following a vacation period as defined on the adopted District Calendar or the first or last student contact days.
                </p>
                <p class="mb-2">
                    <strong class="me-1">**Immediate Family Member:</strong> father, father-in-law, step-father, mother, mother-in-law, step-mother, grandparents, grandchild, sister, sister-in-law, step-sister, brother, brother-in-law, step-brother, son-in-law, daughter-in-law, husband, wife, child, stepchild, or individual living in household.
                </p>

                <cfif Session.EmpType eq 2>
                    <p class="mb-2">
                        <strong class="me-1">***Personal Leave:</strong> Full-time employees may be granted personal leave as follows:
                    </p>
                    <ul class="list-unstyled ms-3">
                        <li>Year-Round employees may use three (3) days of sick leave per fiscal year, beginning July 1st, for the purpose of conducting personal business.</li>
                        <li>Employees who are not year-round may use six (6) days of sick leave per fiscal year, beginning July 1st, for the purpose of conducting personal business.</li>
                        <li>Personal leave is charged against accrued sick leave, and is not accumulative from contract year-to-year.</li>
                    </ul>
                    <p class="mt-3 mb-2">Click on the following to view the full Leaves and Absences Policies:</p>
                    <ul class="list-unstyled ms-3">
                        <li><a href="https://www.mesa.k12.co.us/board/policies/documents/gdc.pdf" target="_blank" rel="noopener noreferrer" class="text-dark text-decoration-underline">Support Staff</a></li>
                        <li><a href="https://www.mesa.k12.co.us/board/policies/documents/gcd.pdf" target="_blank" rel="noopener noreferrer" class="text-dark text-decoration-underline">Administrators</a></li>
                    </ul>
                </cfif>
            </div>
        </div>
        <cfif Session.EmpType eq 1>
            <div class="row mt-4 mb-3 bg-light">
                <div class="col-md-12">
                    <h5 class="fw-bold">Employees covered under MVEA</h5>
                    <p class="mb-3">
                        Day leave may be used for sick leave of the employee, to attend to the illness of immediate family, emergency, and personal business for the employee. In the event an employee is requesting 3 consecutive days or more of leave, he/she must submit a "Request and approval for Leave" form as soon as possible to his/her administrator(s). The form will contain an affirmation that the leave will not be used for vacation or job interviews. <strong class="text-danger">Days immediately preceding and/or following vacation periods and the first and last student contact days are not usable for day leave excepting in case of illness or if there are extenuating circumstances.</strong>
                    </p>
                    <p class="mb-3">
                        For more information on available leave options, please see joint MVEA Agreement section 9.
                    </p>
                    <p class="mb-2">
                        In the event an Employee Leave Request is denied, the Covered Employee may file an appeal. The appeal must be submitted in writing to the Human Resources Department no later than 30 calendar days after the date of the leave and shall include a statement as to why the leave should be approved. The Employee Leave Request Appeals Panel shall consist of representation from MVEA, Human Resources and administration. The following criteria will be reviewed and taken into consideration by the Employee Leave Request Appeal Panel:
                    </p>
                    <ol class="ms-3">
                        <li>Day Leave Usage History</li>
                        <li>Reason for the Request</li>
                        <li>Covered Employee Provided Statement</li>
                        <li>Any additional information as requested by the panel</li>
                    </ol>
                </div>
            </div>
        </cfif>
    </cfform>
    <cfform action="logout.cfm" method="post">
        <div class="row mt-4 bg-light">
            <div class="col-12 text-end">
                <input type="submit" name="logout" value="Logout" class="btn btn-danger" formnovalidate>
            </div>
        </div>
    </cfform>

<!--- View Specific Request --->
<cfelseif StepNum eq 5>
    <cfinclude template="logout.cfm">    
    <!--- Get Request Data --->
    <cfquery name="GetRequestData"  datasource="mesa_web">
    	SELECT *
        FROM	LeaveReq_tblRequest
        WHERE	RequestID = #RequestID# and userid = '#Session.Username#'
    </cfquery>

    <cfform name="SelectEmpType" action="index.cfm?StepNum=5&#urlencodedformat(NOW())#" method="post">
        <cfoutput query="GetRequestData">
            <table class="table">
                <thead>
                    <tr>
                        <th colspan="6" class="text-center">Leave Request ##: #RequestID#</th>
                    </tr>
                    <tr>
                        <th>Dates of Requested</th>
                        <th>Type of Leave Request</th>
                        <th>Sub Needed/Aesop/Frontline ##</th>
                        <th>Supervisor</th>
                        <th>Viewed By Supervisor</th>
                        <th>Approved by Human Resources</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>#LSDateFormat(dtFrom,'mm/dd/yyyy')#-#LSDateFormat(dtTo,'mm/dd/yyyy')#</td>
                        <td>
                            <cfif GetRequestData.requesttype eq 1>
                                Bereavement
                            <cfelseif GetRequestData.requesttype eq 2>
                                Jury/Witness
                            <cfelseif GetRequestData.requesttype eq 3>
                                Officiating/Judging
                            <cfelseif GetRequestData.requesttype eq 4>
                                Community Service
                            <cfelseif GetRequestData.requesttype eq 5>
                            <cfelseif GetRequestData.requesttype eq 6>
                                Leave without Pay
                            <cfelseif GetRequestData.requesttype eq 7>
                                FMLA own serious health condition
                            <cfelseif GetRequestData.requesttype eq 8>
                                FMLA care ofr immediate family member with a serious health condition
                            <cfelseif GetRequestData.requesttype eq 9>
                                Day or Personal Leave
                            <cfelseif GetRequestData.requesttype eq 10>
                                Vacation
                            <cfelseif GetRequestData.requesttype eq 11>
                                FMLA Military Exigency Leave
                            <cfelseif GetRequestData.requesttype eq 12>
                                FMLA Military Caregiver Leave
                            <cfelseif GetRequestData.requesttype eq 13>
                                Sick Leave
                            <cfelseif GetRequestData.requesttype eq 14>
                                Military Leave
                            </cfif>
                        </td>
                        <td>#subrequested#/#subfindernum#</td>
                        <td>#supervisor#</td>
                        <td>#supviewed#</td>
                        <td>#approved#</td>
                    </tr>
                    <tr>
                        <td colspan="2" class="text-center pt-3"><a href="index.cfm?StepNum=1" class="btn btn-secondary me-2">Back to Main</a></td>
                        <td colspan="2" class="text-center pt-3"><a href="index.cfm?StepNum=3" class="btn btn-secondary me-2">Back to View Stipends</a></td>
                        <td colspan="2" class="text-center pt-3"> <input type="submit" name="logout" value="Logout" class="btn btn-primary" />
                        </td>
                    </tr>
                </tbody>
            </table>
        </cfoutput>
    </cfform>
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
        <div class="card mb-4">
            <div class="card-header bg-success">
                <h5 class="mb-0 text-center">Search for Supervisors Email</h5>
            </div>
            <div class="card-body">
                <div class="row g-3 align-items-center justify-content-center mb-3 bg-light">
                    <div class="col-auto">
                        <label for="searchinfo" class="visually-hidden">Search for:</label>
                        <cfinput type="text" name="searchinfo" id="searchinfo" class="form-control" placeholder="Search for...">
                    </div>
                    <div class="col-auto">
                        <label for="searchcolumn" class="visually-hidden">in:</label>
                        <cfselect name="searchcolumn" id="searchcolumn" class="form-select">
                            <option value="lname">Last Name</option>
                            <option value="fname">First Name</option>
                        </cfselect>
                    </div>
                    <div class="col-auto">
                        <cfinput type="submit" name="search" value="Search" class="btn btn-primary">
                    </div>
                </div>
            </div>
        </div>

        <cfif isdefined('form.search')>
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0 text-center">Results: (click email address to return to Leave Request Form)</h5>
                </div>
                <div class="card-body p-0"> <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0"> <thead class="table-dark">
                                <tr>
                                    <th>Full Name</th>
                                    <th>Last Name</th>
                                    <th>First Name</th>
                                    <th>Building</th>
                                    <th>Email</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="SearchSup">
                                    <tr>
                                        <td>#Full_Name#</td>
                                        <td>#lname#</td>
                                        <td>#fname#</td>
                                        <td>#building#</td>
                                        <td><a href="index.cfm?StepNum=7&SupEmail=#Email#" class="text-decoration-underline">#Email#</a></td>
                                    </tr>
                                </cfoutput>
                                <cfif SearchSup.RecordCount eq 0>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-3">No results found.</td>
                                    </tr>
                                </cfif>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </cfif>
    </cfform>
<!--- Sup 2 Email --->
<cfelseif StepNum eq 8>
    <cfif isdefined('form.search')>
        <cfquery name="SearchSup" datasource="accounts">
            SELECT Full_Name, Username, fname, lname, building, Email
            FROM accounts
            WHERE #form.searchcolumn# LIKE '%#form.searchinfo#%' AND Groups NOT LIKE '%students'
            ORDER BY lname, fname
        </cfquery>
    </cfif>
    <cfif isdefined('URL.SupEmail2')>
        <cfset Session.SupEmail2 = '#URL.SupEmail2#'>
        <cflocation url="index.cfm?StepNum=4">
    </cfif>

    <cfform name="SearchSupEmail" method="post" action="index.cfm?StepNum=8">
        <div class="card mb-4">
            <div class="card-header bg-success">
                <h5 class="mb-0 text-center">Search for Supervisors Email</h5>
            </div>
            <div class="card-body">
                <div class="row g-3 align-items-center justify-content-center mb-3 bg-light">
                    <div class="col-auto">
                        <label for="searchinfo" class="visually-hidden">Search for:</label>
                        <cfinput type="text" name="searchinfo" id="searchinfo" class="form-control" placeholder="Search for...">
                    </div>
                    <div class="col-auto">
                        <label for="searchcolumn" class="visually-hidden">in:</label>
                        <cfselect name="searchcolumn" id="searchcolumn" class="form-select">
                            <option value="lname">Last Name</option>
                            <option value="fname">First Name</option>
                        </cfselect>
                    </div>
                    <div class="col-auto">
                        <span class="d-none d-md-inline">You must click search button</span> <cfinput type="submit" name="search" value="Search" class="btn btn-primary ms-md-2"> </div>
                </div>
            </div>
        </div>

        <cfif isdefined('form.search')>
            <div class="card">
                <div class="card-header bg-success">
                    <h5 class="mb-0 text-center">Results: (click email address to return to Leave Request Form)</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th>Full Name</th>
                                    <th>Last Name</th>
                                    <th>First Name</th>
                                    <th>Building</th>
                                    <th>Email</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="SearchSup">
                                    <tr>
                                        <td>#Full_Name#</td>
                                        <td>#lname#</td>
                                        <td>#fname#</td>
                                        <td>#building#</td>
                                        <td><a href="index.cfm?StepNum=8&SupEmail2=#email#" class="text-decoration-underline">#email#</a></td>
                                    </tr>
                                </cfoutput>
                                <cfif SearchSup.RecordCount eq 0>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-3">No results found.</td>
                                    </tr>
                                </cfif>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
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

<div class="container my-5 ">
    <div class="row justify-content-center bg-light" >
        <div class="col-md-8 text-center">
            <div class="alert alert-success" role="alert">
                <h4 class="alert-heading">Request Successfully Submitted!</h4>
                <p>Your Request for Leave has been entered into the system.</p>
                <p class="mb-0">You will be redirected to the main page in <span id="countdown">5</span> seconds.</p>
                <hr>
                <p class="mb-0">
                    If you are not redirected automatically, or if you prefer to navigate now, please click the link below:
                </p>
                <a href="index.cfm?StepNum=1" class="btn btn-primary mt-3">Go to Main Page Now</a>
            </div>
        </div>
    </div>
</div>

<script>
    // JavaScript for controlled redirection with countdown
    let countdownElement = document.getElementById('countdown');
    let timeLeft = 10; // Initial countdown time in seconds

    function updateCountdown() {
        if (countdownElement) {
            countdownElement.textContent = timeLeft;
            if (timeLeft <= 0) {
                window.location.href = 'index.cfm?StepNum=1';
            } else {
                timeLeft--;
                setTimeout(updateCountdown, 1000); // Call function again after 1 second
            }
        }
    }

    // Start the countdown when the page loads
    window.onload = updateCountdown;
</script>

<!--- Set Session Variables to Insert Request --->
<cfelseif StepNum eq 997>
    <cfif isdefined('form.logout')>
	    <cfinclude template="logout.cfm">
    </cfif>
    
    <!--- Set Session Variables --->
    <cfset Session.EmpName = '#Form.EmpName#'>
    <cfset Session.EmpID = '#Form.EmpID#'>
    <cfset Session.EmpBuilding = '#Form.EmpBuilding#'>
    <!---<cfset Session.ReqDates = '#Form.ReqDates#'>--->
    
    <!--- <cfset Session.ReqDateFrom = '#Form.ReqDateFrom#'>
    <cfset Session.ReqDateTo = '#Form.ReqDateTo#'> --->
    <cfif isdefined('Form.ReqDateFrom') AND len(trim(Form.ReqDateFrom)) GT 0>
        <cfset Session.ReqDateFrom = ParseDateTime(Form.ReqDateFrom)>
    <cfelse>
        <cfset Session.ReqDateFrom = ""> 
    </cfif>

    <cfif isdefined('Form.ReqDateTo') AND len(trim(Form.ReqDateTo)) GT 0>
        <cfset Session.ReqDateTo = ParseDateTime(Form.ReqDateTo)>
    <cfelse>
        <cfset Session.ReqDateTo = "">
    </cfif>


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
        VALUES		('#Session.RequestID#', '#Session.Username#', #Session.DateEntered#, '#Session.yearofrequest#', '#Session.LeaveType#', '#Session.dayleavereason#', '#Session.subfinderid#', '#Session.subrequested_yn#', '#Session.bereavementrelationship#', '#Session.EmpSig#', #Session.DateEntered#, '#Session.SupEmail#', '#Session.SupEmail2#', #Session.EmpType#, '#Session.FileName#', '#Session.CommentsTo#', #Session.ReqDateFrom#, #Session.ReqDateTo#, '#Session.ReqNumDays#')
        
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