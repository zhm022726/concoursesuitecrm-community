CREATE SEQUENCE message_file__ttachment_id_seq;
CREATE TABLE message_file_attachment (
  attachment_id INTEGER NOT NULL PRIMARY KEY,
  link_module_id INT NOT NULL,
  link_item_id INT NOT NULL,
  file_item_id INT REFERENCES project_files(item_id),
  filename NVARCHAR2(255) NOT NULL,
  "size" INT DEFAULT 0,
  "version" FLOAT DEFAULT 0
);

CREATE INDEX message_f_link_module_id ON message_file_attachment (link_module_id);
CREATE INDEX message_f_link_item_id ON message_file_attachment (link_item_id);

CREATE SEQUENCE lookup_report_type_code_seq;
CREATE TABLE lookup_report_type (
  code INT NOT NULL PRIMARY KEY,
  description NVARCHAR2(300) NOT NULL,
  default_item CHAR(1) DEFAULT 0,
  "level" INT DEFAULT 0,
  enabled CHAR(1) DEFAULT 1,
  constant INT DEFAULT 1 NOT NULL,
  entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE report_queue ADD output_type INT REFERENCES lookup_report_type(code);
ALTER TABLE report_queue ADD email CHAR(1) DEFAULT 0;

UPDATE permission SET "active" = 1, enabled = 1 WHERE permission = 'product-catalog';
