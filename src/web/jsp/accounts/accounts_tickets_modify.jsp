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
<%@ page import="java.util.*,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.troubletickets.base.*" %>
<%@ page import="java.text.DateFormat" %>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.accounts.base.Organization" scope="request"/>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.troubletickets.base.Ticket" scope="request"/>
<jsp:useBean id="DepartmentList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SeverityList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SourceList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="PriorityList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="CategoryList" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="UserList" class="org.aspcfs.modules.admin.base.UserList" scope="request"/>
<jsp:useBean id="SubList1" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="SubList2" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="SubList3" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="ContactList" class="org.aspcfs.modules.contacts.base.ContactList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="TimeZoneSelect" class="org.aspcfs.utils.web.HtmlSelectTimeZone" scope="request"/>
<%@ include file="../initPage.jsp" %>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popServiceContracts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popAssets.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popProducts.js"></script>
<script language="JavaScript">
  function updateSubList1() {
    var sel = document.forms['details'].elements['catCode'];
    var value = sel.options[sel.selectedIndex].value;
    var url = "TroubleTickets.do?command=CategoryJSList&catCode=" + escape(value);
    window.frames['server_commands'].location.href=url;
  }
  function updateSubList2() {
    var sel = document.forms['details'].elements['subCat1'];
    var value = sel.options[sel.selectedIndex].value;
    var url = "TroubleTickets.do?command=CategoryJSList&subCat1=" + escape(value);
    window.frames['server_commands'].location.href=url;
  }
  function updateSubList3() {
    var sel = document.forms['details'].elements['subCat2'];
    var value = sel.options[sel.selectedIndex].value;
    var url = "TroubleTickets.do?command=CategoryJSList&subCat2=" + escape(value);
    window.frames['server_commands'].location.href=url;
  }
  function updateUserList() {
    var sel = document.forms['details'].elements['departmentCode'];
    var value = sel.options[sel.selectedIndex].value;
    var url = "TroubleTickets.do?command=DepartmentJSList&departmentCode=" + escape(value);
    window.frames['server_commands'].location.href=url;
  }
  function changeDivContent(divName, divContents) {
    if(document.layers){
      // Netscape 4 or equiv.
      divToChange = document.layers[divName];
      divToChange.document.open();
      divToChange.document.write(divContents);
      divToChange.document.close();
    } else if(document.all){
      // MS IE or equiv.
      divToChange = document.all[divName];
      divToChange.innerHTML = divContents;
    } else if(document.getElementById){
      // Netscape 6 or equiv.
      divToChange = document.getElementById(divName);
      divToChange.innerHTML = divContents;
    }
  }
  function checkForm(form) {
    formTest = true;
    message = "";
    if (form.problem.value == "") { 
      message += "- Check that <dhv:label name="ticket.issue">Issue</dhv:label> is entered\r\n";
      formTest = false;
    }
    if (formTest == false) {
      alert("Form could not be saved, please check the following:\r\n\r\n" + message);
      return false;
    } else {
      return true;
    }
  }
  function resetNumericFieldValue(fieldId){
    document.getElementById(fieldId).value = -1;
  }
  function checkForm(form) {
    formTest = true;
    message = "";
    if (form.problem.value == "") { 
      message += "- Check that <dhv:label name="ticket.issue">Issue</dhv:label> is entered\r\n";
      formTest = false;
    }
    if (form.closeNow.checked && form.solution.value == "") { 
      message += "- Resolution needs to be filled in when closing a ticket\r\n";
      formTest = false;
    }
    if (formTest == false) {
      alert("Form could not be saved, please check the following:\r\n\r\n" + message);
      return false;
    } else {
      return true;
    }
  }
  
  function setAssignedDate(){
    resetAssignedDate();
    if (document.forms['details'].assignedTo.value > 0){
      document.forms['details'].assignedDate.value = document.forms['details'].currentDate.value;
    }
  }
  
  function resetAssignedDate(){
    document.forms['details'].assignedDate.value = '';
  }  
</script>
<body>
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Accounts.do"><dhv:label name="accounts.accounts">Accounts</dhv:label></a> > 
<a href="Accounts.do?command=Search">Search Results</a> >
<a href="Accounts.do?command=Details&orgId=<%=OrgDetails.getOrgId()%>"><dhv:label name="accounts.details">Account Details</dhv:label></a> >
<a href="Accounts.do?command=ViewTickets&orgId=<%=OrgDetails.getOrgId()%>"><dhv:label name="accounts.tickets.tickets">Tickets</dhv:label></a> >
<% if (request.getParameter("return") == null) {%>
<a href="AccountTickets.do?command=TicketDetails&id=<%=TicketDetails.getId()%>"><dhv:label name="accounts.tickets.details">Ticket Details</dhv:label></a> >
<%}%>
<dhv:label name="accounts.tickets.modify">Modify Ticket</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
<%@ include file="accounts_details_header_include.jsp" %>
<iframe src="empty.html" name="server_commands" id="server_commands" style="visibility:hidden" height="0"></iframe>
<% String param1 = "orgId=" + OrgDetails.getOrgId(); %>
<dhv:container name="accounts" selected="tickets" param="<%= param1 %>" style="tabs"/>
<table cellpadding="4" cellspacing="0" border="0" width="100%">
  <tr>
    <td class="containerBack">
          <%@ include file="accounts_ticket_header_include.jsp" %>
          <% String param2 = "id=" + TicketDetails.getId(); %>
          [ <dhv:container name="accountstickets" selected="details" param="<%= param2 %>"/> ]
          <br><br>
        <form name="details" action="AccountTickets.do?command=UpdateTicket&auto-populate=true" onSubmit="return checkForm(this);" method="post">    
        <% if (TicketDetails.getClosed() != null) { %>
              <input type="submit" value="Reopen" onClick="javascript:this.form.action='AccountTickets.do?command=ReopenTicket&id=<%=TicketDetails.getId()%>'">
            <% if ("list".equals(request.getParameter("return"))) {%>
              <input type="submit" value="Cancel" onClick="javascript:this.form.action='Accounts.do?command=ViewTickets&orgId=<%=OrgDetails.getOrgId()%>'">
            <%} else {%> 
              <input type="submit" value="Cancel" onClick="javascript:this.form.action='AccountTickets.do?command=TicketDetails&id=<%= TicketDetails.getId() %>'">
            <%}%>
        <%} else {%>
              <input type="submit" value="Update" onClick="return checkForm(this.form)">
            <% if ("list".equals(request.getParameter("return"))) {%>
              <input type="submit" value="Cancel" onClick="javascript:this.form.action='Accounts.do?command=ViewTickets&orgId=<%=OrgDetails.getOrgId()%>'">
            <%} else {%> 
              <input type="submit" value="Cancel" onClick="javascript:this.form.action='AccountTickets.do?command=TicketDetails&id=<%= TicketDetails.getId() %>'">
            <%}%>
              <%= showAttribute(request, "closedError") %>
        <%}%>
        <br />
        <dhv:formMessage />
        <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
          <tr>
            <th colspan="2">
              <strong><dhv:label name="accounts.tickets.information">Ticket Information</dhv:label></strong>
            </th>     
          </tr>
          <tr class="containerBody">
            <td class="formLabel">
              <dhv:label name="accounts.tickets.source">Ticket Source</dhv:label>
            </td>
            <td>
              <%= SourceList.getHtmlSelect("sourceCode",  TicketDetails.getSourceCode()) %>
            </td>
          </tr>
          <tr class="containerBody">
            <td nowrap class="formLabel">
              Contact
            </td>
            <td>
              <% if ( TicketDetails.getThisContact() == null ) {%>
                <%= ContactList.getHtmlSelect("contactId", 0 ) %>
              <%} else {%>
                <%= ContactList.getHtmlSelect("contactId", TicketDetails.getContactId() ) %>
              <%}%>
              <font color="red">*</font> <%= showAttribute(request, "contactIdError") %>
            </td>
          </tr>
          <tr class="containerBody">
          <td class="formLabel">
            Service Contract Number
          </td>
          <td>
           <table cellspacing="0" cellpadding="0" border="0" class="empty">
            <tr>
              <td>
                <div id="addServiceContract"><%= toHtml((TicketDetails.getContractId() != -1) ? TicketDetails.getServiceContractNumber() :"None Selected") %></div>
              </td>
              <td>
                <input type="hidden" name="contractId" id="contractId" value="<%= TicketDetails.getContractId() %>">
                <input type="hidden" name="serviceContractNumber" id="serviceContractNumber" value="<%= TicketDetails.getServiceContractNumber() %>">
                &nbsp;
                <%= showAttribute(request, "contractIdError") %>
                [<a href="javascript:popServiceContractListSingle('contractId','addServiceContract', 'filters=all|my|disabled', <%= TicketDetails.getOrgId() %>);">Select</a>]
                &nbsp [<a href="javascript:changeDivContent('addServiceContract','None Selected');javascript:resetNumericFieldValue('contractId');javascript:changeDivContent('addAsset','None Selected');javascript:resetNumericFieldValue('assetId');javascript:changeDivContent('addLaborCategory','None Selected');javascript:resetNumericFieldValue('productId');">Clear</a>] 
              </td>
            </tr>
          </table>
         </td>
        </tr>
        <tr class="containerBody">
          <td class="formLabel">
            Asset
          </td>
          <td>
           <table cellspacing="0" cellpadding="0" border="0" class="empty">
            <tr>
              <td>
                <div id="addAsset"><%= toHtml((TicketDetails.getAssetId() != -1) ? TicketDetails.getAssetSerialNumber():"None Selected")%></div>
              </td>
              <td>
                <input type="hidden" name="assetId" id="assetId" value="<%=  TicketDetails.getAssetId() %>">
                <input type="hidden" name="assetSerialNumber" id="assetSerialNumber" value="<%=  TicketDetails.getAssetSerialNumber() %>">
                &nbsp;
                <%= showAttribute(request, "assetIdError") %>
                [<a href="javascript:popAssetListSingle('assetId','addAsset', 'filters=allassets|undercontract','contractId','addServiceContract', <%= TicketDetails.getOrgId() %>);">Select</a>]
                &nbsp [<a href="javascript:changeDivContent('addAsset','None Selected');javascript:resetNumericFieldValue('assetId');">Clear</a>] 
             </td>
            </tr>
          </table>
         </td>
        </tr>
          <tr class="containerBody">
          <td class="formLabel">
            Labor Category
          </td>
          <td>
           <table cellspacing="0" cellpadding="0" border="0" class="empty">
            <tr>
              <td>
                <div id="addLaborCategory"><%= toHtml((TicketDetails.getProductId() != -1) ? TicketDetails.getProductSku() :"None Selected") %></div>
              </td>
              <td>
                <input type="hidden" name="productId" id="productId" value="<%=  TicketDetails.getProductId() %>">
                <input type="hidden" name="productSku" id="productSku" value="<%=  TicketDetails.getProductSku() %>">
                &nbsp;
                <%= showAttribute(request, "productIdError") %>
                [<a href="javascript:popProductListSingle('productId','addLaborCategory', 'filters=all|my|disabled');">Select</a>]
                &nbsp [<a href="javascript:changeDivContent('addLaborCategory','None Selected');javascript:resetNumericFieldValue('productId');">Clear</a>] 
              </td>
            </tr>
          </table>
         </td>
        </tr>
        </table>
        <br />
        <a name="categories"></a>
        <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
          <tr>
            <th colspan="2">
              <strong>Classification</strong>
            </th>
          </tr>
          <tr class="containerBody">
            <td class="formLabel" valign="top">
              <dhv:label name="ticket.issue">Issue</dhv:label>
            </td>
            <td>
              <table border="0" cellspacing="0" cellpadding="0" class="empty">
                <tr>
                  <td>
                    <textarea name="problem" cols="55" rows="8"><%= toString(TicketDetails.getProblem()) %></textarea>
                  </td>
                  <td valign="top">
                    <font color="red">*</font> <%= showAttribute(request, "problemError") %>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr class="containerBody">
            <td valign="top" class="formLabel">
              Location
            </td>
            <td>
              <input type="text" name="location" value="<%= toHtmlValue(TicketDetails.getLocation()) %>" size="50" maxlength="256" />
            </td>
          </tr>
          <dhv:include name="ticket.catCode" none="true">
          <tr class="containerBody">
            <td class="formLabel">
              Category
            </td>
            <td>
              <%= CategoryList.getHtmlSelect("catCode", TicketDetails.getCatCode()) %>
            </td>
          </tr>
          </dhv:include>
          <dhv:include name="ticket.subCat1" none="true">
          <tr class="containerBody">
            <td class="formLabel">
              Sub-level 1
            </td>
            <td>
              <%= SubList1.getHtmlSelect("subCat1", TicketDetails.getSubCat1()) %>
            </td>
          </tr>
          </dhv:include>
          <dhv:include name="ticket.subCat2" none="true">
          <tr class="containerBody">
            <td class="formLabel">
              Sub-level 2
            </td>
            <td>
              <%= SubList2.getHtmlSelect("subCat2", TicketDetails.getSubCat2()) %>
            </td>
          </tr>
          </dhv:include>
          <dhv:include name="ticket.subCat3" none="true">
          <tr class="containerBody">
            <td class="formLabel">
              Sub-level 3
            </td>
            <td>
              <%= SubList3.getHtmlSelect("subCat3", TicketDetails.getSubCat3()) %>
            </td>
          </tr>
          </dhv:include>
          <dhv:include name="ticket.severity" none="true">
          <tr class="containerBody">
            <td class="formLabel">
              Severity
            </td>
            <td>
              <%= SeverityList.getHtmlSelect("severityCode", TicketDetails.getSeverityCode()) %>
            </td>
          </tr>
          </dhv:include>
        </table>
        <br>
        <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
          <tr>
            <th colspan="2">
              <strong>Assignment</strong>
            </th>
          </tr>
          <dhv:include name="ticket.priority" none="true">
          <tr class="containerBody">
            <td class="formLabel">
              Priority
            </td>
            <td>
              <%= PriorityList.getHtmlSelect("priorityCode", TicketDetails.getPriorityCode()) %>
            </td>
          </tr>
          </dhv:include>
          <tr class="containerBody">
            <td class="formLabel">
              Department
            </td>
            <td>
              <%= DepartmentList.getHtmlSelect("departmentCode", TicketDetails.getDepartmentCode()) %>
            </td>
          </tr>
          <tr class="containerBody">
            <td nowrap class="formLabel">
              Resource Assigned
            </td>
            <td valign=center>
              <% UserList.setJsEvent("onChange=\"javascript:setAssignedDate();\"");%>
              <%= UserList.getHtmlSelect("assignedTo", TicketDetails.getAssignedTo() ) %>
            </td>
          </tr>
          <tr class="containerBody">
            <td nowrap class="formLabel">
              Assignment Date
            </td>
            <td>
              <zeroio:dateSelect form="details" field="assignedDate" timestamp="<%= TicketDetails.getAssignedDate() %>"  timeZone="<%= TicketDetails.getAssignedDateTimeZone() %>" showTimeZone="yes" />
              <%= showAttribute(request, "assignedDateError") %>
            </td>
          </tr>
          <tr class="containerBody">
            <td class="formLabel">
              Estimated Resolution Date
            </td>
            <td>
              <zeroio:dateSelect form="details" field="estimatedResolutionDate" timestamp="<%= TicketDetails.getEstimatedResolutionDate() %>" timeZone="<%= TicketDetails.getEstimatedResolutionDateTimeZone() %>"  showTimeZone="yes" />
              <%= showAttribute(request, "estimatedResolutionDateError") %>
            </td>
          </tr>
          <tr class="containerBody">
            <td class="formLabel" valign="top">
              Issue Notes
            </td>
            <td>
              <table border="0" cellspacing="0" cellpadding="0" class="empty">
                <tr>
                  <td>
                    <textarea name="comment" cols="55" rows="5"><%= toString(TicketDetails.getComment()) %></textarea>
                  </td>
                  <td valign="top">
                    <dhv:label name="accounts.tickets.ticket.previousTicket">(Previous notes for this ticket are listed under the history tab.)</dhv:label>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <br />
        <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
          <tr>
            <th colspan="2">
              <strong>Resolution</strong>
            </th>
          </tr>
          <tr class="containerBody">
            <td valign="top" class="formLabel">
              Cause
            </td>
            <td>
              <textarea name="cause" cols="55" rows="8"><%= toString(TicketDetails.getCause()) %></textarea>
            </td>
          </tr>
          <tr class="containerBody">
            <td class="formLabel" valign="top">
              Resolution
            </td>
            <td>
              <textarea name="solution" cols="55" rows="8"><%= toString(TicketDetails.getSolution()) %></textarea><br>
              <input type="checkbox" name="closeNow" value="true" <%= TicketDetails.getCloseIt() ? " checked" : ""%>><dhv:label name="accounts.tickets.ticket.close">Close ticket</dhv:label>
              <%--
              <br>
              <input type="checkbox" name="kbase" value="true">Add this solution to Knowledge Base
              --%>
            </td>
          </tr>
          <tr class="containerBody">
            <td class="formLabel">
              Resolution Date
            </td>
            <td>
        <zeroio:dateSelect form="details" field="resolutionDate" timestamp="<%= TicketDetails.getResolutionDate() %>"  timeZone="<%= TicketDetails.getResolutionDateTimeZone() %>"  showTimeZone="yes" />
              <%= showAttribute(request, "resolutionDateError") %>
            </td>
          </tr>
          <tr class="containerBody">
            <td class="formLabel">
              Have our services met or exceeded your expectations?
            </td>
            <td>
              <input type="radio" name="expectation" value="1" <%= (TicketDetails.getExpectation() == 1) ? " checked" : "" %>>Yes
              <input type="radio" name="expectation" value="0" <%= (TicketDetails.getExpectation() == 0) ? " checked" : "" %>>No
              <input type="radio" name="expectation" value="-1" <%= (TicketDetails.getExpectation() == -1) ? " checked" : "" %>>Undecided
            </td>
          </tr>
         </table>
        &nbsp;<br>
        <% if (TicketDetails.getClosed() != null) { %>
              <input type="submit" value="Reopen" onClick="javascript:this.form.action='AccountTickets.do?command=ReopenTicket&id=<%=TicketDetails.getId()%>'">
            <% if ("list".equals(request.getParameter("return"))) {%>
              <input type="submit" value="Cancel" onClick="javascript:this.form.action='Accounts.do?command=ViewTickets&orgId=<%=OrgDetails.getOrgId()%>'">
            <%} else {%> 
              <input type="submit" value="Cancel" onClick="javascript:this.form.action='AccountTickets.do?command=TicketDetails&id=<%= TicketDetails.getId() %>'">
            <%}%>
        <%} else {%>
              <input type="submit" value="Update" onClick="return checkForm(this.form)">
            <% if ("list".equals(request.getParameter("return"))) {%>
              <input type="submit" value="Cancel" onClick="javascript:this.form.action='Accounts.do?command=ViewTickets&orgId=<%=OrgDetails.getOrgId()%>'">
            <%} else {%> 
              <input type="submit" value="Cancel" onClick="javascript:this.form.action='AccountTickets.do?command=TicketDetails&id=<%= TicketDetails.getId() %>'">
            <%}%>
        <%}%>
     </td>
 </tr>
<input type="hidden" name="modified" value="<%= TicketDetails.getModified() %>">
<input type="hidden" name="orgId" value="<%=TicketDetails.getOrgId()%>">
<input type="hidden" name="id" value="<%= TicketDetails.getId() %>">
<input type="hidden" name="companyName" value="<%= toHtml(TicketDetails.getCompanyName()) %>">
<input type="hidden" name="close" value="">
<input type="hidden" name="refresh" value="-1">
<input type="hidden" name="currentDate" value="<%=  request.getAttribute("currentDate") %>" />
</form>
</table>
</body>
