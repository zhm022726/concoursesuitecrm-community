<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<script language="javascript">
  var thisConditionId = -1;
  var thisQuoteId = -1;
  var thisOtherId = -1;
  var thisLocation = '';
  var isCondition = false;
  var menu_init = false;
  //Set the action parameters for clicked item
  function displayMenuCondition(loc, id, quoteId, conditionId, otherId, location, isCon) {
    thisQuoteId = quoteId;
    thisConditionId = conditionId;
    thisOtherId = otherId;
    thisLocation = location;
    isCondition = isCon;
    if (!menu_init) {
      menu_init = true;
      new ypSlideOutMenu("menuQuoteCondition", "down", 0, 0, 170, getHeight("menuQuoteConditionTable"));
    }
    return ypSlideOutMenu.displayDropMenu(id, loc);
  }
  
  //Menu link functions
  function remove() {
    if (isCondition == 'true') {
      if(thisLocation == 'quotes') {
        scrollReload('QuotesConditions.do?command=RemoveCondition&quoteId=' + thisQuoteId+'&conditionId='+thisConditionId);
      } else if (thisLocation == 'accountsQuotes') {
        scrollReload('QuotesConditions.do?command=RemoveCondition&quoteId=' + thisQuoteId+'&conditionId='+thisConditionId+'&orgId='+thisOtherId);
      } else if (thisLocation == 'opportunitiesQuotes') {
        scrollReload('QuotesConditions.do?command=RemoveCondition&quoteId=' + thisQuoteId+'&conditionId='+thisConditionId+'&headerId='+thisOtherId+'<%= addLinkParams(request, "viewSource") %>');
      } else {
        alert(label("program.error.conditions","Programming Error. the location/module has to be specified for conditions"));
      }
    } else if (isCondition == 'false'){
      if(thisLocation == 'quotes') {
        scrollReload('QuotesConditions.do?command=RemoveRemark&quoteId='+thisQuoteId+'&remarkId='+thisConditionId);
      } else if (thisLocation == 'accountsQuotes') {
        scrollReload('QuotesConditions.do?command=RemoveRemark&quoteId='+thisQuoteId+'&remarkId='+thisConditionId+'&orgId='+thisOtherId);
      } else if (thisLocation == 'opportunitiesQuotes') {
        scrollReload('QuotesConditions.do?command=RemoveRemark&quoteId='+thisQuoteId+'&remarkId='+thisConditionId+'&headerId='+thisOtherId+'<%= addLinkParams(request, "viewSource") %>');
      } else {
        alert(label("program.error.remarks","Programming Error. the location/module has to be specified for remarks"));
      }
    }
  }
  
</script>
<div id="menuQuoteConditionContainer" class="menu">
  <div id="menuQuoteConditionContent">
    <table id="menuQuoteConditionTable" class="pulldown" width="80" cellspacing="0">
      <dhv:permission name="quotes-quotes-edit,accounts-quotes-edit">
      <tr onmouseover="cmOver(this)" onmouseout="cmOut(this)" onclick="remove();">
        <th>
          <img src="images/icons/stock_delete-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="button.remove">Remove</dhv:label>
        </td>
      </tr>
      </dhv:permission>
    </table>
  </div>
</div>
