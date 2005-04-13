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

package org.aspcfs.modules.documents.base;

import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.darkhorseventures.framework.actions.*;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.modules.base.Constants;
import com.zeroio.iteam.base.*;

/**
 *  Represents a list of permissions for a document store
 *
 *@author
 *@created
 *@version    $Id$
 */
public class DocumentStorePermissionList extends HashMap {

  private int documentStoreId = -1;


  /**
   *  Constructor for the DocumentStorePermissionList object
   */
  public DocumentStorePermissionList() { }


  /**
   *  Sets the documentStoreId attribute of the DocumentStorePermissionList
   *  object
   *
   *@param  tmp  The new documentStoreId value
   */
  public void setDocumentStoreId(int tmp) {
    this.documentStoreId = tmp;
  }


  /**
   *  Sets the documentStoreId attribute of the DocumentStorePermissionList
   *  object
   *
   *@param  tmp  The new documentStoreId value
   */
  public void setDocumentStoreId(String tmp) {
    this.documentStoreId = Integer.parseInt(tmp);
  }


  /**
   *  Gets the documentStoreId attribute of the DocumentStorePermissionList
   *  object
   *
   *@return    The documentStoreId value
   */
  public int getDocumentStoreId() {
    return documentStoreId;
  }


  /**
   *  Description of the Method
   *
   *@param  db                Description of the Parameter
   *@exception  SQLException  Description of the Exception
   */
  public void buildList(Connection db) throws SQLException {
    StringBuffer sql = new StringBuffer();
    sql.append(
        "SELECT lp.permission, p.userlevel " +
        "FROM document_store_permissions p, lookup_document_store_permission lp " +
        "WHERE p.permission_id = lp.code ");
    createFilter(sql);
    PreparedStatement pst = db.prepareStatement(sql.toString());
    prepareFilter(pst);
    ResultSet rs = pst.executeQuery();
    while (rs.next()) {
      this.put(rs.getString("permission"), new Integer(rs.getInt("userlevel")));
    }
    rs.close();
    pst.close();
  }


  /**
   *  Description of the Method
   *
   *@param  sqlFilter  Description of the Parameter
   */
  private void createFilter(StringBuffer sqlFilter) {
    if (sqlFilter == null) {
      sqlFilter = new StringBuffer();
    }
    if (documentStoreId > -1) {
      sqlFilter.append("AND document_store_id = ? ");
    }
  }


  /**
   *  Description of the Method
   *
   *@param  pst               Description of the Parameter
   *@return                   Description of the Return Value
   *@exception  SQLException  Description of the Exception
   */
  private int prepareFilter(PreparedStatement pst) throws SQLException {
    int i = 0;
    if (documentStoreId > -1) {
      pst.setInt(++i, documentStoreId);
    }
    return i;
  }


  /**
   *  Description of the Method
   *
   *@param  permissionName  Description of the Parameter
   *@param  userLevel       Description of the Parameter
   *@return                 Description of the Return Value
   */
  public boolean hasPermission(String permissionName, int userLevel) {
    Integer value = (Integer) this.get(permissionName);

    return true;
  }


  /**
   *  Gets the accessLevel attribute of the PermissionList object
   *
   *@param  permissionName  Description of the Parameter
   *@return                 The accessLevel value
   */
  public int getAccessLevel(String permissionName) {
    Integer value = (Integer) this.get(permissionName);
    if (value == null) {
      return 1;
    } else {
      return value.intValue();
    }
  }



  /**
   *  Description of the Method
   *
   *@param  db                  Description of the Parameter
   *@param  request             Description of the Parameter
   *@param  tmpDocumentStoreId  Description of the Parameter
   *@exception  SQLException    Description of the Exception
   */
  public static void updateDocumentStorePermissions(Connection db, HttpServletRequest request, int tmpDocumentStoreId) throws SQLException {
    //Look through the request and put the permissions in buckets
    try {
      db.setAutoCommit(false);
      //Delete the previous settings
      PreparedStatement pst = db.prepareStatement(
          "DELETE FROM document_store_permissions " +
          "WHERE document_store_id = ? ");
      pst.setInt(1, tmpDocumentStoreId);
      pst.execute();
      pst.close();
      //Insert the new settings
      int count = 0;
      String permissionId = null;
      while ((permissionId = request.getParameter("perm" + (++count))) != null) {
        pst = db.prepareStatement(
            "INSERT INTO document_store_permissions (document_store_id, permission_id, userlevel) " +
            "VALUES (?, ?, ?)");
        pst.setInt(1, tmpDocumentStoreId);
        pst.setInt(2, Integer.parseInt(permissionId));
        pst.setInt(3, Integer.parseInt(request.getParameter("perm" + count + "level")));
        pst.execute();
      }
      pst.close();
      db.commit();
    } catch (SQLException e) {
      db.rollback();
    } finally {
      db.setAutoCommit(true);
    }
  }


  /**
   *  Description of the Method
   *
   *@param  db                  Description of the Parameter
   *@param  tmpDocumentStoreId  Description of the Parameter
   *@exception  SQLException    Description of the Exception
   */
  public static void delete(Connection db, int tmpDocumentStoreId) throws SQLException {
    PreparedStatement pst = db.prepareStatement(
        "DELETE FROM document_store_permissions " +
        "WHERE document_store_id = ? ");
    pst.setInt(1, tmpDocumentStoreId);
    pst.execute();
    pst.close();
  }


  /**
   *  Description of the Method
   *
   *@param  db                  Description of the Parameter
   *@param  tmpDocumentStoreId  Description of the Parameter
   *@exception  SQLException    Description of the Exception
   */
  public static void insertDefaultPermissions(Connection db, int tmpDocumentStoreId) throws SQLException {
    //Make sure no permissions exist, then insert
    PreparedStatement pst = db.prepareStatement(
        "SELECT count(*) AS perm_count " +
        "FROM document_store_permissions " +
        "WHERE document_store_id = ? ");
    pst.setInt(1, tmpDocumentStoreId);
    ResultSet rs = pst.executeQuery();
    rs.next();
    int count = rs.getInt("perm_count");
    rs.close();
    pst.close();
    //Insert the permissions
    if (count == 0) {
      DocumentStorePermissionLookupList list = new DocumentStorePermissionLookupList();
      list.setIncludeEnabled(Constants.TRUE);
      list.buildList(db);
      Iterator i = list.iterator();
      while (i.hasNext()) {
        DocumentStorePermissionLookup thisPermission = (DocumentStorePermissionLookup) i.next();
        pst = db.prepareStatement(
            "INSERT INTO document_store_permissions " +
            "(document_store_id, permission_id, userlevel) VALUES (?, ?, ?) ");
        pst.setInt(1, tmpDocumentStoreId);
        pst.setInt(2, thisPermission.getId());
        pst.setInt(3, thisPermission.getDefaultRole());
        pst.execute();
      }
      pst.close();
    }
  }
}

