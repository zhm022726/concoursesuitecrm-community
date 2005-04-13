-- Product Option Configurators
INSERT INTO product_option_configurator (configurator_name, short_description, long_description, class_name, result_type) VALUES ('Text', 'A text field for free-form additional information', 'String Configurator', 'org.aspcfs.modules.products.configurator.StringConfigurator', 1);
INSERT INTO product_option_configurator (configurator_name, short_description, long_description, class_name, result_type) VALUES ('Check Box', 'A check box for yes/no information', 'Checkbox Configurator', 'org.aspcfs.modules.products.configurator.CheckboxConfigurator', 1);
INSERT INTO product_option_configurator (configurator_name, short_description, long_description, class_name, result_type) VALUES ('Lookup List', 'A list of available choices that can be selected', 'LookupList Configurator', 'org.aspcfs.modules.products.configurator.LookupListConfigurator', 1);
INSERT INTO product_option_configurator (configurator_name, short_description, long_description, class_name, result_type) VALUES ('Number', 'An input field allowing numbers only', 'Numerical Configurator', 'org.aspcfs.modules.products.configurator.NumericalConfigurator', 1);
