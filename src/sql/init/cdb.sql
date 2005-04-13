INSERT INTO lookup_contact_types (description, category) VALUES ('Acquaintance', 0);
INSERT INTO lookup_contact_types (description, category) VALUES ('Competitor', 0);
INSERT INTO lookup_contact_types (description, category) VALUES ('Customer', 0);
INSERT INTO lookup_contact_types (description, category) VALUES ('Friend', 0);
INSERT INTO lookup_contact_types (description, category) VALUES ('Prospect', 0);
INSERT INTO lookup_contact_types (description, category) VALUES ('Shareholder', 0);
INSERT INTO lookup_contact_types (description, category) VALUES ('Vendor', 0);

INSERT INTO lookup_contact_types (description, category) VALUES ('Accounting', 1);
INSERT INTO lookup_contact_types (description, category) VALUES ('Administrative', 1);
INSERT INTO lookup_contact_types (description, category) VALUES ('Business Development', 1);
INSERT INTO lookup_contact_types (description, category) VALUES ('Customer Service', 1);
INSERT INTO lookup_contact_types (description, category) VALUES ('Engineering', 1);
INSERT INTO lookup_contact_types (description, category) VALUES ('Executive', 1);
INSERT INTO lookup_contact_types (description, category) VALUES ('Finance', 1);
INSERT INTO lookup_contact_types (description, category) VALUES ('Marketing', 1);
INSERT INTO lookup_contact_types (description, category) VALUES ('Operations', 1);
INSERT INTO lookup_contact_types (description, category) VALUES ('Procurement', 1);
INSERT INTO lookup_contact_types (description, category) VALUES ('Sales', 1);
INSERT INTO lookup_contact_types (description, category) VALUES ('Shipping/Receiving', 1);
INSERT INTO lookup_contact_types (description, category) VALUES ('Technology', 1);

INSERT INTO lookup_account_types (description, level) VALUES ('Small', 10);
INSERT INTO lookup_account_types (description, level) VALUES ('Medium', 20);
INSERT INTO lookup_account_types (description, level) VALUES ('Large', 30);
INSERT INTO lookup_account_types (description, level) VALUES ('Contract', 40);
INSERT INTO lookup_account_types (description, level) VALUES ('Non-contract', 50);
INSERT INTO lookup_account_types (description, level) VALUES ('Territory 1: Northeast', 60);
INSERT INTO lookup_account_types (description, level) VALUES ('Territory 2: Southeast', 70);
INSERT INTO lookup_account_types (description, level) VALUES ('Territory 3: Midwest', 80);
INSERT INTO lookup_account_types (description, level) VALUES ('Territory 4: Northwest', 90);
INSERT INTO lookup_account_types (description, level) VALUES ('Territory 5: Southwest', 100);

INSERT INTO lookup_orgaddress_types (description, level) VALUES ('Primary', 10);
INSERT INTO lookup_orgaddress_types (description, level) VALUES ('Auxiliary', 20);
INSERT INTO lookup_orgaddress_types (description, level) VALUES ('Billing', 30);
INSERT INTO lookup_orgaddress_types (description, level) VALUES ('Shipping', 40);

INSERT INTO lookup_orgemail_types (description, level) VALUES ('Primary', 10);
INSERT INTO lookup_orgemail_types (description, level) VALUES ('Auxiliary', 20);

INSERT INTO lookup_orgphone_types (description, level) VALUES ('Main', 10);
INSERT INTO lookup_orgphone_types (description, level) VALUES ('Fax', 20);

INSERT INTO lookup_contactaddress_types (description, level) VALUES ('Business', 10);
INSERT INTO lookup_contactaddress_types (description, level) VALUES ('Home', 20);
INSERT INTO lookup_contactaddress_types (description, level) VALUES ('Other', 30);

INSERT INTO lookup_contactemail_types (description, level) VALUES ('Business', 10);
INSERT INTO lookup_contactemail_types (description, level) VALUES ('Personal', 20);
INSERT INTO lookup_contactemail_types (description, level) VALUES ('Other', 30);

INSERT INTO lookup_contactphone_types (description, level) VALUES ('Business', 10);
INSERT INTO lookup_contactphone_types (description, level) VALUES ('Business2', 20);
INSERT INTO lookup_contactphone_types (description, level) VALUES ('Business Fax', 30);
INSERT INTO lookup_contactphone_types (description, level) VALUES ('Home', 40);
INSERT INTO lookup_contactphone_types (description, level) VALUES ('Home2', 50);
INSERT INTO lookup_contactphone_types (description, level) VALUES ('Home Fax', 60);
INSERT INTO lookup_contactphone_types (description, level) VALUES ('Mobile', 70);
INSERT INTO lookup_contactphone_types (description, level) VALUES ('Pager', 80);
INSERT INTO lookup_contactphone_types (description, level) VALUES ('Other', 90);

INSERT INTO lookup_delivery_options (description,level) VALUES ('Email only',1);
INSERT INTO lookup_delivery_options (description,level) VALUES ('Fax only',2);
INSERT INTO lookup_delivery_options (description,level) VALUES ('Letter only',3);
INSERT INTO lookup_delivery_options (description,level) VALUES ('Email then Fax',4);
INSERT INTO lookup_delivery_options (description,level) VALUES ('Email then Letter',5);
INSERT INTO lookup_delivery_options (description,level) VALUES ('Email, Fax, then Letter',6);
--INSERT INTO lookup_delivery_options (description,level) VALUES ('By Communication Preference',7);
INSERT INTO lookup_delivery_options (description,level,enabled) VALUES ('Instant Message', 7, @FALSE@);
INSERT INTO lookup_delivery_options (description,level,enabled) VALUES ('Secure Socket', 8, @FALSE@);
INSERT INTO lookup_delivery_options (description,level) VALUES ('Broadcast', 9);

INSERT INTO lookup_im_types (description, level) VALUES ('Business',10);
INSERT INTO lookup_im_types (description, level) VALUES ('Personal',20);
INSERT INTO lookup_im_types (description, level) VALUES ('Other',30);

INSERT INTO lookup_im_services (description, level) VALUES ('AOL Instant Messenger',10);
INSERT INTO lookup_im_services (description, level) VALUES ('Jabber Instant Messenger',20);
INSERT INTO lookup_im_services (description, level) VALUES ('MSN Instant Messenger',30);

INSERT INTO lookup_textmessage_types (description, level) VALUES ('Business',10);
INSERT INTO lookup_textmessage_types (description, level) VALUES ('Personal',20);
INSERT INTO lookup_textmessage_types (description, level) VALUES ('Other',30);

INSERT INTO lookup_industry (description) VALUES ('Automotive');
INSERT INTO lookup_industry (description) VALUES ('Biotechnology');
INSERT INTO lookup_industry (description) VALUES ('Broadcasting and Cable');
INSERT INTO lookup_industry (description) VALUES ('Computer');
INSERT INTO lookup_industry (description) VALUES ('Consulting');
INSERT INTO lookup_industry (description) VALUES ('Defense');
INSERT INTO lookup_industry (description) VALUES ('Energy');
INSERT INTO lookup_industry (description) VALUES ('Financial Services');
INSERT INTO lookup_industry (description) VALUES ('Food');
INSERT INTO lookup_industry (description) VALUES ('Healthcare');
INSERT INTO lookup_industry (description) VALUES ('Hospitality');
INSERT INTO lookup_industry (description) VALUES ('Insurance');
INSERT INTO lookup_industry (description) VALUES ('Internet');
INSERT INTO lookup_industry (description) VALUES ('Law Firms');
INSERT INTO lookup_industry (description) VALUES ('Media');
INSERT INTO lookup_industry (description) VALUES ('Pharmaceuticals');
INSERT INTO lookup_industry (description) VALUES ('Real Estate');
INSERT INTO lookup_industry (description) VALUES ('Retail');
INSERT INTO lookup_industry (description) VALUES ('Telecommunications');
INSERT INTO lookup_industry (description) VALUES ('Transportation');

INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Subsidiary of', 'Parent of', 10);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Customer of', 'Supplier to', 20);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Partner of', 'Partner of', 30);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Friend of', 'Friend of', 30);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Competitor of', 'Competitor of', 40);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Employee of', 'Employer of', 50);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Department of', 'Organization made up of', 60);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Group of', 'Organization made up of', 70);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Member of', 'Organization made up of', 80);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Consultant to', 'Client of', 90);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Influencer of', 'Influenced by', 100);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Enemy of', 'Enemy of', 110);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Proponent of', 'Endorsed by', 120);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Ally of', 'Ally of', 130);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Sponsor of', 'Sponsored by', 140);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Relative of', 'Relative of', 150);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Affiliated with', 'Affiliated with', 160);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Teammate of', 'Teammate of', 170);
INSERT INTO lookup_relationship_types (category_id_maps_from, category_id_maps_to, reciprocal_name_1, reciprocal_name_2, level) VALUES ('42420034','42420034', 'Financier of', 'Financed by', 180);

