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
<%@ page import="org.aspcfs.modules.admin.base.Permission, java.util.*" %>
<%@ include file="../initPage.jsp" %>
<jsp:useBean id="Role" class="org.aspcfs.modules.admin.base.Role" scope="request"/>
<jsp:useBean id="PermissionList" class="org.aspcfs.modules.admin.base.PermissionList" scope="request"/>
<body onLoad="javascript:document.forms[0].role.focus();">
<form action='Roles.do?command=InsertRole&auto-populate=true' method='post'>
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Admin.do">Admin</a> >
Add Role
</td>
</tr>
</table>
<%-- End Trails --%>
<input type="submit" value="Add" name="Save">
<input type="submit" value="Cancel" onClick="javascript:this.form.action='Roles.do?command=ListRoles'">
<br>
<dhv:formMessage />
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
	    <strong>Add a Role</strong>
	  </th>
  </tr>
  <tr>
    <td class="formLabel">Role Name</td>
    <td><input type="text" name="role" maxlength="80" value="<%= toHtmlValue(Role.getRole()) %>"><font color="red">*</font> <%= showAttribute(request, "roleError") %></td>
  </tr>
  <tr>
    <td class="formLabel">Description</td>
    <td nowrap><input type="text" name="description" size="60" maxlength="255" value="<%= toHtmlValue(Role.getDescription()) %>"><font color="red">*</font> <%= showAttribute(request, "descriptionError") %></td>
  </tr>
<%--
  <tr>
    <td class="formLabel">
      Portal Role
    </td>
    <td>
    <input type="checkbox" name="roleType" value="on" />
    </td>
  </tr>
--%>
</table>
&nbsp;
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="5">
	    <strong>Configure permissions for this role</strong>
	  </th>
  </tr>
<%
  Iterator i = PermissionList.iterator();
  int idCount = 0;
  while (i.hasNext()) {
    ++idCount;
    Permission thisPermission = (Permission)i.next();
    if (PermissionList.isNewCategory(thisPermission.getCategoryName())) {
%>
    <tr bgcolor="#E5E5E5">
      <td>
        <%= toHtml(thisPermission.getCategoryName()) %>
      </td>
      <td width="40" align="center">Access/<br>View</td>
      <td width="40" align="center">Add</td>
      <td width="40" align="center">Edit</td>
      <td width="40" align="center">Delete</td>
  </tr>
<%
   }
%>  
  <tr>
    <td>
      <input type="hidden" name="permission<%= idCount %>id" value="<%= thisPermission.getId() %>">
      <%= toHtml(thisPermission.getDescription()) %>
    </td>
    <td align="center">
      <% if(thisPermission.getView()){ %>
      <input type="checkbox" value="ON" name="permission<%= idCount %>view">
      <% } else{ %>
      --
    <% } %>
    </td>
    <td align="center">
    <% if(thisPermission.getAdd()){ %>
      <input type="checkbox" value="ON" name="permission<%= idCount %>add">
    <% } else{ %>
      --
    <% } %>
    </td>
    <td align="center">
    <% if(thisPermission.getEdit()){ %>
      <input type="checkbox" value="ON" name="permission<%= idCount %>edit">
    <% } else{ %>
      --
    <% } %>
    </td>
    <td align="center">
    <% if(thisPermission.getDelete()){ %> 
      <input type="checkbox" value="ON" name="permission<%= idCount %>delete">
    <% }else{ %>
      --
    <% } %>
    </td>
  </tr>
<%
  }
%>
</table>
<br>
<input type="submit" value="Add" name="Save">
<input type="submit" value="Cancel" onClick="javascript:this.form.action='Roles.do?command=ListRoles'">
</form>
</body>
