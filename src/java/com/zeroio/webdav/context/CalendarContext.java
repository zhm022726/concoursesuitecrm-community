package com.zeroio.webdav.context;

import com.zeroio.webdav.utils.ICalendar;
import org.apache.naming.resources.Resource;
import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.admin.base.UserList;
import org.aspcfs.modules.mycfs.beans.CalendarBean;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.TimeZone;

/**
 * Description of the Class
 *
 * @author ananth
 * @created December 1, 2004
 */
public class CalendarContext
    extends BaseWebdavContext implements ModuleContext {

  private User user = null;
  private CalendarBean calendarInfo = new CalendarBean();


  /**
   * Sets the calendarInfo attribute of the CalendarContext object
   *
   * @param tmp The new calendarInfo value
   */
  public void setCalendarInfo(CalendarBean tmp) {
    this.calendarInfo = tmp;
  }


  /**
   * Gets the calendarInfo attribute of the CalendarContext object
   *
   * @return The calendarInfo value
   */
  public CalendarBean getCalendarInfo() {
    return calendarInfo;
  }


  /**
   * Sets the user attribute of the CalendarContext object
   *
   * @param tmp The new user value
   */
  public void setUser(User tmp) {
    this.user = tmp;
  }


  /**
   * Gets the user attribute of the CalendarContext object
   *
   * @return The user value
   */
  public User getUser() {
    return user;
  }


  /**
   * Constructor for the CalendarContext object
   */
  public CalendarContext() {
  }


  /**
   * Description of the Method
   *
   * @param db         Description of the Parameter
   * @param userId     Description of the Parameter
   * @param thisSystem Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void buildResources(SystemStatus thisSystem, Connection db, int userId, String fileLibraryPath) throws SQLException {
    //fileLibraryPath is not needed by the CalendarContext. 
    bindings.clear();
    user = new User();
    user.setBuildContact(true);
    user.setBuildHierarchy(true);
    user.buildRecord(db, userId);
    user.setLanguage(thisSystem.getApplicationPrefs().get("SYSTEM.LANGUAGE"));
    user.setCurrency(thisSystem.getApplicationPrefs().get("SYSTEM.CURRENCY"));
    populateBindings(db, thisSystem);
  }


  /**
   * Description of the Method
   *
   * @param db         Description of the Parameter
   * @param thisSystem Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  private void populateBindings(Connection db, SystemStatus thisSystem) throws SQLException {
    UserList shortChildList = user.getShortChildList();
    UserList newUserList = user.getFullChildList(shortChildList, new UserList());
    //Include the owner
    newUserList.add(user);
    Iterator i = newUserList.iterator();
    while (i.hasNext()) {
      User thisUser = (User) i.next();
      String name = thisUser.getContact().getNameFirstLast() + ".ics";
      //populate the calendar info
      buildUserAlerts(thisSystem, thisUser);
      //populate the calendar for this user
      ICalendar ical = new ICalendar(db, thisUser, calendarInfo);
      Resource resource = new Resource(ical.getBytes());
      bindings.put(name, resource);
      buildProperties(name, thisUser.getEntered(), thisUser.getModified(), new Integer(ical.getBytes().length));
    }
  }


  /**
   * Description of the Method
   *
   * @param thisSystem Description of the Parameter
   * @param thisUser   Description of the Parameter
   */
  private void buildUserAlerts(SystemStatus thisSystem, User thisUser) {
    calendarInfo.setTimeZone(TimeZone.getTimeZone(thisUser.getTimeZone()));
    calendarInfo.getAlertTypes().clear();
    //Tasks
    if (hasPermission(thisSystem, thisUser.getId(), "myhomepage-tasks-view")) {
      calendarInfo.addAlertType("Task", "org.aspcfs.modules.tasks.base.TaskListScheduledActions", "Tasks");
    }
    //Activities
    if (hasPermission(thisSystem, thisUser.getId(), "contacts-external_contacts-calls-view") || hasPermission(thisSystem, thisUser.getId(), "accounts-accounts-contacts-calls-view")) {
      calendarInfo.addAlertType("Call", "org.aspcfs.modules.contacts.base.CallListScheduledActions", "Activities");
    }
    //Project Alerts
    if (hasPermission(thisSystem, thisUser.getId(), "projects-projects-view")) {
      calendarInfo.addAlertType("Project", "com.zeroio.iteam.base.ProjectListScheduledActions", "Projects");
    }
    //Accounts Alerts
    if (hasPermission(thisSystem, thisUser.getId(), "accounts-accounts-view")) {
      calendarInfo.addAlertType("Accounts", "org.aspcfs.modules.accounts.base.AccountsListScheduledActions", "Accounts");
    }
    //Opportunity Alerts
    if (hasPermission(thisSystem, thisUser.getId(), "contacts-external_contacts-opportunities-view") || hasPermission(thisSystem, thisUser.getId(), "pipeline-opportunities-view")) {
      calendarInfo.addAlertType("Opportunity", "org.aspcfs.modules.pipeline.base.OpportunityListScheduledActions", "Opportunities");
    }
    //Help Desk Alerts
     if (hasPermission(thisSystem, thisUser.getId(), "products-view") || hasPermission(thisSystem, thisUser.getId(), "tickets-tickets-view")) {
      calendarInfo.addAlertType("Ticket", "org.aspcfs.modules.troubletickets.base.TicketListScheduledActions", "Tickets");
    }
  }
}

