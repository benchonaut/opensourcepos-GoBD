
SET NAMES utf8 ;
SET character_set_client = utf8;
--
-- Table structure for table `ospos_app_config`
--

DROP TABLE IF EXISTS `ospos_app_config`;
CREATE TABLE `ospos_app_config` (
  `key` varchar(50) NOT NULL,
  `value` varchar(500) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `ospos_app_config` WRITE;
INSERT INTO `ospos_app_config` VALUES 
('country_codes','de'),('currency_decimals','2'),('currency_symbol','€'),('dateformat','d.m.Y'),('default_sales_discount','0'),('default_tax_1_name','MWSt 19%'),('default_tax_1_rate','19'),('default_tax_2_name','MWSt 7%'),('default_tax_2_rate','7'),('invoice_enable','1'),('language','german'),('language_code','de'),('number_locale','de_DE'),('payment_options_order','cashdebitcredit'),                                                                                                                                                                                      
,('receipt_show_description','1'),('receipt_show_serialnumber','1'),('receipt_show_taxes','1'),('receipt_show_total_discount','1'),('receipt_template','receipt_default'),('receiving_calculate_average_price','0'),('recv_invoice_format',' %Y-$YCO'),('sales_invoice_format',' %Y-$YCO'),('statistics','1'),('tax_decimals','2'),('tax_included','1'),('thousands_separator','thousands_separator'),('timeformat','H:i:s'),('timezone','Europe/Amsterdam');
UNLOCK TABLES;

