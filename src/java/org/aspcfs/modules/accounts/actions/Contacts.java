package com.darkhorseventures.cfsmodule;

import javax.servlet.*;
import javax.servlet.http.*;
import org.theseus.actions.*;
import java.sql.*;
import java.util.Vector;
import java.sql.*;
import com.darkhorseventures.utils.*;
import com.darkhorseventures.cfsbase.*;
import com.darkhorseventures.webutils.*;

/**
 *  Description of the Class
 *
 *@author     chris
 *@created    August 29, 2001
 *@version    $Id$
 */
public final class Contacts extends CFSModule {

  /**
   *  Description of the Method
   *
   *@param  context  Description of Parameter
   *@return          Description of the Returned Value
   *@since
   */
  public String executeCommandAdd(ActionContext context) {
    addModuleBean(context, "View Accounts", "Add Contact to Account");
    Exception errorMessage = null;
    Connection db = null;
    
    String orgId = context.getRequest().getParameter("orgId");
    Organization thisOrganization = null;

    try {
      db = this.getConnection(context);
      buildFormElements(context, db);
      thisOrganization = new Organization(db, Integer.parseInt(orgId));
      context.getRequest().setAttribute("OrgDetails", thisOrganization);
    } catch (SQLException e) {
      errorMessage = e;
    } finally {
      this.freeConnection(context, db);
    }

    if (errorMessage == null) {
      return ("AddOK");
    } else {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    }
  }
  
  


  /**
   *  Description of the Method
   *
   *@param  context  Description of Parameter
   *@return          Description of the Returned Value
   *@since
   */
  public String executeCommandInsert(ActionContext context) {
    addModuleBean(context, "View Accounts", "Add Contact to Account");
    Exception errorMessage = null;
    boolean recordInserted = false;

    Contact newContact = (Contact)context.getRequest().getAttribute("ContactDetails");
    newContact.setRequestItems(context.getRequest());
    newContact.setEnteredBy(getUserId(context));
    newContact.setModifiedBy(getUserId(context));
    newContact.setOwner(getUserId(context));
    
    Organization thisOrganization = null;

    Connection db = null;
    try {
      db = this.getConnection(context);
      recordInserted = newContact.insert(db);
      if (recordInserted) {
        newContact = new Contact(db, "" + newContact.getId());
        context.getRequest().setAttribute("ContactDetails", newContact);
        thisOrganization = new Organization(db, newContact.getOrgId());
        context.getRequest().setAttribute("OrgDetails", thisOrganization);
      } else {
        processErrors(context, newContact.getErrors());
      }
    } catch (SQLException e) {
      errorMessage = e;
    } finally {
      this.freeConnection(context, db);
    }

    if (errorMessage == null) {
      context.getRequest().setAttribute("orgId", "" + newContact.getOrgId());
      if (recordInserted) {
        return ("DetailsOK");
      } else {
        return (executeCommandAdd(context));
      }
    } else {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    }
  }


  /**
   *  Description of the Method
   *
   *@param  context  Description of Parameter
   *@return          Description of the Returned Value
   *@since
   */
  public String executeCommandDetails(ActionContext context) {
    addModuleBean(context, "View Accounts", "View Contact Details");
    Exception errorMessage = null;

    String contactId = context.getRequest().getParameter("id");
    
    Connection db = null;
    Contact newContact = null;
    Organization thisOrganization = null;

    try {
      db = this.getConnection(context);
      newContact = new Contact(db, contactId);

      LookupList phoneTypeList = new LookupList(db, "lookup_contactphone_types");
      context.getRequest().setAttribute("ContactPhoneTypeList", phoneTypeList);

      LookupList emailTypeList = new LookupList(db, "lookup_contactemail_types");
      context.getRequest().setAttribute("ContactEmailTypeList", emailTypeList);

      LookupList addressTypeList = new LookupList(db, "lookup_contactaddress_types");
      context.getRequest().setAttribute("ContactAddressTypeList", addressTypeList);
      
      thisOrganization = new Organization(db, newContact.getOrgId());
    } catch (Exception e) {
      errorMessage = e;
    } finally {
      this.freeConnection(context, db);
    }

    if (errorMessage == null) {
      context.getRequest().setAttribute("ContactDetails", newContact);
      context.getRequest().setAttribute("OrgDetails", thisOrganization);
      return ("DetailsOK");
    } else {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    }
  }


  /**
   *  Description of the Method
   *
   *@param  context  Description of Parameter
   *@return          Description of the Returned Value
   *@since
   */
  public String executeCommandDelete(ActionContext context) {
    Exception errorMessage = null;
    boolean recordDeleted = false;
    
    Contact thisContact = null;
    Organization thisOrganization = null;
    
    String orgId = context.getRequest().getParameter("orgId");

    Connection db = null;
    try {
      db = this.getConnection(context);
      thisContact = new Contact(db, context.getRequest().getParameter("id"));
      recordDeleted = thisContact.delete(db);
    thisOrganization = new Organization(db, Integer.parseInt(orgId));
      context.getRequest().setAttribute("OrgDetails", thisOrganization);
    } catch (Exception e) {
      errorMessage = e;
    } finally {
      this.freeConnection(context, db);
    }

    addModuleBean(context, "View Accounts", "Delete Contact");
    if (errorMessage == null) {
      context.getRequest().setAttribute("orgId", orgId);
      if (recordDeleted) {
        return ("DeleteOK");
      } else {
        processErrors(context, thisContact.getErrors());
        return (executeCommandView(context));
      }
    } else {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    }
  }


  /**
   *  Modify Contact
   *
   *@param  context  Description of Parameter
   *@return          Description of the Returned Value
   *@since
   */
  public String executeCommandModify(ActionContext context) {
    addModuleBean(context, "View Accounts", "Modify Contact");
    Exception errorMessage = null;

    String orgid = context.getRequest().getParameter("orgId");
    String passedId = context.getRequest().getParameter("id");

    Connection db = null;
    Contact newContact = null;
    Organization thisOrganization = null;
    try {
      db = this.getConnection(context);
      ContactTypeList ctl = new ContactTypeList(db);
      ctl.addItem(0, "--None--");
      context.getRequest().setAttribute("ContactTypeList", ctl);
      newContact = new Contact(db, "" + passedId);
      thisOrganization = new Organization(db, Integer.parseInt(orgid));
      buildFormElements(context, db);
       
    } catch (Exception e) {
      errorMessage = e;
    } finally {
      this.freeConnection(context, db);
    }

    if (errorMessage == null) {
      context.getRequest().setAttribute("ContactDetails", newContact);
      context.getRequest().setAttribute("OrgDetails", thisOrganization);
      return ("ModifyOK");
    } else {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    }
  }


  /**
   *  Description of the Method
   *
   *@param  context  Description of Parameter
   *@return          Description of the Returned Value
   *@since
   */
  public String executeCommandUpdate(ActionContext context) {
    Exception errorMessage = null;

    Contact newContact = (Contact)context.getFormBean();
    newContact.setRequestItems(context.getRequest());
    Organization thisOrganization = null;
    String orgid = context.getRequest().getParameter("orgId");
    
    Connection db = null;
    int resultCount = 0;

    try {
      db = this.getConnection(context);
      newContact.setModifiedBy(getUserId(context));
      resultCount = newContact.update(db);
      if (resultCount == -1) {
        processErrors(context, newContact.getErrors());
        buildFormElements(context, db);
        thisOrganization = new Organization(db, Integer.parseInt(orgid));
      }
    } catch (SQLException e) {
      errorMessage = e;
    } finally {
      this.freeConnection(context, db);
    }

    if (errorMessage == null) {
      if (resultCount == -1) {
        context.getRequest().setAttribute("OrgDetails", thisOrganization);
        return ("ModifyOK");
      } else if (resultCount == 1) {
        return ("UpdateOK");
      } else {
        context.getRequest().setAttribute("Error",
            "<b>This record could not be updated because someone else updated it first.</b><p>" +
            "You can hit the back button to review the changes that could not be committed, " +
            "but you must reload the record and make the changes again.");
        return ("UserError");
      }
    } else {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    }
  }


  /**
   *  Description of the Method
   *
   *@param  context  Description of Parameter
   *@return          Description of the Returned Value
   *@since
   */

  public String executeCommandView(ActionContext context) {
    addModuleBean(context, "View Accounts", "View Contact Details");
    Exception errorMessage = null;

    String orgid = context.getRequest().getParameter("orgId");
    if (orgid == null) {
      orgid = (String)context.getRequest().getAttribute("orgId");
    }

    PagedListInfo companyDirectoryInfo = this.getPagedListInfo(context, "ContactListInfo");
    companyDirectoryInfo.setLink("/Contacts.do?command=View&orgId=" + orgid);

    Connection db = null;
    ContactList contactList = new ContactList();
    Organization thisOrganization = null;
    try {
      db = this.getConnection(context);
      contactList.setPagedListInfo(companyDirectoryInfo);
      contactList.setOrgId(Integer.parseInt(orgid));
      //only MY contacts
      //contactList.setOwner(getUserId(context));
      contactList.buildList(db);
      thisOrganization = new Organization(db, Integer.parseInt(orgid));
    } catch (Exception e) {
      errorMessage = e;
    } finally {
      this.freeConnection(context, db);
    }

    if (errorMessage == null) {
      context.getRequest().setAttribute("ContactList", contactList);
      context.getRequest().setAttribute("OrgDetails", thisOrganization);
      return ("ListOK");
    } else {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    }

  }


  /**
   *  Description of the Method
   *
   *@param  context           Description of Parameter
   *@param  db                Description of Parameter
   *@exception  SQLException  Description of Exception
   *@since
   */
  protected void buildFormElements(ActionContext context, Connection db) throws SQLException {
    ContactTypeList ctl = new ContactTypeList(db);
    ctl.addItem(0, "--None--");
    context.getRequest().setAttribute("ContactTypeList", ctl);

    LookupList phoneTypeList = new LookupList(db, "lookup_contactphone_types");
    context.getRequest().setAttribute("ContactPhoneTypeList", phoneTypeList);

    LookupList emailTypeList = new LookupList(db, "lookup_contactemail_types");
    context.getRequest().setAttribute("ContactEmailTypeList", emailTypeList);

    LookupList addressTypeList = new LookupList(db, "lookup_contactaddress_types");
    context.getRequest().setAttribute("ContactAddressTypeList", addressTypeList);
  }

}

