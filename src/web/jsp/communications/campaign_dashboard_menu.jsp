<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<script language="javascript">
  var thisCampaignId = -1;
  var menu_init = false;
  //Set the action parameters for clicked item
  function displayMenu(id, campaignId, cancel, download) {
    thisCampaignId = campaignId;
    updateMenu(cancel, download);
    if (!menu_init) {
      menu_init = true;
      new ypSlideOutMenu("menuCampaign", "down", 0, 0, 170, getHeight("menuCampaignTable"));
    }
    return ypSlideOutMenu.displayMenu(id);
  }
  
  //Update menu for this Contact based on permissions
  function updateMenu(hasCancelPermission, hasDownload){
    if(hasCancelPermission == 0){
      hideSpan('menuCancel');
    }else{
      showSpan('menuCancel');
    }
  }
  
  //Menu link functions
  function details() {
    window.location.href='CampaignManager.do?command=Details&id=' + thisCampaignId + '&reset=true';
  }
  
  function generateReport() {
    window.location.href='CampaignManager.do?command=ExportReport&id=' + thisCampaignId;
  }
  
  function cancel() {
    confirmForward('CampaignManager.do?command=Cancel&id=' + thisCampaignId + '&notify=true');
  }
</script>
<div id="menuCampaignContainer" class="menu">
  <div id="menuCampaignContent">
    <table id="menuCampaignTable" class="pulldown" width="170">
      <dhv:permission name="campaign-campaigns-view">
      <tr>
        <td>
          <img src="images/icons/stock_zoom-page-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </td>
        <td width="100%">
          <a href="javascript:details()">View Details</a>
        </td>
      </tr>
      </dhv:permission>
      <dhv:permission name="campaign-campaigns-view">
      <tr id="menuReport">
        <td>
          <img src="images/icons/stock_export-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </td>
        <td width="100%">
          <a href="javascript:generateReport()">Export to Excel</a>
        </td>
      </tr>
      </dhv:permission>
      <tr id="menuCancel">
        <td>
          <img src="images/icons/stock_stop-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </td>
        <td width="100%">
          <a href="javascript:cancel()">Cancel</a>
        </td>
      </tr>
    </table>
  </div>
</div>
