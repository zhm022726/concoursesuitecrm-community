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
<%@ page import="org.aspcfs.utils.StringUtils" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="Message" class="org.aspcfs.modules.communications.base.Message" scope="request"/>
<jsp:useBean id="clientType" class="org.aspcfs.utils.web.ClientType" scope="session"/>
<jsp:useBean id="applicationPrefs" class="org.aspcfs.controller.ApplicationPrefs" scope="application"/>
<%@ include file="../initPage.jsp" %>
<%-- Editor must go here, before the body onload --%>
<dhv:evaluate if="<%= !clientType.showApplet() %>">
<jsp:include page="../htmlarea_include.jsp" flush="true"/>
<body onload="initEditor('messageText');document.addMessage.name.focus();">
</dhv:evaluate>
<%-- Use applet instead --%>
<dhv:evaluate if="<%= clientType.showApplet() %>">
<body onload="document.addMessage.name.focus();">
</dhv:evaluate>
<script language="JavaScript" type="text/javascript" src="javascript/checkDate.js"></script>
<script language="JavaScript" type="text/javascript" src="javascript/popCalendar.js"></script>
<script language="JavaScript">
  function checkForm(form) {
    var formTest = true;
    var messageText = "";
<dhv:evaluate if="<%= clientType.showApplet() %>">
    document.addMessage.messageText.value = document.Kafenio.getDocumentBody();
</dhv:evaluate>
    return true;
  }
</script>
<form name="addMessage" method="post" action="CampaignManagerMessage.do?command=Insert&auto-populate=true" onSubmit="return checkForm(this);">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="CampaignManager.do">Communications</a> >
<a href="CampaignManagerMessage.do?command=View">Message List</a> >
Add Message
</td>
</tr>
</table>
<%-- End Trails --%>
<input type="submit" value="Save Message">
<input type="submit" value="Cancel" onClick="javascript:this.form.action='CampaignManagerMessage.do?command=View'">
<br />
<dhv:formMessage />
<%@ include file="message_include.jsp" %>
<br>
<input type="submit" value="Save Message">
<input type="submit" value="Cancel" onClick="javascript:this.form.action='CampaignManagerMessage.do?command=View'">
</form>
</body>
