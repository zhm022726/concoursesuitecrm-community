<%@ page import="java.util.*,com.darkhorseventures.cfsbase.*" %>
<jsp:useBean id="OrgDetails" class="com.darkhorseventures.cfsbase.Organization" scope="request"/>
<jsp:useBean id="OppDetails" class="com.darkhorseventures.cfsbase.Opportunity" scope="request"/>
<%@ include file="initPage.jsp" %>
<script language="JavaScript" TYPE="text/javascript" SRC="/javascript/confirmDelete.js"></script>
<form name="oppdet" action="/Opportunities.do?id=<%=OppDetails.getId()%>&orgId=<%= OppDetails.getAccountLink() %>&contactId=<%= OppDetails.getContactLink() %>" method="post">
<a href="/Opportunities.do?command=View&orgId=<%= OppDetails.getAccountLink() %>">Back to Opportunities List</a><br>&nbsp;
<table cellpadding="4" cellspacing="0" border="1" width="100%" bordercolorlight="#000000" bordercolor="#FFFFFF">
  <tr class="containerHeader">
    <td>
      <strong><%= toHtml(OrgDetails.getName()) %></strong>
    </td>
  </tr>
  <tr class="containerMenu">
    <td>
      <a href="/Accounts.do?command=Details&orgId=<%=OrgDetails.getOrgId()%>"><font color="#000000">Details</font></a> | 
      <a href="/Accounts.do?command=Fields&orgId=<%= OrgDetails.getOrgId() %>"><font color="#000000">Folders</font></a> |
      <font color="#787878">Activities</font> | 
      <a href="/Contacts.do?command=View&orgId=<%=OrgDetails.getOrgId()%>"><font color="#000000">Contacts</font></a> | 
      <a href="/Opportunities.do?command=View&orgId=<%=OrgDetails.getOrgId()%>"><font color="#0000FF">Opportunities</font></a> | 
      <a href="/Accounts.do?command=ViewTickets&orgId=<%= OrgDetails.getOrgId() %>"><font color="#000000">Tickets</font></a> |
      <a href="AccountsDocuments.do?command=View&orgId=<%=OrgDetails.getOrgId()%>"><font color="#000000">Documents</font></a>
    </td>
  </tr>
  <tr>
    <td class="containerBack">
<input type=hidden name="command" value="<%= OppDetails.getId() %>">
<input type=button name="action" value="Modify"	onClick="document.oppdet.command.value='Modify';document.oppdet.submit()">
<input type=button name="action" value="Delete" onClick="document.oppdet.command.value='Delete';document.oppdet.submit()">
<br>
&nbsp;
<table cellpadding="4" cellspacing="0" border="1" width="100%" bordercolorlight="#000000" bordercolor="#FFFFFF">
  <tr class="title">
    <td colspan=2 valign=center align=left>
      <strong><%= toHtml(OppDetails.getDescription()) %></strong>
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      Owner
    </td>
    <td valign=center width=100%>
      <%= OppDetails.getOwnerName() %>
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      Prob. of Close
    </td>
    <td valign=center width=100%>
      <%= OppDetails.getCloseProbValue() %>%
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      Est. Close Date
    </td>
    <td>
      <%= OppDetails.getCloseDateString() %>&nbsp;
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      Low Estimate
    </td>
    <td>
      $<%= OppDetails.getLowCurrency() %>&nbsp;
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      Best Guess
    </td>
    <td>
      $<%= OppDetails.getGuessCurrency() %>&nbsp;
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      High Estimate
    </td>
    <td>
      $<%= OppDetails.getHighCurrency() %>&nbsp;
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      Current Stage
    </td>
    <td>
      <%= toHtml(OppDetails.getStageName()) %>&nbsp;
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      Current Stage Date
    </td>
    <td>
      <%= toHtml(OppDetails.getStageDateString()) %>&nbsp;
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      Est. Commission
    </td>
    <td>
      <%= OppDetails.getCommissionValue() %>%
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      Alert Date
    </td>
    <td>
      <%= toHtml(OppDetails.getAlertDateString()) %>&nbsp;
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      Entered
    </td>
    <td>
      <%= OppDetails.getEnteredByName() %>&nbsp;-&nbsp;<%= OppDetails.getEnteredString() %>
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      Modified
    </td>
    <td>
      <%= OppDetails.getModifiedByName() %>&nbsp;-&nbsp;<%= OppDetails.getModifiedString() %>
    </td>
  </tr>
</table>
&nbsp;
<br>
<input type=button name="action" value="Modify"	onClick="document.oppdet.command.value='Modify';document.oppdet.submit()">
<input type=button name="action" value="Delete" onClick="document.oppdet.command.value='Delete';document.oppdet.submit()">
  </td>
  </tr>
</table>
</form>
