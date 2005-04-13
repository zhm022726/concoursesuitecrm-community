-- Script (C) 2005 Dark Horse Ventures, all rights reserved
-- Database upgrade v2.9.2 (2005-01-14)

UPDATE call_log
SET status_id = 2
WHERE call_id IN (SELECT parent_id FROM call_log)
AND status_id = 3;

INSERT INTO database_version (script_filename, script_version) VALUES ('postgresql_2005-01-14.sql', '2005-01-14');
