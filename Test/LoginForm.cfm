<cfif not isdefined('StepNum')>
	<cfset StepNum=0>
</cfif>

<cfif Stepnum eq 0>
	<!--- User Login --->
    <cfif not isdefined ('username') and not isdefined ('submitform')>
        <p>&nbsp; </p>
        <cfif isdefined('tryagain')>
            <pan class="red">Invalid Username or Password or you are unauthorized- - Try again</span>
            </div>
        </cfif>
        <cfform name="form2" method="post" action="" format="flash" width="500" height="550"  skin="haloblue">
            <cfformgroup type="panel" label="Request and Approval for Leave">
       			<cfinput name="username" type="text" size="20" label="Username:" onKeyDown="if(Key.isDown(Key.ENTER)) Submituser.dispatchEvent({type:'click'});">
                 <cfinput name="password" type="password" size="20" label="Password:" onkeydown="if(Key.isDown(Key.ENTER)) Submituser.dispatchEvent({type:'click'});">
    </td>
            <cfinput type="submit" name="Submituser" value="Submit">
            
            </cfformgroup>
        </cfform>
    </cfif>

	<!--- Check Username and Password --->
	<cfif isdefined ("submituser")>
        
		<!--- Test Validation vs AD --->
        <cfldap action="query" 
           server="honcho.mesa.k12.co.us" 
           name="GetAccounts" 
           start="DC=mesa,DC=k12,DC=co,DC=us"
           filter="(&(objectclass=user)(SamAccountName=#form.username#))"
           username="mesa\#form.username#" 
           password="#form.password#" 
           attributes = "cn,o,l,st,sn,c,mail,telephonenumber, givenname,homephone, streetaddress, postalcode, SamAccountname, physicalDeliveryOfficeName, department, memberof">
        <cfif #GetAccounts.RecordCount# gt 0>
			<cfset Session.Username = '#GetAccounts.cn#'>
            <cfset Session.Building = '#GetAccounts.physicaldeliveryofficename#'>
            <cfquery name="GetUserinfo" datasource="accounts">
                SELECT     
                    Accounts.Username, Accounts.Building, Building.building_number, Accounts.Full_Name, Accounts.Groups, Accounts.SocSecNum
                FROM         
                    Accounts INNER JOIN
                              Building ON Accounts.Building = Building.Building
                WHERE
                    (ACCOUNTS.USERNAME = '#session.username#')
        	</cfquery>
            <cfset Session.BuildingNum = ''>
            <!--- query to get rest of data --->
            <!---<cfoutput>o=#GetAccounts.o#</cfoutput><br>
            <cfoutput>l=#GetAccounts.l#</cfoutput><br>
            <cfoutput>st=#GetAccounts.st#</cfoutput><br>
            <cfoutput>sn=#GetAccounts.sn#</cfoutput><br>
            <cfoutput>mail=#GetAccounts.mail#</cfoutput><br>
            <cfoutput>tele=#GetAccounts.telephonenumber#</cfoutput><br>
            <cfoutput>given=#GetAccounts.givenname#</cfoutput><br>
            <cfoutput>home=#GetAccounts.homephone#</cfoutput><br>
            <cfoutput>street=#GetAccounts.streetaddress#</cfoutput><br>
            <cfoutput>postal=#GetAccounts.postalcode#</cfoutput><br>
            <cfoutput>sam=#GetAccounts.SamAccountname#</cfoutput><br>
            <cfoutput>phy=#GetAccounts.physicaldeliveryofficename#</cfoutput><br>
            <cfoutput>dept=#GetAccounts.department#</cfoutput><br>
            <cfoutput>mem=#GetAccounts.memberof#</cfoutput><br>--->
        </cfif>
        <!--- valid username and password 
        <cfif getaccounts.recordcount eq 0>
            <cflocation url="LoginForm.cfm?tryagain" addtoken="no">
        <cfelse>
            <!--- Check to see if log in is in HR --->
            <cfquery name="GetHR" datasource="mesa_web">
                SELECT Username
                FROM	LeaveReq_HRStaff
                WHERE	Username = '#username#'
            </cfquery>
            <cfif GetHR.RecordCount gt 0>
                <!--- Set Session Variable username, building ect. --->
                <cfset Session.Username = ''>
                <cfset Session.Building = ''>
                <cfset Session.BuildingNum = ''>
                <cfset Session.FullName = ''>
                <cfset Session.Groups = ''>
                <cfset Session.SSN = ''>
                <cflocation url="LoginForm.cfm?StepNum=1&#urlencodedformat(NOW())#" addtoken="no">
            <cfelse>
                <cflocation url="LoginForm.cfm?tryagain" addtoken="no">
            </cfif>
        </cfif>--->
    </cfif>
<cfelseif StepNum eq 1>
</cfif>