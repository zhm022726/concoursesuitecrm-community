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
package org.aspcfs.modules.pipeline.base;

import com.darkhorseventures.framework.actions.ActionContext;
import org.aspcfs.modules.base.Constants;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.web.PagedListInfo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Iterator;

/**
 * Container for OpportunityHeader objects
 *
 * @author chris
 * @version $Id: OpportunityHeaderList.java,v 1.3 2003/01/07 20:21:45
 *          mrajkowski Exp $
 * @created December, 2003
 */
public class OpportunityHeaderList extends ArrayList {

  protected PagedListInfo pagedListInfo = null;
  protected int orgId = -1;
  protected int contactId = -1;
  protected int owner = -1;
  protected String ownerIdRange = null;
  protected ArrayList ignoreTypeIdList = new ArrayList();
  protected String description = null;
  protected int enteredBy = -1;
  protected boolean hasAlertDate = false;
  protected java.sql.Date alertDate = null;
  protected String accountOwnerIdRange = null;
  protected java.sql.Date alertRangeStart = null;
  protected java.sql.Date alertRangeEnd = null;
  protected java.sql.Date closeDateStart = null;
  protected java.sql.Date closeDateEnd = null;
  private boolean queryOpenOnly = false;
  private boolean queryClosedOnly = false;

  private java.sql.Timestamp trashedDate = null;
  private boolean includeOnlyTrashed = false;

  private boolean buildTotalValues = false;
  //gets the component count and total value owned by the specificied user
  private int componentsOwnedByUser = -1;


  /**
   * Constructor for the OpportunityHeaderList object
   */
  public OpportunityHeaderList() {
  }


  /**
   * Sets the pagedListInfo attribute of the OpportunityHeaderList object
   *
   * @param tmp The new pagedListInfo value
   */
  public void setPagedListInfo(PagedListInfo tmp) {
    this.pagedListInfo = tmp;
  }


  /**
   * Sets the orgId attribute of the OpportunityHeaderList object
   *
   * @param tmp The new orgId value
   */
  public void setOrgId(String tmp) {
    this.orgId = Integer.parseInt(tmp);
  }


  /**
   * Sets the orgId attribute of the OpportunityHeaderList object
   *
   * @param tmp The new orgId value
   */
  public void setOrgId(int tmp) {
    this.orgId = tmp;
  }


  /**
   * Sets the contactId attribute of the OpportunityHeaderList object
   *
   * @param tmp The new contactId value
   */
  public void setContactId(String tmp) {
    this.contactId = Integer.parseInt(tmp);
  }


  /**
   * Sets the contactId attribute of the OpportunityHeaderList object
   *
   * @param tmp The new contactId value
   */
  public void setContactId(int tmp) {
    this.contactId = tmp;
  }


  /**
   * Sets the description attribute of the OpportunityHeaderList object
   *
   * @param description The new description value
   */
  public void setDescription(String description) {
    this.description = description;
  }


  /**
   * Sets the enteredBy attribute of the OpportunityHeaderList object
   *
   * @param tmp The new enteredBy value
   */
  public void setEnteredBy(int tmp) {
    this.enteredBy = tmp;
  }


  /**
   * Sets the buildTotalValues attribute of the OpportunityHeaderList object
   *
   * @param buildTotalValues The new buildTotalValues value
   */
  public void setBuildTotalValues(boolean buildTotalValues) {
    this.buildTotalValues = buildTotalValues;
  }


  /**
   * Sets the componentsOwnedByUser attribute of the OpportunityHeaderList
   * object
   *
   * @param componentsOwnedByUser The new componentsOwnedByUser value
   */
  public void setComponentsOwnedByUser(int componentsOwnedByUser) {
    this.componentsOwnedByUser = componentsOwnedByUser;
  }


  /**
   * Gets the componentsOwnedByUser attribute of the OpportunityHeaderList
   * object
   *
   * @return The componentsOwnedByUser value
   */
  public int getComponentsOwnedByUser() {
    return componentsOwnedByUser;
  }


  /**
   * Gets the buildTotalValues attribute of the OpportunityHeaderList object
   *
   * @return The buildTotalValues value
   */
  public boolean getBuildTotalValues() {
    return buildTotalValues;
  }


  /**
   * Sets the accountOwnerIdRange attribute of the OpportunityHeaderList object
   *
   * @param accountOwnerIdRange The new accountOwnerIdRange value
   */
  public void setAccountOwnerIdRange(String accountOwnerIdRange) {
    this.accountOwnerIdRange = accountOwnerIdRange;
  }


  /**
   * Sets the ownerIdRange attribute of the OpportunityHeaderList object
   *
   * @param ownerIdRange The new ownerIdRange value
   */
  public void setOwnerIdRange(String ownerIdRange) {
    this.ownerIdRange = ownerIdRange;
  }


  /**
   * Sets the alertRangeStart attribute of the OpportunityHeaderList object
   *
   * @param tmp The new alertRangeStart value
   */
  public void setAlertRangeStart(java.sql.Date tmp) {
    this.alertRangeStart = tmp;
  }


  /**
   * Sets the alertRangeStart attribute of the OpportunityHeaderList object
   *
   * @param tmp The new alertRangeStart value
   */
  public void setAlertRangeStart(String tmp) {
    this.alertRangeStart = java.sql.Date.valueOf(tmp);
  }


  /**
   * Sets the alertRangeEnd attribute of the OpportunityHeaderList object
   *
   * @param tmp The new alertRangeEnd value
   */
  public void setAlertRangeEnd(java.sql.Date tmp) {
    this.alertRangeEnd = tmp;
  }


  /**
   * Sets the alertRangeEnd attribute of the OpportunityHeaderList object
   *
   * @param tmp The new alertRangeEnd value
   */
  public void setAlertRangeEnd(String tmp) {
    this.alertRangeEnd = java.sql.Date.valueOf(tmp);
  }


  /**
   * Sets the queryClosedOnly attribute of the OpportunityHeaderList object
   *
   * @param queryClosedOnly The new queryClosedOnly value
   */
  public void setQueryClosedOnly(boolean queryClosedOnly) {
    this.queryClosedOnly = queryClosedOnly;
  }


  /**
   * Gets the queryClosedOnly attribute of the OpportunityHeaderList object
   *
   * @return The queryClosedOnly value
   */
  public boolean getQueryClosedOnly() {
    return queryClosedOnly;
  }


  /**
   * Sets the trashedDate attribute of the OpportunityHeaderList object
   *
   * @param tmp The new trashedDate value
   */
  public void setTrashedDate(java.sql.Timestamp tmp) {
    this.trashedDate = tmp;
  }


  /**
   * Sets the trashedDate attribute of the OpportunityHeaderList object
   *
   * @param tmp The new trashedDate value
   */
  public void setTrashedDate(String tmp) {
    this.trashedDate = DatabaseUtils.parseTimestamp(tmp);
  }


  /**
   * Sets the includeOnlyTrashed attribute of the OpportunityHeaderList object
   *
   * @param tmp The new includeOnlyTrashed value
   */
  public void setIncludeOnlyTrashed(boolean tmp) {
    this.includeOnlyTrashed = tmp;
  }


  /**
   * Sets the includeOnlyTrashed attribute of the OpportunityHeaderList object
   *
   * @param tmp The new includeOnlyTrashed value
   */
  public void setIncludeOnlyTrashed(String tmp) {
    this.includeOnlyTrashed = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   * Gets the trashedDate attribute of the OpportunityHeaderList object
   *
   * @return The trashedDate value
   */
  public java.sql.Timestamp getTrashedDate() {
    return trashedDate;
  }


  /**
   * Gets the includeOnlyTrashed attribute of the OpportunityHeaderList object
   *
   * @return The includeOnlyTrashed value
   */
  public boolean getIncludeOnlyTrashed() {
    return includeOnlyTrashed;
  }


  /**
   * Gets the alertRangeStart attribute of the OpportunityHeaderList object
   *
   * @return The alertRangeStart value
   */
  public java.sql.Date getAlertRangeStart() {
    return alertRangeStart;
  }


  /**
   * Gets the alertRangeEnd attribute of the OpportunityHeaderList object
   *
   * @return The alertRangeEnd value
   */
  public java.sql.Date getAlertRangeEnd() {
    return alertRangeEnd;
  }


  /**
   * Gets the queryOpenOnly attribute of the OpportunityHeaderList object
   *
   * @return The queryOpenOnly value
   */
  public boolean getQueryOpenOnly() {
    return queryOpenOnly;
  }


  /**
   * Sets the queryOpenOnly attribute of the OpportunityHeaderList object
   *
   * @param queryOpenOnly The new queryOpenOnly value
   */
  public void setQueryOpenOnly(boolean queryOpenOnly) {
    this.queryOpenOnly = queryOpenOnly;
  }


  /**
   * Sets the hasAlertDate attribute of the OpportunityHeaderList object
   *
   * @param tmp The new hasAlertDate value
   */
  public void setHasAlertDate(boolean tmp) {
    this.hasAlertDate = tmp;
  }


  /**
   * Sets the alertDate attribute of the OpportunityHeaderList object
   *
   * @param tmp The new alertDate value
   */
  public void setAlertDate(java.sql.Date tmp) {
    this.alertDate = tmp;
  }


  /**
   * Gets the closeDateStart attribute of the OpportunityHeaderList object
   *
   * @return The closeDateStart value
   */
  public java.sql.Date getCloseDateStart() {
    return closeDateStart;
  }


  /**
   * Gets the closeDateEnd attribute of the OpportunityHeaderList object
   *
   * @return The closeDateEnd value
   */
  public java.sql.Date getCloseDateEnd() {
    return closeDateEnd;
  }


  /**
   * Sets the closeDateStart attribute of the OpportunityHeaderList object
   *
   * @param tmp The new closeDateStart value
   */
  public void setCloseDateStart(java.sql.Date tmp) {
    this.closeDateStart = tmp;
  }


  /**
   * Sets the closeDateStart attribute of the OpportunityHeaderList object
   *
   * @param tmp The new closeDateStart value
   */
  public void setCloseDateStart(String tmp) {
    try {
      java.util.Date tmpDate = DateFormat.getDateInstance(3).parse(tmp);
      closeDateStart = new java.sql.Date(new java.util.Date().getTime());
      closeDateStart.setTime(tmpDate.getTime());
    } catch (Exception e) {
      closeDateStart = null;
    }
  }


  /**
   * Sets the closeDateEnd attribute of the OpportunityHeaderList object
   *
   * @param tmp The new closeDateEnd value
   */
  public void setCloseDateEnd(java.sql.Date tmp) {
    this.closeDateEnd = tmp;
  }


  /**
   * Sets the closeDateEnd attribute of the OpportunityHeaderList object
   *
   * @param tmp The new closeDateEnd value
   */
  public void setCloseDateEnd(String tmp) {
    try {
      java.util.Date tmpDate = DateFormat.getDateInstance(3).parse(tmp);
      closeDateEnd = new java.sql.Date(new java.util.Date().getTime());
      closeDateEnd.setTime(tmpDate.getTime());
    } catch (Exception e) {
      closeDateEnd = null;
    }
  }


  /**
   * Sets the owner attribute of the OpportunityHeaderList object
   *
   * @param tmp The new owner value
   */
  public void setOwner(int tmp) {
    this.owner = tmp;
  }


  /**
   * Sets the owner attribute of the OpportunityHeaderList object
   *
   * @param tmp The new owner value
   */
  public void setOwner(String tmp) {
    this.owner = Integer.parseInt(tmp);
  }


  /**
   * Gets the accountOwnerIdRange attribute of the OpportunityHeaderList object
   *
   * @return The accountOwnerIdRange value
   */
  public String getAccountOwnerIdRange() {
    return accountOwnerIdRange;
  }


  /**
   * Gets the ownerIdRange attribute of the OpportunityHeaderList object
   *
   * @return The ownerIdRange value
   */
  public String getOwnerIdRange() {
    return ownerIdRange;
  }


  /**
   * Gets the listSize attribute of the OpportunityHeaderList object
   *
   * @return The listSize value
   */
  public int getListSize() {
    return this.size();
  }


  /**
   * Gets the enteredBy attribute of the OpportunityHeaderList object
   *
   * @return The enteredBy value
   */
  public int getEnteredBy() {
    return enteredBy;
  }


  /**
   * Gets the hasAlertDate attribute of the OpportunityHeaderList object
   *
   * @return The hasAlertDate value
   */
  public boolean getHasAlertDate() {
    return hasAlertDate;
  }


  /**
   * Gets the description attribute of the OpportunityHeaderList object
   *
   * @return The description value
   */
  public String getDescription() {
    return description;
  }


  /**
   * Builds a list of contacts based on several parameters. The parameters are
   * set after this object is constructed, then the buildList method is called
   * to generate the list.
   *
   * @param db Description of Parameter
   * @throws SQLException Description of Exception
   * @since 1.1
   */
  public void buildList(Connection db) throws SQLException {

    PreparedStatement pst = null;
    ResultSet rs = null;
    int items = -1;

    StringBuffer sqlSelect = new StringBuffer();
    StringBuffer sqlCount = new StringBuffer();
    StringBuffer sqlFilter = new StringBuffer();
    StringBuffer sqlOrder = new StringBuffer();

    //Need to build a base SQL statement for counting records
    sqlCount.append(
        "SELECT COUNT(*) AS recordcount " +
        "FROM opportunity_header x " +
        "WHERE x.opp_id > -1 ");

    createFilter(db, sqlFilter);

    if (pagedListInfo != null) {
      //Get the total number of records matching filter
      pst = db.prepareStatement(
          sqlCount.toString() +
          sqlFilter.toString());
      items = prepareFilter(pst);
      rs = pst.executeQuery();
      if (rs.next()) {
        int maxRecords = rs.getInt("recordcount");
        pagedListInfo.setMaxRecords(maxRecords);
      }
      rs.close();
      pst.close();

      //Determine the offset, based on the filter, for the first record to show
      if (!pagedListInfo.getCurrentLetter().equals("")) {
        pst = db.prepareStatement(
            sqlCount.toString() +
            sqlFilter.toString() +
            "AND " + DatabaseUtils.toLowerCase(db) + "(x.description) < ? ");
        items = prepareFilter(pst);
        pst.setString(++items, pagedListInfo.getCurrentLetter().toLowerCase());
        rs = pst.executeQuery();
        if (rs.next()) {
          int offsetCount = rs.getInt("recordcount");
          pagedListInfo.setCurrentOffset(offsetCount);
        }
        rs.close();
        pst.close();
      }

      pagedListInfo.setDefaultSort("x.description", null);
      pagedListInfo.appendSqlTail(db, sqlOrder);
    } else {
      sqlOrder.append("ORDER BY x.entered");
    }

    //Need to build a base SQL statement for returning records
    if (pagedListInfo != null) {
      pagedListInfo.appendSqlSelectHead(db, sqlSelect);
    } else {
      sqlSelect.append("SELECT ");
    }
    sqlSelect.append(
        "x.opp_id AS header_opp_id, " +
        "x.description AS header_description, " +
        "x.acctlink AS header_acctlink, " +
        "x.contactlink AS header_contactlink, " +
        "x.entered AS header_entered, " +
        "x.enteredby AS header_enteredby, " +
        "x.modified AS header_modified, " +
        "x.modifiedby AS header_modifiedby, " +
        "x.trashed_date AS header_trashed_date, " +
        "org.name as acct_name, org.enabled as accountenabled, " +
        "ct.namelast as last_name, ct.namefirst as first_name, " +
        "ct.org_name as ctcompany " +
        "FROM opportunity_header x " +
        "LEFT JOIN organization org ON (x.acctlink = org.org_id) " +
        "LEFT JOIN contact ct ON (x.contactlink = ct.contact_id) " +
        "WHERE x.opp_id > -1 ");
    pst = db.prepareStatement(
        sqlSelect.toString() +
        sqlFilter.toString() +
        sqlOrder.toString());
    items = prepareFilter(pst);
    rs = pst.executeQuery();
    if (pagedListInfo != null) {
      pagedListInfo.doManualOffset(db, rs);
    }
    while (rs.next()) {
      OpportunityHeader thisOppHeader = new OpportunityHeader(rs);
      this.add(thisOppHeader);
    }
    rs.close();
    pst.close();

    Iterator i = this.iterator();
    while (i.hasNext()) {
      OpportunityHeader thisOppHeader = (OpportunityHeader) i.next();
      //set the ownerId if the count and total value of only the components owned by a specific user is needed
      thisOppHeader.retrieveComponentCount(db, componentsOwnedByUser);
      if (buildTotalValues) {
        thisOppHeader.buildTotal(db, componentsOwnedByUser);
      }
      thisOppHeader.buildFiles(db);
    }
  }


  /**
   * Adds a feature to the IgnoreTypeId attribute of the OpportunityHeaderList
   * object
   *
   * @param tmp The feature to be added to the IgnoreTypeId attribute
   */
  public void addIgnoreTypeId(String tmp) {
    ignoreTypeIdList.add(tmp);
  }


  /**
   * Adds a feature to the IgnoreTypeId attribute of the OpportunityHeaderList
   * object
   *
   * @param tmp The feature to be added to the IgnoreTypeId attribute
   */
  public void addIgnoreTypeId(int tmp) {
    ignoreTypeIdList.add(String.valueOf(tmp));
  }


  /**
   * Description of the Method
   *
   * @param db           Description of the Parameter
   * @param context      Description of the Parameter
   * @param baseFilePath Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void delete(Connection db, ActionContext context, String baseFilePath) throws SQLException {
    Iterator opportunities = this.iterator();
    while (opportunities.hasNext()) {
      OpportunityHeader thisOpportunity = (OpportunityHeader) opportunities.next();
      thisOpportunity.delete(db, context, baseFilePath);
    }
  }


  /**
   * Description of the Method
   *
   * @param sqlFilter Description of the Parameter
   * @param db        Description of the Parameter
   */
  protected void createFilter(Connection db, StringBuffer sqlFilter) {
    if (sqlFilter == null) {
      sqlFilter = new StringBuffer();
    }
    if (orgId != -1) {
      sqlFilter.append(
          "AND (x.acctlink = ? OR x.contactlink IN (SELECT contact_id from contact c where c.org_id = ? )) ");
    }
    if (contactId != -1) {
      sqlFilter.append("AND x.contactlink = ? ");
    }
    if (enteredBy != -1) {
      sqlFilter.append("AND x.enteredby = ? ");
    }
    if (ignoreTypeIdList.size() > 0) {
      Iterator iList = ignoreTypeIdList.iterator();
      sqlFilter.append("AND x.contactlink NOT IN (");
      while (iList.hasNext()) {
        String placeHolder = (String) iList.next();
        sqlFilter.append("?");
        if (iList.hasNext()) {
          sqlFilter.append(",");
        }
      }
      sqlFilter.append(") ");
    }
    if (description != null) {
      if (description.indexOf("%") >= 0) {
        sqlFilter.append(
            "AND " + DatabaseUtils.toLowerCase(db) + "(x.description) LIKE " + DatabaseUtils.toLowerCase(
                db) + "(?) ");
      } else {
        sqlFilter.append(
            "AND " + DatabaseUtils.toLowerCase(db) + "(x.description) = " + DatabaseUtils.toLowerCase(
                db) + "(?) ");
      }
    }
    if (queryOpenOnly) {
      sqlFilter.append(
          "AND x.opp_id IN (SELECT opp_id from opportunity_component oc where oc.closed IS NULL) ");
    }
    if (queryClosedOnly) {
      sqlFilter.append(
          "AND x.opp_id NOT IN (SELECT opp_id from opportunity_component oc where oc.closed IS NULL) ");
    }
    if (accountOwnerIdRange != null) {
      sqlFilter.append(
          "AND x.acctlink IN (SELECT org_id FROM organization WHERE owner IN (" + accountOwnerIdRange + ")) ");
    }
    //Get the opportunity if user is owner in any one of the components of that opportunity
    if (owner != -1) {
      sqlFilter.append(
          "AND " +
          "( " +
          "(x.opp_id IN (SELECT opp_id FROM opportunity_component oc WHERE oc.owner = ? )) " +
          "OR (x.opp_id NOT IN (SELECT opp_id FROM opportunity_component oc1 WHERE oc1.opp_id = x.opp_id ) AND " +
          "x.enteredby = ?) " +
          ") ");
    }
    //Get the opportunity if user or anyone in user's hierarchy is owner in any one of the components of that opportunity
    if (ownerIdRange != null) {
      sqlFilter.append(
          "AND " +
          "( " +
          "(x.opp_id IN (SELECT opp_id FROM opportunity_component oc WHERE oc.owner IN (" + ownerIdRange + ") ) ) " +
          "OR (x.opp_id NOT IN (SELECT opp_id from opportunity_component oc1 WHERE oc1.opp_id = x.opp_id) AND " +
          "x.enteredby IN (" + ownerIdRange + ") ) " +
          ") ");
    }
    if (includeOnlyTrashed) {
      sqlFilter.append("AND x.trashed_date IS NOT NULL ");
    } else if (trashedDate != null) {
      sqlFilter.append("AND x.trashed_date = ? ");
    } else {
      sqlFilter.append("AND x.trashed_date IS NULL ");
    }

  }


  /**
   * Sets the parameters for the preparedStatement - these items must
   * correspond with the createFilter statement
   *
   * @param pst Description os.gerameter
   * @return Description of the Returned Value
   * @throws SQLException Description of Exception
   * @since 1.3
   */
  protected int prepareFilter(PreparedStatement pst) throws SQLException {
    int i = 0;
    if (orgId != -1) {
      pst.setInt(++i, orgId);
      pst.setInt(++i, orgId);
    }
    if (contactId != -1) {
      pst.setInt(++i, contactId);
    }
    if (enteredBy != -1) {
      pst.setInt(++i, enteredBy);
    }
    if (ignoreTypeIdList.size() > 0) {
      Iterator iList = ignoreTypeIdList.iterator();
      while (iList.hasNext()) {
        int thisType = Integer.parseInt((String) iList.next());
        pst.setInt(++i, thisType);
      }
    }
    if (description != null) {
      pst.setString(++i, description);
    }
    if (owner != -1) {
      pst.setInt(++i, owner);
      pst.setInt(++i, owner);
    }
    if (includeOnlyTrashed) {
      // do nothing
    } else if (trashedDate != null) {
      pst.setTimestamp(++i, trashedDate);
    } else {
      // do nothing
    }
    return i;
  }


  /**
   * Description of the Method
   *
   * @param db       Description of the Parameter
   * @param moduleId Description of the Parameter
   * @param itemId   Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  public static int retrieveRecordCount(Connection db, int moduleId, int itemId) throws SQLException {
    int count = 0;
    StringBuffer sql = new StringBuffer();
    sql.append(
        "SELECT COUNT(*) as itemcount " +
        "FROM opportunity_header o " +
        "LEFT JOIN opportunity_component oc ON (o.opp_id = oc.opp_id) " +
        "WHERE opp_id > 0 ");
    if (moduleId == Constants.ACCOUNTS) {
      sql.append(
          "AND (o.acctlink = ? OR o.contactlink IN (SELECT contact_id FROM contact c WHERE c.org_id = ? )) ");
    }
    PreparedStatement pst = db.prepareStatement(sql.toString());
    if (moduleId == Constants.ACCOUNTS) {
      pst.setInt(1, itemId);
      pst.setInt(2, itemId);
    }
    ResultSet rs = pst.executeQuery();
    if (rs.next()) {
      count = rs.getInt("itemcount");
    }
    rs.close();
    pst.close();
    return count;
  }


  /**
   * Checks if the user owns atleast one of the components for all
   * opportunities of a contact
   *
   * @param db     Description of the Parameter
   * @param userId Description of the Parameter
   * @return The componentOwner value
   * @throws SQLException Description of the Exception
   */
  public static boolean isComponentOwner(Connection db, int userId) throws SQLException {
    boolean isOwner = false;
    PreparedStatement pst = db.prepareStatement(
        "SELECT opp_id " +
        "FROM opportunity_header oh " +
        "WHERE opp_id > 0 and opp_id in ( " +
        "SELECT opp_id from opportunity_component oc " +
        "WHERE oc.owner = ? AND oh.opp_id = oc.opp_id ) ");
    pst.setInt(1, userId);
    ResultSet rs = pst.executeQuery();
    if (rs.next()) {
      isOwner = true;
    }
    rs.close();
    pst.close();
    return isOwner;
  }


  /**
   * Move the opportunities from the contact to the account
   *
   * @param db    Description of the Parameter
   * @param orgId Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void moveOpportunitiesToAccount(Connection db, int orgId) throws SQLException {
    Iterator iterator = (Iterator) this.iterator();
    while (iterator.hasNext()) {
      OpportunityHeader opp = (OpportunityHeader) iterator.next();
      opp.setContactLink(-1);
      opp.setAccountLink(orgId);
      opp.update(db);
    }
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @param db      Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void invalidateUserData(ActionContext context, Connection db) throws SQLException {
    Iterator itr = this.iterator();
    while (itr.hasNext()) {
      OpportunityHeader tmpOpportunityHeader = (OpportunityHeader) itr.next();
      tmpOpportunityHeader.invalidateUserData(context, db);
    }
  }


  /**
   * Description of the Method
   *
   * @param db        Description of the Parameter
   * @param toTrash   Description of the Parameter
   * @param tmpUserId Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  public boolean updateStatus(Connection db, ActionContext context, boolean toTrash, int tmpUserId) throws SQLException {
    Iterator itr = this.iterator();
    while (itr.hasNext()) {
      OpportunityHeader tmpOppHeader = (OpportunityHeader) itr.next();
      tmpOppHeader.updateStatus(db, context, toTrash, tmpUserId);
    }
    return true;
  }
}

