/*
 *  Copyright(c) 2004 Dark Horse Ventures LLC (http://www.centriccrm.com/) All
 *  rights reserved. This material cannot be distributed without written
 *  permission from Dark Horse Ventures LLC. Permission to use, copy, and modify
 *  this material for internal use is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies. DARK HORSE
 *  VENTURES LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
 *  IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
 *  PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
 *  INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
 *  EVENT SHALL DARK HORSE VENTURES LLC OR ANY OF ITS AFFILIATES BE LIABLE FOR
 *  ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
 *  DAMAGES RELATING TO THE SOFTWARE.
 */
package org.aspcfs.apps.notifier;

import com.zeroio.iteam.base.FileItem;
import com.zeroio.iteam.base.FileItemList;
import org.aspcfs.apps.ReportBuilder;
import org.aspcfs.apps.common.ReportConstants;
import org.aspcfs.modules.accounts.base.Organization;
import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.admin.base.Usage;
import org.aspcfs.modules.base.Constants;
import org.aspcfs.modules.base.Notification;
import org.aspcfs.modules.base.Report;
import org.aspcfs.modules.communications.base.Campaign;
import org.aspcfs.modules.communications.base.CampaignList;
import org.aspcfs.modules.communications.base.Recipient;
import org.aspcfs.modules.communications.base.RecipientList;
import org.aspcfs.modules.contacts.base.Call;
import org.aspcfs.modules.contacts.base.CallList;
import org.aspcfs.modules.contacts.base.Contact;
import org.aspcfs.modules.contacts.base.ContactInformationFormatter;
import org.aspcfs.modules.contacts.base.ContactReport;
import org.aspcfs.modules.pipeline.base.OpportunityComponent;
import org.aspcfs.modules.pipeline.base.OpportunityComponentList;
import org.aspcfs.modules.pipeline.base.OpportunityHeader;
import org.aspcfs.modules.system.base.Site;
import org.aspcfs.modules.system.base.SiteList;
import org.aspcfs.utils.*;

import java.io.*;
import java.lang.reflect.Constructor;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.zip.ZipOutputStream;

/**
 *  Application that processes various kinds of Alerts in CFS, generating
 *  notifications for users. This application should not be maintained, but
 *  re-implemented to be module.
 *
 *@author     matt rajkowski
 *@created    October 16, 2001
 *@version    $Id$
 */
public class Notifier extends ReportBuilder {

  private HashMap config = new HashMap();
  private ArrayList taskList = new ArrayList();
  private java.sql.Timestamp today = null;
  private java.sql.Timestamp yesterday = null;

  /**
   *  Description of the Field
   */
  public final static String fs = System.getProperty("file.separator");
  public final static String lf = System.getProperty("line.separator");


  /**
   *  Constructor for the Notifier object public Notifier() { } ** Starts the
   *  process. Processes all of the enabled sites in the database.
   *
   *@param  args  Description of Parameter
   */
  public static void main(String args[]) {
    if (args.length == 0) {
      System.out.println("Usage: Notifier [config file]");
      System.out.println("ExitValue: 2");
    }
    Notifier thisNotifier = new Notifier();
    thisNotifier.execute(args);
    System.exit(0);
  }


  /**
   *  This method can be executed by another class because it does not call
   *  System.exit()
   *
   *@param  args  Description of the Parameter
   */
  public static void doTask(String args[]) {
    if (args.length == 0) {
      System.out.println("Usage: Notifier [config file]");
      System.out.println("ExitValue: 2");
    }
    Notifier thisNotifier = new Notifier();
    thisNotifier.execute(args);
    if (System.getProperty("DEBUG") != null) {
      System.out.println("ExitValue: 0");
    }
  }


  /**
   *  Description of the Method
   *
   *@param  args  Description of the Parameter
   */
  private void execute(String args[]) {
    String filename = args[0];
    if (args.length > 1) {
      //Task was specified on command line
      for (int taskCount = 1; taskCount < args.length; taskCount++) {
        this.getTaskList().add(args[taskCount]);
      }
    } else {
      //Temporary default list of tasks
      this.getTaskList().add("org.aspcfs.apps.notifier.task.NotifyOpportunityOwners");
      this.getTaskList().add("org.aspcfs.apps.notifier.task.NotifyCommunicationsRecipients");
      this.getTaskList().add("org.aspcfs.apps.notifier.task.NotifyCallOwners");
    }
    AppUtils.loadConfig(filename, this.config);
    if (config.containsKey("FILELIBRARY")) {
      this.baseName = (String) this.config.get("GATEKEEPER.URL");
      this.dbUser = (String) this.config.get("GATEKEEPER.USER");
      this.dbPass = (String) this.config.get("GATEKEEPER.PASSWORD");
      Connection db = null;
      try {
        SiteList siteList = SiteUtils.getSiteList(config);
        //Get the time range for the reports
        Calendar calToday = Calendar.getInstance();
        today = new java.sql.Timestamp(calToday.getTimeInMillis());

        Calendar calYesterday = Calendar.getInstance();
        calYesterday.set(Calendar.HOUR_OF_DAY, -25);
        yesterday = new java.sql.Timestamp(calYesterday.getTimeInMillis());

        if (System.getProperty("DEBUG") != null) {
          System.out.println("Notifier-> Start Date: " + yesterday.toString() + "\nAlert End Date: " + today.toString());
        }
        //Process each site
        if (System.getProperty("DEBUG") != null) {
          System.out.println("Notifier-> Processing each site");
        }
        Iterator i = siteList.iterator();
        while (i.hasNext()) {
          Site thisSite = (Site) i.next();
          Class.forName(thisSite.getDatabaseDriver());
          db = DriverManager.getConnection(
              thisSite.getDatabaseUrl(),
              thisSite.getDatabaseUsername(),
              thisSite.getDatabasePassword());
          this.baseName = thisSite.getSiteCode();
          //TODO: The intent is to move these all out as separate tasks and
          //have a TaskContext with an interface
          if (this.getTaskList().size() == 1) {
            Iterator classes = this.getTaskList().iterator();
            while (classes.hasNext()) {
              try {
                //Construct the object, which executes the task
                Class thisClass = Class.forName((String) classes.next());
                Class[] paramClass = new Class[]{Class.forName("java.sql.Connection"), HashMap.class, HashMap.class};
                Constructor constructor = thisClass.getConstructor(paramClass);
                Object[] paramObject = new Object[]{db, thisSite, this.getConfig()};
                Object theTask = constructor.newInstance(paramObject);
                theTask = null;
              } catch (Exception e) {
                e.printStackTrace(System.out);
              }
            }
          }
          if (this.getTaskList().contains("org.aspcfs.apps.notifier.task.NotifyOpportunityOwners")) {
            this.output.append(this.buildOpportunityAlerts(db, thisSite));
          }
          if (this.getTaskList().contains("org.aspcfs.apps.notifier.task.NotifyCommunicationsRecipients")) {
            this.output.append(this.buildCommunications(db, thisSite));
          }
          if (this.getTaskList().contains("org.aspcfs.apps.notifier.task.NotifyCallOwners")) {
            this.output.append(this.buildCallAlerts(db, thisSite));
          }
          db.close();
        }
        if (System.getProperty("DEBUG") != null) {
          System.out.println(this.output.toString());
        }
        //java.util.Date end = new java.util.Date();
      } catch (Exception exc) {
        exc.printStackTrace(System.out);
        System.err.println("Notifier-> BuildReport Error: " + exc.toString());
      } finally {
        if (db != null) {
          try {
            db.close();
            db = null;
          } catch (Exception e) {
          }
        }
      }
    }
  }


  /**
   *  Scans Opportunities for an Alert that is due today. The notification is
   *  stored so that repeat notifications are not sent.
   *
   *@param  db                Description of Parameter
   *@param  siteInfo          Description of the Parameter
   *@return                   Description of the Returned Value
   *@exception  SQLException  Description of Exception
   */
  private String buildOpportunityAlerts(Connection db, Site siteInfo) throws SQLException {
    Report thisReport = new Report();
    thisReport.setBorderSize(0);
    thisReport.addColumn("User");
    //Build the list
    OpportunityComponentList thisList = new OpportunityComponentList();
    thisList.setAlertRangeStart(yesterday);
    thisList.setAlertRangeEnd(today);
    thisList.buildList(db);
    int notifyCount = 0;
    Iterator i = thisList.iterator();
    while (i.hasNext()) {
      OpportunityComponent thisComponent = (OpportunityComponent) i.next();
      Notification thisNotification = new Notification();
      thisNotification.setHost((String) this.config.get("MAILSERVER"));
      thisNotification.setUserToNotify(thisComponent.getOwner());
      thisNotification.setModule("Opportunities");
      thisNotification.setItemId(thisComponent.getId());
      thisNotification.setItemModified(thisComponent.getAlertDate());
      if (thisNotification.isNew(db)) {
        OpportunityHeader thisOpportunity = new OpportunityHeader(db, thisComponent.getHeaderId());
        String relationshipType = null;
        String relationshipName = null;
        if (thisOpportunity.getAccountLink() > 0) {
          try {
            Organization thisOrganization = new Organization(db, thisOpportunity.getAccountLink());
            relationshipType = "Organization";
            relationshipName = thisOrganization.getName();
          } catch (Exception ignore) {
          }
        } else if (thisOpportunity.getContactLink() > 0) {
          try {
            Contact thisContact = new Contact(db, thisOpportunity.getContactLink());
            relationshipType = "Contact";
            relationshipName = thisContact.getNameFull();
          } catch (Exception ignore) {
          }
        }
        thisNotification.setFrom((String) this.config.get("EMAILADDRESS"));
        thisNotification.setSiteCode(baseName);
        thisNotification.setSubject("CRM Opportunity" + (relationshipName != null ? ": " + StringUtils.toHtml(relationshipName) : ""));
        thisNotification.setMessageToSend(
            ReportConstants.NOREPLY_DISCLAIMER + "<br>" +
            "<br>" +
            "The following opportunity component in Centric CRM has an alert set:<br>" +
            "<br>" +
            (relationshipType != null ?
            relationshipType + ": " + StringUtils.toHtml(relationshipName) + "<br>" : "") +
            "Opportunity Name: " + StringUtils.toHtml(thisOpportunity.getDescription()) + "<br>" +
            "Component Description: " + StringUtils.toHtml(thisComponent.getDescription()) + "<br>" +
            "Alert Text: " + StringUtils.toHtml(thisComponent.getAlertText()) + "<br>" +
            "Notes: " + StringUtils.toHtml(thisComponent.getNotes()) + "<br>" +
            "<br>" +
            generateCFSUrl(siteInfo, "LeadsComponents.do?command=DetailsComponent&id=" + thisComponent.getId()));
        thisNotification.setType(Notification.EMAIL);
        thisNotification.setTypeText(Notification.EMAIL_TEXT);
        thisNotification.notifyUser(db);
        ++notifyCount;
      }
      if (thisNotification.hasErrors()) {
        System.out.println("Notifier Error-> " + thisNotification.getErrorMessage());
        if (System.getProperty("DEBUG") != null) {
          System.out.println("Notifier-> Opportunity Component: " + thisComponent.getId());
        }
      }
    }
    thisReport.setHeader("Opportunity Alerts Report for " + start.toString() + lf + "Total Records: " + notifyCount);
    return thisReport.getDelimited();
  }


  /**
   *  Processes a list of calls to see if any alerts are due today that haven't
   *  already been alerted.
   *
   *@param  db                Description of Parameter
   *@param  siteInfo          Description of the Parameter
   *@return                   Description of the Returned Value
   *@exception  SQLException  Description of Exception
   */
  private String buildCallAlerts(Connection db, Site siteInfo) throws SQLException {
    Report thisReport = new Report();
    thisReport.setBorderSize(0);
    thisReport.addColumn("User");
    //Build the list
    CallList thisList = new CallList();
    thisList.setAlertRangeStart(yesterday);
    thisList.setAlertRangeEnd(today);
    thisList.buildList(db);
    int notifyCount = 0;
    Iterator i = thisList.iterator();
    while (i.hasNext()) {
      Call thisCall = (Call) i.next();
      Notification thisNotification = new Notification();
      thisNotification.setHost((String) this.config.get("MAILSERVER"));
      thisNotification.setUserToNotify(thisCall.getEnteredBy());
      thisNotification.setModule("Calls");
      thisNotification.setItemId(thisCall.getId());
      thisNotification.setItemModified(thisCall.getAlertDate());
      if (thisNotification.isNew(db)) {
        thisNotification.setSiteCode(baseName);
        thisNotification.setFrom((String) this.config.get("EMAILADDRESS"));
        thisNotification.setSubject(
            "Call Alert: " + thisCall.getSubject());
        thisNotification.setMessageToSend(
            ReportConstants.NOREPLY_DISCLAIMER + "<br>" +
            "<br>" +
            "The following activity in Centric CRM has an alert set: <br>" +
            "<br>" +
            "Contact: " + StringUtils.toHtml(thisCall.getContactName()) + "<br>" +
            "Notes: " + StringUtils.toHtml(thisCall.getNotes()) + "<br>" +
            "<br>" +
            generateCFSUrl(siteInfo, "ExternalContactsCalls.do?command=Details&id=" + thisCall.getId() + "&contactId=" + thisCall.getContactId()));
        thisNotification.setType(Notification.EMAIL);
        thisNotification.setTypeText(Notification.EMAIL_TEXT);
        thisNotification.notifyUser(db);
        ++notifyCount;
      }
      if (thisNotification.hasErrors()) {
        System.err.println("Notifier Error-> " + thisNotification.getErrorMessage());
      }
    }
    thisReport.setHeader("Opportunity Alerts Report for " + start.toString() + "<br>" + "Total Records: " + notifyCount);
    return thisReport.getDelimited();
  }


  /**
   *  Scans the Communications module to see if there are any recipients that
   *  need to be sent a message.
   *
   *@param  db             Description of Parameter
   *@param  siteInfo       Description of the Parameter
   *@return                Description of the Returned Value
   *@exception  Exception  Description of Exception
   */
  private String buildCommunications(Connection db, Site siteInfo) throws Exception {
    String dbName = siteInfo.getDatabaseName();
    Report thisReport = new Report();
    thisReport.setBorderSize(0);
    thisReport.addColumn("Report");
    //Build the list
    CampaignList thisList = new CampaignList();
    thisList.setActiveRangeStart(yesterday);
    thisList.setActiveRangeEnd(today);
    thisList.setActive(CampaignList.TRUE);
    thisList.setReady(CampaignList.TRUE);
    thisList.setEnabled(CampaignList.TRUE);
    thisList.buildList(db);
    if (System.getProperty("DEBUG") != null) {
      System.out.println("Notifier-> Active Campaigns: " + thisList.size());
    }

    //Get this database's key
    String filePath = (String) config.get("FILELIBRARY") + fs + dbName + fs + "keys" + fs;
    File f = new File(filePath);
    f.mkdirs();
    PrivateString thisKey = new PrivateString(filePath + "survey.key");

    //does the server support SSL
    String schema = "http";
    if ("true".equals((String) config.get("FORCESSL"))) {
      schema = "https";
    }
    //Process each campaign that is active and not processed
    Iterator i = thisList.iterator();
    int notifyCount = 0;
    while (i.hasNext()) {
      //Lock the campaign so the user cannot cancel, and so that another process
      //does not execute this campaign
      Campaign thisCampaign = (Campaign) i.next();
      thisCampaign.setStatusId(Campaign.STARTED);
      if (thisCampaign.lockProcess(db) != 1) {
        continue;
      }
      //Now that the campaign is locked, process it
      int campaignCount = 0;
      int sentCount = 0;
      ArrayList faxLog = new ArrayList();
      ContactReport letterLog = new ContactReport();

      //Read the file attachments list, and copy into another FileItemList
      //with the clientFilename, and the server's filename for the notification
      FileItemList attachments = new FileItemList();
      FileItemList fileItemList = new FileItemList();
      fileItemList.setLinkModuleId(Constants.COMMUNICATIONS_FILE_ATTACHMENTS);
      fileItemList.setLinkItemId(thisCampaign.getId());
      fileItemList.buildList(db);
      if (System.getProperty("DEBUG") != null) {
        System.out.println("Notifier-> Campaign file attachments: " + fileItemList.size());
      }
      Iterator files = fileItemList.iterator();
      while (files.hasNext()) {
        FileItem thisItem = (FileItem) files.next();
        FileItem actualItem = new FileItem();
        actualItem.setClientFilename(thisItem.getClientFilename());
        actualItem.setDirectory((String) config.get("FILELIBRARY") + fs + dbName + fs + "communications" + fs);
        actualItem.setFilename(thisItem.getFilename());
        actualItem.setSize(thisItem.getSize());
        attachments.add(actualItem);
      }

      //Load in the recipients
      RecipientList recipientList = new RecipientList();
      recipientList.setCampaignId(thisCampaign.getId());
      recipientList.setHasNullSentDate(true);
      recipientList.setBuildContact(false);
      recipientList.buildList(db);

      //Generate a campaign run --> Information about when a campaign was processed
      int runId = -1;
      Iterator iList = recipientList.iterator();
      if (iList.hasNext()) {
        runId = thisCampaign.insertRun(db);
      } else {
        thisCampaign.setStatusId(Campaign.ERROR);
        thisCampaign.setStatus("No Recipients");
        thisCampaign.update(db);
      }
      //Send each recipient a message
      while (iList.hasNext()) {
        ++campaignCount;
        Recipient thisRecipient = (Recipient) iList.next();
        Contact thisContact = new Contact(db, thisRecipient.getContactId());

        Notification thisNotification = new Notification();
        thisNotification.setHost((String) this.config.get("MAILSERVER"));
        thisNotification.setContactToNotify(thisContact.getId());
        thisNotification.setModule("Communications Manager");
        thisNotification.setDatabaseName(dbName);
        thisNotification.setItemId(thisCampaign.getId());
        thisNotification.setFileAttachments(attachments);
        thisNotification.setItemModified(thisCampaign.getActiveDate());
        if (thisNotification.isNew(db)) {
          thisNotification.setFrom(thisCampaign.getReplyTo());
          thisNotification.setSubject(thisCampaign.getSubject());
          thisNotification.setMessageIdToSend(thisCampaign.getMessageId());
          //If a survey is attached, encode the url for this recipient
          Template template = new Template();
          template.setText(thisCampaign.getMessage());
          String value = template.getValue("surveyId");
          if (value != null) {
            template.addParseElement("${surveyId=" + value + "}", java.net.URLEncoder.encode(PrivateString.encrypt(thisKey.getKey(), "id=" + value + ",cid=" + thisContact.getId()), "UTF-8"));
          }
          value = template.getValue("survey_url_address");
          if (value != null){
            String serverName = template.getValue("server_name");
            template.addParseElement("${server_name=" + serverName + "}", "");
          
            String addressCurrentURLParameters = java.net.URLEncoder.encode(PrivateString.encrypt(thisKey.getKey(), "addressNoChangeId=" + value + ",cid=" + thisContact.getId() + ",campaignId=" + thisCampaign.getId()), "UTF-8");
            String addressCurrentURL = "If this information is accurate click <a href=\"" + schema + "://" + serverName + "/ProcessAddressSurvey.do?id=" + addressCurrentURLParameters + "}\">here</a>";
            
            String addressUpdateURLParameters = java.net.URLEncoder.encode(PrivateString.encrypt(thisKey.getKey(), "addressSurveyId=" + value + ",cid=" + thisContact.getId() + ",campaignId=" + thisCampaign.getId()), "UTF-8");
            String addressUpdateURL = ", if you would like to update your contact information click <a href=\"" + schema + "://" + serverName + "/ProcessAddressSurvey.do?id=" + addressUpdateURLParameters + "}\">here</a>.";

            template.addParseElement("${survey_url_address="+ value + "}", "<br />" + addressCurrentURL + addressUpdateURL + "<br />");
          }
          value = template.getValue("addressSurveyId");
          if (value != null){
            template.addParseElement("${addressSurveyId=" + value + "}", java.net.URLEncoder.encode(PrivateString.encrypt(thisKey.getKey(), "addressSurveyId=" + value + ",cid=" + thisContact.getId() + ",campaignId=" + thisCampaign.getId()), "UTF-8"));
          }
          value = template.getValue("addressNoChangeId");
          if (value != null){
            template.addParseElement("${addressNoChangeId=" + value + "}", java.net.URLEncoder.encode(PrivateString.encrypt(thisKey.getKey(), "addressNoChangeId=" + value + ",cid=" + thisContact.getId() + ",campaignId=" + thisCampaign.getId()), "UTF-8"));
          }
          if (thisCampaign.getHasAddressRequest()) {
            String templateFilePath = (String) config.get("FILELIBRARY") + fs + dbName + fs + "templates.xml";
            String contactInformation = ContactInformationFormatter.getContactInformation(
                  thisContact, templateFilePath);
            value = template.getValue("contact_address");
            if (value != null){
              template.addParseElement("${contact_address=" + value + "}", ((contactInformation != null)?contactInformation:""));
            }
          }
          //NOTE: The following items are the same as the ProcessMessage.java items
          template.addParseElement("${name}", StringUtils.toHtml(thisContact.getNameFirstLast()));
          template.addParseElement("${firstname}", StringUtils.toHtml(thisContact.getNameFirst()));
          template.addParseElement("${lastname}", StringUtils.toHtml(thisContact.getNameLast()));
          template.addParseElement("${company}", StringUtils.toHtml(thisContact.getCompany()));
          template.addParseElement("${department}", StringUtils.toHtml(thisContact.getDepartmentName()));
          thisNotification.setMessageToSend(template.getParsedText());
          thisNotification.setType(thisCampaign.getSendMethodId());
          thisNotification.notifyContact(db);
          if (thisNotification.getType() == Notification.EMAIL || thisNotification.getType() == Notification.BROADCAST) {
            Usage emailUsage = new Usage();
            emailUsage.setEnteredBy(thisCampaign.getModifiedBy());
            emailUsage.setAction(Constants.USAGE_COMMUNICATIONS_EMAIL);
            emailUsage.setRecordId(thisCampaign.getId());
            emailUsage.setRecordSize(thisNotification.getSize());
            emailUsage.insert(db);
          }
          if (thisNotification.getFaxLogEntry() != null) {
            faxLog.add(thisNotification.getFaxLogEntry() + "|" + thisCampaign.getEnteredBy() + "|" + thisCampaign.getId());
          } else if (thisNotification.getContact() != null) {
            letterLog.add(thisNotification.getContact());
          }
          ++notifyCount;
          ++sentCount;
          thisRecipient.setRunId(runId);
          thisRecipient.setSentDate(new java.sql.Timestamp(System.currentTimeMillis()));
          thisRecipient.setStatusDate(new java.sql.Timestamp(System.currentTimeMillis()));
          thisRecipient.setStatusId(1);
          thisRecipient.setStatus(thisNotification.getStatus());
          if (System.getProperty("DEBUG") != null) {
            System.out.println("Notifier-> Notification status: " + thisNotification.getStatus());
          }
          thisRecipient.update(db);
        }
        if (thisNotification.hasErrors()) {
          System.out.println("Notifier Error-> " + thisNotification.getErrorMessage());
        }
      }
      if (campaignCount > 0) {
        outputLetterLog(thisCampaign, letterLog, dbName, db);
        outputFaxLog(faxLog, db, siteInfo);
        thisCampaign.setStatusId(Campaign.FINISHED);
        thisCampaign.setRecipientCount(campaignCount);
        thisCampaign.setSentCount(sentCount);
        thisCampaign.update(db);
      }
    }
    thisReport.setHeader("Communications Report for " + start.toString() + lf + "Total Records: " + notifyCount);
    return thisReport.getDelimited();
  }


  /**
   *  From a list of fax entries, a script is exported and executed to kick-off
   *  the fax process.
   *
   *@param  faxLog         Description of Parameter
   *@param  db             Description of the Parameter
   *@param  siteInfo       Description of the Parameter
   *@return                Description of the Returned Value
   *@exception  Exception  Description of the Exception
   */
  private boolean outputFaxLog(ArrayList faxLog, Connection db, Site siteInfo) throws Exception {
    if (System.getProperty("DEBUG") != null) {
      System.out.println("Notifier-> Outputting fax log");
    }
    if (faxLog == null || faxLog.size() == 0) {
      return false;
    }
    PrintWriter out = null;
    String baseDirectory = (String) config.get("FILELIBRARY") + fs + "faxFiles";
    if (baseDirectory != null && !baseDirectory.equals("")) {
      if (!baseDirectory.endsWith(fs)) {
        baseDirectory += fs;
      }
      File dir = new File(baseDirectory);
      dir.mkdirs();
    }
    SimpleDateFormat formatter1 = new SimpleDateFormat("yyyyMMddHHmmss");
    String uniqueScript = formatter1.format(new java.util.Date());
    try {
      out = new PrintWriter(new BufferedWriter(new FileWriter(baseDirectory + "cfsfax" + uniqueScript + ".sh")));
      Iterator faxEntries = faxLog.iterator();
      while (faxEntries.hasNext()) {
        String uniqueId = formatter1.format(new java.util.Date());
        String thisEntry = (String) faxEntries.next();
        StringTokenizer st = new StringTokenizer(thisEntry, "|");
        String databaseName = st.nextToken();
        String messageId = st.nextToken();
        String faxNumber = st.nextToken();
        String contactId = null;
        if (st.hasMoreTokens()) {
          contactId = st.nextToken();
        }
        String enteredBy = null;
        if (st.hasMoreTokens()) {
          enteredBy = st.nextToken();
        }
        String recordId = null;
        if (st.hasMoreTokens()) {
          recordId = st.nextToken();
        }

        if (!"false".equals((String) config.get("FAXENABLED"))) {
          //Faxing is enabled
          String baseFilename = baseDirectory + "cfsfax" + uniqueId + messageId + "-" + faxNumber;
          //Must escape the & for Linux shell script
          String url = "http://" + siteInfo.getVirtualHost() + "/ProcessMessage.do?code=" + siteInfo.getSiteCode() + "\\&messageId=" + messageId + (contactId != null ? "\\&contactId=" + contactId : "");
          if (HTTPUtils.convertUrlToPostscriptFile(url, baseFilename) == 1) {
            continue;
          }
          if (ImageUtils.convertPostscriptToTiffG3File(baseFilename) == 1) {
            continue;
          }
          File psFile = new File(baseFilename + ".ps");
          psFile.delete();

          //TODO: Create a wrapper class for HylaFax to simplify and reuse this

          //Info for log file which can be parsed later and queried against HylaFax
          out.println("echo \"### SendFax Script, transcript in .log file\"");
          out.println("echo \"# database:" + databaseName + "\"");
          out.println("echo \"# campaignId:" + recordId + "\"");
          out.println("echo \"# enteredBy:" + enteredBy + "\"");
          out.println("echo \"# contactId:" + contactId + "\"");
          //Fax command -- only removes file if sendfax is successful
          out.println(
              "sendfax -n " +
              "-h " + (String) config.get("FAXSERVER") + " " +
              "-d " + faxNumber + " " +
              baseFilename + ".tiff > " + baseDirectory + "cfsfax" + uniqueScript + ".log " +
              "&& rm " + baseFilename + ".tiff ");

          //Track usage
          //NOTE: Could add a URL post in the script to let the server know the file was actually faxed instead
          File faxFile = new File(baseFilename + ".tiff");
          if (faxFile.exists()) {
            Usage faxUsage = new Usage();
            faxUsage.setEnteredBy(Integer.parseInt(enteredBy));
            faxUsage.setAction(Constants.USAGE_COMMUNICATIONS_FAX);
            faxUsage.setRecordId(Integer.parseInt(recordId));
            faxUsage.setRecordSize(faxFile.length());
            faxUsage.insert(db);
          }
        }
      }
    } catch (IOException e) {
      e.printStackTrace(System.err);
      return false;
    } finally {
      if (out != null) {
        out.close();
      }
    }
    try {
      java.lang.Process process = java.lang.Runtime.getRuntime().exec(
          "/bin/sh " + baseDirectory + "cfsfax" + uniqueScript + ".sh");
    } catch (Exception e) {
      e.printStackTrace(System.out);
    }
    return true;
  }


  /**
   *  Saves a list of contacts to a file and inserts a file reference in the
   *  database.
   *
   *@param  thisCampaign   Description of Parameter
   *@param  contactReport  Description of Parameter
   *@param  dbName         Description of Parameter
   *@param  db             Description of Parameter
   *@return                Description of the Returned Value
   *@exception  Exception  Description of Exception
   */
  private boolean outputLetterLog(Campaign thisCampaign, ContactReport contactReport, String dbName, Connection db) throws Exception {
    if (System.getProperty("DEBUG") != null) {
      System.out.println("Notifier-> Outputting letter log");
    }
    if (contactReport == null || contactReport.size() == 0) {
      return false;
    }
    String filePath = (String) config.get("FILELIBRARY") + fs + dbName + fs + "campaign" + fs + CFSModule.getDatePath(new java.util.Date()) + fs;
    String baseFilename = contactReport.generateFilename();
    File f = new File(filePath);
    f.mkdirs();

    String[] fields = {"nameLast", "nameMiddle", "nameFirst", "company", "title", "department", "businessPhone", "businessAddress", "city", "state", "zip", "country"};
    contactReport.setCriteria(fields);
    contactReport.setFilePath(filePath);
    contactReport.setEnteredBy(0);
    contactReport.setModifiedBy(0);
    contactReport.setHeader(null);
    contactReport.buildReportBaseInfo();
    contactReport.buildReportHeaders();
    contactReport.buildReportData(null);
    CFSModule.saveTextFile(contactReport.getRep().getHtml(), filePath + baseFilename + ".html");

    //Stream communications data to Zip file
    ZipOutputStream zip = new ZipOutputStream(new FileOutputStream(filePath + baseFilename));
    ZipUtils.addTextEntry(zip, "contacts-" + baseFilename + ".csv", contactReport.getRep().getDelimited());

    //Get this database's key
    String keyFilePath = (String) config.get("FILELIBRARY") + fs + dbName + fs + "keys" + fs;
    File keys = new File(keyFilePath);
    keys.mkdirs();
    PrivateString thisKey = new PrivateString(keyFilePath + "survey.key");

    Template template = new Template();
    template.setText(thisCampaign.getMessage());
    String value = template.getValue("surveyId");
    if (value != null) {
      template.addParseElement("${surveyId=" + value + "}", java.net.URLEncoder.encode(PrivateString.encrypt(thisKey.getKey(), "id=" + value), "UTF-8"));
    }
    ZipUtils.addTextEntry(zip, "letter-" + baseFilename + ".html", template.getParsedText());
    zip.close();
    int fileSize = (int) (new File(filePath + baseFilename)).length();

    FileItem thisItem = new FileItem();
    thisItem.setLinkModuleId(Constants.COMMUNICATIONS_DOCUMENTS);
    thisItem.setLinkItemId(thisCampaign.getId());
    thisItem.setEnteredBy(thisCampaign.getEnteredBy());
    thisItem.setModifiedBy(thisCampaign.getModifiedBy());
    thisItem.setSubject("Campaign Mail Merge");
    thisItem.setVersion(1.0);
    thisItem.setClientFilename("cfs-" + baseFilename + ".zip");
    thisItem.setFilename(baseFilename);
    thisItem.setSize(fileSize);
    thisItem.insert(db);

    return true;
  }


  /**
   *  Description of the Method
   *
   *@param  siteInfo  Description of the Parameter
   *@param  url       Description of the Parameter
   *@return           Description of the Return Value
   */
  public String generateCFSUrl(Site siteInfo, String url) {
    String schema = "http";
    if ("true".equals((String) config.get("FORCESSL"))) {
      schema = "https";
    }
    return ("<a href=\"" + schema + "://" + siteInfo.getVirtualHost() + "/" + url + "\">" +
        "View in Centric CRM" +
        "</a>");
  }


  /**
   *  Gets the taskList attribute of the Notifier object
   *
   *@return    The taskList value
   */
  public ArrayList getTaskList() {
    return taskList;
  }


  /**
   *  Gets the config attribute of the Notifier object
   *
   *@return    The config value
   */
  public HashMap getConfig() {
    return config;
  }
}

