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
<%@ page import="java.util.*,org.aspcfs.modules.admin.base.*,org.aspcfs.utils.StringUtils" %>
<jsp:useBean id="UserList" class="org.aspcfs.modules.admin.base.UserList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.admin.base.User" scope="request"/>
<html>
<head>
</head>
<body onload='page_init();'>
<script language='Javascript'>
function page_init() {
  var list = parent.document.forms['projectMemberForm'].elements['selTotalList'];
  list.options.length = 0;
<%
  Iterator i = UserList.iterator();
  while (i.hasNext()) {
    User thisUser = (User)i.next();
%>
  if ( !(inArray(parent.document.forms['projectMemberForm'].elements['selProjectList'], <%= thisUser.getId() %>)) ) {
    var newOpt = parent.document.createElement("OPTION");
    newOpt.text='<%= StringUtils.jsStringEscape(thisUser.getContact().getNameFirstLast()) %>';
    newOpt.value='<%= thisUser.getId() %>';
    list.options[list.length] = newOpt;
  }
  parent.initList(<%= thisUser.getId() %>);
<%
  }
%>
}

function inArray(a, s) {
	var i = 0;
	for(i=0; i < a.length; i++) {
		if (a.options[i].value == s) {
			return true;
		}
	}
	return false;
}
</script>
</body>
</html>

