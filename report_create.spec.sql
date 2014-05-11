create or replace package report_create

as

	report_default_tracking		number := 1;
	report_default_header		number := 0;
	report_default_footer		number := 0;
	report_default_pagenumber	number := 1;
	report_default_pagetype		varchar2(200) := 'A4';
	report_default_orientation	varchar2(200) := 'portrait';

	type report_attributes is record (
		page_tracking			number,
		page_header				number,
		page_footer				number,
		page_numbers			number,
		page_type				varchar2(200),
		page_orientation		varchar2(200),
		page_svgs_created		number
	);

	type report_keywords is table of varchar2(4000) index by varchar2(200);

	type report is record (
		report_id				number,
		report_name				varchar2(200),
		report_description		varchar2(4000),
		report_current_page		number,
		attributes				report_attributes,
		keywords				report_keywords,
		report_pages			report_page.pages
	);

	procedure new_report (
		report_object		in out	report,
		name_in				in		varchar2,
		description_in		in		varchar2
	);

	procedure set_attribute (
		report_object		in out	report,
		attribute_name		in		varchar2,
		attribute_value		in		varchar2
	);

	procedure new_report_page (
		report_object		in out	report,
		page_name			in		varchar2 default null,
		page_template		in		varchar2 default null
	);

	procedure report_pages_to_files (
		report_object		in out	report
	);

	procedure report_pagefiles_to_pdf (
		report_object		in out	report,
		pdf_created			out		boolean,
		pdf_name			out		varchar2
	);

	procedure set_keyword (
		report_object		in out	report,
		keyword				in		varchar2,
		value				in		varchar2
	);

	procedure set_page_by_num (
		report_object		in out	report,
		page_num_in			in		number
	);

	procedure set_page_by_name (
		report_object		in out	report,
		page_name_in		in		varchar2
	);

	procedure report_page_keyword_replace (
		report_object		in out	report,
		page_idx_in			in		number
	);

end report_create;
/
