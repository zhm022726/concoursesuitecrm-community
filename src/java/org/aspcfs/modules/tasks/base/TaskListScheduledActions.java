/*
 *  Copyright(c) 2004 Concursive Corporation (http://www.concursive.com/) All
 *  rights reserved. This material cannot be distributed without written
 *  permission from Concursive Corporation. Permission to use, copy, and modify
 *  this material for internal use is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies. CONCURSIVE
 *  CORPORATION MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
 *  IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
 *  PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
 *  INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
 *  EVENT SHALL CONCURSIVE CORPORATION OR ANY OF ITS AFFILIATES BE LIABLE FOR
 *  ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
 *  DAMAGES RELATING TO THE SOFTWARE.
 */
package org.aspcfs.modules.tasks.base;

import com.darkhorseventures.framework.actions.ActionContext;
import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.base.Constants;
import org.aspcfs.modules.base.ScheduledActions;
import org.aspcfs.modules.mycfs.base.CalendarEventList;
import org.aspcfs.utils.DateUtils;
import org.aspcfs.utils.web.CalendarView;

import java.sql.Connection;
import java.sql.SQLException;
import java.text.DateFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.TimeZone;

/**
 * Description of the Class
 *
 * @author akhi_m
 * @version $Id: TaskListScheduledActions.java,v 1.4 2002/12/04 13:11:34
 *          mrajkowski Exp $
 * @created October 2, 2002
 */
public class TaskListScheduledActions extends TaskList implements ScheduledActions {

  private ActionContext context = null;
  private CFSModule module = null;
  private int userId = -1;
  //user for whom tasks need to be retrieved
  private int loginId = -1;

  //user that has logged in


  /**
   * Gets the loginId attribute of the TaskListScheduledActions object
   *
   * @return The loginId value
   */
  public int getLoginId() {
    return loginId;
  }


  /**
   * Sets the loginId attribute of the TaskListScheduledActions object
   *
   * @param tmp The new loginId value
   */
  public void setLoginId(int tmp) {
    this.loginId = tmp;
  }


  /**
   * Sets the loginId attribute of the TaskListScheduledActions object
   *
   * @param tmp The new loginId value
   */
  public void setLoginId(String tmp) {
    this.loginId = Integer.parseInt(tmp);
  }


  /**
   * Constructor for the TaskListScheduledActions object
   */
  public TaskListScheduledActions() {
  }


  /**
   * Sets the module attribute of the QuoteListScheduledActions object
   *
   * @param tmp The new module value
   */
  public void setModule(CFSModule tmp) {
    this.module = tmp;
  }


  /**
   * Sets the context attribute of the QuoteListScheduledActions object
   *
   * @param tmp The new context value
   */
  public void setContext(ActionContext tmp) {
    this.context = tmp;
  }


  /**
   * Sets the userId attribute of the TaskListScheduledActions object
   *
   * @param tmp The new userId value
   */
  public void setUserId(int tmp) {
    this.userId = tmp;
  }


  /**
   * Sets the userId attribute of the TaskListScheduledActions object
   *
   * @param tmp The new userId value
   */
  public void setUserId(String tmp) {
    this.userId = Integer.parseInt(tmp);
  }


  /**
   * Gets the context attribute of the QuoteListScheduledActions object
   *
   * @return The context value
   */
  public ActionContext getContext() {
    return context;
  }


  /**
   * Gets the module attribute of the QuoteListScheduledActions object
   *
   * @return The module value
   */
  public CFSModule getModule() {
    return module;
  }


  /**
   * Gets the userId attribute of the TaskListScheduledActions object
   *
   * @return The userId value
   */
  public int getUserId() {
    return userId;
  }


  /**
   * Description of the Method
   *
   * @param companyCalendar Description of the Parameter
   * @param db              Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void buildAlerts(CalendarView companyCalendar, Connection db) throws SQLException {

    try {
      //get the id of the user that has logged in
      if (module != null && context != null) {
        loginId = module.getUserId(context);
      }

      if (System.getProperty("DEBUG") != null) {
        System.out.println(
            "TaskListScheduledActions-> Building Task Alerts for user " + userId);
      }

      //get TimeZone
      TimeZone timeZone = companyCalendar.getCalendarInfo().getTimeZone();

      // Add Tasks to calendar details
      this.setOwner(userId);
      if (loginId != userId) {
        this.setSharing(Constants.FALSE);
      }
      this.setComplete(Constants.FALSE);
      this.buildShortList(db);
      Iterator taskList = this.iterator();
      while (taskList.hasNext()) {
        Task thisTask = (Task) taskList.next();
        thisTask.buildResources(db);
        String alertDate = DateUtils.getServerToUserDateString(
            timeZone, DateFormat.SHORT, thisTask.getDueDate());
        companyCalendar.addEvent(
            alertDate, CalendarEventList.EVENT_TYPES[0], thisTask);
      }
    } catch (SQLException e) {
      throw new SQLException("Error Building Task Calendar Alerts");
    }
  }


  /**
   * Description of the Method
   *
   * @param companyCalendar Description of the Parameter
   * @param db              Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void buildAlertCount(CalendarView companyCalendar, Connection db) throws SQLException {

    try {
      if (System.getProperty("DEBUG") != null) {
        System.out.println("TaskListScheduledActions-> Building Alert Count ");
      }
      if (module != null && context != null) {
        loginId = module.getUserId(context);
      }
      //get TimeZone
      TimeZone timeZone = companyCalendar.getCalendarInfo().getTimeZone();

      // Add Task count to calendar
      this.setOwner(userId);
      if (loginId != userId) {
        this.setSharing(Constants.FALSE);
      }
      this.setComplete(Constants.FALSE);
      HashMap dayEvents = this.queryRecordCount(db, timeZone);
      Set s = dayEvents.keySet();
      Iterator i = s.iterator();
      while (i.hasNext()) {
        String thisDay = (String) i.next();
        companyCalendar.addEventCount(
            thisDay, CalendarEventList.EVENT_TYPES[0], dayEvents.get(thisDay));
        if (System.getProperty("DEBUG") != null) {
          System.out.println(
              "TaskListScheduledActions-> Added Tasks for " + thisDay + "- " + String.valueOf(
                  dayEvents.get(thisDay)));
        }
      }
    } catch (SQLException e) {
      throw new SQLException(
          "Error Building Task Calendar Alerts: " + e.getMessage());
    }
  }
}

