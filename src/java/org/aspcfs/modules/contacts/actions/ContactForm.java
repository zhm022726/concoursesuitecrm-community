package org.aspcfs.modules.contacts.actions;

import com.darkhorseventures.framework.actions.ActionContext;
import java.sql.*;
import java.util.*;
import java.io.*;
import org.aspcfs.utils.*;
import org.aspcfs.utils.web.*;
import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.contacts.base.*;
import org.aspcfs.modules.base.*;

/**
 *  Basic Contact object.<br>
 *  Processes and Builds necessary data for any Contact object.
 *
 *@author     Mathur
 *@created    April 3, 2003
 *@version    $Id$
 */
public final class ContactForm extends CFSModule {
  /**
   *  Prepares supporting form data required for any Contact object.
   *
   *@param  context  Description of the Parameter
   *@return          Description of the Return Value
   */
  public String executeCommandPrepare(ActionContext context) {
    Exception errorMessage = null;
    Connection db = null;
    //Get contact object from the request (bean is not accessible here)
    Contact newContact = (Contact) context.getRequest().getAttribute("ContactDetails");
    try {
      db = this.getConnection(context);
      LookupList phoneTypeList = new LookupList(db, "lookup_contactphone_types");
      context.getRequest().setAttribute("ContactPhoneTypeList", phoneTypeList);

      LookupList emailTypeList = new LookupList(db, "lookup_contactemail_types");
      context.getRequest().setAttribute("ContactEmailTypeList", emailTypeList);

      LookupList addressTypeList = new LookupList(db, "lookup_contactaddress_types");
      context.getRequest().setAttribute("ContactAddressTypeList", addressTypeList);
    } catch (SQLException e) {
      errorMessage = e;
    } finally {
      this.freeConnection(context, db);
    }
    if (errorMessage == null) {
      if ("true".equals(context.getRequest().getParameter("popup"))) {
        return "PreparePopupAddOK";
      }
      if (newContact != null && newContact.getId() > 0) {
        return "PrepareModifyOK";
      } else {
        return "PrepareAddOK";
      }
    } else {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    }
  }
}
