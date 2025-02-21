<cfif isDefined("fileUpload")>
  <cffile action="upload"
     fileField="fileUpload"
     destination="\\Loki\2003$\apps\LeaveRequest\Attachments\">
     <p>Thank you, your file has been uploaded.</p>
</cfif>
<form enctype="multipart/form-data" method="post">
<input type="file" name="fileUpload" /><br />
<input type="submit" value="Upload File" />
</form>