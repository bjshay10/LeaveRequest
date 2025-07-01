<cfapplication name="EmployeeLeaveRequest_supervisor" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,0,10,0)#">
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
				Leave Request - Supervisor Page
			<!-- InstanceEndEditable --></h1>
   	  	</span><br />
				 <!-- InstanceBeginEditable name="Content" -->
<cfif not isdefined('StepNum')>
	<cfset StepNum = 0>
</cfif>

<cfif not isdefined('Session.requestid')>
	<cfset Session.requestid = #requestid#>
</cfif>

<cfif not isdefined('Session.emp_username')>
	<cfset Session.emp_username = #userid#>
</cfif>

<cfif not isdefined('Session.SupNum')>
	<cfset Session.SupNum = #Supervisor#>
</cfif>

<cfif (cgi.https eq "off") and 
	(cgi.SERVER_NAME does not contain "intranet")>
	<cflocation url="https://www.mesa.k12.co.us/apps/LeaveRequest/supervisor.cfm" addtoken="no">
	<cfabort>
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
	<cfform name="form2" method="post" action="" format="flash" width="500" height="550"  skin="haloblue">
		<cfformgroup type="panel" label="Request and Approval for Leave">
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
            <cflocation url="supervisor.cfm?requestid=#Session.Requestid#&amp;userid=#Session.emp_username#&amp;tryagain" addtoken="no">
        <cfelse>
            <!--- Set Session Variable username, building ect. --->
            <cfset Session.Username = '#getaccounts.Username#'>
            <cfset Session.Building = '#getaccounts.Building#'>
            <cfset Session.BuildingNum = '#getaccounts.building_number#'>
            <cfset Session.FullName = '#getaccounts.Full_Name#'>
            <cfset Session.Groups = '#getaccounts.Groups#'>
            <cfset Session.SSN = '#getaccounts.SocSecNum#'>
            <cflocation url="supervisor.cfm?StepNum=1&amp;#urlencodedformat(NOW())#" addtoken="no">
        </cfif>
    
    </cfif>
<cfelseif StepNum eq 1>
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
    
    <cfform name="ReviewedRequest" action="supervisor.cfm?StepNum=2" method="post">
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
                    <td>#requesteddates#</td>
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
                    <cfelseif #GetReq_info.Requesttype# eq 13>
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
            </table>
        </cfoutput>
        
        <table border="0" width="100%">
        	<tr>
            	<td align="center"><cfinput type="checkbox" label="I have Reviewed" name="reviewed" value="yes">I have reviewed this request on <cfoutput>#LSDateFormat(NOW(),'mm/dd/yyyy')#</cfoutput>
            </td></tr>
             <tr>
                	<td align="center"><cfinput type="submit" name="submit" value="submit"></td>
                </tr>
        </table>
        
    </cfform>
<cfelseif StepNum eq 2>
	<cfif isdefined('form.reviewed')>
    	<cfset Session.reviewed = 'Yes'>
    <cfelse>
    	<cfset Session.reviewed = 'No'>
    </cfif>
   	<cfoutput>#Session.SupNum#</cfoutput>
    <!--- Update Request --->
    <cfif #Session.SupNum# eq 1>
        <cfquery name="ViewedRequest" datasource="mesa_web">
            UPDATE LeaveReq_tblRequest
            SET	supviewed = '#Session.reviewed#',
                supvieweddate = '#LSDateFormat(NOW(),'mm/dd/yyyy')#'
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
    
    <cflocation url="supervisor.cfm?Stepnum=3">
<cfelseif StepNum eq 3>
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