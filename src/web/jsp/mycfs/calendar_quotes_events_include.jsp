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
<%-- draws the quote events for a specific day --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="org.aspcfs.modules.quotes.base.Quote,org.aspcfs.modules.base.Constants" %>
<%
  QuoteEventList quoteEventList = (QuoteEventList) thisDay.get(category);
%>

<%-- include quotes --%>
<dhv:evaluate if="<%= quoteEventList.getTodaysQuotes().size() > 0 %>">
<table border="0">
  <tr>
    <td colspan="6" nowrap>
      <%-- event name --%>
      <img border="0" src="images/box.gif" align="texttop" title="Quotes"><a href="javascript:changeImages('todaysquotesimage<%=toFullDateString(thisDay.getDate()) %>','images/arrowdown.gif','images/arrowright.gif');javascript:switchStyle(document.getElementById('todaysquotesdetails<%=toFullDateString(thisDay.getDate()) %>'));" onMouseOver="window.status='View Details';return true;" onMouseOut="window.status='';return true;"><img src="<%= firstEvent ? "images/arrowdown.gif" : "images/arrowright.gif"%>" name="todaysquotesimage<%=toFullDateString(thisDay.getDate())%>" id="<%= firstEvent ? "0" : "1"%>" border="0" title="Click To View Details">Quotes pending your approval</a>&nbsp;(<%= quoteEventList.getTodaysQuotes().size() %>)
    </td>
  </tr>
</table>
<table border="0" id="todaysquotesdetails<%= toFullDateString(thisDay.getDate()) %>" style="<%= firstEvent ? "display:" : "display:none"%>">
  <%-- include quote details --%>
  <%
    Iterator j = quoteEventList.getTodaysQuotes().iterator();
    if(j.hasNext()){
  %>
    <tr>
      <th>
        &nbsp
      </th>
      <th class="weekSelector" nowrap>
        <strong>Quote #</strong>
      </th>
      <th class="weekSelector" nowrap>
        <strong>Due</strong>
      </th>
      <th class="weekSelector" width="100%">
        <strong>Description</strong>
      </th>
    </tr>
  <%  
      while(j.hasNext()){
      Quote thisQuote = (Quote) j.next();
      menuCount++;
    %>
    <tr>
     <td>
       <%-- Use the unique id for opening the menu, and toggling the graphics --%>
       <a href="javascript:displayQuoteMenu('select<%= menuCount %>','menuQuote', '<%=  thisQuote.getId() %>', '<%= thisQuote.getContactId() %>');"
       onMouseOver="over(0, <%= menuCount %>)" onmouseout="out(0, <%= menuCount %>);hideMenu('menuQuote');"><img src="images/select.gif" name="select<%= menuCount %>" id="select<%= menuCount %>" align="absmiddle" border="0"></a>
     </td>
     <td nowrap>
       <%= thisQuote.getId() %>
     </td>
     <td nowrap>
       <dhv:tz timestamp="<%= thisQuote.getExpirationDate() %>" timeOnly="true"/>
     </td>
     <td nowrap>
       <%= StringUtils.trimToSizeNoDots(toString(thisQuote.getShortDescription()), 30) %>
     </td>
    </tr>
   <% }
   } %>
</table>
</dhv:evaluate>



