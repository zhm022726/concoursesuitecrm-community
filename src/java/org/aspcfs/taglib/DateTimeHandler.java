package org.aspcfs.taglib;

import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;
import java.sql.Timestamp;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.ObjectUtils;
import java.util.Hashtable;
import org.aspcfs.controller.SystemStatus;
import com.darkhorseventures.database.ConnectionElement;
import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.login.beans.UserBean;
import java.text.*;

/**
 *  This Class formats the specified date/time with the timezone for the current
 *  UserBean session.
 *
 *@author     matt rajkowski
 *@created    September 3, 2003
 *@version    $Id$
 */
public class DateTimeHandler extends TagSupport {

  private Timestamp timestamp = null;
  private boolean dateOnly = false;
  private int timeFormat = DateFormat.LONG;
  private int dateFormat = DateFormat.SHORT;
  private String pattern = null;
  private String defaultValue = "";


  /**
   *  The date to be formatted
   *
   *@param  tmp  The new timestamp value
   */
  public void setTimestamp(Timestamp tmp) {
    this.timestamp = tmp;
  }


  /**
   *  The date to be formatted
   *
   *@param  tmp  The new timestamp value
   */
  public void setTimestamp(java.util.Date tmp) {
    this.timestamp = new java.sql.Timestamp(tmp.getTime());
  }


  /**
   *  The date to be formatted
   *
   *@param  tmp  The new timestamp value
   */
  public void setTimestamp(String tmp) {
    this.timestamp = DatabaseUtils.parseTimestamp(tmp);
  }


  /**
   *  Default in case the date is empty/null
   *
   *@param  tmp  The new default value
   */
  public void setDefault(String tmp) {
    this.defaultValue = tmp;
  }


  /**
   *  Gets the date only without the time
   *
   *@param  dateOnly  The new dateOnly value
   */
  public void setDateOnly(boolean dateOnly) {
    this.dateOnly = dateOnly;
  }


  /**
   *  Gets the date without the time
   *
   *@param  dateOnly  The new dateOnly value
   */
  public void setDateOnly(String dateOnly) {
    this.dateOnly = "true".equals(dateOnly);
  }


  /**
   *  Sets a pattern
   *
   *@param  pattern  The new pattern value
   */
  public void setPattern(String pattern) {
    this.pattern = pattern;
  }


  /**
   *  Sets a time format
   *
   *@param  timeFormat  The new timeFormat value
   */
  public void setTimeFormat(int timeFormat) {
    this.timeFormat = timeFormat;
  }


  /**
   *  Sets a time format
   *
   *@param  timeFormat  The new timeFormat value
   */
  public void setTimeFormat(String timeFormat) {
    this.timeFormat = Integer.parseInt(timeFormat);
  }


  /**
   *  Sets the date format
   *
   *@param  dateFormat  The new dateFormat value
   */
  public void setDateFormat(int dateFormat) {
    this.dateFormat = dateFormat;
  }


  /**
   *  Sets the date format
   *
   *@param  dateFormat  The new dateFormat value
   */
  public void setDateFormat(String dateFormat) {
    this.dateFormat = Integer.parseInt(dateFormat);
  }


  /**
   *  Description of the Method
   *
   *@return                   Description of the Return Value
   *@exception  JspException  Description of the Exception
   */
  public int doStartTag() throws JspException {
    try {
      if (timestamp != null && !"".equals(timestamp)) {
        String timeZone = null;
        //Retrieve the user's timezone from their UserBean session
        UserBean userBean = (UserBean) pageContext.getSession().getAttribute("User");
        if (userBean != null) {
          ConnectionElement ce = (ConnectionElement) pageContext.getSession().getAttribute("ConnectionElement");
          SystemStatus systemStatus = (SystemStatus) ((Hashtable) pageContext.getServletContext().getAttribute("SystemStatus")).get(ce.getUrl());
          User thisUser = systemStatus.getUser(userBean.getUserId());
          timeZone = thisUser.getTimeZone();
        }

        //Format the specified timestamp with the retrieved timezone
        //TODO: combine the Locale when User Locale that has been implemented
        SimpleDateFormat formatter = null;
        if (dateOnly) {
          formatter = (SimpleDateFormat) SimpleDateFormat.getDateInstance
              (dateFormat);
        } else {
          formatter = (SimpleDateFormat) SimpleDateFormat.getDateTimeInstance
              (dateFormat, timeFormat);
        }

        //set the pattern
        if (pattern != null) {
          formatter.applyPattern(pattern);
        }else{
          //default pattern for a date :9/21/2003
          if(dateOnly){
            formatter.applyPattern("M/d/yyyy");
          }
        }

        //set the timezone
        if (timeZone != null) {
          java.util.TimeZone tz = java.util.TimeZone.getTimeZone(timeZone);
          formatter.setTimeZone(tz);
        }

        this.pageContext.getOut().write(formatter.format(timestamp));
      } else {
        //no date found, output default
        this.pageContext.getOut().write(defaultValue);
      }
    } catch (Exception e) {
      System.err.println("EXCEPTION: DateTimeHandler-> Timestamp " + timestamp + " could not be formatted for userbean session");
    }
    return SKIP_BODY;
  }


  /**
   *  Description of the Method
   *
   *@return    Description of the Return Value
   */
  public int doEndTag() {
    return EVAL_PAGE;
  }

}
