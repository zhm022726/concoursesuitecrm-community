<%-- 
  - Copyright(c) 2004 Concursive Corporation (http://www.concursive.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Concursive Corporation. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. CONCURSIVE
  - CORPORATION MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
  - IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
  - PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
  - INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
  - EVENT SHALL CONCURSIVE CORPORATION OR ANY OF ITS AFFILIATES BE LIABLE FOR
  - ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
  - DAMAGES RELATING TO THE SOFTWARE.
  - 
  - Version: $Id$
  - Description:
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.contacts.base.*" %>
<%@ page import="java.text.DateFormat" %>
<jsp:useBean id="ContactDetails" class="org.aspcfs.modules.contacts.base.Contact" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/scrollReload.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<script type="text/javascript">
<% String param2 = addLinkParams(request, "popup|popupType|actionId");%>
function reopen() {
  scrollReload('CompanyDirectory.do?command=EmployeeDetails&empid=<%= ContactDetails.getId() %><%= param2 %>');
}
function reopenOnDelete() {
  try {
    if ('<%= isPopup(request) %>' != 'true') {
      scrollReload('CompanyDirectory.do?command=ListEmployees');
    } else {
      var contactId = -1;
      try {
        contactId = opener.reopenContact('<%= ContactDetails.getId() %>');
      } catch (oException) {
      }
      if (contactId != '<%= ContactDetails.getId() %>') {
        opener.reopen();
      }
    }
  } catch (oException) {
  }
  if ('<%= isPopup(request) %>' == 'true') {
    window.close();
  }
}

function reopenContact(id) {
  if (id == '<%= ContactDetails.getId() %>') {
    scrollReload('CompanyDirectory.do?command=ListEmployees');
    return id;
  } else {
    return '<%= ContactDetails.getId() %>';
  }
}
</script>
<form name="details" action="CompanyDirectory.do?command=ModifyEmployee&empid=<%= ContactDetails.getId() %>" method="post">
<dhv:evaluate if="<%= !isPopup(request) %>">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="CompanyDirectory.do?command=ListEmployees"><dhv:label name="employees.employees">Employees</dhv:label></a> >
<a href="CompanyDirectory.do?command=ListEmployees"><dhv:label name="employees.view">View Employees</dhv:label></a> >
<dhv:label name="employees.details">Employee Details</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
</dhv:evaluate>
<dhv:container name="employees" selected="details" object="ContactDetails" param='<%= "id=" + ContactDetails.getId() %>' appendToUrl='<%= addLinkParams(request, "popup|popupType|actionId") %>' hideContainer="<%= !ContactDetails.getEnabled() || ContactDetails.isTrashed() %>">
<dhv:evaluate if="<%= ContactDetails.getEnabled()  && !ContactDetails.isTrashed() %>">
  <dhv:permission name="contacts-internal_contacts-edit"><input type="button" value="<dhv:label name="global.button.modify">Modify</dhv:label>" onClick="javascript:this.form.action='CompanyDirectory.do?command=ModifyEmployee&empid=<%= ContactDetails.getId() %>';submit();"></dhv:permission>
  <dhv:permission name="contacts-internal_contacts-delete"><input type="button" value="<dhv:label name="global.button.delete">Delete</dhv:label>" onClick="javascript:popURLReturn('CompanyDirectory.do?command=ConfirmDelete&id=<%= ContactDetails.getId() %>&popup=true<%= isPopup(request) ? "&sourcePopup=true":"" %>','CompanyDirectory.do?command=ListEmployees', 'Delete_Employee','330','200','yes','no');"></dhv:permission>
  <dhv:permission name="contacts-internal_contacts-view"><input type="button" value="<dhv:label name="button.downloadVcard">Download VCard</dhv:label>" onClick="javascript:window.location.href='ExternalContacts.do?command=DownloadVCard&id=<%= ContactDetails.getId() %>'"/></dhv:permission>
  <dhv:permission name="contacts-internal_contacts-view,contacts-internal_contacts-edit,contacts-internal_contacts-delete"><br><br></dhv:permission>
</dhv:evaluate>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong><dhv:label name="accounts.accounts_details.PrimaryInformation">Primary Information</dhv:label></strong>
    </th>
  </tr>
  <dhv:evaluate if="<%= hasText(ContactDetails.getAdditionalNames()) %>">
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="accounts.accounts_add.additionalNames">Additional Names</dhv:label>
    </td>
    <td>
      <%= toHtml(ContactDetails.getAdditionalNames()) %>
    </td>
  </tr>
  </dhv:evaluate>
  <dhv:evaluate if="<%= hasText(ContactDetails.getNickname()) %>">
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="accounts.accounts_add.nickname">Nickname</dhv:label>
    </td>
    <td>
      <%= toHtml(ContactDetails.getNickname()) %>
    </td>
  </tr>
  </dhv:evaluate>
  <dhv:evaluate if="<%= ContactDetails.getBirthDate() != null %>">
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="accounts.accounts_add.dateOfBirth">Birthday</dhv:label>
    </td>
    <td>
      <zeroio:tz timestamp="<%= ContactDetails.getBirthDate() %>" dateOnly="true"/>
    </td>
  </tr>
  </dhv:evaluate>
  <tr class="containerBody">
    <td class="formLabel"><dhv:label name="accounts.accounts_contacts_add.Title">Title</dhv:label></td>
    <td><%= toHtml(ContactDetails.getTitle()) %></td>
  </tr>
  <dhv:evaluate if="<%= hasText(ContactDetails.getDepartmentName()) %>">
  <tr class="containerBody">
    <td class="formLabel"><dhv:label name="reports.employees.employees.department">Department</dhv:label></td>
    <td><%= toHtml(ContactDetails.getDepartmentName()) %></td>
  </tr>
  </dhv:evaluate>
  <dhv:evaluate if="<%= hasText(ContactDetails.getRole()) %>">
<tr class="containerBody">
  <td nowrap class="formLabel">
    <dhv:label name="accounts.accounts_add.role">Role</dhv:label>
  </td>
  <td>
    <%= toHtml(ContactDetails.getRole()) %>
  </td>
</tr>
</dhv:evaluate>
</table>
&nbsp;<br />
<dhv:include name="contact.emailAddresses" none="true">
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
	    <strong><dhv:label name="accounts.accounts_add.EmailAddresses">Email Addresses</dhv:label></strong>
	  </th>
  </tr>
<%  
  Iterator iemail = ContactDetails.getEmailAddressList().iterator();
  if (iemail.hasNext()) {
    while (iemail.hasNext()) {
      ContactEmailAddress thisEmailAddress = (ContactEmailAddress)iemail.next();
%>    
  <tr class="containerBody">
    <td nowrap class="formLabel"><%= toHtml(thisEmailAddress.getTypeName()) %></td>
    <td>
      <a href="mailto:<%= toHtml(thisEmailAddress.getEmail()) %>"><%= toHtml(thisEmailAddress.getEmail()) %></a>&nbsp;
<% if(!thisEmailAddress.getPrimaryEmail()) {%>
  &nbsp;
<%} else {%>
  <dhv:label name="account.primary.brackets">(Primary)</dhv:label>
<%}%>
    </td>
  </tr>
<%    
    }
       if(ContactDetails.getNoEmail()){
   %>
		<tr class="containerBody">
        <td class="formLabel" nowrap>
          <dhv:label name="accounts.accounts_contacts.emailPreference">Email Preference</dhv:label>
        </td>
        <td>
           <dhv:label name="accounts.accounts_contacts.noEmail">Do Not Email</dhv:label>
        </td>
      </tr>
   <%
   }
    
  } else {
%>
  <tr class="containerBody">
    <td colspan="2"><font color="#9E9E9E"><dhv:label name="contacts.NoEmailAdresses">No email addresses entered.</dhv:label></font></td>
  </tr>
<%}%>
</table>
&nbsp;<br />
</dhv:include>
<dhv:include name="contact.instantMessageAddresses" none="true">
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
    <tr>
      <th colspan="2">
        <strong><dhv:label name="accounts.accounts_add.InstantMessageAddresses">Instant Message Addresses</dhv:label></strong>
      </th>
    </tr>
  <%
    Iterator imAddress = ContactDetails.getInstantMessageAddressList().iterator();
    if (imAddress.hasNext()) {
      while (imAddress.hasNext()) {
        ContactInstantMessageAddress thisInstantMessageAddress = (ContactInstantMessageAddress)imAddress.next();
  %>
  <tr class="containerBody">
    <td class="formLabel">
      <%= toHtml(thisInstantMessageAddress.getAddressIMTypeName()) %>
    </td>
    <td>
      <dhv:evaluate if="<%= hasText(thisInstantMessageAddress.getAddressIM()) %>">
        <%= toHtml(thisInstantMessageAddress.getAddressIM()) %>
         (<%= toHtml(thisInstantMessageAddress.getAddressIMServiceName()) %>)
        <dhv:evaluate if="<%=thisInstantMessageAddress.getPrimaryIM()%>">
          <dhv:label name="account.primary.brackets">(Primary)</dhv:label>
        </dhv:evaluate>
      </dhv:evaluate>
      &nbsp;
    </td>
  </tr>
  <%
      }
     if(ContactDetails.getNoInstantMessage()){
   %>
		<tr class="containerBody">
        <td class="formLabel" nowrap>
          <dhv:label name="accounts.accounts_contacts.IMPreference">Instant Messages Preference</dhv:label>
        </td>
        <td>
           <dhv:label name="accounts.accounts_contacts.noIM">Do Not Instant Message</dhv:label>
        </td>
      </tr>
   <%
   }
      
    } else {
  %>
  <tr class="containerBody">
    <td>
      <font color="#9E9E9E"><dhv:label name="contacts.NoInstantMessageAddresses">No instant message addresses entered.</dhv:label></font>
    </td>
  </tr>
  <%}%>
</table>
  &nbsp;
</dhv:include>
<dhv:include name="contact.textMessageAddresses" none="true">
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong><dhv:label name="accounts.accounts_add.TextMessageAddresses">Text Message Addresses</dhv:label></strong>
    </th>
  </tr>
  <%
    Iterator itmAddress = ContactDetails.getTextMessageAddressList().iterator();
    if (itmAddress.hasNext()) {
      while (itmAddress.hasNext()) {
        ContactTextMessageAddress thisTextMessageAddress = (ContactTextMessageAddress)itmAddress.next();
  %>
    <tr class="containerBody">
      <td class="formLabel">
        <%= toHtml(thisTextMessageAddress.getTypeName()) %>
      </td>
      <td>
        <dhv:evaluate if="<%= hasText(thisTextMessageAddress.getTextMessageAddress()) %>">
        <a href="mailto:<%= toHtml(thisTextMessageAddress.getTextMessageAddress()) %>"><%= toHtml(thisTextMessageAddress.getTextMessageAddress()) %></a>&nbsp;
          <dhv:evaluate if="<%=thisTextMessageAddress.getPrimaryTextMessageAddress()%>">
            <dhv:label name="account.primary.brackets">(Primary)</dhv:label>
          </dhv:evaluate>
        </dhv:evaluate>
        &nbsp;
      </td>
    </tr>
  <%
      }
     if(ContactDetails.getNoTextMessage()){
   %>
		<tr class="containerBody">
        <td class="formLabel" nowrap>
          <dhv:label name="accounts.accounts_contacts.textMessagePreference">Text Messages Preference</dhv:label>
        </td>
        <td>
           <dhv:label name="accounts.accounts_contacts.noIM">Do Not Text Message</dhv:label>
        </td>
      </tr>
   <%
   }
      
    } else {
  %>
    <tr class="containerBody">
      <td>
        <font color="#9E9E9E"><dhv:label name="contacts.NoTextMessageAddresses">No text message addresses entered.</dhv:label></font>
      </td>
    </tr>
  <%}%>
</table>
&nbsp;
</dhv:include>
<dhv:include name="contact.phoneNumbers" none="true">
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
	    <strong><dhv:label name="accounts.accounts_add.PhoneNumbers">Phone Numbers</dhv:label></strong>
	  </th>
  </tr>
<%  
  Iterator inumber = ContactDetails.getPhoneNumberList().iterator();
  if (inumber.hasNext()) {
    while (inumber.hasNext()) {
      ContactPhoneNumber thisPhoneNumber = (ContactPhoneNumber)inumber.next();
%>    
  <tr class="containerBody">
    <td class="formLabel" nowrap><%= toHtml(thisPhoneNumber.getTypeName()) %></td>
    <td>
      <%= toHtml(thisPhoneNumber.getPhoneNumber()) %>&nbsp;
<% if(!thisPhoneNumber.getPrimaryNumber()) {%>
  &nbsp;
<%} else {%>
  <dhv:label name="account.primary.brackets">(Primary)</dhv:label>
<%}%>
    </td>
  </tr>
<%
    }
     if(ContactDetails.getNoPhone()){
   %>
		<tr class="containerBody">
        <td class="formLabel" nowrap>
          <dhv:label name="accounts.accounts_contacts.phonePreference">Phone Calls Preference</dhv:label>
        </td>
        <td>
           <dhv:label name="accounts.accounts_contacts.noPhone">Do Not Phone Call</dhv:label>
        </td>
      </tr>
   <%
   }
       if(ContactDetails.getNoFax()){
   %>
		<tr class="containerBody">
        <td class="formLabel" nowrap>
          <dhv:label name="accounts.accounts_contacts.faxPreference">Fax Preference</dhv:label>
        </td>
        <td>
           <dhv:label name="accounts.accounts_contacts.noFax">Do Not Fax</dhv:label>
        </td>
      </tr>
   <%
   }
    
  } else {
%>
  <tr class="containerBody">
    <td colspan="2"><font color="#9E9E9E"><dhv:label name="contacts.NoPhoneNumbers">No phone numbers entered.</dhv:label></font></td>
  </tr>
<%}%>
</table>
&nbsp;
</dhv:include>
<dhv:include name="contact.addresses" none="true">
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
	    <strong><dhv:label name="accounts.accounts_add.Addresses">Addresses</dhv:label></strong>
	  </th>
  </tr>
<%  
  Iterator iaddress = ContactDetails.getAddressList().iterator();
  if (iaddress.hasNext()) {
    while (iaddress.hasNext()) {
      ContactAddress thisAddress = (ContactAddress)iaddress.next();
%>    
    <tr class="containerBody">
      <td class="formLabel" valign="top" nowrap><%= toHtml(thisAddress.getTypeName()) %></td>
      <td>
        <%= toHtml(thisAddress.toString()) %>&nbsp;
<% if(!thisAddress.getPrimaryAddress()) {%>
  &nbsp;
<%} else {%>
  <dhv:label name="account.primary.brackets">(Primary)</dhv:label>
<%}%>
      </td>
    </tr>
<%    
    }
     if(ContactDetails.getNoMail()){
   %>
		<tr class="containerBody">
        <td class="formLabel" nowrap>
          <dhv:label name="accounts.accounts_contacts.mailPreference">Mail Preference</dhv:label>
        </td>
        <td>
           <dhv:label name="accounts.accounts_contacts.noMail">Do Not Mail</dhv:label>
        </td>
      </tr>
   <%
   } 
  } else {
%>
  <tr class="containerBody">
    <td colspan="2"><font color="#9E9E9E"><dhv:label name="contacts.NoAddresses">No addresses entered.</dhv:label></font></td>
  </tr>
<%}%>
</table>
<br />
</dhv:include>
<dhv:include name="contact.additionalDetails" none="true">
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
	    <strong><dhv:label name="accounts.accounts_add.AdditionalDetails">Additional Details</dhv:label></strong>
	  </th>
  </tr>
  <tr class="containerBody">
    <td class="formLabel" nowrap><dhv:label name="accounts.accounts_add.Notes">Notes</dhv:label></td>
    <td><%= toHtml(ContactDetails.getNotes()) %>&nbsp;</td>
  </tr>
</table>
&nbsp;
</dhv:include>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong><dhv:label name="accounts.accounts_contacts_calls_details.RecordInformation">Record Information</dhv:label></strong>
    </th>
  </tr>
  <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="accounts.accounts_calls_list.Entered">Entered</dhv:label>
    </td>
    <td>
      <dhv:username id="<%= ContactDetails.getEnteredBy() %>"/>
      <zeroio:tz timestamp="<%= ContactDetails.getEntered()  %>" timeZone="<%= User.getTimeZone() %>" showTimeZone="true" />
    </td>
  </tr>
  <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="accounts.accounts_contacts_calls_details.Modified">Modified</dhv:label>
    </td>
    <td>
      <dhv:username id="<%= ContactDetails.getModifiedBy() %>"/>
      <zeroio:tz timestamp="<%= ContactDetails.getModified()  %>" timeZone="<%= User.getTimeZone() %>" showTimeZone="true" />
    </td>
  </tr>
  <dhv:evaluate if="<%= hasText(ContactDetails.getImportName()) %>">
  <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="contact.importName">Import Name</dhv:label>
    </td>
    <td>
      <%= toHtml(ContactDetails.getImportName()) %>
    </td>
  </tr>
  </dhv:evaluate>
</table>
<dhv:evaluate if="<%= ContactDetails.getEnabled()  && !ContactDetails.isTrashed() %>">
  <dhv:permission name="contacts-internal_contacts-view,contacts-internal_contacts-edit,contacts-internal_contacts-delete"><br></dhv:permission>
  <dhv:permission name="contacts-internal_contacts-edit"><input type="button" value="<dhv:label name="global.button.modify">Modify</dhv:label>" onClick="javascript:this.form.action='CompanyDirectory.do?command=ModifyEmployee&empid=<%= ContactDetails.getId() %>';submit();"></dhv:permission>
  <dhv:permission name="contacts-internal_contacts-delete"><input type="button" value="<dhv:label name="global.button.delete">Delete</dhv:label>" onClick="javascript:popURLReturn('CompanyDirectory.do?command=ConfirmDelete&id=<%= ContactDetails.getId() %>&popup=true<%= isPopup(request) ? "&sourcePopup=true":"" %>','CompanyDirectory.do?command=ListEmployees', 'Delete_Employee','330','200','yes','no');"></dhv:permission>
  <dhv:permission name="contacts-internal_contacts-view"><input type="button" value="<dhv:label name="button.downloadVcard">Download VCard</dhv:label>" onClick="javascript:window.location.href='ExternalContacts.do?command=DownloadVCard&id=<%= ContactDetails.getId() %>'"/></dhv:permission>
</dhv:evaluate>
</dhv:container>
<%= addHiddenParams(request, "popup|popupType|actionId") %>
</form>

