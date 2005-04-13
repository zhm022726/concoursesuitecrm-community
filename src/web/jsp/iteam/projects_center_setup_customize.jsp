<%-- 
  - Copyright(c) 2004 Team Elements LLC (http://www.teamelements.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Team Elements LLC. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. TEAM ELEMENTS
  - LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
  - IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
  - PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
  - INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
  - EVENT SHALL TEAM ELEMENTS LLC OR ANY OF ITS AFFILIATES BE LIABLE FOR
  - ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
  - DAMAGES RELATING TO THE SOFTWARE.
  - 
  - Author(s): Matt Rajkowski
  - Version: $Id$
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,com.zeroio.iteam.base.*" %>
<jsp:useBean id="Project" class="com.zeroio.iteam.base.Project" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>
<script language="JavaScript" type="text/javascript" src="javascript/checkDate.js"></script>
<script language="JavaScript" type="text/javascript" src="javascript/popURL.js"></script>
<form method="POST" name="inputForm" action="ProjectManagement.do?command=UpdateFeatures&auto-populate=true">
<table border="0" cellpadding="1" cellspacing="0" width="100%">
  <tr class="subtab">
    <td>
      <img src="images/icons/stock_macro-objects-16.gif" border="0" align="absmiddle">
      <a href="ProjectManagement.do?command=ProjectCenter&section=Setup&pid=<%= Project.getId() %>"><dhv:label name="documents.permissions.setup">Setup</dhv:label></a> >
      <dhv:label name="project.customizeProject">Customize Project</dhv:label>
    </td>
  </tr>
</table>
<br>
<input type="submit" value="<dhv:label name="global.button.update">Update</dhv:label>">
<input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:window.location.href='ProjectManagement.do?command=ProjectCenter&section=Setup&pid=<%= Project.getId() %>'"><br>
&nbsp;
<table cellpadding="4" cellspacing="0" width="100%" class="pagedList">
  <input type="hidden" name="id" value="<%= Project.getId() %>">
  <input type="hidden" name="modified" value="<%= Project.getModified() %>">
  <tr>
    <th colspan="2" valign="center">
      <strong><dhv:label name="project.updateProjectFeatures">Update Project Features</dhv:label></strong>
    </th>
  </tr>
<%-- 
<dhv:evaluate if="<%= User.getAccessGuestProjects() %>">
  <tr class="containerBody">
    <td class="formLabel" valign="top">Global Settings</td>
    <td>
      <input type="checkbox" name="portal" value="ON"<%= Project.getPortal() ? " checked" : "" %>>
      Project is the default home page project for all users (including guests)<br>
      <input type="checkbox" name="allowGuests" value="ON"<%= Project.getAllowGuests() ? " checked" : "" %>>
      Guests are allowed to view this project, without logging in and without being a member of the project
    </td>
  </tr>
</dhv:evaluate>
--%>
  <tr class="containerBody">
    <td class="formLabel" valign="top"><dhv:label name="project.projectTabs">Project Tabs</dhv:label></td>
    <td>
      <table width="100%" class="empty">
        <tr>
          <td><dhv:label name="product.enabled">Enabled</dhv:label></td>
          <td><dhv:label name="project.tab">Tab</dhv:label></td>
          <td width="100%"><dhv:label name="project.label">Label</dhv:label></td>
        </tr>
        <tr>
          <td align="center"><input type="checkbox" name="showNews" value="ON"<%= Project.getShowNews() ? " checked" : "" %>></td>
          <td><dhv:label name="project.news">News</dhv:label></td>
          <td><input type="text" name="labelNews" value="<%= toHtmlValue(Project.getLabelNews()) %>" maxlength="50"/></td>
        </tr>
        <tr>
          <td align="center"><input type="checkbox" name="showDiscussion" value="ON"<%= Project.getShowDiscussion() ? " checked" : "" %>></td>
          <td><dhv:label name="project.discussion">Discussion</dhv:label></td>
          <td><input type="text" name="labelDiscussion" value="<%= toHtmlValue(Project.getLabelDiscussion()) %>" maxlength="50"/></td>
        </tr>
        <tr>
          <td align="center"><input type="checkbox" name="showDocuments" value="ON"<%= Project.getShowDocuments() ? " checked" : "" %>></td>
          <td><dhv:label name="accounts.accounts_documents_details.Documents">Documents</dhv:label></td>
          <td><input type="text" name="labelDocuments" value="<%= toHtmlValue(Project.getLabelDocuments()) %>" maxlength="50"/></td>
        </tr>
        <tr>
          <td align="center"><input type="checkbox" name="showLists" value="ON"<%= Project.getShowLists() ? " checked" : "" %>></td>
          <td><dhv:label name="project.lists">Lists</dhv:label></td>
          <td><input type="text" name="labelLists" value="<%= toHtmlValue(Project.getLabelLists()) %>" maxlength="50"/></td>
        </tr>
        <tr>
          <td align="center"><input type="checkbox" name="showPlan" value="ON"<%= Project.getShowPlan() ? " checked" : "" %>></td>
          <td><dhv:label name="project.plan">Plan</dhv:label></td>
          <td><input type="text" name="labelPlan" value="<%= toHtmlValue(Project.getLabelPlan()) %>" maxlength="50"/></td>
        </tr>
        <tr>
          <td align="center"><input type="checkbox" name="showTickets" value="ON"<%= Project.getShowTickets() ? " checked" : "" %>></td>
          <td><dhv:label name="dependency.tickets">Tickets</dhv:label></td>
          <td><input type="text" name="labelTickets" value="<%= toHtmlValue(Project.getLabelTickets()) %>" maxlength="50"/></td>
        </tr>
        <tr>
          <td align="center"><input type="checkbox" name="showAccounts" value="ON"<%= Project.getShowAccounts() ? " checked" : "" %>></td>
          <td><dhv:label name="documents.accounts.long_html">Accounts</dhv:label></td>
          <td><input type="text" name="labelAccounts" value="<%= toHtmlValue(Project.getLabelAccounts()) %>" maxlength="50"/></td>
        </tr>
        <tr>
          <td align="center"><input type="checkbox" name="showTeam" value="ON"<%= Project.getShowTeam() ? " checked" : "" %>></td>
          <td><dhv:label name="documents.team.long_html">Team</dhv:label></td>
          <td><input type="text" name="labelTeam" value="<%= toHtmlValue(Project.getLabelTeam()) %>" maxlength="50"/></td>
        </tr>
        <tr>
          <td align="center"><input type="checkbox" name="showDetails" value="ON"<%= Project.getShowDetails() ? " checked" : "" %>></td>
          <td><dhv:label name="contacts.details">Details</dhv:label></td>
          <td><input type="text" name="labelDetails" value="<%= toHtmlValue(Project.getLabelDetails()) %>" maxlength="50"/></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<br>
<input type="submit" value="<dhv:label name="global.button.update">Update</dhv:label>">
<input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:window.location.href='ProjectManagement.do?command=ProjectCenter&section=Setup&pid=<%= Project.getId() %>'">
</form>
