<%-- 
  - Copyright(c) 2004 Dark Horse Ventures LLC (http://www.centriccrm.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Dark Horse Ventures LLC. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. DARK HORSE
  - VENTURES LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
  - IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
  - PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
  - INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
  - EVENT SHALL DARK HORSE VENTURES LLC OR ANY OF ITS AFFILIATES BE LIABLE FOR
  - ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
  - DAMAGES RELATING TO THE SOFTWARE.
  - 
  - Version: $Id$
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.utils.web.*,java.util.*,org.aspcfs.modules.assets.base.*,org.aspcfs.modules.servicecontracts.base.*,java.text.DateFormat" %>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.accounts.base.Organization" scope="request"/>
<jsp:useBean id="serviceContractList" class="org.aspcfs.modules.servicecontracts.base.ServiceContractList" scope="request"/>
<jsp:useBean id="serviceContractCategoryList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="serviceContractTypeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ServiceContractListInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>
<%-- Initialize the drop-down menus --%>
<%@ include file="../initPopupMenu.jsp" %>
<%@ include file="sc_list_menu.jsp" %>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></SCRIPT>
<script language="JavaScript" type="text/javascript">
  <%-- Preload image rollovers for drop-down menu --%>
  loadImages('select');
</script>
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Accounts.do"><dhv:label name="accounts.accounts">Accounts</dhv:label></a> > 
<a href="Accounts.do?command=Search">Search Results</a> >
<a href="Accounts.do?command=Details&orgId=<%=OrgDetails.getOrgId()%>"><dhv:label name="accounts.details">Account Details</dhv:label></a> >
Service Contracts
</td>
</tr>
</table>
<%-- End Trails --%>
<%@ include file="accounts_details_header_include.jsp" %>
<dhv:container name="accounts" selected="servicecontracts" param="<%= "orgId=" + OrgDetails.getOrgId() %>" style="tabs"/>
<table cellpadding="4" cellspacing="0" border="0" width="100%">
  <tr>
    <td class="containerBack">
<%-- Begin the container contents --%>
<dhv:permission name="accounts-service-contracts-add">
  <a href="AccountsServiceContracts.do?command=Add&orgId=<%=OrgDetails.getOrgId()%>">Add a Service Contract</a>
</dhv:permission>
<dhv:permission name="accounts-service-contracts-add" none="true"></dhv:permission>
<dhv:pagedListStatus title="<%= showError(request, "actionError") %>" object="ServiceContractListInfo"/>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="pagedList">
  <tr>
    <th>
      <strong>Action</strong>
    </th>
    <th width="20%" nowrap>
      <strong>Contract Number</strong>
    </th>
    <th width="20%" >
      <strong>Category</strong>
    </th>
    <th width="20%" nowrap>
      <strong>Type</strong>
    </th>
    <th width="20%">
      <strong>Current Contract Date</strong>
    </th>
    <th width="20%" nowrap>
      <strong>End Date</strong>
    </th>
  </tr>
  
  <% 
    Iterator itr = serviceContractList.iterator();
    if (itr.hasNext()){
      int rowid = 0;
      int i = 0;
      while (itr.hasNext()){
        i++;
        rowid = (rowid != 1 ? 1 : 2);
        ServiceContract thisContract = (ServiceContract)itr.next();
    %>      
    <tr class="row<%= rowid %>">
      <td width="8" valign="center" nowrap>
          <% int status = -1;%>
          <% status = OrgDetails.getEnabled() ? 1 : 0; %>
          <%-- Use the unique id for opening the menu, and toggling the graphics --%>
           <a href="javascript:displayMenu('select<%= i %>','menuServiceContract', '<%=request.getParameter("orgId") %>', '<%= thisContract.getId() %>');"
           onMouseOver="over(0, <%= i %>)" onmouseout="out(0, <%= i %>); hideMenu('menuServiceContract');"><img src="images/select.gif" name="select<%= i %>" id="select<%= i %>" align="absmiddle" border="0" /></a>
      </td>
      <td width="20%">
        <a href="AccountsServiceContracts.do?command=View&orgId=<%=request.getParameter("orgId")%>&id=<%= thisContract.getId()%>"><%= toHtml(thisContract.getServiceContractNumber()) %></a>
      </td>
      <td width="20%">
      <dhv:evaluate if="<%= thisContract.getCategory() > 0 %>">
        <%= toHtml(serviceContractCategoryList.getSelectedValue(thisContract.getCategory())) %>
      </dhv:evaluate>&nbsp;
      </td>
      <td width="20%" >
      <dhv:evaluate if="<%= thisContract.getType() > 0 %>">
        <%= toHtml(serviceContractTypeList.getSelectedValue(thisContract.getType())) %>
      </dhv:evaluate>&nbsp;
      </td>
      <td width="20%">
        <% if(!User.getTimeZone().equals(thisContract.getCurrentStartDateTimeZone())){%>
        <zeroio:tz timestamp="<%= thisContract.getCurrentStartDate() %>" timeZone="<%= User.getTimeZone() %>" showTimeZone="yes" default="&nbsp;"/>
        <% } else { %>
        <zeroio:tz timestamp="<%= thisContract.getCurrentStartDate() %>" dateOnly="true" timeZone="<%= thisContract.getCurrentStartDateTimeZone() %>" showTimeZone="yes" default="&nbsp;"/>
        <% } %>
      </td>
      <td width="20%"  nowrap>
        <% if(!User.getTimeZone().equals(thisContract.getCurrentEndDateTimeZone())){%>
        <zeroio:tz timestamp="<%= thisContract.getCurrentEndDate() %>" timeZone="<%= User.getTimeZone() %>" showTimeZone="yes" default="&nbsp;"/>
        <% } else {%>
        <zeroio:tz timestamp="<%= thisContract.getCurrentEndDate() %>" dateOnly="true" timeZone="<%= thisContract.getCurrentEndDateTimeZone() %>" showTimeZone="yes" default="&nbsp;"/>
        <% } %>
      </td>
    </tr>
    <%  
      }
    }else{
    %>
    <tr class="containerBody">
      <td colspan="6">
        No service contracts found.
      </td>
    </tr>
    <%
    }
    %>
</table>
  <br>
  <dhv:pagedListControl object="ServiceContractListInfo"/>
</td>
</tr>
</table>
