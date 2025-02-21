<fusedoc fuse="adSecurity" language="ColdFusion">
      <responsibilities>
            I am a Custom Tag used to validate a userid/password
            against Active Directory and return back a bunch
            of information in the userinfo structure
      </responsibilities>
      <properties>
            <property name="version" value="1.02"/>
            <history author="Jeff Yokum" date="01/15/2003" type="created"/>
            <history author="Jeff Yokum" date="01/20/2003" type="updated">
                  Added errorCode return value to help determine why a user returned
                  invalid. Was it the credentials or was there a problem talking
                  with ActiveDirectory?
            </history>
            <history author="Jeff Yokum" date="01/22/2003" type="updated">
                  Fixed problem with blank passwords being supplied. If a blank
                  password is supplied to the cfldap tag, it returns an empty
                  recordset instead of throwing an error.
            </history>
      </properties>
      <io>
            <in>
                  <string name="username" scope="attributes"/>
                  <string name="password" scope="attributes"/>
                  <string name="ADserver" scope="attributes" default="myServerName" optional/>
                  <string name="ADdomain" scope="attributes" default="myDomainName.com" optional/>
                  <string name="ADstart" scope="attributes" default="DC=com,DC=myDomainName" optional/>
                  <string name="usernameX" scope="attributes" default="backupUsername" optional comments="If you need to override the username for secondary validation"/>
                  <string name="passwordX" scope="attributes" default="backupPassword" optional comments="If you need to override the password for secondary validation"/>
            </in>
            <out>
                  <structure name="userinfo" scope="caller">
                        <string name="validUser" comments="0=Invalid; 1=Valid" />
                        <string name="errorCode" comments="0=None; 1=Invalid User/Password; 2=ActiveDirectory problem"
                        <string name="firstName" comments="" />
                        <string name="middleInit" comments="" />
                        <string name="lastName" comments="" />
                        <string name="address" comments="" />
                        <string name="city" comments="" />
                        <string name="state" comments="" />
                        <string name="zip" comments="" />
                        <string name="email" comments="" />
                        <string name="phone" comments="" />
                        <string name="pager" comments="" />
                        <string name="mobile" comments="" />
                        <string name="fax" comments="" />
                        <string name="memberOf" comments="" />
                        <string name="dn" comments="" />
                        <string name="UAC" comments="userAccountControl" />
                  </structure>
            </out>
      </io>
</fusedoc>