<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.contacts.base.*, org.aspcfs.modules.communications.base.Campaign" %>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.accounts.base.Organization" scope="request"/>
<jsp:useBean id="CampaignList" class="org.aspcfs.modules.communications.base.CampaignList" scope="request"/>
<jsp:useBean id="ContactDetails" class="org.aspcfs.modules.contacts.base.Contact" scope="request"/>
<jsp:useBean id="AccountContactMessageListInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="Campaign" class="org.aspcfs.modules.communications.base.Campaign" scope="request"/>
<%@ include file="../initPage.jsp" %>
<a href="Accounts.do">Account Management</a> > 
<a href="Accounts.do?command=View">View Accounts</a> >
<a href="Accounts.do?command=Details&orgId=<%=OrgDetails.getOrgId()%>">Account Details</a> >
<a href="Contacts.do?command=View&orgId=<%=OrgDetails.getOrgId()%>">Contacts</a> >
<a href="Contacts.do?command=Details&id=<%=ContactDetails.getId()%>">Contact Details</a> >
<a href="Contacts.do?command=ViewMessages&contactId=<%= ContactDetails.getId() %>">Messages</a> >
Message Details<br>
<hr color="#BFBFBB" noshade>
<%@ include file="accounts_details_header_include.jsp" %>
<dhv:container name="accounts" selected="contacts" param="<%= "orgId=" + OrgDetails.getOrgId() %>" style="tabs"/>
<table cellpadding="4" cellspacing="0" border="0" width="100%">
  <tr>
    <td class="containerBack">
    <% String param1 = "id=" + ContactDetails.getId(); 
    %>
        <strong><%= ContactDetails.getNameLastFirst() %>:</strong>
        [ <dhv:container name="accountscontacts" selected="messages" param="<%= param1 %>"/> ]
      <br>
      <br>
      <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
        <tr>
          <th colspan="2">
            <strong>Selected message</strong>
          </th>
        </tr>
        <tr class="containerBody">
          <td class="formLabel">
            Campaign
          </td>
          <td>
            <%=toHtml(Campaign.getName())%>
          </td>
        </tr>
        <tr class="containerBody">
          <td class="formLabel">
            Reply To
          </td>
          <td>
            <%=toHtml(Campaign.getReplyTo())%>
          </td>
        </tr>
        <tr class="containerBody">
          <td class="formLabel">
            Message Subject
          </td>
          <td>
            <%=toHtml(Campaign.getMessageName())%>
          </td>
        </tr>
        <tr class="containerBody">
          <td class="formLabel" valign="top">
            Message Text
          </td>
          <td>
            <%= (Campaign.getMessage()) %>&nbsp; 
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>