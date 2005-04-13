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
<%@ page  import="java.util.*" %>
<jsp:useBean id="errors" class="java.util.HashMap" scope="request"/>
<img src="images/error.gif" border="0" align="absmiddle"/>
<font color='red'><dhv:label name="errors.anErrorHasOccured">An Error Has Occurred</dhv:label></font>
<hr color="#BFBFBB" noshade>
<%
  String errorMessage = (String)request.getAttribute("Error");
  if (errorMessage != null) {
%>
<%= errorMessage %>
<%
  } else {
    Iterator errorList = errors.values().iterator();
    while (errorList.hasNext()) {
%>
  <%= (String)errorList.next() %><br>
<%  
    }
%>
<dhv:label name="errors.noFurtherInfoAvailable">No further information is available.</dhv:label>
<%
  }
%>
